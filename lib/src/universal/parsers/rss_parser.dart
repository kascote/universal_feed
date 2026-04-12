import 'package:xml/xml.dart';

import '../../../universal_feed.dart';
import '../../shared/extensions.dart';
import '../../shared/shared.dart';
import '../extensions/content/content_parser.dart';
import '../extensions/dcterms/dc_parser.dart';
import '../extensions/dcterms/dcterms_parser.dart';
import '../extensions/extension_parser.dart';
import '../extensions/geo/geo_parser.dart';
import '../extensions/links/links_parser.dart';
import '../extensions/media/media_parser.dart';
import '../extensions/podcast/itunes_channel_parser.dart';
import '../extensions/podcast/itunes_item_parser.dart';
import '../extensions/podcast/podcast_channel_parser.dart';
import '../extensions/podcast/podcast_item_parser.dart';
import '../extensions/syndication/syndication_parser.dart';

/// Parse an RSS feed
void rssXmlParser(
  UniversalFeed uf,
  XmlDocument doc, {
  OnChannelParse? onChannelParse,
  OnItemParse? onItemParse,
  PodcastPrecedence podcastPrecedence = PodcastPrecedence.podcastIndex,
}) {
  final root = doc.rootElement;
  final channel = root.getElement('channel');
  if (channel == null) return;

  final parsers = _getExtensionParsers(uf, podcastPrecedence);

  rssChannelParser(uf, channel);
  _parseChannelExtensions(uf, channel, parsers.channel);
  uf.feedId = uf.guid ?? uf.htmlLink?.href ?? generateFallbackFeedId();

  onChannelParse?.call(uf, XmlRawElement(uf.feedId, channel));

  final rssItems = channel.findElements('item');
  var itemIndex = 0;
  for (final rssItem in rssItems) {
    final itemId = 'item_$itemIndex';
    final item = Item.rssFromXml(uf, rssItem, itemId);
    _parseItemExtensions(uf, item, rssItem, parsers.item);

    onItemParse?.call(item, XmlRawElement(item.itemId, rssItem));

    uf.items.add(item);
    itemIndex++;
  }
}

/// Parse the channel element of an rss feed
void rssChannelParser(UniversalFeed uf, XmlElement channel) {
  channel
    ..ifPresent('title', (value) => uf.title = value)
    ..ifPresentXml('description', (value) => uf.description = value.decodeText(uf.meta.kind))
    ..ifPresent(
      'link',
      (value) {
        uf.htmlLink = Link.create(
          href: value,
          rel: LinkRelationType.alternate,
          type: 'text/html',
        );
        uf.links.add(uf.htmlLink!);
      },
    )
    ..ifPresent('lastBuildDate', (value) => uf.updated = Timestamp(value))
    ..ifPresent('pubDate', (value) => uf.published = Timestamp(value))
    ..ifPresent('author', (value) => uf.authors.add(Author.fromString(value)..type = AuthorType.author))
    ..ifPresent('managingEditor', (value) => uf.authors.add(Author.fromString(value)..type = AuthorType.editor))
    ..ifPresent('webMaster', (value) => uf.authors.add(Author.fromString(value)..type = AuthorType.webMaster))
    ..ifPresent('language', (value) => uf.language = value)
    ..ifPresentXml('image', (value) => uf.image = Image.fromXml(value))
    ..ifPresent('copyright', (value) => uf.copyright = value)
    ..ifPresent('generator', (value) => uf.generator = Generator.create(value))
    ..forEachElementXml(
      'category',
      (value) {
        final category = Category.fromXml(value);
        if (category != null) {
          uf.categories.add(category);
        }
      },
    )
    ..ifPresent('docs', (value) => uf.docs = value);
}

/// Parse an rss item
Item rssItemParser(UniversalFeed uf, Item item, XmlElement element) {
  element
    ..ifPresent('title', (value) => item.title = value)
    ..ifPresent('description', (value) => item.description = value)
    ..ifPresent(
      'link',
      (value) {
        final lnk = Link.create(href: value, type: 'link', rel: LinkRelationType.alternate);
        item.link = lnk;
        item.links.add(lnk);
      },
    )
    ..ifPresent(
      'pubDate',
      (value) {
        final date = Timestamp(value);
        item
          ..published = date
          ..updated = date;
      },
    )
    ..forEachElement(
      'author',
      (value) => item.authors.add(Author.fromString(value)..type = AuthorType.author),
    )
    ..ifPresentXml('image', (value) => item.image = Image.fromXml(value))
    ..forEachElementXml(
      'category',
      (value) {
        final category = Category.fromXml(value);
        if (category != null) {
          item.categories.add(category);
        }
      },
    )
    ..forEachElementXml('enclosure', (value) => item.enclosures.add(Enclosure.rssFromXml(value)))
    ..ifPresentXml(
      'source',
      (value) {
        item.source = Link.create(
          href: value.getAttribute('url') ?? '',
          type: 'application/xml',
          rel: LinkRelationType.self,
        );
        item.source!.title = value.innerText;
      },
    )
    ..ifPresent(
      'comments',
      (value) => item.comments = Link.create(
        rel: LinkRelationType.alternate,
        type: 'text/html',
        href: value,
      ),
    )
    // is the last attribute read, so we can set the Link if isPermaLink is true
    // and no explicit link was provided
    ..ifPresentXml(
      'guid',
      (eleGuid) {
        final isPermaLink = eleGuid.getAttribute('isPermaLink') ?? 'true';
        if (isPermaLink == 'true' && item.link == null) {
          item.link = Link.create(
            href: eleGuid.innerText,
            type: 'text/html',
            rel: LinkRelationType.alternate,
          );
        }
        item.guid = eleGuid.innerText;
      },
    );

  return item;
}

void _parseChannelExtensions(
  UniversalFeed uf,
  XmlElement channel,
  List<ChannelExtensionParser> parsers,
) {
  for (final parser in parsers) {
    parser.parseChannel(uf, channel);
  }
}

void _parseItemExtensions(
  UniversalFeed uf,
  Item item,
  XmlElement element,
  List<ItemExtensionParser> itemParsers,
) {
  for (final parser in itemParsers) {
    parser.parseItem(uf, item, element);
  }
}

/// Returns both channel and item extension parsers.
/// Parsers that implement both interfaces are created once and added to both lists.
({List<ChannelExtensionParser> channel, List<ItemExtensionParser> item}) _getExtensionParsers(
  UniversalFeed uf,
  PodcastPrecedence podcastPrecedence,
) {
  final channelParsers = <ChannelExtensionParser>[];
  final itemParsers = <ItemExtensionParser>[];

  // Extensions that work at BOTH levels
  if (uf.meta.extensions.hasDc) {
    final dcParser = DublinCoreParser(uf.meta.extensions.nsUrl(nsDublinCoreNs)!);
    channelParsers.add(dcParser);
    itemParsers.add(dcParser);
  }

  // Podcast extensions: iTunes and Podcast Index both feed PodcastChannel
  // / PodcastItem. Registration order encodes precedence — the winner
  // runs last so it overwrites.
  final itunesDeclared = uf.meta.extensions.hasItunes;
  final indexDeclared = uf.meta.extensions.hasPodcastIndex;

  void registerItunes() {
    final ns = uf.meta.extensions.nsUrl(nsItunesNs)!;
    channelParsers.add(ItunesChannelParser(ns));
    itemParsers.add(ItunesItemParser(ns));
  }

  void registerIndex() {
    final ns = uf.meta.extensions.nsUrl(nsPodcastNs)!;
    channelParsers.add(PodcastChannelParser(ns));
    itemParsers.add(PodcastItemParser(ns));
  }

  switch (podcastPrecedence) {
    case PodcastPrecedence.podcastIndex:
      if (itunesDeclared) registerItunes();
      if (indexDeclared) registerIndex();
    case PodcastPrecedence.itunes:
      if (indexDeclared) registerIndex();
      if (itunesDeclared) registerItunes();
  }

  // Channel-only extensions
  if (uf.meta.extensions.hasAtom) {
    channelParsers.add(AtomLinksParser(uf.meta.extensions.nsUrl(nsAtomNs)!));
  }
  if (uf.meta.extensions.hasSyndication) {
    channelParsers.add(SyndicationParser(uf.meta.extensions.nsUrl(nsSyndicationNs)!));
  }

  // Item-only extensions
  if (uf.meta.extensions.hasContent) {
    itemParsers.add(ContentParser(uf.meta.extensions.nsUrl(nsContentNs)!));
  }
  if (uf.meta.extensions.hasMedia) {
    itemParsers.add(MediaParser(uf.meta.extensions.nsUrl(nsMediaNs)!));
  }
  if (uf.meta.extensions.hasGeoRss) {
    itemParsers.add(GeoRssParser(uf.meta.extensions.nsUrl(nsGeoNs)!));
  }
  if (uf.meta.extensions.hasDcTerms) {
    itemParsers.add(DcTermsParser(uf.meta.extensions.nsUrl(nsDcTermsNs)!));
  }

  return (channel: channelParsers, item: itemParsers);
}
