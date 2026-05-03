# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Universal Feed is a Dart library that parses RSS, Atom, and JSON feeds into a unified data model. It supports multiple
feed format versions (RSS 0.90-2.0, Atom 0.3/1.0, JSON Feed 1.0/1.1) and common feed extensions (Dublin Core, Media
RSS, iTunes/Podcast, GeoRSS, Syndication).

The library is designed to be liberal in parsing - it makes minimal assumptions about feed content and defers complex
operations like timestamp parsing to the consumer.

## Development Commands

### Testing

```bash
# Run all tests
make test

# Run a specific test file
make testf FILE=test/rss_cases.dart

# Run with coverage and open HTML report
make cover
```

### Linting

```bash
# lint the whole project
make lint

# lint a specific file
dart lint FILE=lib/src/universal/universal_feed.dart
```

## Architecture

### Core Parsing Flow

1. **Entry Point**: `UniversalFeed.parseFromString(String content)` in `lib/src/universal/universal_feed.dart`
   - Detects feed format by content (JSON starts with `{`, otherwise XML)
   - Creates `MetaData` to identify feed type, version, and registered namespaces
   - Routes to appropriate parser based on feed kind

2. **Format-Specific Parsers** in `lib/src/universal/parsers/`:
   - `rss_parser.dart`: Handles all RSS versions (0.90-2.0)
   - `atom_parser.dart`: Handles Atom 0.3 and 1.0
   - `json_parser.dart`: Handles JSON Feed 1.0 and 1.1

3. **Two-Phase Parsing**:
   - Phase 1: Parse feed-level metadata (channel/feed)
   - Phase 2: Parse items/entries into `Item` objects

### Unified Data Model

The `UniversalFeed` class provides a normalized view across formats:

- RSS `<channel>` and Atom `<feed>` → `UniversalFeed` properties
- RSS `<item>` and Atom `<entry>` → `Item` objects in `items` list
- Different field names mapped to common properties (see `field_mapping.md`)

Key entities:

- `UniversalFeed`: Root feed object with metadata and items
- `Item`: Individual feed entry/item
- `MetaData`: Feed type, version, and extension information
- `Timestamp`: Unparsed timestamp string with helper methods for parsing
- `Link`, `Author`, `Category`, `Enclosure`, `Content`, `Image`: Supporting data types

### Extension Support

Extensions are namespace-based and detected via `MetaData.extensions`:

- **DC Terms** (`lib/src/universal/extensions/dcterms/`): Dublin Core metadata (author, creator, contributor, publisher, date, rights, subject, etc.)
- **Media RSS** (`lib/src/universal/extensions/media/`): Rich media content (images, videos, audio with thumbnails, credits, ratings)
- **iTunes/Podcast** (`lib/src/universal/extensions/podcast/`): Podcast-specific metadata (duration, episode info, explicit flag, etc.)
- **GeoRSS** (`lib/src/universal/extensions/geo/`): Geographic location data (lat/long points)
- **Syndication** (`lib/src/universal/extensions/syndication/`): Update frequency and scheduling
- **Content** (inline in parsers): Content-encoded extension for full HTML/text content

Extensions are conditionally parsed based on namespace registration:

```dart
if (uf.meta.extensions.hasMedia) {
  item.media = Media.contentFromXml(uf, element);
}
```

**Note**: Extension data classes contain the parsed data and are accessible via `UniversalFeed` and `Item` properties (e.g., `feed.syndication`, `item.media`, `item.podcast`, `item.dcterms`, `item.geo`).

### Custom Entity Extraction

The library supports extracting custom fields from feeds via optional callbacks, allowing users to maintain fully-typed storage for fields not covered by the standard model or built-in extensions.

**Core Components** (`lib/src/universal/`):
- `callbacks.dart`: Callback typedefs (`OnChannelParse`, `OnItemParse`)
- `raw_element.dart`: Sealed class hierarchy for format-agnostic raw data access
  - `RawElement`: Base sealed class with stable ID
  - `XmlRawElement`: Wrapper for XML elements (RSS/Atom)
  - `JsonRawElement`: Wrapper for JSON objects (JSON Feed)

**Key Features**:
1. **Fully Typed Storage**: Users define their own data structures, no `dynamic` casting
2. **Stable IDs**: `feedId` and `itemId` remain constant after filtering/sorting operations
3. **Format-Agnostic**: Single callback can handle XML and JSON via sealed class pattern matching
4. **Access to Parsed Data**: Callbacks receive both raw elements AND parsed objects (reuse standard fields)
5. **Leverages Existing Utilities**: Uses `XmlElementParsing` and `JsonMapExtensions` for extraction

**Usage Example**:

```dart
// Define typed storage
final customData = <String, ArticleMetadata>{};

final feed = UniversalFeed.parseFromString(
  content,
  onItemParse: (item, raw) {
    // Pattern match on format - single callback handles both!
    final metadata = switch (raw) {
      XmlRawElement() => _extractFromXml(raw.element, item.title ?? ''),
      JsonRawElement() => _extractFromJson(raw.json, item.title ?? ''),
    };
    customData[item.itemId] = metadata;
  },
);

// Access with stable matching - fully typed!
for (final item in feed.items) {
  final metadata = customData[item.itemId]!;
  print('${metadata.title}: ${metadata.customField}');
}

// IDs stay stable after filtering/sorting
final filtered = feed.items.where((i) => i.title?.contains('Dart') ?? false);
final meta = customData[filtered.first.itemId]!; // Still works!
```

**ID Generation Strategy**:
- **itemId**: Sequential per feed: `item_0`, `item_1`, `item_2`, etc.
- **feedId**: Uses feed guid/link/id if available, falls back to `feed_{timestamp}_{random}`

**See**: `examples/custom_extraction.dart` for comprehensive examples including:
- Basic custom field extraction from RSS
- Namespaced custom fields in Atom feeds
- Nested JSON object extraction
- Format-agnostic extraction with pattern matching
- Realistic podcast feed with custom metadata

### Shared Utilities

`lib/src/shared/` contains cross-format utilities:

- `date_parser.dart`: Flexible timestamp parsing for various formats
- `extensions.dart`: Extension methods for type-safe parsing
  - `JsonMapExtensions`: Safe JSON map access (`getTyped<T>()`, `ifPresent<T>()`)
  - `XmlElementParsing`: XML element extraction with callbacks
    - `ifPresent()`: Extract element text if exists
    - `ifPresentXml()`: Extract element as XmlElement if exists
    - `forEachElement()`: Iterate over matching elements (text content)
    - `forEachElementXml()`: Iterate over matching elements (XmlElement)
- `errors.dart`: Custom exception types
- `tz_data.dart`: Timezone abbreviation data

### Parsing Helpers

The parsers use helper functions in `lib/src/shared/shared.dart`:

- `textDecoder()`: Handle different text encoding modes (text/html/xml/escaped/base64)
- `siblingText()`: Extract text nodes at the same level, excluding child element text
- `getJsElements<T>()`: Extract typed elements from JSON maps with callbacks

**Parsing Style**: Use the `XmlElementParsing` extension methods (e.g., `element.ifPresent()`) for XML parsing with clean cascade notation.

## Key Design Patterns

1. **Liberal Parsing**: The library doesn't validate or throw errors for malformed data; it extracts what it can
2. **Deferred Processing**: Timestamps are stored as strings; callers use `Timestamp.parse()` methods when needed
3. **Factory Constructors**: Each entity has format-specific factories (`Item.rssFromXml()`, `Item.atomFromXml()`, `Item.jsonFromJson()`) that are thin wrappers around parser functions (`rssItemParser()`, `atomItemParser()`, `jsonItemParser()`)
4. **Namespace-Aware**: XML parsing respects namespace prefixes for extensions
5. **Type-Safe Extraction**: Uses generics and extension methods for safe data extraction
6. **Parser Functions**: Core parsing logic lives in dedicated parser functions (e.g., `rssChannelParser()`, `rssItemParser()`) that are called by factory constructors

## Testing Strategy

Tests are organized by feed type and extension:

- **Format-specific test cases**:
  - `rss_cases.dart`: RSS feed parsing tests
  - `atom_cases.dart`: Atom 0.3 feed parsing tests
  - `atom10_cases.dart`: Atom 1.0 feed parsing tests
  - `json10_cases.dart`: JSON Feed 1.0 parsing tests
  - `json11_cases.dart`: JSON Feed 1.1 parsing tests
- **Extension-specific test cases**:
  - `dcterm_cases.dart`: Dublin Core/DC Terms extension tests
  - `itunes_cases.dart`: iTunes/Podcast extension tests
  - `media_rss_cases.dart`: Media RSS extension tests
  - `syndication_cases.dart`: Syndication extension tests
  - `georss_cases.dart`: GeoRSS extension tests
- **Unit tests**: `date_parser_test.dart`, `universal_feed_test.dart`, `meta_test.dart`, `general_test.dart`, `extensions_test.dart`
- **Integration tests**: `wellformed/` directory contains real-world feed samples organized by format (atom/, rss/, json/)
- Tests use sample XML/JSON strings with assertions on parsed output, validating that data is correctly extracted into the `UniversalFeed` model

## Field Mapping

See `field_mapping.md` for the complete mapping between RSS, Atom, and JSON Feed fields to `UniversalFeed` properties. This is essential when adding support for new fields or debugging parsing issues.
