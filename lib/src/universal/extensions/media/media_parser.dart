import 'package:xml/xml.dart';

import '../../../../universal_feed.dart';
import '../../../shared/extensions.dart';
import '../extension_parser.dart';
import 'content.dart';
import 'credit.dart';
import 'media.dart';
import 'player.dart';
import 'rating.dart';

/// Media RSS extension parser - only works at item level
class MediaParser implements ItemExtensionParser {
  /// Creates a new [MediaParser] with the given namespace URL
  MediaParser(this.namespaceUrl);

  @override
  final String namespaceUrl;

  @override
  void parseItem(UniversalFeed feed, Item item, XmlElement element) {
    // Media content only exists at item level
    item.media = _parseMedia(feed, element);
  }

  /// Parse media extension elements from an XML node
  /// This method handles recursive parsing for media:group elements
  Media _parseMedia(UniversalFeed feed, XmlElement node) {
    final media = Media();

    node
      ..forEachElementXml('content', (xml) => media.content.add(MediaContent.fromXml(feed, xml)), ns: namespaceUrl)
      ..forEachElementXml('group', (group) {
        // Recursive parsing for nested media groups
        media.group.add(_parseMedia(feed, group));
      }, ns: namespaceUrl)
      ..ifPresentXml('title', (value) => media.title = value.decodeAs('plain'), ns: namespaceUrl)
      ..ifPresentXml('description', (value) => media.description = value.decodeAs('plain'), ns: namespaceUrl)
      ..forEachElementXml('rating', (xml) {
        media.rating.add(Rating.fromXml(xml));
      }, ns: namespaceUrl)
      ..forEachElementXml('keywords', (xml) {
        final keywords = Category.loadTags(xml, defaultScheme: 'keyword');
        if (keywords != null) media.categories.addAll(keywords);
      }, ns: namespaceUrl)
      ..forEachElementXml('category', (xml) {
        final category = Category.fromXml(xml);
        if (category != null) media.categories.add(category);
      }, ns: namespaceUrl)
      ..forEachElementXml('thumbnail', (xml) => media.thumbnails.add(Image.fromXmlAttributes(xml)), ns: namespaceUrl)
      ..ifPresentXml('player', (value) => media.player = Player.fromXml(value), ns: namespaceUrl)
      ..forEachElementXml('credit', (xml) => media.credits.add(Credit.fromXml(xml)), ns: namespaceUrl);

    return media;
  }
}
