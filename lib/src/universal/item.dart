import 'package:xml/xml.dart';

import './parsers/rss_parser.dart';
import '../../universal_feed.dart';

///
class UniversalItem {
  /// A string that uniquely identifies the item
  ///
  /// Guid stands for globally unique identifier. It's a string that uniquely identifies the item.
  /// When present, an aggregator may choose to use this string to determine if an item is new.
  /// There are no rules for the syntax of a guid. Aggregators must view them as a string.
  /// It's up to the source of the feed to establish the uniqueness of the string.
  ///
  /// If the guid element has an attribute named "isPermaLink" with a value of true, the reader
  /// may assume that it is a permalink to the item, that is, a url that can be opened in a Web browser,
  /// that points to the full item described by the <item> element.
  /// isPermaLink is optional, its default value is true. If its value is false, the guid may not be assumed
  /// to be a url, or a url to anything in particular.
  ///
  /// If "isPermaLink" is present and has a value of true, the value will be used as the [link] attribute
  ///
  /// rss ref: https://cyber.harvard.edu/rss/rss.html#ltguidgtSubelementOfLtitemgt
  String? guid;

  /// The title of the item.
  ///
  /// rss ref: https://cyber.harvard.edu/rss/rss.html#hrelementsOfLtitemgt
  String? title;

  /// The item synopsis.
  ///
  /// rss ref: https://cyber.harvard.edu/rss/rss.html#hrelementsOfLtitemgt
  String? description;

  /// The item content
  UniversalContent? content;

  /// The url of the item.
  ///
  /// rss ref: https://cyber.harvard.edu/rss/rss.html#hrelementsOfLtitemgt
  UniversalLink? link;

  /// Collection of links that are related to the item
  final List<UniversalLink> links = [];

  /// Its value is a date, indicating when the item was published. If it's a date in the future,
  /// aggregators may choose to not display the item until that date.
  ///
  /// rss ref: https://cyber.harvard.edu/rss/rss.html#ltpubdategtSubelementOfLtitemgt
  UniversalTimestamp? updated;

  /// Its value is a date, indicating when the item was published. If it's a date in the future,
  /// aggregators may choose to not display the item until that date.
  ///
  /// rss ref: https://cyber.harvard.edu/rss/rss.html#ltpubdategtSubelementOfLtitemgt
  UniversalTimestamp? published;

  /// Name and Email address of the author of the item.
  ///
  /// It's the email address of the author of the item. For newspapers and magazines syndicating via RSS,
  /// the author is the person who wrote the article that the <item> describes. For collaborative weblogs,
  /// the author of the item might be different from the managing editor or webmaster. For a weblog authored by a single
  /// individual it would make sense to omit the <author> element.
  ///
  /// rss ref: https://cyber.harvard.edu/rss/rss.html#ltauthorgtSubelementOfLtitemgt
  final List<UniversalAuthor> authors = [];

  ///
  UniversalImage? image;

  /// It has one optional attribute, domain, a string that identifies a categorization taxonomy.
  /// The value of the element is a forward-slash-separated string that identifies a hierarchic location in the indicated taxonomy.
  /// Processors may establish conventions for the interpretation of categories.
  ///
  /// rss ref: https://cyber.harvard.edu/rss/rss.html#ltcategorygtSubelementOfLtitemgt
  final List<UniversalCategory> categories = [];

  /// Describes a media object that is attached to the item.
  ///
  /// It has three required attributes. url says where the enclosure is located,
  /// length says how big it is in bytes, and type says what its type is, a standard MIME type.
  /// The url must be an http url.
  ///
  /// rss ref: https://cyber.harvard.edu/rss/rss.html#ltenclosuregtSubelementOfLtitemgt
  final List<UniversalEnclosure> enclosures = [];

  /// The RSS channel that the item came from.
  ///
  /// Its value is the name of the RSS channel that the item came from, derived from its <title>.
  /// It has one required attribute, url, which links to the feed
  ///
  /// rss ref: https://cyber.harvard.edu/rss/rss.html#ltsourcegtSubelementOfLtitemgt
  UniversalLink? source;

  /// URL of a page for comments relating to the item.
  ///
  /// If present, it is the url of the comments page for the item.
  ///
  /// rss ref: https://cyber.harvard.edu/rss/rss.html#ltcommentsgtSubelementOfLtitemgt
  UniversalLink? comments;

  UniversalItem._();

  /// Creates a new [UniversalItem]
  factory UniversalItem.rssFromXml(UniversalFeed uf, XmlElement rssItem) {
    final item = UniversalItem._();
    rssItemParser(uf, item, rssItem);
    return item;
  }
}
