import 'package:xml/xml.dart';

import '../../../../universal_feed.dart';
import '../../../shared/extensions.dart';
import '../../../shared/shared.dart';

/// Parses an Atom source element
///
/// NOTE: This parser contains duplicated logic from atomFeedParser in atom_parser.dart.
/// This duplication is intentional to keep Source as a separate lightweight type.
/// If you modify this parser, consider whether atomFeedParser needs similar changes.
void atomSourceParser(Source source, XmlElement element) {
  // DUPLICATED: This parsing logic mirrors atomFeedParser for feed-level metadata
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
        // Note: source elements are only in Atom 1.0+, so we use 'type' not 'mode'
        source.title = textDecoder(item.getAttribute('type') ?? 'text', item);
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
    ..ifPresentXml('rights', (item) => source.copyright = decodeTextField(item))
    ..ifPresentXml(
      'subtitle',
      (item) => source.subtitle = decodeTextField(item),
    )
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
