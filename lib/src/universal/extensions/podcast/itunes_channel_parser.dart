import 'package:xml/xml.dart';

import '../../../../universal_feed.dart';
import '../../../shared/extensions.dart';
import '../extension_parser.dart';

/// Parses the iTunes vocabulary (`<itunes:*>`) into the unified
/// [PodcastChannel] model.
class ItunesChannelParser implements ChannelExtensionParser {
  /// Creates a new [ItunesChannelParser] with the given namespace URL
  ItunesChannelParser(this.namespaceUrl);

  @override
  final String namespaceUrl;

  @override
  void parseChannel(UniversalFeed feed, XmlElement channel) {
    final ic = feed.podcast ?? PodcastChannel();

    channel
      ..ifPresentXml(
        'image',
        (value) {
          final url = value.getAttribute('href') ?? value.getAttribute('url');
          if (url != null) ic.image = Image(url.trim());
        },
        ns: namespaceUrl,
      )
      ..forEachElementXml(
        'category',
        (value) {
          final cat = _parseItunesCategory(value, namespaceUrl, 1);
          if (cat != null) ic.categories.add(cat);
        },
        ns: namespaceUrl,
      )
      ..ifPresentXml(
        'owner',
        (value) {
          feed.authors.add(
            Author(
              name: value.getElement('name', namespace: namespaceUrl)?.innerText ?? '',
              email: value.getElement('email', namespace: namespaceUrl)?.innerText ?? '',
            )..type = AuthorType.creator,
          );
        },
        ns: namespaceUrl,
      )
      ..ifPresent(
        'author',
        (value) => feed.authors.add(Author.fromString(value)..type = AuthorType.author),
        ns: namespaceUrl,
      );

    ic
      ..explicit = channel.getElement('explicit', namespace: namespaceUrl)?.innerText.trim()
      ..title = channel.getElement('title', namespace: namespaceUrl)?.innerText.trim()
      ..type = channel.getElement('type', namespace: namespaceUrl)?.innerText.trim()
      ..newFeedUrl = channel.getElement('new-feed-url', namespace: namespaceUrl)?.innerText.trim()
      ..block = channel.getElement('block', namespace: namespaceUrl)?.innerText.trim()
      ..complete = channel.getElement('complete', namespace: namespaceUrl)?.innerText.trim()
      ..summary = channel.getElement('summary', namespace: namespaceUrl)?.innerText.trim();

    channel.ifPresentXml(
      'keywords',
      (xml) {
        final kws = Set.of(
          xml.innerText.split(',').map((e) => e.trim()),
        ).where((e) => e.isNotEmpty);
        if (kws.isEmpty) return;
        final cats = List<Category>.generate(
          kws.length,
          (p) => Category(label: kws.elementAt(p), scheme: 'keyword'),
        );
        ic.categories.addAll(cats);
      },
      ns: namespaceUrl,
    );

    feed.podcast = ic;
  }
}

const _maxItunesCategoryDepth = 10;

Category? _parseItunesCategory(XmlElement node, String ns, int depth) {
  final text = node.getAttribute('text')?.trim();
  if (text == null || text.isEmpty) return null;

  final cat = Category(label: text);
  if (depth >= _maxItunesCategoryDepth) return cat;

  for (final child in node.findElements('category', namespace: ns)) {
    final sub = _parseItunesCategory(child, ns, depth + 1);
    if (sub != null) cat.children.add(sub);
  }
  return cat;
}
