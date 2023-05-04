import 'package:xml/xml.dart';

import '../shared/shared.dart';

/// Holds information about a category associated to an entry or feed
class Category {
  /// Provides a human-readable label for display in end-user applications
  String label;

  /// Identifies the category to which the entry or feed belongs to
  String? term;

  /// Is an IRI that identifies a categorization scheme
  ///
  /// ref IRI: https://www.rfc-editor.org/rfc/rfc3987
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
  static Category? fromXml(XmlElement node) {
    final value = siblingText(node);
    final scheme = node.getAttribute('domain') ?? node.getAttribute('scheme');
    final label = node.getAttribute('label');
    final term = node.getAttribute('term');

    if (scheme == null && label == null && value.trim().isEmpty) {
      return null;
    }

    return Category(scheme: scheme, value: value, label: label ?? value, term: term);
  }

  /// Helper function to create a List of categories from
  /// an string separated by commas
  static List<Category>? loadTags(XmlElement node, {String? defaultScheme}) {
    final tags = node.text.split(',').where((e) => e.isNotEmpty);
    if (tags.isEmpty) return null;
    return List.generate(
      tags.length,
      (pos) => Category(label: tags.elementAt(pos).trim(), scheme: defaultScheme),
    );
  }
}
