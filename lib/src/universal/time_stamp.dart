import '../shared/date_parser.dart';

/// Date instances on the feed
class Timestamp {
  /// Original value of the field
  final String value;

  DateTime? _parsedValue;

  /// Creates a new UniversalTimestamp instance
  Timestamp(this.value);

  /// Try to parse the string value to a DateTime object
  DateTime? parseValue() {
    return _parsedValue ??= parseDate(value);
  }

  @override
  String toString() {
    return value;
  }
}
