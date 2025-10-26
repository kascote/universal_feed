import 'package:xml/xml.dart';

import '../../universal_feed.dart';
import './parsers/atom_parser.dart';
import './parsers/rss_parser.dart';
import 'extensions/podcast/itunes_channel.dart';
import 'extensions/syndication/syndication.dart';
import 'parsers/json_parser.dart';

/// Feed is the root element of the UniversalFeed.
///
/// RSS v2.0 spec - https://cyber.harvard.edu/rss/rss.html
/// Atom v0.3 spec - https://validator.w3.org/feed/docs/atom.html
/// Atom v1.0 spec - https://www.rfc-editor.org/rfc/rfc4287.html
class UniversalFeed {
  /// Contains metadata information for the Feed.
  late final MetaData meta;

  /// Unique identifier for the feed.
  String? guid;

  /// The name of the channel.
  String? title;

  /// Phrase or sentence describing the channel.
  String? description;

  /// The URL to the XML feed corresponding to the feed.
  Link? xmlLink;

  /// The URL to the HTML website corresponding to the feed.
  Link? htmlLink;

  /// Collection of links related to the feed.
  final List<Link> links = [];

  /// The last time the content of the channel changed.
  ///
  /// rss ref: https://cyber.harvard.edu/rss/rss.html#optionalChannelElements
  Timestamp? updated;

  /// The publication date for the content in the channel.
  ///
  /// rss ref: https://cyber.harvard.edu/rss/rss.html#optionalChannelElements
  Timestamp? published;

  /// Collect all email address from all authors. (managingEditor, webMaster, etc)
  ///
  /// rss ref: https://cyber.harvard.edu/rss/rss.html#optionalChannelElements
  final List<Author> authors = [];

  /// The language of the feed.
  ///
  /// The language the channel is written in. This allows aggregators to group all Italian language sites, for example, on a single page.
  /// This is a required element for Atom feeds, but optional for RSS feeds.
  ///
  /// rss ref: https://cyber.harvard.edu/rss/rss.html#optionalChannelElements
  String? language;

  /// Specifies a GIF, JPEG or PNG image that can be displayed with the channel.
  ///
  /// rss ref: https://cyber.harvard.edu/rss/rss.html#ltimagegtSubelementOfLtchannelgt
  /// atom ref: https://www.rfc-editor.org/rfc/rfc4287#section-4.2.8
  Image? image;

  /// Specifies an image IRI that provides iconic visual identification for a channel.
  ///
  /// atom ref: https://www.rfc-editor.org/rfc/rfc4287#section-4.2.5
  Image? icon;

  /// Copyright notice for content in the channel.
  ///
  /// rss ref: https://cyber.harvard.edu/rss/rss.html#optionalChannelElements
  String? copyright;

  /// A string indicating the program used to generate the channel.
  ///
  /// rss ref: https://cyber.harvard.edu/rss/rss.html#optionalChannelElements
  Generator? generator;

  /// Specify one or more categories that the channel belongs to.
  ///
  /// rss ref: https://cyber.harvard.edu/rss/rss.html#optionalChannelElements
  final List<Category> categories = [];

  /// Feed entries
  ///
  /// rss ref: /// https://cyber.harvard.edu/rss/rss.html#hrelementsOfLtitemgt
  final List<Item> items = [];

  /// A URL that points to the documentation for the format used in the RSS file.
  ///
  /// rss ref: https://cyber.harvard.edu/rss/rss.html#optionalChannelElements
  String? docs;

  /// If the feed defines a Syndication namespace, this object will be populated.
  Syndication? syndication;

  /// If the feed defines an Itunes namespace, this object will be populated.
  ItunesChannel? podcast;

  UniversalFeed._();

  /// Parses a feed string into a UniversalFeed object.
  ///
  /// Supports RSS (0.90-2.0), Atom (0.3, 1.0), and JSON Feed (1.0, 1.1) formats.
  /// The [content] string must contain valid feed data (XML or JSON).
  ///
  /// Throws:
  /// * [ArgumentError] if [content] is empty
  /// * [UnsupportedFeedFormatException] if the feed format is not recognized
  /// * [MissingRequiredFieldException] if required fields are missing (JSON Feed)
  /// * [InvalidFieldValueException] if field values are malformed
  /// * [XmlParserException] if XML is malformed
  /// * [FormatException] if JSON is malformed
  ///
  /// For a non-throwing alternative, use [tryParse].
  factory UniversalFeed.parseFromString(String content) {
    content = content.trim();

    if (content.isEmpty) {
      throw ArgumentError.value(content, 'content', 'Content cannot be empty');
    }

    if (content.startsWith('{')) {
      return jsonParser(UniversalFeed._(), content);
    }

    final doc = XmlDocument.parse(content);
    final root = doc.rootElement;

    final feed = UniversalFeed._()..meta = MetaData.rssFromXml(doc);

    if (feed.meta.kind == FeedKind.rss) {
      rssXmlParser(feed, doc);
    } else if (feed.meta.kind == FeedKind.atom) {
      atomXmlParser(feed, root);
    }

    return feed;
  }

  /// Attempts to parse a feed string, returning `null` if parsing fails.
  ///
  /// This is a convenience method that catches all parsing exceptions and returns
  /// `null` instead of throwing. Use this when you don't want to handle exceptions
  /// yourself and prefer a simple null check.
  ///
  /// Returns:
  /// * A [UniversalFeed] object if parsing succeeds
  /// * `null` if parsing fails due to malformed input
  ///
  /// Example:
  /// ```dart
  /// final feed = UniversalFeed.tryParse(feedString);
  /// if (feed != null) {
  ///   print(feed.title);
  /// } else {
  ///   print('Failed to parse feed');
  /// }
  /// ```
  static UniversalFeed? tryParse(String content) {
    try {
      return UniversalFeed.parseFromString(content);
    } on FeedException {
      // Unsupported format, missing required fields, invalid field values
      return null;
    } on XmlParserException {
      // Malformed XML
      return null;
    } on XmlTagException {
      // XML tag errors
      return null;
    } on FormatException {
      // JSON parsing errors
      return null;
    }
  }
}
