import 'package:xml/xml.dart';

import './shared.dart';

/// Holds information about a category assigned to an entry or feed
class UniversalCategory {
  /// Provides a human-readable label for display in end-user applications
  String label;

  /// Identifies the category to which the entry or feed belongs to
  String? term;

  /// Is an IRI that identifies a categorization scheme
  String? scheme;

  /// The text inside the tag
  String? value;

  /// Creates a new [UniversalCategory] object
  UniversalCategory({
    required this.label,
    this.term,
    this.scheme,
    this.value,
  });

  /// Creates a new category object from an [XmlElement]
  static UniversalCategory? fromXML(XmlElement node) {
    final value = siblingText(node);
    final scheme = node.getAttribute('domain') ?? node.getAttribute('scheme');
    final label = node.getAttribute('label');

    if (scheme == null && label == null && value.trim().isEmpty) {
      return null;
    }

    return UniversalCategory(
      scheme: scheme,
      value: value,
      label: label ?? value,
    );
  }
}
