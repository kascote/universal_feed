import 'package:xml/xml.dart';

/// Sealed class representing raw feed data in format-specific form.
///
/// This allows callbacks to receive the original raw data (XML or JSON)
/// along with the parsed objects, enabling extraction of custom fields
/// while reusing standard parsed data.
///
/// Use pattern matching to handle different formats:
/// ```dart
/// final data = switch (raw) {
///   XmlRawElement() => extractFromXml(raw.element),
///   JsonRawElement() => extractFromJson(raw.json),
/// };
/// ```
sealed class RawElement {
  /// The stable identifier for this element (feedId or itemId).
  final String id;

  RawElement(this.id);
}

/// XML-based feed data (RSS/Atom).
///
/// Contains the raw XmlElement from the parsed feed document.
/// Use this to extract custom fields from RSS or Atom feeds.
class XmlRawElement extends RawElement {
  /// The raw XmlElement representing the channel/feed or item/entry.
  final XmlElement element;

  /// Constructs an XmlRawElement with the given [id] and [element].
  XmlRawElement(super.id, this.element);
}

/// JSON-based feed data (JSON Feed).
///
/// Contains the raw JSON object from the parsed feed document.
/// Use this to extract custom fields from JSON feeds.
class JsonRawElement extends RawElement {
  /// The raw JSON object representing the feed or item.
  final Map<String, dynamic> json;

  /// Constructs a JsonRawElement with the given [id] and [json].
  JsonRawElement(super.id, this.json);
}
