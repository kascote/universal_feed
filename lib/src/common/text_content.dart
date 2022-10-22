import 'package:xml/xml.dart';

import '../../src/shared.dart';

/// Text container that will be 'decoded' based on his type when sourced.
class TextContent {
  /// Type of the text encoding. Could be txt, html, base64, etc
  late String? type;

  /// Original text value
  late String original;

  late String _value;

  /// Creates a new Text content from an [XmlElement]
  TextContent(XmlElement node, {this.type}) {
    original = node.text;
    type ??= node.getAttribute('type') ?? 'plain';
    _value = getContentText(type!, node);
  }

  /// Decoded value
  String get value => _value;
}
