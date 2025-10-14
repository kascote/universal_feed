import 'package:xml/xml.dart';

/// Extensions for common types to simplify code and improve readability.
extension JsonMapExtensions on Map<String, dynamic> {
  /// Retrieves a value from the map and casts it to the specified type [T].
  /// Will return `null` if the key does not exist or the value is not of type [T].
  T? getTyped<T>(String key) {
    final value = this[key];
    return value is T ? value : null;
  }

  /// If the key exists and the value is of type [T], calls the provided [callback] with the value.
  void ifPresent<T>(String key, void Function(T value) callback) {
    final value = getTyped<T>(key);
    if (value != null) callback(value);
  }
}

/// Extensions for XML element parsing to provide type-safe element extraction.
extension XmlElementParsing on XmlElement {
  /// Extracts element text content if the element exists.
  /// Calls [callback] with the innerText of the element.
  void ifPresent(
    String name,
    void Function(String text) callback, {
    String? ns,
  }) {
    final element = getElement(name, namespace: ns);
    if (element != null) callback(element.innerText);
  }

  /// Extracts element as XmlElement if it exists.
  /// Calls [callback] with the XmlElement itself.
  void ifPresentXml(
    String name,
    void Function(XmlElement element) callback, {
    String? ns,
  }) {
    final element = getElement(name, namespace: ns);
    if (element != null) callback(element);
  }

  /// Iterates over all matching elements and calls [callback] with each element's text content.
  void forEachElement(
    String name,
    void Function(String text) callback, {
    String? ns,
  }) {
    final elements = findElements(name, namespace: ns);
    for (final element in elements) {
      callback(element.innerText);
    }
  }

  /// Iterates over all matching elements and calls [callback] with each XmlElement.
  void forEachElementXml(
    String name,
    void Function(XmlElement element) callback, {
    String? ns,
  }) {
    findElements(name, namespace: ns).forEach(callback);
  }
}
