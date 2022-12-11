import 'package:xml/xml.dart';

import './universal_feed_base.dart';

/// Enum that list the supported feeds
enum FeedKind {
  /// RSS feed
  rss,

  /// Atom feed
  atom,
}

/// Universal feed helper
class UniversalFeed {
  /// Kind of feed parsed
  late final FeedKind kind;

  /// When the feed parses as RSS, this variable holds the information
  late final RSS rss;

  /// When the feed parses as Atom, this variable holds the information
  late final Atom atom;

  /// Universal feed constructor
  UniversalFeed(String content) {
    final doc = XmlDocument.parse(content);
    final root = doc.rootElement;

    switch (root.localName) {
      case 'feed':
        kind = FeedKind.atom;
        atom = Atom.parseFromXml(root);
        break;
      case 'rss':
      case 'RDF':
        kind = FeedKind.rss;
        rss = RSS.parseFromXML(root);
        break;
      default:
        throw FeedError('Unknown feed type: ${root.localName}');
    }
  }
}
