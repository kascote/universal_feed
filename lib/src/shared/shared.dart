import 'dart:convert';

import 'package:html_unescape/html_unescape.dart';
import 'package:xml/xml.dart';

/// Helper function to retrieve all the elements that match a node name. The callback will receive
/// each node individually
void getJsElements<T>(Map<String, dynamic> node, String fieldName, {required void Function(T) cb}) {
  final elements = node[fieldName] as List<dynamic>?;
  if (elements == null) return;
  elements.whereType<T>().forEach(cb);
}

/// Function that returns only text nodes from nodes at the same level.
/// Example xml:
///
/// ```xml
///     <node-1>
///       some text1
///       <some-node>
///         some text11
///       </some-node>
///       some text2
///     </node-1>
/// ```
///
/// the returned value will be
///    some text1 some text2
String siblingText(XmlNode node) {
  final nodes = node.descendants;
  if (nodes.isEmpty) return node.innerText;
  final value = nodes.first.siblings.where((n) => n is XmlText || n is XmlCDATA).map((n) => n.value).join().trim();
  if (value.isEmpty) return node.innerText;
  return value;
}

/// Decode different options of text nodes.
///
/// Supports multiple encoding types: xml, html, base64, html escaped, and text.
///
/// Returns empty string for unknown encoding types instead of throwing an 
/// exception, allowing feed parsing to continue even when encountering 
/// unfamiliar content encoding modes.
String textDecoder(String type, XmlElement item) {
  String value;
  switch (type) {
    // returns the inner xml without trying to decode it
    case 'application/xhtml+xml':
    case 'xml':
    case 'xhtml':
      value = item.innerXml.trim();
    // if the inner xml contains CDATA then return the text, if not,
    // consider the inner xml as html and only unescape it
    case 'xml2':
      final inner = item.innerXml.trim();
      if (inner.contains('CDATA')) {
        value = item.innerText;
      } else {
        final unescape = HtmlUnescape();
        value = unescape.convert(inner);
      }
    // decode html escaped text
    case '':
    case 'text':
    case 'plain':
    case 'text/plain':
    case 'html':
    case 'escaped':
      // TODO(nelson): item.text already escape html, we need to review
      // how capable is and maybe deprecate HtmlUnescape
      value = HtmlUnescape().convert(item.innerText.trim());
    // decode base64 text
    case 'application/octet-stream':
    case 'base64':
      value = utf8.decode(base64.decode(item.innerText.trim()));

    default:
      // Liberal parsing: return empty string for unknown encoding types
      value = '';
  }

  return value;
}
