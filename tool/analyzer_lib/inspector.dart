import 'package:universal_feed/universal_feed.dart';

/// Result of inspecting a feed
class InspectionResult {
  InspectionResult(this.feed, this.issues);

  final UniversalFeed feed;
  final List<Issue> issues;
}

/// An issue found during inspection
class Issue {
  Issue(this.severity, this.field, this.message, {this.rawValue});

  final Severity severity;
  final String field;
  final String message;
  final String? rawValue;

  @override
  String toString() {
    final prefix = severity == Severity.warning ? '⚠️' : 'ℹ️';
    return '$prefix $field: $message${rawValue != null ? ' (raw: "$rawValue")' : ''}';
  }
}

enum Severity { warning, info }

/// Inspects a parsed feed for potential issues
class FeedInspector {
  /// Inspect a feed and report any issues
  InspectionResult inspect(UniversalFeed feed) {
    final issues = <Issue>[];

    _checkTimestamp(feed.published, 'feed.published', issues);
    _checkTimestamp(feed.updated, 'feed.updated', issues);

    for (var i = 0; i < feed.items.length; i++) {
      final item = feed.items[i];
      final prefix = 'item[$i]';

      _checkTimestamp(item.published, '$prefix.published', issues);
      _checkTimestamp(item.updated, '$prefix.updated', issues);

      _checkCDATA(item.title, '$prefix.title', issues);
      _checkCDATA(item.description, '$prefix.description', issues);
      for (var j = 0; j < item.content.length; j++) {
        _checkCDATA(item.content[j].value, '$prefix.content[$j]', issues);
      }

      if (item.dcterms != null) {
        _checkDateString(item.dcterms!.created, '$prefix.dcterms.created', issues);
        _checkDateString(item.dcterms!.modified, '$prefix.dcterms.modified', issues);
        _checkDateString(item.dcterms!.issued, '$prefix.dcterms.issued', issues);
      }
    }

    return InspectionResult(feed, issues);
  }

  void _checkTimestamp(Timestamp? timestamp, String field, List<Issue> issues) {
    if (timestamp == null) return;

    final parsed = timestamp.parseValue();
    if (parsed == null) {
      issues.add(
        Issue(
          Severity.warning,
          field,
          'Failed to parse date',
          rawValue: timestamp.value,
        ),
      );
    }
  }

  void _checkDateString(String? dateStr, String field, List<Issue> issues) {
    if (dateStr == null || dateStr.isEmpty) return;

    final timestamp = Timestamp(dateStr);
    final parsed = timestamp.parseValue();
    if (parsed == null) {
      issues.add(
        Issue(
          Severity.warning,
          field,
          'Failed to parse date',
          rawValue: dateStr,
        ),
      );
    }
  }

  void _checkCDATA(String? value, String field, List<Issue> issues) {
    if (value == null) return;

    if (value.contains('<![CDATA[') || value.contains(']]>')) {
      issues.add(
        Issue(
          Severity.info,
          field,
          'Contains CDATA markers',
        ),
      );
    }

    if (value.contains('&lt;') || value.contains('&gt;') || value.contains('&amp;') || value.contains('&quot;')) {
      issues.add(
        Issue(
          Severity.info,
          field,
          'Contains HTML entities',
        ),
      );
    }
  }
}
