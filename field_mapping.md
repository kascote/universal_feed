# Fields mapping

| UniversalFeed  | RSS             | Atom          | JSON           |
| -------------- | --------------- | ------------- | -------------- |
|                | Feed            |               |                |
| -------------  | --------------- | ------------- | -------------  |
| Title          | Title           | Title         | title          |
| Description    | Description     | Subtitle      | description    |
| xmlLinks       |                 |               | feed_url       |
| htmlLinks      |                 |               | home_page_url  |
| links          | link            |               |                |
| Updated        | lastBuildDate   | Updated       |                |
| Published      | pubDate         |               |                |
| Authors        | Author          | Author        | authors        |
| Authors        | Contributor     | Contributor   |                |
| Authors        | managingEditor  |               |                |
| Authors        | webMaster       |               |                |
| Language       | language        |               | language       |
| Image          | image           | Logo          | favicon        |
| Copyright      | copyright       | rights        |                |
| Generator      | Generator       | Generator     |                |
| Categories     | category        | category      |                |
| Docs           | docs            |               |                |
| guid           |                 | id            |                |
|                |                 | Icon          | icon           |
| ============== | =============== | ============= | =============  |
|                | Extensions      |               |                |
| ============== | ==============  | ============= | =============  |
| Syndication    |                 |               |                |
| Podcast        |                 |               |                |
| ============== | ==============  | ============= | =============  |
| ============== | ==============  | ============= | =============  |
| ============== | ==============  | ============= | =============  |
|                | Entry           |               |                |
| ============== | ==============  | ============= | =============  |
| Guid           | guid            | id            | id             |
| Title          | title           | title         | title          |
| Description    | description     | summary       | summary        |
| Content        | media:encoded   | content       | content_html   |
| Link           | link            | link          | url            |
| Links          |                 | link          |                |
| Links          |                 |               | external_url   |
| updated        | pubDate         | updated       | date_modified  |
| published      | pubDate         | published     | date_published |
| Authors        | author          | author        | authors        |
| authors        | author          | author        |                |
| authors        |                 | contributor   |                |
| image          | image           |               | image          |
| Categories     | category        | category      | tags           |
| enclosures     | enclosure       |               | attachments    |
| source         | source          |               |                |
| sourceEntry    |                 | source        |                |
| comments       | comments        |               |                |
| copyright      |                 | rights        |                |
| ============== | =============== | ============= |                |
|                | Extensions      |               |                |
| ============== | ==============  | ============= |                |
| Media          |                 |               |                |
| Geo            |                 |               |                |
| DcTerms        |                 |               |                |
| Podcast        |                 |               |                |

## Podcast extension (unified iTunes + Podcast Index)

The `PodcastChannel` / `PodcastItem` model is fed by two vocabularies:
the iTunes namespace (`xmlns:itunes`) and the Podcast Index namespace
(`xmlns:podcast`, `https://podcastindex.org/namespace/1.0`). Both
parsers target the same unified model. Precedence is configurable via
`PodcastPrecedence` when calling `UniversalFeed.parseFromString` — no
overlap field is collapsed yet, so the knob exists as scaffolding for
future follow-up specs.

| UniversalFeed | Itunes  | PodcastIndex       |
| ------------- | ------- | ------------------ |
| FEED          |         |                    |
| ============= | ======= | =================  |
| txts          |         | podcast:txt        |
| guid          |         | podcast:guid       |
| ============= | ======= | =================  |
| ITEM          |         |                    |
| ------------- | ------- | -----------------  |
| chapters      |         | podcast:chapters   |
| transcripts   |         | podcast:transcript |
