import 'package:xml/xml.dart';

import '../../../universal_feed.dart';
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
  getElements<XmlElement>(
    root,
    'author',
    cb: (xml) => uf.authors.add(Author.fromXml(xml)),
  );

  getElements<XmlElement>(
    root,
    'contributor',
    cb: (xml) => uf.authors.add(Author.fromXml(xml)),
  );

  getElements<XmlElement>(root, 'link', cb: (value) => uf.links.add(Link.fromXml(value)));

  getElement<XmlElement>(
    root,
    'title',
    cb: (item) => uf.title = uf.meta.version == '0.3'
        ? textDecoder(item.getAttribute('mode') ?? 'xml', item)
        : textDecoder(item.getAttribute('type') ?? 'text', item),
  );

  getElement<String>(root, 'updated', cb: (value) => uf.updated = Timestamp(value));
  getElement<String>(root, 'modified', cb: (value) => uf.updated = Timestamp(value));
  getElement<XmlElement>(
    root,
    'generator',
    cb: (xml) => uf.generator = Generator(
      xml.text,
      xml.getAttribute('version') ?? '',
      xml.getAttribute('url') ?? xml.getAttribute('uri') ?? '',
    ),
  );
  getElement<String>(root, 'id', cb: (value) => uf.guid = value);
  // getElement<String>(root, 'icon', cb: (value) => uf.icon = value);
  getElement<XmlElement>(root, 'logo', cb: (element) => uf.image = Image.fromXml(element));
  getElement<XmlElement>(root, 'rights', cb: (item) => uf.copyright = decodeTextField(item));
  getElement<XmlElement>(root, 'subtitle', cb: (item) => uf.description = decodeTextField(item));

  getElements<XmlElement>(
    root,
    'category',
    cb: (value) {
      final category = Category.fromXml(value);
      if (category != null) {
        uf.categories.add(category);
      }
    },
  );
}

/// Parses an Atom item
Item atomItemParser(UniversalFeed uf, Item item, XmlElement element) {
  getElements<XmlElement>(element, 'author', cb: (xml) => item.authors.add(Author.fromXml(xml)));
  getElements<XmlElement>(element, 'content', cb: (xml) => item.content.add(Content.fromXml(xml)));

  getElements<XmlElement>(
    element,
    'contributor',
    cb: (xml) => item.authors.add(Author.fromXml(xml)..type = AuthorType.contributor),
  );

  getElement<String>(
    element,
    'created',
    cb: (value) {
      final date = Timestamp(value);
      item
        ..published = date
        ..updated = date;
    },
  );

  getElement<String>(
    element,
    'issued',
    cb: (value) {
      final date = Timestamp(value);
      item
        ..published = date
        ..updated = date;
    },
  );

  getElement<String>(element, 'modified', cb: (value) => item.updated = Timestamp(value));
  getElement<String>(element, 'id', cb: (value) => item.guid = value);
  getElements<XmlElement>(element, 'link', cb: (value) => item.links.add(Link.fromXml(value)));
  getElement<XmlElement>(element, 'summary', cb: (value) => item.description = decodeTextField(value));
  getElement<XmlElement>(element, 'title', cb: (value) => item.title = decodeTextField(value));

  getElements<XmlElement>(
    element,
    'category',
    cb: (value) {
      final category = Category.fromXml(value);
      if (category != null) {
        item.categories.add(category);
      }
    },
  );

  getElement<XmlElement>(element, 'rights', cb: (value) => item.copyright = decodeTextField(value));

  getElement<XmlElement>(
    element,
    'source',
    cb: (value) => item.sourceEntry = UniversalFeed.parseFromXml(value),
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
