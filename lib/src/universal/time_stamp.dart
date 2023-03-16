import '../shared/date_parser.dart';

/// Represent all the date instances on the feed
class UniversalTimestamp {
  /// Original value of the field
  final String value;

  /// Creates a new UniversalTimestamp instance
  const UniversalTimestamp(this.value);

  /// Try to parse the string value to a DateTime object
  DateTime? parseValue() {
    return parseDate(value);
  }

  @override
  String toString() {
    return value;
  }
}
