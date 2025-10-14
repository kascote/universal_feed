import 'package:xml/xml.dart';

import '../../../universal_feed.dart';
import '../../shared/extensions.dart';
import '../../shared/shared.dart';

/// Parses an Atom feed
void atomXmlParser(UniversalFeed uf, XmlElement root) {
  atomFeedParser(uf, root);

  final items = root.findElements('entry');
  for (final item in items) {
    uf.items.add(Item.atomFromXml(uf, item));
  }
}

/// Parses the main feed element of an Atom feed
void atomFeedParser(UniversalFeed uf, XmlElement root) {
  root
    ..forEachElementXml(
      'author',
      (xml) => uf.authors.add(Author.fromXml(xml)),
    )
    ..forEachElementXml(
      'contributor',
      (xml) => uf.authors.add(Author.fromXml(xml)),
    )
    ..forEachElementXml(
      'link',
      (value) {
        final link = Link.fromXml(value);
        if (link.rel == LinkRelationType.self) uf.xmlLink = link;
        if (link.rel == LinkRelationType.alternate && uf.htmlLink == null) uf.htmlLink = link;
        uf.links.add(link);
      },
    )
    ..ifPresentXml(
      'title',
      (item) => uf.title = uf.meta.version == '0.3'
          ? textDecoder(item.getAttribute('mode') ?? 'xml', item)
          : textDecoder(item.getAttribute('type') ?? 'text', item),
    )
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
    ..ifPresentXml('rights', (item) => uf.copyright = decodeTextField(item))
    ..ifPresentXml(
      'subtitle',
      (item) => uf.description = decodeTextField(item),
    )
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

/// Parses an Atom item
Item atomItemParser(UniversalFeed uf, Item item, XmlElement element) {
  element
    ..forEachElementXml(
      'author',
      (xml) => item.authors.add(Author.fromXml(xml)),
    )
    ..forEachElementXml(
      'content',
      (xml) => item.content.add(Content.fromXml(xml)),
    )
    ..forEachElementXml(
      'contributor',
      (xml) => item.authors.add(Author.fromXml(xml)..type = AuthorType.contributor),
    )
    ..ifPresent(
      'created',
      (value) {
        final date = Timestamp(value);
        item
          ..published = date
          ..updated = date;
      },
    )
    ..ifPresent(
      'published',
      (value) {
        final date = Timestamp(value);
        item
          ..published = date
          ..updated = date;
      },
    )
    ..ifPresent(
      'issued',
      (value) {
        final date = Timestamp(value);
        item
          ..published = date
          ..updated = date;
      },
    )
    ..ifPresent('modified', (value) => item.updated = Timestamp(value))
    ..ifPresent('updated', (value) => item.updated = Timestamp(value))
    ..ifPresent('id', (value) => item.guid = value)
    ..forEachElementXml(
      'link',
      (value) => item.links.add(Link.fromXml(value)),
    )
    ..ifPresentXml(
      'summary',
      (value) => item.description = decodeTextField(value),
    )
    ..ifPresentXml('title', (value) => item.title = decodeTextField(value))
    ..forEachElementXml(
      'category',
      (value) {
        final category = Category.fromXml(value);
        if (category != null) {
          item.categories.add(category);
        }
      },
    )
    ..ifPresentXml(
      'rights',
      (value) => item.copyright = decodeTextField(value),
    )
    ..ifPresentXml(
      'source',
      (value) => item.sourceEntry = UniversalFeed.parseFromXml(value),
    );

  if (uf.meta.extensions.hasMedia) {
    item.media = Media.contentFromXml(uf, element);
  }

  return item;
}

/// Helper t Decode a text field
String decodeTextField(XmlElement element) {
  final type = element.getAttribute('mode') ?? element.getAttribute('type') ?? 'text';
  return textDecoder(type, element);
}
