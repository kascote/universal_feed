import 'package:xml/xml.dart';

/// Media object attached to an entry, usually a binary object (image, sound, video)
/// It has three required attributes. url says where the enclosure is located, length
/// says how big it is in bytes, and type says what its type is, a standard MIME type.
///
/// The url must be an http url.
///    <enclosure url="http://www.scripting.com/mp3s/weatherReportSuite.mp3" length="12216320" type="audio/mpeg" />
class Enclosure {
  /// Length in bytes of the object
  final String length;

  /// Object's mime-type
  final String type;

  /// URI pointing to the object
  final String url;

  /// Creates a new [Enclosure] object
  const Enclosure({required this.url, required this.length, this.type = 'application/octet-stream'});

  /// Creates an [Enclosure] object from an [XmlElement]
  factory Enclosure.rssFromXml(XmlElement node) {
    return Enclosure(
      url: node.getAttribute('url') ?? node.getAttribute('href') ?? '',
      length: node.getAttribute('length') ?? '',
      type: node.getAttribute('type') ?? '',
    );
  }
}
