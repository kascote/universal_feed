/// Helper class that is a basic DCMI Period parser
///
/// https://www.dublincore.org/specifications/dublin-core/dcmi-period/
class DcPeriod {
  /// The instant corresponding to the commencement of the time interval
  String? start;

  /// The instant corresponding to the termination of the time interval
  String? end;

  /// The encoding used for the representation of the time-instants in the start and end components
  String? scheme;

  /// A name for the time interval
  String? name;

  DcPeriod._();

  /// Parses the content from an string
  factory DcPeriod.fromString(String value) {
    final period = DcPeriod._();
    final elements = value.split(';').map((e) => e.trim());

    for (final element in elements) {
      if (element.isEmpty) {
        continue;
      }

      final field = element.split('=');
      final lhs = field[0];
      final rhs = field[1];

      switch (lhs) {
        case 'start':
          period.start = rhs;
          break;
        case 'end':
          period.end = rhs;
          break;
        case 'scheme':
          period.scheme = rhs;
          break;
        case 'name':
          period.name = rhs;
          break;
      }
    }

    return period;
  }
}
