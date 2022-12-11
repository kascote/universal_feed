import 'package:xml/xml.dart';

import '../../src/shared.dart';
import '../../src/universal_feed_base.dart';

/// Atom feed entry representation
class Entry {
  /// The "atom:author" element is a Person construct that indicates the
  /// author of the entry or feed.
  ///
  /// spec: https://www.rfc-editor.org/rfc/rfc4287.html#section-4.2.1
  List<Author>? authors;

  /// The "atom:category" element conveys information about a category
  /// associated with an entry or feed.
  ///
  /// spec: https://www.rfc-editor.org/rfc/rfc4287.html#section-4.2.2
  List<Category>? categories;

  /// The "atom:content" element either contains or links to the content of
  /// the entry.
  ///
  /// spec: https://www.rfc-editor.org/rfc/rfc4287.html#section-4.1.3
  List<Content>? content;

  /// The "atom:contributor" element is a Person construct that indicates a
  /// person or other entity who contributed to the entry or feed.
  List<Author>? contributors;

  ///
  Timestamp? created;

  ///
  List<Enclosure>? enclosures;

  /// GeoRSS extension container
  GeoRss? geoRss;

  /// The "atom:id" element conveys a permanent, universally unique
  /// identifier for an entry or feed.
  String? id;

  /// The "atom:link" element defines a reference from an entry or feed to
  /// a Web resource.  This specification assigns no meaning to the content
  /// (if any) of this element.
  List<Link>? links;

  /// The "atom:published" element is a Date construct indicating an
  /// instant in time associated with an event early in the life cycle of
  /// the entry.
  Timestamp? published;

  /// The "atom:rights" element is a Text construct that conveys
  /// information about rights held in and over an entry or feed.
  String? rights;

  /// If an atom:entry is copied from one feed into another feed, then the
  /// source atom:feed's metadata (all child elements of atom:feed other
  /// than the atom:entry elements) MAY be preserved within the copied
  /// entry by adding an atom:source child element
  Entry? source;

  /// The "atom:summary" element is a Text construct that conveys a short
  /// summary, abstract, or excerpt of an entry.
  String? summary;

  /// The "atom:title" element is a Text construct that conveys a human-
  /// readable title for an entry or feed.
  String? title;

  /// The "atom:updated" element is a Date construct indicating the most
  /// recent instant in time when an entry or feed was modified in a way
  /// the publisher considers significant.
  Timestamp? updated;

  ///
  factory Entry.fromXml(Atom atom, XmlElement node) {
    final entry = Entry._()
      ..authors = getListFromNodes<Author>(
        node,
        'author',
        cb: (xml) => Author(
          name: xml.getElement('name')?.text ?? '',
          email: xml.getElement('email')?.text ?? '',
          url: xml.getElement('uri')?.text ?? xml.getElement('homepage')?.text ?? xml.getElement('url')?.text ?? '',
        ),
      );

    if (atom.version == AtomVersion.v03) {
      entry.content = getListFromNodes<Content>(
        node,
        'content',
        cb: Content.fromXml,
      );
    } else {
      entry.content = getListFromNodes<Content>(
        node,
        'content',
        cb: Content.fromV1Xml,
      );
    }
    entry.contributors = getListFromNodes<Author>(
      node,
      'contributor',
      cb: (xml) => Author(
        name: xml.getElement('name')?.text ?? '',
        email: xml.getElement('email')?.text ?? '',
        url: xml.getElement('uri')?.text ?? xml.getElement('homepage')?.text ?? xml.getElement('url')?.text ?? '',
      ),
    );

    getElement<String>(
      node,
      'created',
      cb: (value) => entry.created = Timestamp(value),
    );
    getElement<String>(
      node,
      'id',
      cb: (value) => entry.id = value,
    );
    getElement<String>(
      node,
      'issued',
      cb: (value) => entry.published = Timestamp(value),
    );
    entry.links = getListFromNodes<Link>(
      node,
      'link',
      cb: (node) {
        final lnk = Link(
          rel: node.getAttribute('rel') ?? '',
          type: node.getAttribute('type') ?? '',
          href: node.getAttribute('href') ?? '',
        )
          ..title = node.getAttribute('title')
          ..length = node.getAttribute('length');
        return lnk;
      },
    );

    entry.links?.where((element) => element.rel == 'enclosure').forEach((lnk) {
      final enc = Enclosure(url: lnk.href, length: lnk.length ?? '', type: lnk.type);
      if (entry.enclosures == null) {
        entry.enclosures = [enc];
      } else {
        entry.enclosures!.add(enc);
      }
    });

    getElement<String>(node, 'updated', cb: (value) => entry.updated = Timestamp(value));
    getElement<String>(node, 'modified', cb: (value) => entry.updated = Timestamp(value));
    getElement<String>(node, 'published', cb: (value) => entry.published = Timestamp(value));
    getElement<XmlElement>(
      node,
      'summary',
      cb: (item) => entry.summary = atom.version == AtomVersion.v03
          ? getContentText(item.getAttribute('mode') ?? 'xml', item)
          : getContentText(item.getAttribute('type') ?? 'text', item),
    );
    getElement<XmlElement>(
      node,
      'title',
      cb: (item) => entry.title = atom.version == AtomVersion.v03
          ? getContentText(item.getAttribute('mode') ?? 'xml', item)
          : getContentText(item.getAttribute('type') ?? 'text', item),
    );
    entry.categories = getListFromNodes<Category>(
      node,
      'category',
      cb: (xml) => Category(
        label: xml.getAttribute('label') ?? '',
        term: xml.getAttribute('term') ?? '',
        scheme: xml.getAttribute('scheme') ?? '',
      ),
    );
    getElement<XmlElement>(
      node,
      'rights',
      cb: (item) => entry.rights = getContentText(item.getAttribute('type') ?? 'text', item),
    );
    getElement<XmlElement>(
      node,
      'source',
      cb: (value) => entry.source = Entry.fromXml(atom, value),
    );

    if (atom.namespaces.hasGeoRss) {
      entry.geoRss = GeoRss.fromXml(atom.namespaces, node);
    }

    return entry;
  }

  Entry._();

  /// Unique Entry identifier
  String? get guid => id;
}
