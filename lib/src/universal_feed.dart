import 'package:xml/xml.dart';

import './universal_feed_base.dart';

/// Enum to identify the direfent kind of feeds
enum FeedKind {
  /// RSS feed
  rss,

  /// Atom feed
  atom,
}

/// Universal feed helper
class UniversalFeed {
  /// Type of feed parsed
  late final FeedKind kind;

  /// If the feed parsed is RSS, here will recide the information
  late final RSS rss;

  /// If the feed parsed is Atom, here will recide the information
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
