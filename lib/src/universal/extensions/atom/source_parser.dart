import 'package:xml/xml.dart';

import '../../../../universal_feed.dart';
import '../../../shared/extensions.dart';

/// Parses an Atom source element
void atomSourceParser(Source source, XmlElement element) {
  element
    ..forEachElementXml(
      'author',
      (xml) => source.authors.add(Author.fromXml(xml)),
    )
    ..forEachElementXml(
      'contributor',
      (xml) => source.authors.add(Author.fromXml(xml)),
    )
    ..forEachElementXml(
      'link',
      (value) {
        final link = Link.fromXml(value);
        if (link.rel == LinkRelationType.alternate && source.htmlLink == null) {
          source.htmlLink = link;
        }
        source.links.add(link);
      },
    )
    ..ifPresentXml(
      'title',
      (item) {
        // Note: source elements are only in Atom 1.0+, so we use default atomVersion
        source.title = item.decodeText(FeedKind.atom);
      },
    )
    ..ifPresent('updated', (value) => source.updated = Timestamp(value))
    ..ifPresent('modified', (value) => source.updated = Timestamp(value))
    ..ifPresentXml(
      'generator',
      (xml) => source.generator = Generator(
        xml.innerText,
        xml.getAttribute('version') ?? '',
        xml.getAttribute('url') ?? xml.getAttribute('uri') ?? '',
      ),
    )
    ..ifPresent('id', (value) => source.guid = value)
    ..ifPresent('icon', (value) => source.icon = Image(value))
    ..ifPresent('logo', (value) => source.image = Image(value))
    ..ifPresentXml('rights', (item) => source.copyright = item.decodeText(FeedKind.atom))
    ..ifPresentXml('subtitle', (item) => source.subtitle = item.decodeText(FeedKind.atom))
    ..forEachElementXml(
      'category',
      (value) {
        final category = Category.fromXml(value);
        if (category != null) {
          source.categories.add(category);
        }
      },
    );
}
