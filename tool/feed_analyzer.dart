import 'dart:io';

import 'package:universal_feed/universal_feed.dart';

import 'analyzer_lib/fetcher.dart';
import 'analyzer_lib/formatter.dart';
import 'analyzer_lib/inspector.dart';

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    _printUsage();
    exit(1);
  }

  final inputFile = args[0];
  final file = File(inputFile);

  if (!file.existsSync()) {
    stderr.writeln('Error: File not found: $inputFile');
    exit(1);
  }

  final lines = await file.readAsLines();
  final sources = lines.map((line) => line.trim()).where((line) => line.isNotEmpty && !line.startsWith('#')).toList();

  if (sources.isEmpty) {
    stderr.writeln('Error: No feed URLs found in $inputFile');
    exit(1);
  }

  stdout.writeln('Found ${sources.length} feed(s) to analyze\n');

  final fetcher = FeedFetcher();
  final inspector = FeedInspector();
  final formatter = ReportFormatter();

  var successCount = 0;
  var failureCount = 0;

  for (var i = 0; i < sources.length; i++) {
    final source = sources[i];
    stdout.writeln('[$i/${sources.length}] Fetching: $source');

    final fetchResult = await fetcher.fetch(source);

    if (!fetchResult.isSuccess) {
      stderr.writeln('  ✗ Failed: ${fetchResult.error}');
      failureCount++;
      stdout.writeln();
      continue;
    }

    stdout.writeln('  ✓ Fetched (${fetchResult.content!.length} bytes)');

    try {
      final feed = UniversalFeed.parseFromString(fetchResult.content!);
      stdout.writeln('  ✓ Parsed as ${feed.meta.kind.name} ${feed.meta.version}');

      final inspection = inspector.inspect(feed);
      final report = formatter.format(inspection);

      stdout.writeln(report);
      successCount++;

      // Pause before next feed (unless it's the last one)
      if (i < sources.length - 1) {
        stdout.write('\nPress Enter to continue to next feed...');
        stdin.readLineSync();
        stdout.writeln();
      }
    } on Object catch (e, stack) {
      stderr.writeln('  ✗ Parse failed: $e');
      if (args.contains('--verbose')) {
        stderr.writeln(stack);
      }
      failureCount++;
      stdout.writeln();
    }
  }

  stdout
    ..writeln('\n${'═' * 80}')
    ..writeln('SUMMARY')
    ..writeln('═' * 80)
    ..writeln('Total: ${sources.length}')
    ..writeln('Success: $successCount')
    ..writeln('Failed: $failureCount');
}

void _printUsage() {
  stdout.writeln('''
Universal Feed Analyzer

Usage:
  dart tool/feed_analyzer.dart <feeds-file> [--verbose]

Arguments:
  feeds-file    Path to a text file containing feed URLs (one per line)
  --verbose     Show detailed error messages and stack traces

Example feeds file format:
  # RSS feeds
  https://example.com/feed.xml
  https://blog.example.com/rss

  # Atom feeds
  https://example.com/atom.xml

  # Local files
  /path/to/local/feed.xml

Lines starting with # are treated as comments and ignored.
''');
}
