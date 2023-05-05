import 'package:xml/xml.dart';

import '../shared/shared.dart';

/// Element either contains or links to the content of the entry.
class Content {
  /// Parsed content
  String value;

  /// Original value's content-type
  String type;

  /// IRI pointing to the content
  ///
  /// ref IRI: https://www.rfc-editor.org/rfc/rfc3987
  String? src;

  /// Created a new [Content] object
  Content({required this.value, required this.type, this.src});

  /// Creates a new [Content] object from an [XmlElement]
  factory Content.fromXml(XmlElement node, {String defaultType = 'xml'}) {
    final type = node.getAttribute('mode') ?? node.getAttribute('type') ?? defaultType;
    return Content(
      value: textDecoder(type, node),
      type: type,
      src: node.getAttribute('src'),
    );
  }

  @override
  String toString() {
    return '$type $src $value';
  }
}
