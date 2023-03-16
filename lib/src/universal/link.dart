///
// <link rel="alternate" type="text/html" href="https://ipaintfish.com" />
// <link rel="self" type="application/atom+xml" href="https://ipaintfish.com/feed/atom/" />
// <link rel="replies" type="application/atom+xml" href="https://ipaintfish.com/eye-sea-you-fish-2022-art/feed/atom/" thr:count="0"/>
// <link rel="replies" type="text/html" href="https://ipaintfish.com/whimsical-stargayzer-2022-art/#comments" thr:count="0"/>

/// Link Relation Types
enum LinkRelationType {
  /// The "alternate" Link Relation Type indicates that the referenced resource is a substitute for the current document.
  alternate,

  /// The "self" Link Relation Type indicates that the referenced resource is a representation of the current document.
  self,

  /// The "replies" Link Relation Type indicates that the referenced resource is a resource providing information about the link's context.
  replies,

  /// The "enclosure" Link Relation Type indicates that the referenced resource is a related resource that is potentially large in size and might require special handling.
  enclosure,

  /// placeholder for unknown link types
  other,
}

/// A Link is a reference from one Web resource to another.
class UniversalLink {
  /// Link's REL attribute
  LinkRelationType rel;

  /// Link's type attribute.
  String type;

  /// resource URI
  String href;

  /// Link's title
  String? title;

  /// Length of the linked content in octets
  String? length;

  // TODO: Handle more complex links like Atom and links in RSS
  /// Creates a new Link
  UniversalLink({
    required this.rel,
    required this.type,
    required this.href,
  });

  /// Helper create method to handle more easily the [rel] attribute
  factory UniversalLink.create({
    required String type,
    required String href,
    required String rel,
  }) {
    return UniversalLink(
      rel: LinkRelationType.values.firstWhere((e) => e.name == rel, orElse: () => LinkRelationType.other),
      type: type,
      href: href,
    );
  }

  @override
  String toString() {
    return 'Link: $rel ~ $type ~ $title ~ $href ~ $length';
  }
}
