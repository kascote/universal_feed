import 'package:xml/xml.dart';

/// Link Relation Types
enum LinkRelationType {
  /// The value "alternate" signifies that the IRI in the value of the href
  /// attribute identifies an alternate version of the resource described by
  /// the containing element.
  alternate,

  /// The value "related" signifies that the IRI in the value of the href
  /// attribute identifies a resource related to the resource described by the
  /// containing element.  For example, the feed for a site that discusses the
  /// performance of the search engine at "http://search.example.com" might
  /// contain, as a child of atom:feed:
  ///
  /// `<link rel="related" href="http://search.example.com/"/>`
  ///
  /// An identical link might appear as a child of any atom:entry whose content
  /// contains a discussion of that same search engine.
  related,

  /// The value "self" signifies that the IRI in the value of the href attribute
  /// identifies a resource equivalent to the containing element.
  self,

  /// The value "enclosure" signifies that the IRI in the value of the href
  /// attribute identifies a related resource that is potentially large in size
  /// and might require special handling.  For atom:link elements with
  /// rel="enclosure", the length attribute SHOULD be provided.
  enclosure,

  /// The value "via" signifies that the IRI in the value of the href attribute
  /// identifies a resource that is the source of the information provided in
  /// the containing element.
  via,

  /// placeholder for unknown link types
  other,
}

/// A Link is a reference from one Web resource to another.
class Link {
  /// Link's REL attribute
  LinkRelationType rel;

  /// Original REL attribute. If the REL attribute is not a valid LinkRelationType
  /// his attribute will be set with the original REL value
  String? originalRel;

  /// Link's type attribute.
  String type;

  /// resource URI
  String href;

  /// Link's title
  String? title;

  /// Length of the linked content in octets
  String? length;

  /// Creates a new Link
  Link({
    required this.rel,
    required this.type,
    required this.href,
  });

  /// Helper factory to handle the [rel] attribute
  factory Link.create({
    required String type,
    required String href,
    required String rel,
  }) {
    return Link(
      rel: LinkRelationType.values.firstWhere((e) => e.name == rel, orElse: () => LinkRelationType.other),
      type: type,
      href: href,
    );
  }

  /// Creates a [Link] from an [XmlElement]
  factory Link.fromXml(XmlElement element) {
    final rel = element.getAttribute('rel') ?? '';

    return Link(
      rel: LinkRelationType.values.firstWhere((e) => e.name == rel, orElse: () => LinkRelationType.other),
      type: element.getAttribute('type') ?? '',
      href: element.getAttribute('href') ?? '',
    )
      ..title = element.getAttribute('title') ?? ''
      ..length = element.getAttribute('length') ?? ''
      ..originalRel = rel;
  }

  @override
  String toString() {
    return 'Link: $rel ~ $type ~ $title ~ $href ~ $length';
  }
}
