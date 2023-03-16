import 'dart:convert';

import 'package:html_unescape/html_unescape.dart';
import 'package:xml/xml.dart';

import '../errors.dart';

/// Callback function for the [getElement] function
typedef ElementCallback<T> = void Function(T);

/// Helper function to retrieve the node or the node content as Text and execute the callback
/// only if the required node exists
void getElement<T>(XmlElement node, String fieldName, {required ElementCallback<T> cb, String? ns}) {
  final element = node.getElement(fieldName, namespace: ns);
  if (element != null) {
    if (T == String) cb(element.text as T);
    if (T == XmlElement) cb(element as T);
  }
}

/// Helper function to retrieve all the elements that match a node name. The callback will receive
/// each node individually
void getElements<T>(XmlElement node, String fieldName, {required ElementCallback<T> cb, String? ns}) {
  final elements = node.findElements(fieldName, namespace: ns);
  if (elements.isEmpty) return;

  for (final element in elements) {
    if (T == String) cb(element.text as T);
    if (T == XmlElement) cb(element as T);
  }
}

/// Function that returns only text nodes from nodes at the same level.
/// Example xml:
///
///     <node-1>
///       some text1
///       <some-node>
///         some text11
///       </some-node>
///       some text2
///     </node-1>
///
/// the returned value will be
///    some text1 some text2
String siblingText(XmlNode node) {
  final nodes = node.descendants;
  if (nodes.isEmpty) return node.text;
  final value = nodes.first.siblings.where((n) => n is XmlText || n is XmlCDATA).map((n) => n.text).join().trim();
  if (value.isEmpty) return node.text;
  return value;
}

/// Decode different options of text nodes
/// can decode xml, html, base64, html escaped
String textDecoder(String type, XmlElement item) {
  String value;
  switch (type) {
    // returns the inner xml without trying to decode it
    case 'xml':
    case 'xhtml':
      value = item.innerXml;
      break;
    // if the inner xml contains CDATA then return the text, if not,
    // consider the inner xml as html and only unescape it
    case 'xml2':
      final inner = item.innerXml;
      if (inner.contains('CDATA')) {
        value = item.text;
      } else {
        final unescape = HtmlUnescape();
        value = unescape.convert(inner);
      }
      break;
    // decode html escaped text
    case '':
    case 'text':
    case 'plain':
    case 'html':
    case 'escaped':
      // TODO: check that item.text already escape html
      value = HtmlUnescape().convert(item.text);
      break;
    // decode base64 text
    case 'application/octet-stream':
    case 'base64':
      value = utf8.decode(base64.decode(item.text.trim()));
      break;

    default:
      throw FeedError('field encoded mode type unknown: $type');
  }

  return value;
}
