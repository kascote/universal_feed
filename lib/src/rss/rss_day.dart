import 'package:xml/xml.dart';

/// RSSDay is a single day in a SkipDays tag
class RSSDay {
  /// Value of the entry
  final String value;

  /// RSSDay constructor
  const RSSDay(this.value);

  /// Parse an [RSSDay] entry from an [XmlElement]
  static List<RSSDay>? fromXML(XmlElement xml) {
    final days = xml.getElement('skipDays');
    if (days == null) return null;

    final day = days.findElements('day');
    return List<RSSDay>.generate(day.length, (pos) => RSSDay(day.elementAt(pos).text));
  }
}
