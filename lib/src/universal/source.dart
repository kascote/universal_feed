import 'package:xml/xml.dart';

import '../../universal_feed.dart';
import 'extensions/atom/source_parser.dart';

/// Metadata about the source feed when an Atom entry is syndicated from another feed.
///
/// If an atom:entry is copied from one feed into another feed, then the
/// source atom:feed's metadata (all child elements of atom:feed other
/// than the atom:entry elements) MAY be preserved within a source element.
///
/// The atom:source element is designed to allow the aggregation of entries from
/// different feeds while retaining information about an entry's source feed.
///
/// atom ref: https://www.rfc-editor.org/rfc/rfc4287.html#section-4.2.11
class Source {
  /// Unique identifier for the source feed.
  String? guid;

  /// The name of the source feed.
  String? title;

  /// Phrase or sentence describing the source feed.
  String? subtitle;

  /// The URL to the HTML website corresponding to the source feed.
  Link? htmlLink;

  /// Collection of links related to the source feed.
  final List<Link> links = [];

  /// The last time the content of the source feed changed.
  Timestamp? updated;

  /// Authors of the source feed.
  final List<Author> authors = [];

  /// Specifies an image that can be displayed with the source feed.
  Image? image;

  /// Specifies an icon that provides iconic visual identification for the source feed.
  Image? icon;

  /// Copyright notice for content in the source feed.
  String? copyright;

  /// A string indicating the program used to generate the source feed.
  Generator? generator;

  /// Categories that the source feed belongs to.
  final List<Category> categories = [];

  Source._();

  /// Creates a new [Source] from an Atom source XML element
  factory Source.fromXml(XmlElement element) {
    final source = Source._();
    atomSourceParser(source, element);
    return source;
  }
}
