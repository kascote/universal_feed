import 'package:xml/xml.dart';

///
class RSSHour {
  ///
  final String value;

  ///
  const RSSHour(this.value);

  ///
  static List<RSSHour>? fromXML(XmlElement xml) {
    final shours = xml.getElement('skipHours');
    if (shours == null) return null;

    final hours = shours.findElements('hour');
    return List<RSSHour>.generate(hours.length, (pos) => RSSHour(hours.elementAt(pos).text));
  }
}
