import 'package:xml/xml.dart';

import '../shared/shared.dart';

/// Object that hold or links to the content of a feed entry
class UniversalContent {
  /// Parsed content of the tag
  String value;

  /// Original type of the value
  String type;

  /// IRI pointing to the content
  String? src;

  /// Created a new [UniversalContent] object
  UniversalContent({required this.value, required this.type, this.src});

  ///
  // TODO(nelson): normalize this
  factory UniversalContent.fromV1Xml(XmlElement node) {
    final type = node.getAttribute('type') ?? 'text';

    return UniversalContent(
      value: textDecoder(type, node),
      type: type,
      src: node.getAttribute('src'),
    );
  }

  ///
  factory UniversalContent.fromXml(XmlElement node) {
    final type = node.getAttribute('mode') ?? node.getAttribute('type') ?? 'xml';
    return UniversalContent(
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
