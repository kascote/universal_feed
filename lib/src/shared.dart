import 'dart:convert';

import 'package:html_unescape/html_unescape.dart';
import 'package:xml/xml.dart';

import './errors.dart';

///
typedef ElementT<T> = void Function(T);

///
typedef ElementCB = void Function(String);

///
typedef ElementXmlCB = void Function(XmlElement);

///
typedef ListXmlCB<T> = T? Function(XmlElement);

///
typedef ListXmlCB2<T> = List<T>? Function(XmlElement);

///
typedef ListVoid<T> = void Function(List<T>);

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

/// Helper function to retrieve a node's attribute and execute the callback only if the
/// node exists
void getAttribute(XmlElement node, String attrName, {required ElementCB cb, String? ns}) {
  final attr = node.getAttribute(attrName, namespace: ns);
  if (attr == null) return;
  cb(attr);
}

/// Helper function to retrive the node or the node content as Text and execute the callback
/// only if the required node exists
void getElement<T>(XmlElement node, String fieldName, {required ElementT<T> cb, String? ns}) {
  final element = node.getElement(fieldName, namespace: ns);
  if (element != null) {
    if (T == String) cb(element.text as T);
    if (T == XmlElement) cb(element as T);
    /* throw FeedError('type constrain unknown: [$T] - ${element.toString()}'); */
  }
}

/// Helper function to retrive the node or the node content as Text and execute the callback
/// only if the required node exists
/// Is similar to [getElement] except that this function will return the last element if there
/// are multiple elements with the same tag
void getLastElement<T>(XmlElement node, String fieldName, {required ElementT<T> cb, String? ns}) {
  final elements = node.findElements(fieldName, namespace: ns);
  if (elements.isEmpty) return;

  final element = elements.last;
  if (T == String) cb(element.text as T);
  if (T == XmlElement) cb(element as T);
}

/// Helper function to retrieve all the elements that match a node name. The callback will receive
/// each node individually
void getElements<T>(XmlElement node, String fieldName, {required ElementT<T> cb, String? ns}) {
  final elements = node.findElements(fieldName, namespace: ns);
  if (elements.isEmpty) return;

  for (final element in elements) {
    if (T == String) cb(element.text as T);
    if (T == XmlElement) cb(element as T);
  }
}

/// Function that will collect all nodes with the same name and return a list. The content of the list
/// will be the return value of the callback function
List<T>? getListFromNodes<T>(XmlElement node, String fieldName, {required ListXmlCB<T> cb, String? ns}) {
  final elements = node.findElements(fieldName, namespace: ns);
  if (elements.isEmpty) return null;

  final rc = List<T>.of([]);
  for (final element in elements) {
    final ele = cb(element);
    if (ele != null) rc.add(ele);
  }

  return rc.isEmpty ? null : rc;
}

/// Helper function to capture tags that will share a common storage.
/// For example rss.categories and rss.tags will be stored under the same key
/// but we do not know the order they will appear and if both exists or only one
void getListFromXmlList<T>(
  XmlElement node,
  String fieldName, {
  required List<T>? start,
  required ListXmlCB<T> generator,
  required ListVoid<T> storage,
  String? ns,
}) {
  final elements = node.findElements(fieldName, namespace: ns);
  if (elements.isEmpty) return;

  final rc = List<T>.of(start ?? []);
  for (final element in elements) {
    final ele = generator(element);
    if (ele != null) rc.add(ele);
  }

  if (rc.isNotEmpty) storage(rc);
}

/// Helper function to capture tags that could expand to multiple objects.
/// For example a tag like
///
///     <tag>element1, element2, element3</tag>
///
/// And we want that each element be a different object
void getListFromElementList<T>(
  XmlElement node,
  String fieldName, {
  required List<T>? start,
  required ListXmlCB2<T> generator,
  required ListVoid<T> storage,
  String? ns,
}) {
  final elements = node.findElements(fieldName, namespace: ns);
  if (elements.isEmpty) return;

  final rc = List<T>.of(start ?? []);
  for (final element in elements) {
    final ele = generator(element);
    if (ele != null) rc.addAll(ele);
  }

  if (rc.isNotEmpty) storage(rc);
}

/// Helper function to decode different options of text nodes
/// can decode xml, html, base64, html escaped
String getContentText(String type, XmlElement item) {
  String value;
  switch (type) {
    case 'xml':
    case 'xhtml':
      value = item.innerXml;
      break;
    case 'xml2':
      final inner = item.innerXml;
      if (inner.contains('CDATA')) {
        value = item.text;
      } else {
        final unescape = HtmlUnescape();
        value = unescape.convert(inner);
      }
      break;
    case '':
    case 'text':
    case 'plain':
    case 'html':
    case 'escaped':
      final unescape = HtmlUnescape();
      value = unescape.convert(item.text);
      break;
    case 'application/octet-stream':
    case 'base64':
      value = utf8.decode(base64.decode(item.text.trim()));
      break;

    default:
      throw FeedError('field encoded mode type unknown: $type');
  }

  return value;
}
