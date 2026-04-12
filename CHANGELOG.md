## Unreleased

- BREAKING: rename `ItunesChannel`/`ItunesItem` → `PodcastChannel`/
  `PodcastItem`. `feed.podcast` / `item.podcast` property names unchanged;
  only the returned type names change.
- add support for the Podcast Index namespace (`xmlns:podcast`) with
  `<podcast:txt>` tag parsing at channel and item level. Namespace
  precedence is configurable via `PodcastPrecedence` (default:
  `podcastIndex`).
- support multiple `itunes:category` elements on podcast channels and expose
  nested subcategories via new `Category.children` field (previously only
  the first top-level category was parsed and parent/child link was lost).
- BREAKING: drop `PodcastChannel.author` (String) and `PodcastChannel.owner`
  (Author). `itunes:author` and `itunes:owner` now append to `feed.authors`
  with `AuthorType.author` and `AuthorType.creator` respectively.

## 0.7.0

- refactor how extensions are handled. Now each feed type has its own extension
  handler.
- refactor internal parser methods.
- fix how permalinks are handled in rss feeds. Now follow the spec more closely.
- Atom Item's source property updated to be a Source object and not a nested
  UniversalFeed
- fix bug on rfc822 date parsing with one day digit
- improve exceptions definition (FeedException, UnsupportedFeedFormatException,
  MissingRequiredFieldException, InvalidFieldValueException)
- fix date parser to consistently return null instead of throwing
- fix tryParse to catch all exception types
- improve documentation for exceptions and parsing methods
- add support to extract custom entities from feeds

## 0.6.0

- adds support for json feeds

## 0.5.0

- first contribution! thanks @d370urn3ur
- enabled parsing `logo` and `icon` elements from atoms feeds
- bump dependencies, fixed analysis comments.

## 0.4.0

- fixes html and xml link resolution
- fixes rss media extension parsing
- updated dependencies
- fixes xml library deprecated methods
- implements UniversalFeed.tryParse()

## 0.3.0

- IMPORTANT UPDATE: The library has undergone significant changes and is now
  completely revamped. The RSS and Atom feeds are now combined into one entity,
  making them much easier to use. Please note that there may be more changes
  before we reach version 1.0. However, we hope it will not be as extensive as
  this one.

## 0.2.0

- multiple fixes on empty node detection
- initial parsing of date times. Look at `Timestamp.parseValue()`

## 0.1.0

- Initial version.
