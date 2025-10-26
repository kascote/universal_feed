/// Base exception class for all feed-related errors.
///
/// Extended by:
/// * [UnsupportedFeedFormatException] for unrecognized feed formats
/// * [MissingRequiredFieldException] for missing required fields
/// * [InvalidFieldValueException] for malformed field values
///
class FeedException implements Exception {
  /// A message describing the error
  final String message;

  /// Creates a new FeedException with an error [message]
  FeedException(this.message);

  @override
  String toString() => message;
}

/// Exception thrown when an unsupported or unrecognized feed format is encountered.
///
/// This exception is thrown when the parser cannot identify the feed format
/// or encounters a format it doesn't support.
///
/// Examples of when this is thrown:
/// * XML root element is not 'rss', 'feed', or 'RDF'
/// * Unrecognized custom feed formats
///
class UnsupportedFeedFormatException extends FeedException {
  /// The detected format string (e.g., root element name)
  final String? detectedFormat;

  /// Creates a new UnsupportedFeedFormatException
  UnsupportedFeedFormatException({
    this.detectedFormat,
  }) : super(
         detectedFormat != null ? 'Unsupported feed format: $detectedFormat' : 'Unsupported feed format',
       );
}

/// Exception thrown when a required field is missing from the feed.
///
/// Primarily used for JSON Feed parsing where certain fields are mandatory
/// according to the specification (e.g., 'version', 'title').
///
class MissingRequiredFieldException extends FeedException {
  /// The name of the missing field
  final String fieldName;

  /// The type of feed ('RSS', 'Atom', 'JSON Feed')
  final String feedType;

  /// Creates a new MissingRequiredFieldException
  MissingRequiredFieldException({
    required this.fieldName,
    required this.feedType,
  }) : super('$feedType missing required field: $fieldName');
}

/// Exception thrown when a field value is invalid or malformed.
///
/// This exception is thrown when a field has an unexpected type or format.
/// The exception provides details about what was expected vs. what was received.
///
/// Examples of malformed data:
/// * Invalid URI format for version field
/// * Wrong data type (string instead of number, etc.)
/// * Malformed date strings
///
class InvalidFieldValueException extends FeedException {
  /// The name of the field with invalid value
  final String fieldName;

  /// The actual value that was invalid
  final dynamic actualValue;

  /// The expected type or format description
  final String expectedType;

  /// Creates a new InvalidFieldValueException
  InvalidFieldValueException({
    required this.fieldName,
    required this.actualValue,
    required this.expectedType,
  }) : super(
         'Invalid value for field "$fieldName": expected $expectedType, got $actualValue',
       );
}

/// Exception used for generic errors
class FeedError implements Exception {
  /// A message describing the error
  final String message;

  /// Creates a new FeedError with an error [message]
  FeedError(this.message);

  @override
  String toString() => message;
}
