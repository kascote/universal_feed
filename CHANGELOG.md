## Unreleased

- add `<podcast:value>` parsing (Podcast Index namespace, channel- and
  item-level, multi-valued per the per-tag spec) including child
  `<podcast:valueRecipient>` and `<podcast:valueTimeSplit>`. Exposed as
  `feed.podcast.values` and `item.podcast.values`
  (`List<PodcastValue>`). Blocks missing required `type` / `method` are
  skipped; recipients missing `type` / `address` / `split` are dropped
  individually; `valueTimeSplit` entries missing `startTime` /
  `duration` are skipped. `fee` is parsed as `bool?` (true/false/null);
  all numeric attrs (`suggested`, `split`, `startTime`, `duration`,
  `remoteStartTime`, `remotePercentage`) round-trip as raw strings.
  `valueTimeSplit` captures both `<podcast:valueRecipient>` children
  and the first valid `<podcast:remoteItem>` (spec says exclusive —
  precedence is the consumer's call). Multiple `<podcast:value>` blocks
  per parent are preserved in source order to support multi-scheme
  feeds. The `PodcastRemoteItem` primitive is reused; no extensions
  needed.
- add `<podcast:alternateEnclosure>` parsing (Podcast Index namespace,
  item-level, multi-valued), including child `<podcast:source>` (with
  required `uri` and optional `contentType`) and `<podcast:integrity>`
  (with required `type` + `value`). Exposed as
  `item.podcast.alternateEnclosures` (`List<PodcastAlternateEnclosure>`).
  Wrapper carries all spec attributes — `type`, `length`, `bitrate`,
  `height`, `lang`, `title`, `rel`, `codecs`, `isDefault` — plus
  `sources` (`List<PodcastEnclosureSource>`) and `integrity`
  (`List<PodcastIntegrity>`, multiple captured for liberal parsing so
  consumers supporting only `sri` or only `pgp-signature` find a usable
  entry). Wrappers with no valid `<podcast:source>` child are skipped;
  invalid `<podcast:source>` / `<podcast:integrity>` children are
  dropped individually. Surface kept distinct from RSS `item.enclosures`
  (no back-fill, no merge).
- add `<podcast:podroll>` parsing (Podcast Index namespace, channel-level,
  single). Exposed as `feed.podcast.podroll` (`PodcastPodroll?`) wrapping
  one or more `PodcastRemoteItem` children in source order. Last tag wins
  on duplicate; wrapper is `null` when no valid `<podcast:remoteItem>`
  child survived parsing.
- add `<podcast:publisher>` parsing (Podcast Index namespace,
  channel-level, single). Exposed as `feed.podcast.publisher`
  (`PodcastPublisher?`) wrapping a single `PodcastRemoteItem`. First valid
  child wins on multi-child wrappers; last tag wins on duplicate
  `<podcast:publisher>`. The `medium="publisher"` attribute is captured
  raw, not enforced — consumers can inspect `remoteItem.medium`.
- add `<podcast:remoteItem>` parsing (Podcast Index namespace,
  channel-level, multi-valued). Exposed as `feed.podcast.remoteItems`
  (`List<PodcastRemoteItem>`) with required `feedGuid` plus optional
  `feedUrl`, `itemGuid`, `medium` (raw + `knownMedium` / `mediumIsList`
  derived via the same logic as `<podcast:medium>`), and `title`.
  Elements missing `feedGuid` are skipped. The same value class will
  be reused by upcoming `<podcast:podroll>` / `<podcast:publisher>` /
  `<podcast:valueTimeSplit>` containers. Refactor: medium parsing
  lifted from `PodcastChannelParser._parseMedium` into a shared
  `parseMedium` helper — single source of truth for the `L`-suffix
  list-variant detection.
- add `<podcast:image>` parsing (Podcast Index namespace, channel- and
  item-level, multi-valued). Exposed as `feed.podcast.images` and
  `item.podcast.images` (`List<PodcastImage>`), each with `href`,
  optional `alt`, `aspectRatio`, `width`, `height`, `type`, `purpose`
  (raw) plus a derived lowercased `purposeTokens` list. Elements
  missing `href` are skipped. The deprecated `<podcast:images srcset>`
  form is intentionally not parsed. `<liveItem>` parent deferred.
- add `<podcast:chat>` parsing (Podcast Index namespace, channel and
  item level, single per parent). Exposed as `feed.podcast.chat` and
  `item.podcast.chat` (`PodcastChat?`) with `server`, `protocol`, and
  optional `accountId`, `space` (raw strings). Entries missing
  `server` or `protocol` are skipped; last tag wins on duplicate.
  Item-level overrides channel-level per spec — resolution left to
  the consumer.
- add `<podcast:socialInteract>` parsing (Podcast Index namespace,
  item-level, multi-valued). Exposed as `item.podcast.socialInteracts`
  (`List<PodcastSocialInteract>`), each with `protocol`, optional `uri`,
  `accountId`, `accountUrl`, `priority` (raw strings). The opt-out
  sentinel `protocol="disabled"` is preserved without a `uri`; other
  entries missing `protocol` or `uri` are skipped.
- add `<podcast:soundbite>` parsing (Podcast Index namespace, item-level,
  multi-valued). Exposed as `item.podcast.soundbites`
  (`List<PodcastSoundbite>`), each with `startTime`, `duration` (raw
  strings, seconds), and optional `title` (body, null when empty per
  spec). Elements missing either required attribute are skipped.
- add `<podcast:location>` parsing (Podcast Index namespace, channel- and
  item-level, multi-valued). Exposed as `feed.podcast.locations` and
  `item.podcast.locations` (`List<PodcastLocation>`), each with `text`
  (body), `rel`, `geo`, `osm`, `country`. Spec defaults are not
  back-filled (raw `null` preserved). Elements with a blank body are
  skipped. `<liveItem>` parent deferred until liveItem lands.
- add `<podcast:person>` parsing (Podcast Index namespace, channel- and
  item-level, multi-valued). Exposed as `feed.podcast.persons` and
  `item.podcast.persons` (`List<PodcastPerson>`), each with `name` (body),
  `role`, `group`, `img`, `href`. Convenience getters `effectiveRole` and
  `effectiveGroup` apply the spec defaults (`host` / `cast`) without
  losing the raw `null`. Elements without a body are skipped.
- internal: factor shared `<podcast:license>` parsing into
  `podcast_parsing.dart` (library-internal). No public API change.
- add `<podcast:trailer>` parsing (Podcast Index namespace, channel-level,
  multi-valued). Exposed as `feed.podcast.trailers` (`List<PodcastTrailer>`),
  each with `url`, `title` (body), `pubdate` (`Timestamp?`), `length`,
  `type`, and `season`. Elements without a `url` attribute are skipped.
- add `<podcast:funding>` parsing (Podcast Index namespace, channel-level,
  multi-valued). Exposed as `feed.podcast.fundings` (`List<PodcastFunding>`),
  each with `url` and `text` (element body). Source order preserved.
- add `<podcast:license>` parsing (Podcast Index namespace, channel- and
  item-level). Exposed as `feed.podcast.license` and `item.podcast.license`
  (`PodcastLicense?`) with `spdx`, `url`, and `text` fields. Last tag wins
  on duplicates.
- add `podcast:season name` and `podcast:episode display` attribute parsing
  (Podcast Index namespace, item-level). Exposed as `item.podcast.seasonName`
  (`String?`) and `item.podcast.episodeDisplay` (`String?`). When both
  `itunes:season`/`itunes:episode` and `podcast:season`/`podcast:episode` are
  present, the Podcast Index values take precedence.

- add `<podcast:block>` parsing (Podcast Index namespace, channel-level,
  multi-valued). Exposed as `feed.podcast.blocks` (`List<PodcastBlock>`),
  each with `id` (platform slug or null for global), `value` (raw body),
  and `blocked` (`bool?`). Distinct from the iTunes scalar
  `feed.podcast.block`.
- BREAKING: rename `ItunesChannel`/`ItunesItem` → `PodcastChannel`/
  `PodcastItem`. `feed.podcast` / `item.podcast` property names unchanged;
  only the returned type names change.
- add support for the Podcast Index namespace (`xmlns:podcast`) with
  `<podcast:txt>` tag parsing at channel and item level. Namespace
  precedence is configurable via `PodcastPrecedence` (default:
  `podcastIndex`).
- add `<podcast:chapters>` parsing (Podcast Index namespace, item-level).
  Exposed as `item.podcast.chapters` with `url` and `type` fields.
- add `<podcast:transcript>` parsing (Podcast Index namespace, item-level,
  multi-valued). Exposed as `item.podcast.transcripts` with `url`, `type`,
  `language`, `rel` fields.
- add `<podcast:guid>` parsing (Podcast Index namespace, channel-level).
  Exposed as `feed.podcast.guid`.
- add `<podcast:medium>` parsing (Podcast Index namespace, channel-level).
  Exposed as `feed.podcast.medium` (raw), `feed.podcast.knownMedium`
  (enum with `other`/`absent` escape hatches), and `feed.podcast.mediumIsList`
  (true for `L`-suffix variants).
- add `<podcast:locked>` parsing (Podcast Index namespace, channel-level).
  Exposed as `feed.podcast.locked` (`bool?`) and `feed.podcast.lockedOwner`
  (`String?` from the `owner` attribute).
- add `<podcast:podping>` parsing (Podcast Index namespace, channel-level).
  Exposed as `feed.podcast.podpingUsesPodping` (`bool?`) from the
  `usesPodping` attribute. Accepts `true`/`yes` and `false`/`no`.
- add `<podcast:updateFrequency>` parsing (Podcast Index namespace,
  channel-level). Exposed as `feed.podcast.updateFrequency`
  (`PodcastUpdateFrequency?`) with `description` (text body), `complete`
  (`bool?`), `dtstart` (`String?`), and `rrule` (`String?`) fields. Raw
  strings for `dtstart`/`rrule`; callers parse as needed.
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
