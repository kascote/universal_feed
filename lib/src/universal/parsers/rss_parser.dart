import 'package:xml/xml.dart';

import '../../../universal_feed.dart';
import '../../shared/shared.dart';

/// Parse an RSS feed
void rssXmlParser(UniversalFeed uf, XmlDocument doc) {
  final root = doc.rootElement;
  final channel = root.getElement('channel');
  if (channel == null) return;
  rssChannelParser(uf, channel);

  if (uf.namespaces.hasSyndication) {
    uf.syndication = Syndication.fromXml(uf, channel);
  }

  final rssItems = channel.findElements('item');
  for (final rssItem in rssItems) {
    uf.items.add(UniversalItem.rssFromXml(uf, rssItem));
  }
}

/// Parse the channel element of an rss feed
void rssChannelParser(UniversalFeed uf, XmlElement channel) {
  getElement<String>(channel, 'title', cb: (value) => uf.title = value);
  getElement<XmlElement>(channel, 'description', cb: (value) => uf.description = textDecoder('xml2', value));
  getElement<String>(
    channel,
    'link',
    cb: (value) {
      uf.htmlLink = UniversalLink.create(href: value, rel: 'alternate', type: 'text/html');
      uf.links.add(uf.htmlLink!);
    },
  );
  getElement<String>(
    channel,
    'link',
    cb: (value) => uf.xmlLink = UniversalLink.create(rel: 'alternate', type: 'text/html', href: value),
  );
  getElement<String>(channel, 'lastBuildDate', cb: (value) => uf.updated = UniversalTimestamp(value));
  getElement<String>(channel, 'pubDate', cb: (value) => uf.published = UniversalTimestamp(value));
  getElement<String>(
    channel,
    'author',
    cb: (value) => uf.authors.add(UniversalAuthor.fromString(value)..type = AuthorType.author),
  );
  getElement<String>(
    channel,
    'managingEditor',
    cb: (value) => uf.authors.add(UniversalAuthor.fromString(value)..type = AuthorType.editor),
  );
  getElement<String>(
    channel,
    'webMaster',
    cb: (value) => uf.authors.add(UniversalAuthor.fromString(value)..type = AuthorType.webMaster),
  );
  getElement<String>(channel, 'language', cb: (value) => uf.language = value);
  getElement<XmlElement>(channel, 'image', cb: (value) => uf.image = UniversalImage.fromXml(value));
  getElement<String>(channel, 'copyright', cb: (value) => uf.copyright = value);
  getElement<String>(channel, 'generator', cb: (value) => uf.generator = value);
  getElements<XmlElement>(
    channel,
    'category',
    cb: (value) {
      final category = UniversalCategory.fromXml(value);
      if (category != null) {
        uf.categories.add(category);
      }
    },
  );
  getElement<String>(channel, 'docs', cb: (value) => uf.docs = value);

  if (uf.namespaces.hasAtom) {
    final atomUrl = uf.namespaces.nsUrl(nsAtomNs);
    // Channel's link points to the Web site hosting the feed (not the feed itself)
    // Atom's link usually points to the feed itself
    getElement<XmlElement>(
      channel,
      'link',
      cb: (value) {
        final rel = value.getAttribute('rel') ?? 'other';
        final link = UniversalLink.create(
          rel: rel,
          type: value.getAttribute('type') ?? 'text/html',
          href: value.getAttribute('href') ?? '',
        );

        if (rel == 'self') {
          uf.xmlLink = link;
          uf.links.add(link);
        }
      },
      ns: atomUrl,
    );
  }

  if (uf.namespaces.hasDc) {
    final dcUrl = uf.namespaces.nsUrl(nsDublinCoreNs);
    getElement<String>(channel, 'title', cb: (value) => uf.title = value, ns: dcUrl);
    getElement<String>(
      channel,
      'author',
      cb: (value) => uf.authors.add(UniversalAuthor.fromString(value)..type = AuthorType.author),
      ns: dcUrl,
    );
    getElement<String>(
      channel,
      'creator',
      cb: (value) => uf.authors.add(UniversalAuthor.fromString(value)..type = AuthorType.creator),
      ns: dcUrl,
    );
    getElement<String>(
      channel,
      'contributor',
      cb: (value) => uf.authors.add(UniversalAuthor.fromString(value)..type = AuthorType.contributor),
      ns: dcUrl,
    );
    getElement<String>(
      channel,
      'publisher',
      cb: (value) => uf.authors.add(UniversalAuthor.fromString(value)..type = AuthorType.publisher),
      ns: dcUrl,
    );
    getElement<String>(channel, 'date', cb: (value) => uf.updated = UniversalTimestamp(value), ns: dcUrl);
    getElement<String>(channel, 'rights', cb: (value) => uf.copyright = value, ns: dcUrl);
    getElements<String>(
      channel,
      'subject',
      cb: (value) => uf.categories.add(UniversalCategory(label: value)),
      ns: dcUrl,
    );
  }
}

/// Parse an rss item
UniversalItem rssItemParser(UniversalFeed uf, UniversalItem item, XmlElement element) {
  final nsContentUrl = uf.namespaces.nsUrl(nsContentNs);

  getElement<String>(element, 'title', cb: (value) => item.title = value);
  getElement<String>(element, 'description', cb: (value) => item.description = value);
  getElement<XmlElement>(
    element,
    'encoded',
    cb: (value) => item.content = UniversalContent.fromV1Xml(value),
    ns: nsContentUrl,
  );
  getElement<String>(
    element,
    'link',
    cb: (value) {
      final lnk = UniversalLink.create(href: value, type: 'link', rel: 'alternate');
      item.link = lnk;
      item.links.add(lnk);
    },
  );
  getElement<String>(
    element,
    'pubDate',
    cb: (value) {
      final date = UniversalTimestamp(value);
      item
        ..published = date
        ..updated = date;
    },
  );
  getElements<String>(
    element,
    'author',
    cb: (value) => item.authors.add(UniversalAuthor.fromString(value)..type = AuthorType.author),
  );
  getElement<XmlElement>(element, 'image', cb: (value) => item.image = UniversalImage.fromXml(value));
  getElements<XmlElement>(
    element,
    'category',
    cb: (value) {
      final category = UniversalCategory.fromXml(value);
      if (category != null) {
        item.categories.add(category);
      }
    },
  );
  getElements<XmlElement>(
    element,
    'enclosure',
    cb: (value) => item.enclosures.add(UniversalEnclosure.rssFromXml(value)),
  );
  getElement<XmlElement>(
    element,
    'source',
    cb: (value) {
      item.source = UniversalLink.create(href: value.getAttribute('url') ?? '', type: 'application/xml', rel: 'self');
      item.source!.title = value.text;
    },
  );
  getElement<String>(
    element,
    'comments',
    cb: (value) => item.comments = UniversalLink.create(rel: 'alternate', type: 'text/html', href: value),
  );

  // is the last attribute read, so we can set the Link if isPermaLink is true
  getElement<XmlElement>(
    element,
    'guid',
    cb: (eleGuid) {
      final isPermaLink = eleGuid.getAttribute('isPermaLink') ?? 'false';
      if (isPermaLink == 'true') {
        item.link = UniversalLink.create(href: eleGuid.text, type: 'text/html', rel: 'alternate');
      }
      item.guid = eleGuid.text;
    },
  );

  if (uf.namespaces.hasDc) {
    final dcUrl = uf.namespaces.nsUrl(nsDublinCoreNs);
    getElement<String>(
      element,
      'author',
      cb: (value) => item.authors.add(UniversalAuthor.fromString(value)..type = AuthorType.author),
      ns: dcUrl,
    );
    getElement<String>(
      element,
      'contributor',
      cb: (value) => item.authors.add(UniversalAuthor.fromString(value)..type = AuthorType.contributor),
      ns: dcUrl,
    );
    getElements<String>(
      element,
      'creator',
      cb: (value) => item.authors.add(UniversalAuthor.fromString(value)..type = AuthorType.creator),
      ns: dcUrl,
    );
    getElement<String>(
      element,
      'date',
      cb: (value) {
        final date = UniversalTimestamp(value);
        item
          ..published = date
          ..updated = date;
      },
      ns: dcUrl,
    );
    getElement<String>(
      element,
      'description',
      cb: (value) => item.description = value,
      ns: dcUrl,
    );
    getElement<String>(
      element,
      'publisher',
      cb: (value) => item.authors.add(UniversalAuthor.fromString(value)..type = AuthorType.publisher),
      ns: dcUrl,
    );
    getElement<String>(
      element,
      'title',
      cb: (value) => item.title = value,
      ns: dcUrl,
    );
  }

  if (uf.namespaces.hasMedia) {
    item.media = Media.contentFromXml(uf, element);
  }

  if (uf.namespaces.hasGeoRss) {
    item.geo = Geo.fromXml(uf, element);
  }

  return item;
}
