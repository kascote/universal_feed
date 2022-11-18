import 'package:xml/xml.dart';

import './rss_cloud.dart';
import './rss_day.dart';
import './rss_hour.dart';
import '../shared.dart';
import '../universal_feed_base.dart';

/// Object to hold information related to the Site creator and the Feed being parsed
class RSSChannel {
  /// List of [Author]s for the Feed
  List<Author>? authors; // RSS managingEditor / DC creator

  /// List of [Category] associated with this feed
  List<Category>? categories;

  /// It specifies a web service that supports the rssCloud interface which can be implemented in HTTP-POST, XML-RPC or SOAP 1.1.
  RSSCloud? cloud;

  ///
  List<Author>? contributors;

  /// Copyright notice for content in the channel.
  String? copyright;

  ///
  String? description;

  /// A URL that points to the documentation for the format used in the RSS file.
  String? docs;

  /// A string indicating the program used to generate the channel.
  String? generator;

  /// Specifies a GIF, JPEG or PNG image that can be displayed with the channel.
  Image? image;

  ///
  ItunesChannel? itunes;

  /// The language the channel is written in.
  String? language;

  /// The URL to the HTML website corresponding to the channel.
  Link? link;

  /// The publication date for the content in the channel.
  Timestamp? published; // RSS pubDate

  /// Email address for person responsible for technical issues relating to channel.
  Author? publisher; // RSS webmaster

  /// The PICS rating for the channel.
  ///
  /// http://www.w3.org/PICS/
  String? rating;

  /// A hint for aggregators telling them which days they can skip.
  ///
  /// This element contains up to seven <day> sub-elements whose value is Monday, Tuesday,
  /// Wednesday, Thursday, Friday, Saturday or Sunday. Aggregators may not read the channel
  /// during days listed in the <skipDays> element.
  List<RSSDay>? skipDays;

  /// A hint for aggregators telling them which hours they can skip.
  ///
  /// This element contains up to 24 <hour> sub-elements whose value is a number between 0
  /// and 23, representing a time in GMT, when aggregators, if they support the feature,
  /// may not read the channel on hours listed in the <skipHours> element. The hour beginning
  /// at midnight is hour zero.
  List<RSSHour>? skipHours;

  ///
  Syndication? syndication;

  /// The name of the channel.
  String? title;

  /// TTL stands for time to live. It's a number of minutes that indicates how long a
  /// channel can be cached before refreshing from the source
  String? ttl;

  /// The last time the content of the channel changed.
  Timestamp? updated; // RSS lastBuildDate / DC date

  /// Creates an [RSSChannel] from a [XmlElement]
  factory RSSChannel.fromXML(RSS rss, XmlElement node) {
    final channel = RSSChannel._();

    getElement<String>(node, 'title', cb: (value) => channel.title = value);
    getElement<String>(node, 'link', cb: (value) => channel.link = Link(href: value, type: 'link', rel: ''));
    getElement<XmlElement>(node, 'description', cb: (value) => channel.description = getContentText('xml2', value));

    channel
      ..language = node.getElement('language')?.text
      ..copyright = node.getElement('copyright')?.text
      ..docs = node.getElement('docs')?.text;
    getElement<String>(node, 'lastBuildDate', cb: (value) => channel.updated = Timestamp(value));
    getElement<String>(node, 'pubDate', cb: (value) => channel.published = Timestamp(value));
    channel
      ..rating = node.getElement('rating')?.text
      ..generator = node.getElement('generator')?.text
      ..ttl = node.getElement('ttl')?.text
      ..skipHours = RSSHour.fromXML(node)
      ..skipDays = RSSDay.fromXML(node);
    getElement<XmlElement>(node, 'cloud', cb: (xml) => channel.cloud = RSSCloud.fromXML(xml));
    getElement<XmlElement>(node, 'image', cb: (xml) => channel.image = Image.fromXML(xml));
    channel.authors = getListFromNodes<Author>(node, 'author', cb: (value) => Author.fromString(value.text));
    getListFromXmlList<Author>(
      node,
      'managingEditor',
      start: channel.authors ?? [],
      generator: (value) => Author.fromString(value.text),
      storage: (value) => channel.authors = value,
    );
    getElement<String>(node, 'webMaster', cb: (value) => channel.publisher = Author.fromString(value));
    channel.categories = getListFromNodes<Category>(node, 'category', cb: Category.fromXML);

    if (rss.namespaces.hasDc) {
      final dcUrl = rss.namespaces.nsUrl(nsDublicCoreNs);
      /* Dublin Core */
      getListFromXmlList<Author>(
        node,
        'author',
        ns: dcUrl,
        start: channel.authors ?? [],
        generator: (value) {
          return Author.fromString(value.text);
        },
        storage: (value) => channel.authors = value,
      );
      getListFromXmlList<Author>(
        node,
        'managingEditor',
        ns: dcUrl,
        start: channel.authors ?? [],
        generator: (value) => Author.fromString(value.text),
        storage: (value) => channel.authors = value,
      );
      getListFromXmlList<Author>(
        node,
        'contributor',
        ns: dcUrl,
        start: channel.contributors ?? [],
        generator: (value) => Author.fromString(value.text),
        storage: (value) => channel.contributors = value,
      );
      getListFromXmlList<Author>(
        node,
        'creator',
        ns: dcUrl,
        start: channel.authors ?? [],
        generator: (value) => Author.fromString(value.text),
        storage: (value) => channel.authors = value,
      );
      getElement<String>(node, 'date', ns: dcUrl, cb: (value) => channel.updated = Timestamp(value));
      getElement<String>(
        node,
        'publisher',
        ns: dcUrl,
        cb: (value) => channel.publisher = Author.fromString(value),
      );
      getElement<String>(node, 'rights', ns: dcUrl, cb: (value) => channel.copyright = value);
      getElement<String>(node, 'title', ns: dcUrl, cb: (value) => channel.title = value);
      getElement<String>(node, 'language', ns: dcUrl, cb: (value) => channel.language = value);
      getListFromXmlList<Category>(
        node,
        'subject',
        ns: dcUrl,
        start: channel.categories ?? [],
        generator: (value) => Category(label: value.text),
        storage: (value) => channel.categories = value,
      );
    } // dublin core

    if (rss.namespaces.hasItunes) {
      channel.itunes = ItunesChannel.fromXml(rss, node);
    }

    if (rss.namespaces.hasSyndication) {
      channel.syndication = Syndication.fromXml(rss, node);
    }

    return channel;
  }

  RSSChannel._();
}
