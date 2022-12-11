/// Container to hold an Link reference
class Link {
  /// Link's REL attribute
  String rel;

  /// Link's type attribute.
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
