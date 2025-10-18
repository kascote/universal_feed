import 'package:xml/xml.dart';

import '../../../../universal_feed.dart';
import '../../../shared/extensions.dart';
import '../extension_parser.dart';

/// Dublin Core extension parser - works at both channel and item levels
/// but parses different fields at each level
class DublinCoreParser implements ChannelExtensionParser, ItemExtensionParser {
  /// Creates a new [DublinCoreParser] with the given namespace URL
  DublinCoreParser(this.namespaceUrl);

  @override
  final String namespaceUrl;

  @override
  void parseChannel(UniversalFeed feed, XmlElement channel) {
    channel
      ..ifPresent('title', (value) => feed.title = value, ns: namespaceUrl)
      ..ifPresent(
        'author',
        (value) => feed.authors.add(Author.fromString(value)..type = AuthorType.author),
        ns: namespaceUrl,
      )
      ..ifPresent(
        'creator',
        (value) => feed.authors.add(Author.fromString(value)..type = AuthorType.creator),
        ns: namespaceUrl,
      )
      ..ifPresent(
        'contributor',
        (value) => feed.authors.add(Author.fromString(value)..type = AuthorType.contributor),
        ns: namespaceUrl,
      )
      ..ifPresent(
        'publisher',
        (value) => feed.authors.add(Author.fromString(value)..type = AuthorType.publisher),
        ns: namespaceUrl,
      )
      ..ifPresent('date', (value) => feed.updated = Timestamp(value), ns: namespaceUrl)
      ..ifPresent('rights', (value) => feed.copyright = value, ns: namespaceUrl)
      ..forEachElement(
        'subject',
        (value) => feed.categories.add(Category(label: value)),
        ns: namespaceUrl,
      );
  }

  @override
  void parseItem(UniversalFeed feed, Item item, XmlElement element) {
    element
      ..ifPresent(
        'author',
        (value) => item.authors.add(Author.fromString(value)..type = AuthorType.author),
        ns: namespaceUrl,
      )
      ..ifPresent(
        'contributor',
        (value) => item.authors.add(Author.fromString(value)..type = AuthorType.contributor),
        ns: namespaceUrl,
      )
      ..forEachElement(
        'creator',
        (value) => item.authors.add(Author.fromString(value)..type = AuthorType.creator),
        ns: namespaceUrl,
      )
      ..ifPresent(
        'date',
        (value) {
          final date = Timestamp(value);
          item
            ..published = date
            ..updated = date;
        },
        ns: namespaceUrl,
      )
      ..ifPresent('description', (value) => item.description = value, ns: namespaceUrl)
      ..ifPresent(
        'publisher',
        (value) => item.authors.add(Author.fromString(value)..type = AuthorType.publisher),
        ns: namespaceUrl,
      )
      ..ifPresent('title', (value) => item.title = value, ns: namespaceUrl);
  }
}
