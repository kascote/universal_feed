import 'package:xml/xml.dart';

import '../../src/shared.dart';

/// Object that hold or links to the content of a feed entry
class Content {
  /// Parsed content of the tag
  String value;

  /// Original type of the value
  String type;

  /// IRI pointing to the content
  String? src;

  /// Created a new [Content] object
  Content({required this.value, required this.type, this.src});

  ///
  factory Content.fromV1Xml(XmlElement node) {
    final type = node.getAttribute('type') ?? 'text';

    return Content(
      value: getContentText(type, node),
      type: type,
      src: node.getAttribute('src'),
    );
  }

  ///
  factory Content.fromXml(XmlElement node) {
    return Content(
      value: getContentText(node.getAttribute('mode') ?? 'xml', node),
      type: 'text',
      src: node.getAttribute('src'),
    );
  }

  @override
  String toString() {
    return '$type $src $value';
  }
}
