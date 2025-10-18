import 'package:xml/xml.dart';

import '../../../../universal_feed.dart';
import '../../../shared/extensions.dart';
import '../extension_parser.dart';

/// Atom links extension parser for RSS feeds - only works at channel level
class AtomLinksParser implements ChannelExtensionParser {
  /// Creates a new [AtomLinksParser] with the given namespace URL
  AtomLinksParser(this.namespaceUrl);

  @override
  final String namespaceUrl;

  @override
  void parseChannel(UniversalFeed feed, XmlElement channel) {
    // Channel's link points to the Web site hosting the feed (not the feed itself)
    // Atom's link usually points to the feed itself
    channel.forEachElementXml(
      'link',
      (value) {
        final link = Link.fromXml(value);
        if (link.rel == LinkRelationType.self) feed.xmlLink = link;
        if (link.rel == LinkRelationType.alternate && feed.htmlLink == null) feed.htmlLink = link;
        feed.links.add(link);
      },
      ns: namespaceUrl,
    );
  }
}
