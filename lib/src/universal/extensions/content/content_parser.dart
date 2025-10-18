import 'package:xml/xml.dart';

import '../../../../universal_feed.dart';
import '../../../shared/extensions.dart';
import '../extension_parser.dart';

/// Content extension parser - only works at item level
class ContentParser implements ItemExtensionParser {
  /// Creates a new [ContentParser] with the given namespace URL
  ContentParser(this.namespaceUrl);

  @override
  final String namespaceUrl;

  @override
  void parseItem(UniversalFeed feed, Item item, XmlElement element) {
    element.forEachElementXml(
      'encoded',
      (value) => item.content.add(Content.fromXml(value, defaultType: 'text')),
      ns: namespaceUrl,
    );
  }
}
