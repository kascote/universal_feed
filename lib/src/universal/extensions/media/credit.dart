import 'package:xml/xml.dart';

/// Hols the contribution to the creation of the media object.
class Credit {
  /// original value of the tag
  String value;

  /// specifies the role the entity played
  String? role;

  /// is the URI that identifies the role scheme.
  String? scheme;

  /// Creates a new [Credit] object
  Credit(this.value);

  /// Creates a new [Credit] object from an [XmlElement]
  factory Credit.fromXml(XmlElement node) {
    return Credit(node.innerText)
      ..role = node.getAttribute('role')
      ..scheme = node.getAttribute('scheme');
  }

  @override
  String toString() {
    return '$value [$role - $scheme]';
  }
}
