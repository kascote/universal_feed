import 'package:xml/xml.dart';

import '../../../../universal_feed.dart';
import '../extension_parser.dart';
import 'geo.dart';

/// GeoRSS extension parser - only works at item level
class GeoRssParser implements ItemExtensionParser {
  /// Creates a new [GeoRssParser] with the given namespace URL
  GeoRssParser(this.namespaceUrl);

  @override
  final String namespaceUrl;

  @override
  void parseItem(UniversalFeed feed, Item item, XmlElement element) {
    final geo = Geo()
      ..line = element.getElement('line', namespace: namespaceUrl)?.innerText
      ..polygon = element.getElement('polygon', namespace: namespaceUrl)?.innerText
      ..box = element.getElement('box', namespace: namespaceUrl)?.innerText
      ..featureTypeTag = element.getElement('featuretypetag', namespace: namespaceUrl)?.innerText
      ..relationshipTag = element.getElement('relationshiptag', namespace: namespaceUrl)?.innerText
      ..featureName = element.getElement('featurename', namespace: namespaceUrl)?.innerText
      ..elev = element.getElement('elev', namespace: namespaceUrl)?.innerText
      ..floor = element.getElement('floor', namespace: namespaceUrl)?.innerText
      ..radius = element.getElement('radius', namespace: namespaceUrl)?.innerText;

    item.geo = geo;
  }
}
