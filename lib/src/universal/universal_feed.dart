import 'package:xml/xml.dart';

import './parsers/atom_parser.dart';
import './parsers/rss_parser.dart';
import '../../universal_feed.dart';

///
/// Atom v0.3 spec - https://validator.w3.org/feed/docs/atom.html
class UniversalFeed {
  /// Contains metadata information for the Feed.
  late final UniversalMeta meta;

  /// Contains the Feed's namespaces declared.
  late final Namespaces namespaces;

  /// Unique identifier for the feed.
  String? guid;

  /// The name of the channel.
  String? title;

  /// Phrase or sentence describing the channel.
  String? description;

  /// The URL to the XML feed corresponding to the feed.
  UniversalLink? xmlLink;

  /// The URL to the HTML website corresponding to the feed.
  UniversalLink? htmlLink;

  /// Collection of links related to the feed.
  final List<UniversalLink> links = [];

  /// The last time the content of the channel changed.
  ///
  /// rss ref: https://cyber.harvard.edu/rss/rss.html#optionalChannelElements
  UniversalTimestamp? updated;

  /// The publication date for the content in the channel.
  ///
  /// rss ref: https://cyber.harvard.edu/rss/rss.html#optionalChannelElements
  UniversalTimestamp? published;

  /// Collect all email address from all authors. (managingEditor, webMaster, etc)
  ///
  /// rss ref: https://cyber.harvard.edu/rss/rss.html#optionalChannelElements
  final List<UniversalAuthor> authors = [];

  /// The language of the feed.
  ///
  /// The language the channel is written in. This allows aggregators to group all Italian language sites, for example, on a single page.
  /// This is a required element for Atom feeds, but optional for RSS feeds.
  ///
  /// rss ref: https://cyber.harvard.edu/rss/rss.html#optionalChannelElements
  String? language;

  /// Specifies a GIF, JPEG or PNG image that can be displayed with the channel.
  ///
  /// rss ref:
  UniversalImage? image;

  /// Copyright notice for content in the channel.
  ///
  /// rss ref: https://cyber.harvard.edu/rss/rss.html#optionalChannelElements
  String? copyright;

  /// A string indicating the program used to generate the channel.
  ///
  /// rss ref: https://cyber.harvard.edu/rss/rss.html#optionalChannelElements
  UniversalGenerator? generator;

  /// Specify one or more categories that the channel belongs to.
  ///
  /// rss ref: https://cyber.harvard.edu/rss/rss.html#optionalChannelElements
  final List<UniversalCategory> categories = [];

  ///
  final List<UniversalItem> items = [];

  /// A URL that points to the documentation for the format used in the RSS file.
  ///
  /// rss ref: https://cyber.harvard.edu/rss/rss.html#optionalChannelElements
  String? docs;

  ///
  Syndication? syndication;

  ///
  ItunesChannel? podcast;

  UniversalFeed._();

  /// Generate a new UniversalFeed object from an feed string.
  /// The string must be an XML string with RSS or Atom encoding.
  factory UniversalFeed.parseFromString(String content) {
    final doc = XmlDocument.parse(content);
    final root = doc.rootElement;

    final feed = UniversalFeed._()
      ..meta = UniversalMeta.rssFromXml(doc)
      ..namespaces = Namespaces(doc.rootElement.attributes);

    if (feed.meta.kind == FeedKind.rss) {
      rssXmlParser(feed, doc);
    } else if (feed.meta.kind == FeedKind.atom) {
      atomXmlParser(feed, root);
    }

    return feed;
  }

  /// Generate a new UniversalFeed object from an XML element.
  factory UniversalFeed.parseFromXml(XmlElement content) {
    final feed = UniversalFeed._();
    atomXmlParser(feed, content);
    return feed;
  }
}
