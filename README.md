# Universal Feed Parser

Universal Feed is a feed parser that supports RSS and Atom feeds. The library unifies the parsing of different feeds in a common entity, simplifying consumption.

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

Supported feeds extensions

* Dublin Core
* Dublin Core Terms
* Geo RSS
* Media RSS
* Syndication
* Itunes

## Overview

This library makes no assumptions about the data parsed and tries to be quite liberal about the feed's content.
For example, `timestamps`, the field's value is read, but there is no attempt to parse them when the feed is processed. The TimeStamp object used has methods to help with the parsing.
To understand the mapping of RSS and Atom to Universal Feed can check [this file](./field_mapping.md).

## Getting started

Here is a simple example to get started:

```dart
  final file = File(filepath);
  final content = file.readAsStringSync();

  final uf = UniversalFeed.parseFromString(content);
  print(uf.title);
  print(uf.description);
  print(uf.meta.kind); // rss or atom
  print(uf.meta.extensions); // extensions declared on the header
  print(uf.meta.version); // feed version
```

## Developing

The library is entirely new and was not battle-tested yet. I'm using a corpus of 400~ feeds, and it goes through
it without trouble. But there are still some parts that I want to review and maybe refactor.
