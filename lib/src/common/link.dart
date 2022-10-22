/// Container to hold an Link reference
class Link {
  /// REL attribute of the link
  String rel;

  /// Link's type's attibute.
  String type;

  /// URI to image
  String href;

  /// Link's title
  String? title;

  /// Link's size in bytes
  String? length;

  /// Creates a new Link
  Link({
    required this.rel,
    required this.type,
    required this.href,
  });

  @override
  String toString() {
    return 'Link: $rel ~ $type ~ $title ~ $href ~ $length';
  }
}
