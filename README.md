# Universal Feed Parser

Library to parse RSS and Atom feeds. It includes support for RSS from version 0.90 to 2.0 and Atom 0.3 and 1.0.

It has out-of-the-box support for some common extensions like:

  * Dublin Core
  * Dublin Core Terms
  * Geo RSS
  * Media RSS
  * Syndication
  * Itunes

This library makes no assumptions about the data parsed and tries to be quite liberal about the feed's content. 
For example, `timestamps`, the field's value is read, but there is no attempt to parse them. The 
TimeStamp object used to collect the data will have methods to help with the parsing later.

## Getting started

Simple example to get started:

```dart
  final file = File(filepath);
  final content = file.readAsStringSync();

  final uf = UniversalFeed(content);
  if (uf.kind == FeedKind.rss) {
    // work with feed as RSS
  } else {
    // work with feed as Atom
  }
```

## Developing

The library is entirely new and was not battle-tested yet. I'm using a corpus of 400~ feeds, and it goes through 
it without trouble. But there are some parts that I want to review and maybe refactor.

