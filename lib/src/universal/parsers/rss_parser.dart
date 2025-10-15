import 'package:xml/xml.dart';

import '../../../universal_feed.dart';
import '../../shared/extensions.dart';
import '../../shared/shared.dart';

/// Parse an RSS feed
void rssXmlParser(UniversalFeed uf, XmlDocument doc) {
  final root = doc.rootElement;
  final channel = root.getElement('channel');
  if (channel == null) return;
  rssChannelParser(uf, channel);

  if (uf.meta.extensions.hasSyndication) {
    uf.syndication = Syndication.fromXml(uf, channel);
  }

  if (uf.meta.extensions.hasItunes) {
    uf.podcast = ItunesChannel.fromXml(uf, channel);
  }

  final rssItems = channel.findElements('item');
  for (final rssItem in rssItems) {
    uf.items.add(Item.rssFromXml(uf, rssItem));
  }
}

/// Parse the channel element of an rss feed
void rssChannelParser(UniversalFeed uf, XmlElement channel) {
  channel
    ..ifPresent('title', (value) => uf.title = value)
    ..ifPresentXml(
      'description',
      (value) => uf.description = textDecoder('xml2', value),
    )
    ..ifPresent(
      'link',
      (value) {
        uf.htmlLink = Link.create(
          href: value,
          rel: 'alternate',
          type: 'text/html',
        );
        uf.links.add(uf.htmlLink!);
      },
    )
    ..ifPresent('lastBuildDate', (value) => uf.updated = Timestamp(value))
    ..ifPresent('pubDate', (value) => uf.published = Timestamp(value))
    ..ifPresent(
      'author',
      (value) => uf.authors.add(Author.fromString(value)..type = AuthorType.author),
    )
    ..ifPresent(
      'managingEditor',
      (value) => uf.authors.add(Author.fromString(value)..type = AuthorType.editor),
    )
    ..ifPresent(
      'webMaster',
      (value) => uf.authors.add(Author.fromString(value)..type = AuthorType.webMaster),
    )
    ..ifPresent('language', (value) => uf.language = value)
    ..ifPresentXml('image', (value) => uf.image = Image.fromXml(value))
    ..ifPresent('copyright', (value) => uf.copyright = value)
    ..ifPresent(
      'generator',
      (value) => uf.generator = Generator.create(value),
    )
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

  if (uf.meta.extensions.hasAtom) {
    final atomUrl = uf.meta.extensions.nsUrl(nsAtomNs);
    // Channel's link points to the Web site hosting the feed (not the feed itself)
    // Atom's link usually points to the feed itself
    channel.forEachElementXml(
      'link',
      (value) {
        final link = Link.fromXml(value);
        if (link.rel == LinkRelationType.self) uf.xmlLink = link;
        if (link.rel == LinkRelationType.alternate && uf.htmlLink == null) uf.htmlLink = link;
        uf.links.add(link);
      },
      ns: atomUrl,
    );
  }

  if (uf.meta.extensions.hasDc) {
    final dcUrl = uf.meta.extensions.nsUrl(nsDublinCoreNs);
    channel
      ..ifPresent('title', (value) => uf.title = value, ns: dcUrl)
      ..ifPresent(
        'author',
        (value) => uf.authors.add(Author.fromString(value)..type = AuthorType.author),
        ns: dcUrl,
      )
      ..ifPresent(
        'creator',
        (value) => uf.authors.add(Author.fromString(value)..type = AuthorType.creator),
        ns: dcUrl,
      )
      ..ifPresent(
        'contributor',
        (value) => uf.authors.add(
          Author.fromString(value)..type = AuthorType.contributor,
        ),
        ns: dcUrl,
      )
      ..ifPresent(
        'publisher',
        (value) => uf.authors.add(Author.fromString(value)..type = AuthorType.publisher),
        ns: dcUrl,
      )
      ..ifPresent(
        'date',
        (value) => uf.updated = Timestamp(value),
        ns: dcUrl,
      )
      ..ifPresent('rights', (value) => uf.copyright = value, ns: dcUrl)
      ..forEachElement(
        'subject',
        (value) => uf.categories.add(Category(label: value)),
        ns: dcUrl,
      );
  }
}

/// Parse an rss item
Item rssItemParser(UniversalFeed uf, Item item, XmlElement element) {
  element
    ..ifPresent('title', (value) => item.title = value)
    ..ifPresent('description', (value) => item.description = value);

  if (uf.meta.extensions.hasContent) {
    element.forEachElementXml(
      'encoded',
      (value) => item.content.add(Content.fromXml(value, defaultType: 'text')),
      ns: uf.meta.extensions.nsUrl(nsContentNs),
    );
  }

  element
    ..ifPresent(
      'link',
      (value) {
        final lnk = Link.create(href: value, type: 'link', rel: 'alternate');
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
    ..forEachElementXml(
      'enclosure',
      (value) => item.enclosures.add(Enclosure.rssFromXml(value)),
    )
    ..ifPresentXml(
      'source',
      (value) {
        item.source = Link.create(
          href: value.getAttribute('url') ?? '',
          type: 'application/xml',
          rel: 'self',
        );
        item.source!.title = value.innerText;
      },
    )
    ..ifPresent(
      'comments',
      (value) => item.comments = Link.create(
        rel: 'alternate',
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
            rel: 'alternate',
          );
        }
        item.guid = eleGuid.innerText;
      },
    );

  if (uf.meta.extensions.hasDc) {
    final dcUrl = uf.meta.extensions.nsUrl(nsDublinCoreNs);
    element
      ..ifPresent(
        'author',
        (value) => item.authors.add(Author.fromString(value)..type = AuthorType.author),
        ns: dcUrl,
      )
      ..ifPresent(
        'contributor',
        (value) => item.authors.add(
          Author.fromString(value)..type = AuthorType.contributor,
        ),
        ns: dcUrl,
      )
      ..forEachElement(
        'creator',
        (value) => item.authors.add(Author.fromString(value)..type = AuthorType.creator),
        ns: dcUrl,
      )
      ..ifPresent(
        'date',
        (value) {
          final date = Timestamp(value);
          item
            ..published = date
            ..updated = date;
        },
        ns: dcUrl,
      )
      ..ifPresent(
        'description',
        (value) => item.description = value,
        ns: dcUrl,
      )
      ..ifPresent(
        'publisher',
        (value) => item.authors.add(
          Author.fromString(value)..type = AuthorType.publisher,
        ),
        ns: dcUrl,
      )
      ..ifPresent(
        'title',
        (value) => item.title = value,
        ns: dcUrl,
      );
  }

  if (uf.meta.extensions.hasMedia) {
    item.media = Media.contentFromXml(uf, element);
  }

  if (uf.meta.extensions.hasGeoRss) {
    item.geo = Geo.fromXml(uf, element);
  }

  if (uf.meta.extensions.hasDcTerms) {
    item.dcterms = DcTerms.parseFomXml(uf, element);
  }

  if (uf.meta.extensions.hasItunes) {
    item.podcast = ItunesItem.fromXml(uf, element);
  }

  return item;
}
