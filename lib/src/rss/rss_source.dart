import 'package:xml/xml.dart';

/// Its value is the name of the RSS channel that the item came from, derived from its <title>.
/// It has one required attribute, url, which links to the XMLization of the source.
class RSSSource {
  /// Url to the entity source
  final String url;

  /// Entity's title
  final String title;

  /// RSSource contructor
  const RSSSource({this.url = '', this.title = ''});

  /// Parse a [RSSSource] tag from an [XmlElement]
  factory RSSSource.fromXML(XmlElement src) {
    return RSSSource(
      url: src.getAttribute('url') ?? '',
      title: src.text,
    );
  }
}
