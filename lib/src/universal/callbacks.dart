import 'item.dart';
import 'raw_element.dart';
import 'universal_feed.dart';

/// Called after channel/feed parsing with both parsed feed and raw element.
///
/// This callback receives:
/// - [feed]: The fully parsed UniversalFeed object with all standard fields
/// - [raw]: The raw element (XmlRawElement or JsonRawElement) for custom field extraction
///
/// Use pattern matching to handle different formats:
/// ```dart
/// onChannelParse: (feed, raw) {
///   final customData = switch (raw) {
///     XmlRawElement() => extractFromXml(raw.element, feed.title),
///     JsonRawElement() => extractFromJson(raw.json, feed.title),
///   };
///   myStorage[feed.feedId] = customData;
/// }
/// ```
typedef OnChannelParse = void Function(UniversalFeed feed, RawElement raw);

/// Called after item/entry parsing with both parsed item and raw element.
///
/// This callback receives:
/// - [item]: The fully parsed Item object with all standard fields
/// - [raw]: The raw element (XmlRawElement or JsonRawElement) for custom field extraction
///
/// Use pattern matching to handle different formats:
/// ```dart
/// onItemParse: (item, raw) {
///   final metadata = switch (raw) {
///     XmlRawElement() => ItemMetadata.fromXml(raw.element, item.title ?? ''),
///     JsonRawElement() => ItemMetadata.fromJson(raw.json, item.title ?? ''),
///   };
///   myStorage[item.itemId] = metadata;
/// }
/// ```
typedef OnItemParse = void Function(Item item, RawElement raw);
