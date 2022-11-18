import 'package:xml/xml.dart';

import './rss_source.dart';
import '../../src/shared.dart';
import '../../src/universal_feed_base.dart';

/// RSSItem is each ones of the entries of an RSS feed
class RSSItem {
  /// List of authors for this entry
  List<Author>? authors; // DC creator

  /// List of [Category] assigned to this Entry
  List<Category>? categories;

  /// Usually an URL pointing to the comments for this Entry
  String? comments;

  /// List of [Content] elements associated with this Entry
  List<Content>? content;

  /// List of Contributors for this Entry
  List<Author>? contributors;

  /// Entry's Copyrights
  String? copyright; // DC rights

  ///
  DcTerms? dcterms;

  /// Entry's description
  String? description;

  /// Media object attached to this Entry
  List<Enclosure>? enclosure;

  /// Date and time when this Entry is considered no longer valid
  Timestamp? expired; // RSS expirationDate

  /// Geo localization of this Entry
  GeoRss? georss;

  /// Unique identifier for this Entry
  String? guid;

  /// Identify if [guid] is a permanet one and will be valid over time
  bool guidIsPerma = false;

  /// In case of this entry makes reference to a podcast, this entry will hold information
  /// related to it
  ItunesItem? itunes;

  /// URI to the entry on the host platform
  Link? link;

  ///
  MediaRss? media;

  /// TimeStamp when this entry eas first publised
  Timestamp? published; // RSS pubDate

  /// Who was the publisher of this entry
  Author? publisher;

  /// Identifies the Entry's source
  RSSSource? source;

  /// Little summary of the content of the Entry
  String? summary;

  /// Title of the Entry
  String? title;

  /// Last date and time when this entry was updated
  Timestamp? updated; // DC date

  /// Parse an [RSSItem] from an [XmlElement]
  factory RSSItem.fromXML(RSS rss, XmlElement xml) {
    if (xml.name.local != 'item') {
      throw FeedError('XML Element is not an Item element (${xml.name.local})');
    }

    final item = RSSItem._();

    getElement<String>(xml, 'title', cb: (value) => item.title = value);
    getElement<String>(xml, 'link', cb: (value) => item.link = Link(href: value, type: 'link', rel: ''));
    getElement<XmlElement>(xml, 'description', cb: (value) => item.description = getContentText('xml2', value));

    item
      ..comments = xml.getElement('comments')?.text
      .._resolveGuid(xml.getElement('guid'));
    getElement<String>(xml, 'pubDate', cb: (value) => item.published = Timestamp(value));

    getListFromXmlList<Author>(
      xml,
      'author',
      start: item.authors ?? [],
      generator: (value) => Author.fromString(value.text),
      storage: (value) => item.authors = value,
    );
    getElement<XmlElement>(xml, 'source', cb: (value) => item.source = RSSSource.fromXML(value));
    getListFromXmlList<Enclosure>(
      xml,
      'enclosure',
      start: item.enclosure ?? [],
      generator: Enclosure.fromXML,
      storage: (value) => item.enclosure = value,
    );
    getListFromXmlList<Category>(
      xml,
      'category',
      start: item.categories,
      generator: Category.fromXML,
      storage: (value) => item.categories = value,
    );
    getElements<XmlElement>(xml, 'tags', cb: (node) => item._loadCategories(Category.loadTags(node)));
    getElement<String>(xml, 'summary', cb: (value) => item.summary = value);
    getLastElement<String>(xml, 'expirationDate', cb: (value) => item.expired = Timestamp(value));

    if (rss.namespaces.hasDc) {
      final dcUrl = rss.namespaces.nsUrl(nsDublicCoreNs);
      getElement<String>(xml, 'title', ns: dcUrl, cb: (value) => item.title = value);
      getListFromXmlList<Author>(
        xml,
        'author',
        ns: dcUrl,
        start: item.authors ?? [],
        generator: (value) => Author.fromString(value.text),
        storage: (value) => item.authors = value,
      );
      getListFromXmlList<Author>(
        xml,
        'creator',
        ns: dcUrl,
        start: item.authors ?? [],
        generator: (value) => Author.fromString(value.text),
        storage: (value) => item.authors = value,
      );

      getElement<String>(xml, 'date', ns: dcUrl, cb: (value) => item.updated = Timestamp(value));
      getElement<String>(xml, 'description', ns: dcUrl, cb: (value) => item.description = value);
      getElement<String>(
        xml,
        'publisher',
        ns: dcUrl,
        cb: (value) => item.publisher = Author.fromString(value),
      );
      getElement<String>(xml, 'rights', ns: dcUrl, cb: (value) => item.copyright = value);
      getListFromXmlList<Author>(
        xml,
        'contributor',
        ns: dcUrl,
        start: item.contributors ?? [],
        generator: (value) => Author.fromString(value.text),
        storage: (value) => item.contributors = value,
      );
      getElement<String>(xml, 'title', ns: dcUrl, cb: (value) => item.title = value);
      getListFromXmlList<Category>(
        xml,
        'subject',
        ns: dcUrl,
        start: item.categories ?? [],
        generator: (value) => Category(label: value.text),
        storage: (value) => item.categories = value,
      );
    } // dublin core

    if (rss.namespaces.hasContent) {
      getListFromXmlList<Content>(
        xml,
        'encoded',
        ns: rss.namespaces.nsUrl(nsContentNs),
        start: item.content ?? [],
        generator: (value) => Content(value: value.text, type: 'text/html'),
        storage: (value) => item.content = value,
      );
    }

    if (rss.namespaces.hasMedia) {
      item.media = MediaRss.contentFromXml(rss, xml);
    }

    if (rss.namespaces.hasItunes) {
      item.itunes = ItunesItem.fromXml(rss, xml);
    }

    if (rss.namespaces.hasGeoRss) {
      item.georss = GeoRss.fromXml(rss.namespaces, xml);
    }

    if (rss.namespaces.hasDcTerms) {
      item.dcterms = DcTerms.parseFomXml(rss, xml);
    }

    return item;
  }

  RSSItem._();

  void _loadCategories(List<Category>? cats) {
    if (cats == null) return;

    if (categories == null) {
      categories = cats;
    } else {
      categories!.addAll(cats);
    }
  }

  void _resolveGuid(XmlElement? node) {
    if (node == null) return;

    final uri = node.text;
    guidIsPerma = node.getAttribute('isPermaLink') == 'true';

    if (guidIsPerma) {
      Uri.parse(uri);
      // if link is empty, make it equal to guid
      link ??= Link(href: uri, type: 'link', rel: '');
    }

    guid = uri;
  }
}
