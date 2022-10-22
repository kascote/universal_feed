import 'package:xml/xml.dart';

import '../../src/atom/atom.dart';
import '../../src/common/author.dart';
import '../../src/common/generator.dart';
import '../../src/common/link.dart';
import '../../src/shared.dart';

/// Contains all the feed fields except the [Atom.entries]
class AtomHead {
  /// The "atom:title" element is a Text construct that conveys a human-
  /// readable title for an entry or feed.
  ///
  /// spec: https://www.rfc-editor.org/rfc/rfc4287.html#section-4.2.14
  String? title;

  /// Different kind of Links related to the feed
  /// The "atom:link" element defines a reference from an entry or feed to
  /// a Web resource.  This specification assigns no meaning to the content
  /// (if any) of this element.
  ///
  /// spec: https://www.rfc-editor.org/rfc/rfc4287.html#section-4.2.7
  List<Link>? links;

  /// The "atom:author" element is a Person construct that indicates the
  /// author of the entry or feed.
  ///
  /// spec: https://www.rfc-editor.org/rfc/rfc4287.html#section-4.2.1
  List<Author>? authors;

  /// The "atom:contributor" element is a Person construct that indicates a
  /// person or other entity who contributed to the entry or feed.
  ///
  /// spec: https://www.rfc-editor.org/rfc/rfc4287.html#section-4.2.3
  List<Author>? contributors;

  /// The "atom:generator" element's content identifies the agent used to
  /// generate a feed, for debugging and other purposes.
  ///
  /// spec: https://www.rfc-editor.org/rfc/rfc4287.html#section-4.2.4
  Generator? generator;

  /// The "atom:id" element conveys a permanent, universally unique
  /// identifier for an entry or feed.
  ///
  /// spec: https://www.rfc-editor.org/rfc/rfc4287.html#section-4.2.6
  String? id;

  ///
  String? info;

  /// The "atom:updated" element is a Date construct indicating the most
  /// recent instant in time when an entry or feed was modified in a way
  /// the publisher considers significant.
  ///
  /// spec: https://www.rfc-editor.org/rfc/rfc4287.html#section-4.2.15
  String? updated;

  ///
  String? tagline;

  /// The "atom:icon" element's content is an IRI reference RFC3987 that
  /// identifies an image that provides iconic visual identification for a
  /// feed.
  ///
  /// spec: https://www.rfc-editor.org/rfc/rfc4287.html#section-4.2.5
  String? icon;

  /// The "atom:logo" element's content is an IRI reference RFC3987 that
  /// identifies an image that provides visual identification for a feed.
  ///
  /// spec: https://www.rfc-editor.org/rfc/rfc4287.html#section-4.2.8
  String? logo;

  /// The "atom:rights" element is a Text construct that conveys
  /// information about rights held in and over an entry or feed.
  ///
  /// spec: https://www.rfc-editor.org/rfc/rfc4287.html#section-4.2.10
  String? rights;

  /// The "atom:subtitle" element is a Text construct that conveys a human-
  /// readable description or subtitle for a feed.
  ///
  /// spec: https://www.rfc-editor.org/rfc/rfc4287.html#section-4.2.12
  String? subtitle;

  ///
  factory AtomHead.fromXml(Atom atom, XmlElement node) {
    final head = AtomHead._()
      ..authors = getListFromNodes<Author>(
        node,
        'author',
        cb: (xml) => Author(
          name: xml.getElement('name')?.text ?? '',
          email: xml.getElement('email')?.text ?? '',
          url: xml.getElement('uri')?.text ?? xml.getElement('homepage')?.text ?? xml.getElement('url')?.text ?? '',
        ),
      )
      ..contributors = getListFromNodes<Author>(
        node,
        'contributor',
        cb: (xml) => Author(
          name: xml.getElement('name')?.text ?? '',
          email: xml.getElement('email')?.text ?? '',
          url: xml.getElement('uri')?.text ?? xml.getElement('homepage')?.text ?? xml.getElement('url')?.text ?? '',
        ),
      )
      ..links = getListFromNodes<Link>(
        node,
        'link',
        cb: (node) {
          final lnk = Link(
            rel: node.getAttribute('rel') ?? '',
            type: node.getAttribute('type') ?? '',
            href: node.getAttribute('href') ?? '',
          )
            ..title = node.getAttribute('title') ?? ''
            ..length = node.getAttribute('length') ?? '';
          return lnk;
        },
      );

    getElement<XmlElement>(
      node,
      'title',
      cb: (item) => head.title = atom.version == AtomVersion.v03
          ? getContentText(item.getAttribute('mode') ?? 'xml', item)
          : getContentText(item.getAttribute('type') ?? 'text', item),
    );

    getElement<String>(node, 'updated', cb: (value) => head.updated = value);
    getElement<String>(node, 'modified', cb: (value) => head.updated = value);
    getElement<XmlElement>(
      node,
      'generator',
      cb: (xml) => head.generator = Generator(
        xml.text,
        xml.getAttribute('version') ?? '',
        xml.getAttribute('url') ?? xml.getAttribute('uri') ?? '',
      ),
    );
    getElement<String>(node, 'id', cb: (value) => head.id = value);
    getElement<XmlElement>(
      node,
      'info',
      cb: (item) => head.info = getContentText(item.getAttribute('mode') ?? 'xml', item),
    );
    getElement<XmlElement>(
      node,
      'tagline',
      cb: (item) => head.tagline = getContentText(item.getAttribute('mode') ?? 'xml', item),
    );
    getElement<String>(node, 'icon', cb: (value) => head.icon = value);
    getElement<String>(node, 'logo', cb: (value) => head.logo = value);
    getElement<XmlElement>(
      node,
      'rights',
      cb: (item) => head.rights = getContentText(item.getAttribute('type') ?? 'text', item),
    );
    getElement<XmlElement>(
      node,
      'subtitle',
      cb: (item) => head.subtitle = getContentText(item.getAttribute('type') ?? 'text', item),
    );

    return head;
  }

  AtomHead._();

  /// Unique entry identifier
  String? get guid => id;
}
