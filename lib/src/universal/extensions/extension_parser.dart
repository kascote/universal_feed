import 'package:xml/xml.dart';

import '../../../universal_feed.dart';

/// Base interface for all extension parsers
abstract class ExtensionParser {
  /// The namespace URL for this extension (used for XML lookups)
  String get namespaceUrl;
}

/// Interface for extensions that parse channel/feed-level data
abstract class ChannelExtensionParser extends ExtensionParser {
  /// Parse channel/feed-level extension data
  void parseChannel(UniversalFeed feed, XmlElement channel);
}

/// Interface for extensions that parse item/entry-level data
abstract class ItemExtensionParser extends ExtensionParser {
  /// Parse item/entry-level extension data
  void parseItem(UniversalFeed feed, Item item, XmlElement element);
}
