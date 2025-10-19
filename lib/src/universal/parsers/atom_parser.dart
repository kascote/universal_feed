import 'package:xml/xml.dart';

import '../../../universal_feed.dart';
import '../../shared/extensions.dart';
import '../extensions/extension_parser.dart';
import '../extensions/media/media_parser.dart';

/// Parses an Atom feed
void atomXmlParser(UniversalFeed uf, XmlElement root) {
  atomFeedParser(uf, root);

  // Get extension parsers once for the entire feed (same pattern as RSS parser)
  final itemParsers = _getItemExtensionParsers(uf);

  final items = root.findElements('entry');
  for (final itemElement in items) {
    final item = Item.atomFromXml(uf, itemElement);
    _parseItemExtensions(uf, item, itemElement, itemParsers);
    uf.items.add(item);
  }
}

/// Parses the main feed element of an Atom feed
void atomFeedParser(UniversalFeed uf, XmlElement root) {
  root
    ..forEachElementXml('author', (xml) => uf.authors.add(Author.fromXml(xml)))
    ..forEachElementXml('contributor', (xml) => uf.authors.add(Author.fromXml(xml)))
    ..forEachElementXml(
      'link',
      (value) {
        final link = Link.fromXml(value);
        if (link.rel == LinkRelationType.self) uf.xmlLink = link;
        if (link.rel == LinkRelationType.alternate && uf.htmlLink == null) uf.htmlLink = link;
        uf.links.add(link);
      },
    )
    ..ifPresentXml('title', (item) => uf.title = item.decodeText(uf.meta.kind, atomVersion: uf.meta.version))
    ..ifPresent('updated', (value) => uf.updated = Timestamp(value))
    ..ifPresent('modified', (value) => uf.updated = Timestamp(value))
    ..ifPresentXml(
      'generator',
      (xml) => uf.generator = Generator(
        xml.innerText,
        xml.getAttribute('version') ?? '',
        xml.getAttribute('url') ?? xml.getAttribute('uri') ?? '',
      ),
    )
    ..ifPresent('id', (value) => uf.guid = value)
    ..ifPresent('icon', (value) => uf.icon = Image(value))
    ..ifPresent('logo', (value) => uf.image = Image(value))
    ..ifPresentXml('rights', (item) => uf.copyright = item.decodeText(uf.meta.kind))
    ..ifPresentXml('subtitle', (item) => uf.description = item.decodeText(uf.meta.kind))
    ..forEachElementXml(
      'category',
      (value) {
        final category = Category.fromXml(value);
        if (category != null) {
          uf.categories.add(category);
        }
      },
    );
}

/// Updates the published and updated fields of an item
void _updatePublishedUpdated(Item item, String value) {
  final date = Timestamp(value);
  item
    ..published ??= date
    ..updated ??= date;
}

/// Parses an Atom item
Item atomItemParser(UniversalFeed uf, Item item, XmlElement element) {
  element
    ..forEachElementXml('author', (xml) => item.authors.add(Author.fromXml(xml)))
    ..forEachElementXml('content', (xml) => item.content.add(Content.fromXml(xml)))
    ..forEachElementXml('contributor', (xml) => item.authors.add(Author.fromXml(xml)..type = AuthorType.contributor))
    ..ifPresent('created', (value) => _updatePublishedUpdated(item, value))
    ..ifPresent('published', (value) => _updatePublishedUpdated(item, value))
    ..ifPresent('issued', (value) => _updatePublishedUpdated(item, value))
    ..ifPresent('modified', (value) => item.updated = Timestamp(value))
    ..ifPresent('updated', (value) => item.updated = Timestamp(value))
    ..ifPresent('id', (value) => item.guid = value)
    ..forEachElementXml('link', (value) => item.links.add(Link.fromXml(value)))
    ..ifPresentXml('summary', (value) => item.description = value.decodeText(uf.meta.kind))
    ..ifPresentXml('title', (value) => item.title = value.decodeText(uf.meta.kind))
    ..forEachElementXml(
      'category',
      (value) {
        final category = Category.fromXml(value);
        if (category != null) {
          item.categories.add(category);
        }
      },
    )
    ..ifPresentXml('rights', (value) => item.copyright = value.decodeText(uf.meta.kind))
    ..ifPresentXml('source', (value) => item.sourceEntry = Source.fromXml(value));

  return item;
}

/// Parse item-level extensions
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

/// Returns item extension parsers for Atom feeds
List<ItemExtensionParser> _getItemExtensionParsers(UniversalFeed uf) {
  final itemParsers = <ItemExtensionParser>[];

  // Item-only extensions
  if (uf.meta.extensions.hasMedia) {
    itemParsers.add(MediaParser(uf.meta.extensions.nsUrl(nsMediaNs)!));
  }

  return itemParsers;
}
