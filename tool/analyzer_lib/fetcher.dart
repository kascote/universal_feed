import 'dart:io';

/// Result of fetching a feed
class FetchResult {
  FetchResult.success(this.content, this.url) : error = null, statusCode = 200;

  FetchResult.failure(this.url, this.error, [this.statusCode]) : content = null;

  final String url;
  final String? content;
  final String? error;
  final int? statusCode;

  bool get isSuccess => content != null;
}

/// Fetches feed content from URLs or local files
class FeedFetcher {
  FeedFetcher({this.timeout = const Duration(seconds: 30)});

  final Duration timeout;

  /// Fetch a feed from a URL or local file path
  Future<FetchResult> fetch(String source) async {
    if (!source.startsWith('http://') && !source.startsWith('https://')) {
      return _fetchFromFile(source);
    }

    return _fetchFromUrl(source);
  }

  Future<FetchResult> _fetchFromFile(String path) async {
    try {
      final file = File(path);
      if (!file.existsSync()) {
        return FetchResult.failure(path, 'File not found');
      }
      final content = await file.readAsString();
      return FetchResult.success(content, path);
    } on Object catch (e) {
      return FetchResult.failure(path, 'Error reading file: $e');
    }
  }

  Future<FetchResult> _fetchFromUrl(String url) async {
    final client = HttpClient();
    try {
      final uri = Uri.parse(url);
      final request = await client.getUrl(uri).timeout(timeout);

      request.headers.set('User-Agent', 'UniversalFeed-Analyzer/1.0');

      final response = await request.close().timeout(timeout);

      if (response.statusCode != 200) {
        return FetchResult.failure(
          url,
          'HTTP ${response.statusCode}',
          response.statusCode,
        );
      }

      final content = await response.transform(const SystemEncoding().decoder).join();
      return FetchResult.success(content, url);
    } on Object catch (e) {
      return FetchResult.failure(url, 'Fetch error: $e');
    } finally {
      client.close();
    }
  }
}
