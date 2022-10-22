/// Represent all the date instances on the feed
class Timestamp {
  /// Original value of the field
  final String value;

  /// Creates a new Timestamp instance
  const Timestamp(this.value);

  @override
  String toString() {
    return value;
  }
}
