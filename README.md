# Universal Feed Parser

Universal Feed is a feed parser that supports RSS, Atom and JSON feeds. The library unifies the parsing of different feeds in a common entity, simplifying consumption.

Supported feeds versions

* RSS 0.90
* Netscape RSS 0.91
* Userland RSS 0.91
* RSS 0.92
* RSS 0.93
* RSS 0.94
* RSS 1.0
* RSS 2.0
* Atom 0.3
* Atom 1.0
* JSON Feed 1.0
* JSON Feed 1.1

Supported feeds extensions

* Dublin Core
* Dublin Core Terms
* Geo RSS
* Media RSS
* Syndication
* Itunes
* PodcastIndex / Podcasting 2.0 (value4value, transcripts, chapters, liveItem, alternateEnclosure, persons, soundbites, etc.)
* Content (`content:encoded`)

## Overview

The parser is liberal on purpose. It makes no assumptions about the data and tries to extract whatever the feed has, even if the feed is a bit broken — no validation, no exceptions thrown for malformed content, you get whatever could be read.

Some operations are deferred to the consumer. For example, `timestamps` are read as-is and exposed as a `Timestamp` object with helpers, so you only pay the parsing cost when you actually need a `DateTime`.

The library is heavily tested against a corpus of 960~ real-world feed samples in `test/wellformed/`, covering every supported format and extension, so weird edge cases tend to be already covered.

To understand the mapping of RSS, Atom and JSON Feed to Universal Feed you can check [this file](./field_mapping.md).

## Getting started

A minimal example:

```dart
import 'dart:io';
import 'package:universal_feed/universal_feed.dart';

void main() {
  final content = File('feed.xml').readAsStringSync();
  final uf = UniversalFeed.parseFromString(content);

  print(uf.title);
  print(uf.description);
  print(uf.meta.kind);       // rss / atom / json
  print(uf.meta.version);    // feed version
  print(uf.meta.extensions); // extensions declared on the header

  for (final item in uf.items.take(5)) {
    print('- ${item.title}');
    print('  ${item.links.firstOrNull?.href}');
    print('  ${item.published?.parseValue()?.toIso8601String()}');

    // extensions are conditionally available
    if (item.podcast != null) {
      print('  transcripts: ${item.podcast!.transcripts.length}');
    }
  }
}
```

More examples in [`example/`](./example/), including custom field extraction via callbacks for fields not covered by the standard model.

## Developing

The library is fairly new but the 960~ feed test corpus catches a lot. There are still some parts I want to review and maybe refactor — PRs and bug reports welcome.
