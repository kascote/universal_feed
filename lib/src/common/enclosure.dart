import 'package:xml/xml.dart';

/// It has three required attributes. url says where the enclosure is located, length
/// says how big it is in bytes, and type says what its type is, a standard MIME type.
///
/// The url must be an http url.
///    <enclosure url="http://www.scripting.com/mp3s/weatherReportSuite.mp3" length="12216320" type="audio/mpeg" />
class Enclosure {
  /// Length in bytes of the object
  final String length;

  /// Objec's mime-type
  final String type;

  /// URI pointing to the object
  final String url;

  /// Creates a new [Enclosure] object
  const Enclosure({required this.url, required this.length, this.type = 'application/octect-stream'});

  /// Creates an [Enclosure] object from an [XmlElement]
  factory Enclosure.fromXML(XmlElement node) {
    return Enclosure(
      url: node.getAttribute('url') ?? node.getAttribute('href') ?? '',
      length: node.getAttribute('length') ?? '',
      type: node.getAttribute('type') ?? '',
    );
  }

  @override
  String toString() {
    return 'Enclosure type $type ~ length $length ~ $url';
  }
}
