/// Exception thrown when an error is found
class FeedError implements Exception {
  /// A message describing the error
  String message;

  /// Created a new FeedError with an error [message]
  FeedError(this.message);

  @override
  String toString() => message;
}
