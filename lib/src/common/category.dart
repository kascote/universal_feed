import 'package:xml/xml.dart';

import '../../src/shared.dart';

/// Holds information about a category assigned to an entry or feed
class Category {
  /// Provides a human-readable label for display in end-user applications
  String label;

  /// Identifies the category to which the entry or feed belongs
  String? term;

  /// Is an IRI that identifies a categorization scheme
  String? scheme;

  /// The text inside the tag
  String? value;

  /// Creates a new [Category] object
  Category({
    required this.label,
    this.term,
    this.scheme,
    this.value,
  });

  /// Creates a new cateogry object from an [XmlElement]
  factory Category.fromXML(XmlElement node) {
    final value = siblingText(node);
    return Category(
      scheme: node.getAttribute('domain') ?? node.getAttribute('scheme'),
      value: value,
      label: node.getAttribute('label') ?? value,
    );
  }

  @override
  String toString() {
    return '$label - $term - $scheme - $value';
  }

  /// Helper function to create a List of categories from
  /// an string separated by commas
  static List<Category> loadTags(XmlElement node, {String? defaulScheme}) {
    final tags = node.text.split(',');
    return List.generate(tags.length, (pos) => Category(label: tags.elementAt(pos).trim(), scheme: defaulScheme));
  }
}
