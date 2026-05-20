# Field Mapping

How raw feed fields (RSS, Atom, JSON Feed) map into the `UniversalFeed` model and its extensions.

Conventions used in the tables:

- `—` means the format / namespace does not provide this field
- `not parsed` means the field exists in the spec but the library does not extract it yet
- When the same value comes from different elements depending on the format, every source is listed in its column

## Table of contents

- [Feed-level (UniversalFeed)](#feed-level-universalfeed)
- [Item-level (Item)](#item-level-item)
- [Link resolution](#link-resolution)
- [Extension: Content (`content:encoded`)](#extension-content-contentencoded)
- [Extension: Dublin Core / DC Terms](#extension-dublin-core--dc-terms)
- [Extension: Syndication](#extension-syndication)
- [Extension: Media RSS](#extension-media-rss)
- [Extension: GeoRSS](#extension-georss)
- [Extension: Podcast (iTunes + PodcastIndex)](#extension-podcast-itunes--podcastindex)
- [Parsing notes & quirks](#parsing-notes--quirks)

---

## Feed-level (UniversalFeed)

| UniversalFeed     | RSS                                                                                        | Atom                                                         | JSON Feed                          | Notes                                                                    |
| ----------------- | ------------------------------------------------------------------------------------------ | ------------------------------------------------------------ | ---------------------------------- | ------------------------------------------------------------------------ |
| `meta.kind`       | derived (root is `<rss>`/`<rdf:RDF>`)                                                      | derived (root is `<feed>`)                                   | derived (content starts with `{`)  | rss / atom / json                                                        |
| `meta.version`    | `<rss version="">`                                                                         | `<feed version="">`                                          | `version` (URL form)               | feed format version                                                      |
| `meta.extensions` | declared `xmlns:*` on root                                                                 | declared `xmlns:*` on root                                   | —                                  | which extensions are active                                              |
| `feedId`          | guid → `htmlLink.href` → generated                                                         | feed `<id>` → generated                                      | `feed_url` → generated             | stable opaque id for the feed                                            |
| `guid`            | —                                                                                          | `<feed><id>`                                                 | —                                  | format-native unique id                                                  |
| `title`           | `<channel><title>`                                                                         | `<feed><title>`                                              | `title`                            |                                                                          |
| `description`     | `<channel><description>`                                                                   | `<feed><subtitle>`                                           | `description`                      | atom uses subtitle                                                       |
| `htmlLink`        | `<channel><link>`                                                                          | `<feed><link rel="alternate">`                               | `home_page_url`                    | site URL                                                                 |
| `xmlLink`         | `<atom:link rel="self">` (if present)                                                      | `<feed><link rel="self">`                                    | `feed_url`                         | self/feed-document URL                                                   |
| `links`           | all `<link>` (incl. atom: ext)                                                             | all `<feed><link>`                                           | —                                  | full list, with rel preserved                                            |
| `updated`         | `<channel><lastBuildDate>`                                                                 | `<feed><updated>` / `<modified>` (Atom 0.3)                  | —                                  |                                                                          |
| `published`       | `<channel><pubDate>`                                                                       | —                                                            | —                                  |                                                                          |
| `authors`         | `<author>` (type=author), `<managingEditor>` (type=editor), `<webMaster>` (type=webMaster) | `<author>` (type=author), `<contributor>` (type=contributor) | `authors[]` (1.1) / `author` (1.0) | unified list with type discriminator                                     |
| `language`        | `<channel><language>`                                                                      | —                                                            | `language`                         |                                                                          |
| `image`           | `<channel><image>` (url, title, link, width, height, description)                          | `<feed><logo>` (url only)                                    | `favicon` (url only)               | RSS shape is richer                                                      |
| `icon`            | —                                                                                          | `<feed><icon>`                                               | `icon`                             |                                                                          |
| `copyright`       | `<channel><copyright>`                                                                     | `<feed><rights>`                                             | —                                  |                                                                          |
| `generator`       | `<channel><generator>` (text only)                                                         | `<feed><generator>` + `version` / `uri` attrs                | —                                  | atom carries attrs too                                                   |
| `categories`      | `<channel><category domain="">value</category>`                                            | `<feed><category term="" label="" scheme="">`                | —                                  | RSS `domain` → scheme                                                    |
| `docs`            | `<channel><docs>`                                                                          | —                                                            | —                                  |                                                                          |
| `items`           | `<channel><item>` \*                                                                       | `<feed><entry>` \*                                           | `items[]`                          | see Item table                                                           |
| `liveItems`       | `<channel><podcast:liveItem>` \*                                                           | —                                                            | —                                  | PodcastIndex live entries; parsed as `Item` with `item.podcast.live` set |
| `syndication`     | sy: ext                                                                                    | —                                                            | —                                  | see Syndication section                                                  |
| `podcast`         | itunes: + podcast: ext                                                                     | —                                                            | —                                  | see Podcast section                                                      |

JSON Feed fields not parsed today: `next_url`, `expired`, `hubs`, `banner_image`, `_extensions`.

---

## Item-level (Item)

| Item          | RSS                                           | Atom                                                                                     | JSON Feed                                                            | Notes                                        |
| ------------- | --------------------------------------------- | ---------------------------------------------------------------------------------------- | -------------------------------------------------------------------- | -------------------------------------------- |
| `itemId`      | generated `item_N`                            | generated `item_N`                                                                       | generated `item_N`                                                   | sequential, stable through filter/sort       |
| `guid`        | `<item><guid>`                                | `<entry><id>`                                                                            | `id`                                                                 |                                              |
| `title`       | `<item><title>`                               | `<entry><title>`                                                                         | `title`                                                              |                                              |
| `description` | `<item><description>`                         | `<entry><summary>`                                                                       | `summary`                                                            |                                              |
| `content`     | `<content:encoded>` (Content ext)             | `<entry><content type="">`                                                               | `content_html` → `content_text`                                      | list; supports multiple variants             |
| `link`        | `<item><link>` or `<guid isPermaLink="true">` | — (read via `links` with `rel=alternate`)                                                | `url`                                                                | atom has no scalar link                      |
| `links`       | atom: ext on RSS items, if present            | all `<entry><link>`                                                                      | `external_url` (as `rel=related`)                                    | full list with rel                           |
| `updated`     | `<item><pubDate>`                             | `<entry><updated>` / `<modified>` (Atom 0.3)                                             | `date_modified`                                                      | RSS pubDate fills both updated and published |
| `published`   | `<item><pubDate>`                             | `<entry><published>` / `<issued>` / `<created>` (fallback chain)                         | `date_published`                                                     |                                              |
| `authors`     | `<item><author>`                              | `<entry><author>`, `<entry><contributor>`                                                | `authors[]` (1.1) / `author` (1.0)                                   | same shape as feed-level                     |
| `image`       | `<item><image>` (when present)                | —                                                                                        | `image`                                                              |                                              |
| `categories`  | `<item><category domain="">`                  | `<entry><category term="" label="" scheme="">`                                           | `tags[]` (strings)                                                   |                                              |
| `enclosures`  | `<item><enclosure url="" type="" length="">`  | — (atom uses `<link rel="enclosure">`, stays in `links`, NOT mirrored into `enclosures`) | `attachments[]` (url, mime_type, size_in_bytes, duration_in_seconds) |                                              |
| `source`      | `<item><source url="">title</source>`         | —                                                                                        | —                                                                    | RSS-only                                     |
| `sourceEntry` | —                                             | `<entry><source>` (nested feed metadata)                                                 | —                                                                    | Atom-only                                    |
| `comments`    | `<item><comments>`                            | —                                                                                        | —                                                                    |                                              |
| `copyright`   | —                                             | `<entry><rights>`                                                                        | —                                                                    |                                              |
| `dcterms`     | dc:/dcterms: ext                              | dc:/dcterms: ext                                                                         | —                                                                    | see Dublin Core section                      |
| `media`       | media: ext                                    | media: ext                                                                               | —                                                                    | see Media RSS section                        |
| `geo`         | georss: ext                                   | —                                                                                        | —                                                                    | see GeoRSS section                           |
| `podcast`     | itunes: + podcast: ext                        | —                                                                                        | —                                                                    | see Podcast section                          |

---

## Link resolution

Both feeds and items expose a normalized `links: List<Link>`. The format-specific dispatch:

| Source                                            | Goes to                            | Notes                                                                    |
| ------------------------------------------------- | ---------------------------------- | ------------------------------------------------------------------------ |
| Atom `<link rel="self">`                          | `xmlLink` + `links`                |                                                                          |
| Atom `<link rel="alternate">`                     | `htmlLink` (first match) + `links` |                                                                          |
| Atom `<link rel="enclosure">`                     | `links` only                       | NOT mirrored into `item.enclosures` — read from `links` if you need them |
| Atom `<link rel="hub">` / `via` / `related` / ... | `links`                            | rel preserved on the `Link` object                                       |
| RSS `<channel><link>`                             | `htmlLink` + `links`               |                                                                          |
| RSS `<atom:link rel="self">` (extension on RSS)   | `xmlLink` + `links`                |                                                                          |
| RSS `<item><enclosure>`                           | `enclosures`                       | dedicated list                                                           |
| JSON `home_page_url`                              | `htmlLink`                         |                                                                          |
| JSON `feed_url`                                   | `xmlLink`                          |                                                                          |
| JSON `items[].url`                                | `item.link` (as `rel=self`)        |                                                                          |
| JSON `items[].external_url`                       | `item.links` (as `rel=related`)    |                                                                          |
| JSON `items[].attachments`                        | `item.enclosures`                  | converted                                                                |

---

## Extension: Content (`content:encoded`)

Namespace: `http://purl.org/rss/1.0/modules/content/` (declared as `xmlns:content`).

| Item field                    | Source                          | Notes                                                                                           |
| ----------------------------- | ------------------------------- | ----------------------------------------------------------------------------------------------- |
| `content[]` (`List<Content>`) | `<content:encoded>` (repeating) | each becomes a `Content`; CDATA handled; defaults to `type=text`; optional `src` attr preserved |

Atom's native `<content>` element (no namespace) maps to the same `item.content` list via the Atom parser directly.

---

## Extension: Dublin Core / DC Terms

Two namespaces are recognized, both feeding the same model:

- `dc:*` → `http://purl.org/dc/elements/1.1/`
- `dcterms:*` → `http://purl.org/dc/terms/`

`dc:*` fields are folded into the **core** `UniversalFeed` / `Item` (authors, dates, categories, title, description, rights). `dcterms:*` fields populate the dedicated `DcTerms` object on `Item`.

### `dc:` mapping into the core model

| Goes to                      | Source                                         | Scope       | Notes                      |
| ---------------------------- | ---------------------------------------------- | ----------- | -------------------------- |
| `title`                      | `dc:title`                                     | feed + item |                            |
| `description`                | `dc:description`                               | item        |                            |
| `copyright`                  | `dc:rights`                                    | feed        |                            |
| `categories`                 | `dc:subject` (repeating)                       | feed        | label-only                 |
| `authors` (type=author)      | `dc:author`                                    | feed + item |                            |
| `authors` (type=creator)     | `dc:creator` (repeating)                       | feed + item |                            |
| `authors` (type=contributor) | `dc:contributor` (repeating feed; single item) | feed + item |                            |
| `authors` (type=publisher)   | `dc:publisher`                                 | feed + item |                            |
| `updated`                    | `dc:date`                                      | feed        | parsed as `Timestamp`      |
| `published` + `updated`      | `dc:date`                                      | item        | both set to the same value |

Not parsed today: `dc:coverage`, `dc:format`, `dc:identifier`, `dc:language`, `dc:relation`, `dc:source`, `dc:type`.

### `dcterms:` mapping (item-level only)

| `Item.dcterms.*` | Source                | Notes                                                    |
| ---------------- | --------------------- | -------------------------------------------------------- |
| `created`        | `<dcterms:created>`   | string                                                   |
| `issued`         | `<dcterms:issued>`    | string                                                   |
| `modified`       | `<dcterms:modified>`  | string                                                   |
| `valid`          | `<dcterms:valid>`     | `DcPeriod` (parsed from `start=…;end=…;scheme=…;name=…`) |
| `available`      | `<dcterms:available>` | `DcPeriod`                                               |

Not parsed today: `abstract`, `accessRights`, `accrualMethod`, `accrualPeriodicity`, `accrualPolicy`, `alternative`, `audience`, `bibliographicCitation`, `conformsTo`, `dateAccepted`, `dateCopyrighted`, `dateSubmitted`, `educationLevel`, `extent`, `hasFormat`, `hasPart`, `hasVersion`, `instructionalMethod`, `isFormatOf`, `isPartOf`, `isReferencedBy`, `isReplacedBy`, `isRequiredBy`, `isVersionOf`, `license`, `mediator`, `medium`, `provenance`, `references`, `replaces`, `requires`, `rightsHolder`, `spatial`, `tableOfContents`, `temporal`.

---

## Extension: Syndication

Namespace: `http://purl.org/rss/1.0/modules/syndication/` (declared as `xmlns:sy`). Feed-level only.

| `UniversalFeed.syndication.*` | Source                 | Notes                                                                               |
| ----------------------------- | ---------------------- | ----------------------------------------------------------------------------------- |
| `updatePeriod`                | `<sy:updatePeriod>`    | `hourly` / `daily` / `weekly` / `monthly` / `yearly`; defaults to `daily` if absent |
| `updateFrequency`             | `<sy:updateFrequency>` | integer-as-string; defaults to `1`                                                  |
| `updateBase`                  | `<sy:updateBase>`      | `yyyy-mm-ddThh:mm`; optional                                                        |

---

## Extension: Media RSS

Namespace: `http://search.yahoo.com/mrss/` (declared as `xmlns:media`). Wired on both RSS and Atom item parsers. Aggregated under `item.media: Media`.

### `Media` (container)

| Property      | Source                                                | Notes                                                     |
| ------------- | ----------------------------------------------------- | --------------------------------------------------------- |
| `group`       | `<media:group>`                                       | `List<Media>` — recursive; carries grouped `MediaContent` |
| `content`     | `<media:content>`                                     | `List<MediaContent>`; under item OR under `media:group`   |
| `rating`      | `<media:rating>`                                      | `List<Rating>`                                            |
| `title`       | `<media:title>`                                       | plain-decoded                                             |
| `description` | `<media:description>`                                 | plain-decoded                                             |
| `categories`  | `<media:category>`, `<media:keywords>`                | `<media:keywords>` is split on `,` with scheme `keyword`  |
| `thumbnails`  | `<media:thumbnail url="" width="" height="" time="">` | `List<Image>`; `time` preserved on `Image.time`           |
| `credits`     | `<media:credit role="" scheme="">`                    | `List<Credit>`                                            |
| `player`      | `<media:player url="" width="" height="">`            | single `Player`                                           |

### `MediaContent`

| Property                                                                                | Source                      | Notes                                                   |
| --------------------------------------------------------------------------------------- | --------------------------- | ------------------------------------------------------- |
| `url`                                                                                   | `url=""` attr               | required unless `<media:player>` is present             |
| `fileSize`                                                                              | `fileSize=""` attr          | bytes (string)                                          |
| `type`                                                                                  | `type=""` attr              | MIME                                                    |
| `medium`                                                                                | `medium=""` attr            | `image` / `audio` / `video` / `document` / `executable` |
| `isDefault`                                                                             | `isDefault=""` attr         | string `true`/`false`                                   |
| `expression`                                                                            | `expression=""` attr        | `sample` / `full` / `nonstop` (default `full`)          |
| `bitrate`                                                                               | `bitrate=""` attr           | kbps                                                    |
| `framerate`                                                                             | `framerate=""` attr         | fps                                                     |
| `samplingrate`                                                                          | `samplingrate=""` attr      | kHz                                                     |
| `channels`                                                                              | `channels=""` attr          |                                                         |
| `duration`                                                                              | `duration=""` attr          | seconds                                                 |
| `height` / `width`                                                                      | `height` / `width` attrs    |                                                         |
| `lang`                                                                                  | `lang=""` attr              | RFC 3066                                                |
| `rating` / `title` / `description` / `categories` / `thumbnails` / `player` / `credits` | nested `<media:*>` children | same shapes as the container                            |

Not parsed today: `<media:copyright>`, `<media:text>`, `<media:restriction>`, `<media:community>`, `<media:comments>`, `<media:responses>`, `<media:backLinks>`, `<media:status>`, `<media:price>`, `<media:license>`, `<media:subTitle>`, `<media:peerLink>`, `<media:rights>`, `<media:scenes>`, `<media:location>`, `<media:embed>`, `<media:hash>`.

---

## Extension: GeoRSS

Namespace: `http://www.georss.org/georss` (declared as `xmlns:georss`). Spec: [OGC 17-002r1](https://docs.ogc.org/cs/17-002r1/17-002r1.html). Wired on RSS items. Aggregated under `item.geo: Geo`.

| `Geo.*`           | Source                     | Notes                                             |
| ----------------- | -------------------------- | ------------------------------------------------- |
| `line`            | `<georss:line>`            | space-separated lat/lon pairs (≥2)                |
| `polygon`         | `<georss:polygon>`         | space-separated lat/lon pairs (≥4, last == first) |
| `box`             | `<georss:box>`             | two lat/lon pairs (lower / upper corners)         |
| `featureTypeTag`  | `<georss:featuretypetag>`  |                                                   |
| `relationshipTag` | `<georss:relationshiptag>` |                                                   |
| `featureName`     | `<georss:featurename>`     |                                                   |
| `elev`            | `<georss:elev>`            | meters above WGS84                                |
| `floor`           | `<georss:floor>`           |                                                   |
| `radius`          | `<georss:radius>`          | meters                                            |

Not parsed today: `<georss:point>`, `<georss:circle>`, `<georss:where>` (GML), W3C basic `<geo:Point>` / `<geo:lat>` / `<geo:long>`.

---

## Extension: Podcast (iTunes + PodcastIndex)

Two namespaces feed the same unified model:

- `xmlns:itunes` → `http://www.itunes.com/dtds/podcast-1.0.dtd`
- `xmlns:podcast` → `https://podcastindex.org/namespace/1.0` (Podcasting 2.0)

Both populate `UniversalFeed.podcast: PodcastChannel` and `Item.podcast: PodcastItem`. When both namespaces define an equivalent concept, precedence is configurable via `PodcastPrecedence` on `UniversalFeed.parseFromString` — today the knob exists as scaffolding; no overlap field is collapsed yet.

### Channel — `UniversalFeed.podcast` (`PodcastChannel`)

| Property                                               | iTunes (`itunes:*`)                                                     | PodcastIndex (`podcast:*`)                                                                | Notes                                                 |
| ------------------------------------------------------ | ----------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- | ----------------------------------------------------- |
| `image`                                                | `<itunes:image href="">`                                                | —                                                                                         | href only                                             |
| `explicit`                                             | `<itunes:explicit>`                                                     | —                                                                                         |                                                       |
| `title`                                                | `<itunes:title>`                                                        | —                                                                                         | show-specific title for Apple                         |
| `type`                                                 | `<itunes:type>`                                                         | —                                                                                         |                                                       |
| `newFeedUrl`                                           | `<itunes:new-feed-url>`                                                 | —                                                                                         |                                                       |
| `block`                                                | `<itunes:block>`                                                        | —                                                                                         | iTunes scalar (distinct from `blocks`)                |
| `complete`                                             | `<itunes:complete>`                                                     | —                                                                                         |                                                       |
| `summary`                                              | `<itunes:summary>`                                                      | —                                                                                         |                                                       |
| `categories`                                           | `<itunes:category text="">` (nested subcategories), `<itunes:keywords>` | —                                                                                         | keywords split by `,`, scheme `keyword`               |
| `guid`                                                 | —                                                                       | `<podcast:guid>`                                                                          | UUIDv5 per spec; last wins                            |
| `medium` / `knownMedium` / `mediumIsList`              | —                                                                       | `<podcast:medium>`                                                                        | string + enum + boolean (trailing `L` ⇒ list variant) |
| `locked` / `lockedOwner`                               | —                                                                       | `<podcast:locked owner="">`                                                               | body is `yes` / `no`                                  |
| `txts`                                                 | —                                                                       | `<podcast:txt purpose="">value</podcast:txt>` (repeating)                                 |                                                       |
| `blocks`                                               | —                                                                       | `<podcast:block id="">value</podcast:block>` (repeating)                                  | platform-targeted blocks                              |
| `fundings`                                             | —                                                                       | `<podcast:funding url="">label</podcast:funding>` (repeating)                             |                                                       |
| `license`                                              | —                                                                       | `<podcast:license spdx="" url="">text</podcast:license>`                                  | last wins                                             |
| `trailers`                                             | —                                                                       | `<podcast:trailer url="" pubdate="" length="" type="" season="">title</podcast:trailer>`  |                                                       |
| `persons`                                              | —                                                                       | `<podcast:person role="" group="" img="" href="">name</podcast:person>`                   |                                                       |
| `locations`                                            | —                                                                       | `<podcast:location rel="" geo="" osm="" country="">text</podcast:location>`               |                                                       |
| `chat`                                                 | —                                                                       | `<podcast:chat server="" protocol="" accountId="" space="">`                              | last wins                                             |
| `images`                                               | —                                                                       | `<podcast:image href="" alt="" aspect-ratio="" width="" height="" type="" purpose="">`    | plural — distinct from `image`                        |
| `remoteItems`                                          | —                                                                       | `<podcast:remoteItem feedGuid="" feedUrl="" itemGuid="" medium="" title="">`              | used by list-variant feeds                            |
| `podroll`                                              | —                                                                       | `<podcast:podroll>` with `<podcast:remoteItem>` children                                  | last wins                                             |
| `publisher`                                            | —                                                                       | `<podcast:publisher>` with one `<podcast:remoteItem>`                                     | last wins                                             |
| `values`                                               | —                                                                       | `<podcast:value type="" method="" suggested="">` + nested recipients / time-splits        |                                                       |
| `liveItems` (on `UniversalFeed`, not `PodcastChannel`) | —                                                                       | `<podcast:liveItem status="" start="" end="">`                                            | parsed as `Item`s with `item.podcast.live` set        |
| `updateFrequency`                                      | —                                                                       | `<podcast:updateFrequency complete="" dtstart="" rrule="">text</podcast:updateFrequency>` | last wins                                             |
| `podpingUsesPodping`                                   | —                                                                       | `<podcast:podping usesPodping="">`                                                        | boolean attr                                          |

### Item — `Item.podcast` (`PodcastItem`)

| Property                     | iTunes (`itunes:*`)      | PodcastIndex (`podcast:*`)                                                              | Notes                                             |
| ---------------------------- | ------------------------ | --------------------------------------------------------------------------------------- | ------------------------------------------------- |
| `duration`                   | `<itunes:duration>`      | —                                                                                       |                                                   |
| `image`                      | `<itunes:image href="">` | —                                                                                       | href only                                         |
| `explicit`                   | `<itunes:explicit>`      | —                                                                                       |                                                   |
| `title`                      | `<itunes:title>`         | —                                                                                       |                                                   |
| `episode` / `episodeDisplay` | `<itunes:episode>`       | `<podcast:episode display="">`                                                          | display string from `podcast:` attr               |
| `season` / `seasonName`      | `<itunes:season>`        | `<podcast:season name="">`                                                              | name from `podcast:` attr                         |
| `episodeType`                | `<itunes:episodeType>`   | —                                                                                       |                                                   |
| `block`                      | `<itunes:block>`         | —                                                                                       |                                                   |
| `summary`                    | `<itunes:summary>`       | —                                                                                       |                                                   |
| `txts`                       | —                        | `<podcast:txt purpose="">value</podcast:txt>`                                           |                                                   |
| `chapters`                   | —                        | `<podcast:chapters url="" type="">`                                                     | last wins                                         |
| `transcripts`                | —                        | `<podcast:transcript url="" type="" language="" rel="">`                                |                                                   |
| `license`                    | —                        | `<podcast:license spdx="" url="">text</podcast:license>`                                | last wins                                         |
| `persons`                    | —                        | `<podcast:person …>name</podcast:person>`                                               | overrides channel-level                           |
| `locations`                  | —                        | `<podcast:location …>text</podcast:location>`                                           | overrides channel-level                           |
| `soundbites`                 | —                        | `<podcast:soundbite startTime="" duration="">title</podcast:soundbite>`                 |                                                   |
| `socialInteracts`            | —                        | `<podcast:socialInteract protocol="" uri="" accountId="" accountUrl="" priority="">`    | `protocol="disabled"` opts out                    |
| `chat`                       | —                        | `<podcast:chat …>`                                                                      | overrides channel-level                           |
| `images`                     | —                        | `<podcast:image …>`                                                                     | overrides channel-level                           |
| `alternateEnclosures`        | —                        | `<podcast:alternateEnclosure …>` w/ `<podcast:source>` + `<podcast:integrity>` children | not mirrored into RSS `enclosures`                |
| `values`                     | —                        | `<podcast:value …>`                                                                     | overrides channel-level                           |
| `contentLinks`               | —                        | `<podcast:contentLink href="">text</podcast:contentLink>`                               | valid under item AND `liveItem`                   |
| `live`                       | —                        | `<podcast:liveItem status="" start="" end="">`                                          | only set when item came from `<podcast:liveItem>` |

### Podcast nested types

`PodcastTranscript` — `url` / `type` / `knownType` (enum: `vtt`, `srt`, `subrip`, `json`, `html`, `plain`, `other`, `absent`) / `language` / `rel`.

`PodcastChapters` — `url` / `type`.

`PodcastValue` — `type` / `method` / `suggested` attrs + `recipients[]` + `timeSplits[]`.

`PodcastValueRecipient` — `name` / `type` / `address` / `split` / `customKey` / `customValue` / `fee` (all attrs).

`PodcastValueTimeSplit` — `startTime` / `duration` / `remoteStartTime` / `remotePercentage` attrs + `recipients[]` + nested `remoteItem`.

`PodcastPerson` — body=`name`; attrs `role` / `group` / `img` / `href`.

`PodcastLocation` — body=text; attrs `rel` / `geo` (RFC 5870 URI, raw) / `osm` / `country` (ISO 3166-1 α2).

`PodcastChat` — attrs `server` / `protocol` / `accountId` / `space`.

`PodcastImage` — attrs `href` / `alt` / `aspect-ratio` / `width` / `height` / `type` / `purpose`; `purposeTokens` = `purpose` split on whitespace, lowercased.

`PodcastPodroll` — `items[]` of `PodcastRemoteItem`.

`PodcastPublisher` — single `remoteItem`.

`PodcastRemoteItem` — attrs `feedGuid` / `feedUrl` / `itemGuid` / `medium` / `title`; derived `knownMedium` + `mediumIsList`.

`PodcastFunding` — `url` attr, body=`text`.

`PodcastSoundbite` — attrs `startTime` / `duration`, body=`title`.

`PodcastTrailer` — attrs `url` / `pubdate` (Timestamp) / `length` / `type` / `season`, body=`title`.

`PodcastLicense` — attrs `spdx` / `url`, body=`text`.

`PodcastAlternateEnclosure` — attrs `type` / `length` / `bitrate` / `height` / `lang` / `title` / `rel` / `codecs` / `default` (→ `isDefault`); children `sources[]` + `integrity[]`.

`PodcastEnclosureSource` — attrs `uri` (required) / `contentType`.

`PodcastIntegrity` — attrs `type` (`sri` / `pgp-signature`) / `value`.

`PodcastSocialInteract` — attrs `protocol` / `uri` / `accountId` / `accountUrl` / `priority`.

`PodcastContentLink` — `href` attr, body=`text`.

`PodcastTxt` — `purpose` attr, body=`value`.

`PodcastUpdateFrequency` — body=`description`, attrs `complete` (boolean) / `dtstart` (Timestamp) / `rrule`.

`PodcastLive` — attrs `status` / `knownStatus` (enum: `pending`, `live`, `ended`, `other`, `absent`) / `start` (Timestamp) / `end` (Timestamp).

`PodcastBlock` — `id` attr (platform slug; null = global), body=raw, `blocked` derived (`true`/`false`/`null`).

---

## Parsing notes & quirks

- **Liberal**: the parser never throws on malformed content. If a field can't be read, it stays null/empty. Validation is the consumer's job.
- **Timestamps**: stored as `Timestamp(value: rawString)`. Call `.parseValue()` to get a `DateTime?`. No parsing happens at feed-parse time.
- **Atom items have no `item.link`**: Atom doesn't have a single canonical link element on entries — read `item.links` and pick the rel you care about (typically `alternate`).
- **Atom enclosures stay in `links`**: `<link rel="enclosure">` on Atom items is NOT copied into `item.enclosures`. Read from `item.links` if you need them. RSS `<enclosure>` and JSON `attachments[]` go into `item.enclosures` directly.
- **RSS `pubDate` and `dc:date` set both timestamps**: in items, both `published` and `updated` get the same value (RSS doesn't distinguish).
- **Atom date fallback chain (item)**: `published` ← `created` → `published` → `issued`; `updated` ← `modified` → `updated`.
- **Authors are unified**: RSS `author` / `managingEditor` / `webMaster` and Atom `author` / `contributor` and DC `creator` / `contributor` / `publisher` all collapse into `authors: List<Author>` with a `type` discriminator.
- **Namespaces drive extensions**: an extension is only parsed if its namespace is declared on the root. Check `feed.meta.extensions.has*` before reading.
- **iTunes categories nest**: `<itunes:category>` supports child `<itunes:category>` (subcategory). Other category sources are flat.
- **PodcastIndex item-level overrides channel-level** for `persons`, `locations`, `chat`, `images`, `values`. Channel-level acts as default; if an item declares its own, consumer-side merging is up to you.
- **Live items**: `<podcast:liveItem>` is parsed as a regular `Item` and lives in `feed.liveItems` (not `feed.items`). The discriminator is `item.podcast.live != null`.
