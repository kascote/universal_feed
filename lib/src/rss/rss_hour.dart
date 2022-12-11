import 'package:xml/xml.dart';

///
class RSSHour {
  ///
  final String value;

  ///
  const RSSHour(this.value);

  ///
  static List<RSSHour>? fromXML(XmlElement xml) {
    final skipHours = xml.getElement('skipHours');
    if (skipHours == null) return null;

    final hours = skipHours.findElements('hour');
    return List<RSSHour>.generate(hours.length, (pos) => RSSHour(hours.elementAt(pos).text));
  }
}
