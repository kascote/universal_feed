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

  /// Creates a new category object from an [XmlElement]
  static Category? fromXML(XmlElement node) {
    final value = siblingText(node);
    final scheme = node.getAttribute('domain') ?? node.getAttribute('scheme');
    final label = node.getAttribute('label');

    if (scheme == null && label == null && value.trim().isEmpty) {
      return null;
    }

    return Category(
      scheme: scheme,
      value: value,
      label: label ?? value,
    );
  }

  @override
  String toString() {
    final sb = StringBuffer()
      ..write(label)
      ..write(term == null ? '' : ' : $term')
      ..write(scheme == null ? '' : ' : $scheme')
      ..write(value == null ? '' : ' : $value');
    return sb.toString();
  }

  /// Helper function to create a List of categories from
  /// an string separated by commas
  static List<Category>? loadTags(XmlElement node, {String? defaultScheme}) {
    final tags = node.text.split(',').where((e) => e.isNotEmpty);
    if (tags.isEmpty) return null;
    return List.generate(tags.length, (pos) => Category(label: tags.elementAt(pos).trim(), scheme: defaultScheme));
  }
}
