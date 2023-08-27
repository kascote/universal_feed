import 'package:xml/xml.dart';

/// This allows the permissible audience to be declared.
/// If this element is not included, it assumes that no restrictions are necessary.
class Rating {
  /// is the URI that identifies the rating scheme.
  String? scheme;

  /// original value of the entry
  String value;

  /// Creates a new [Rating] object
  Rating(this.value, [this.scheme]);

  /// Creates a new [Rating] object from an [XmlElement]
  factory Rating.fromXml(XmlElement node) {
    return Rating(node.innerText, node.getAttribute('scheme'));
  }
}
