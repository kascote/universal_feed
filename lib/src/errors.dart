/// Exception used for generic errors
class FeedError implements Exception {
  /// A message describing the error
  String message;

  /// Creates a new FeedError with an error [message]
  FeedError(this.message);

  @override
  String toString() => message;
}

/// Exception used when an errors is found parsing the feed
class FeedParseError extends FeedError {
  /// Creates a new FeedParserError with an error [message]
  FeedParseError(super.message);
}
