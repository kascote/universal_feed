import 'package:xml/xml.dart';

import '../../../../universal_feed.dart';
import '../../../shared/extensions.dart';
import '../extension_parser.dart';

/// Parses the iTunes vocabulary (`<itunes:*>`) into the unified
/// [PodcastItem] model.
class ItunesItemParser implements ItemExtensionParser {
  /// Creates a new [ItunesItemParser] with the given namespace URL
  ItunesItemParser(this.namespaceUrl);

  @override
  final String namespaceUrl;

  @override
  void parseItem(UniversalFeed feed, Item item, XmlElement element) {
    final ii = (item.podcast ?? PodcastItem())
      ..duration = element.getElement('duration', namespace: namespaceUrl)?.innerText.trim()
      ..explicit = element.getElement('explicit', namespace: namespaceUrl)?.innerText.trim()
      ..title = element.getElement('title', namespace: namespaceUrl)?.innerText.trim()
      ..episode = element.getElement('episode', namespace: namespaceUrl)?.innerText.trim()
      ..season = element.getElement('season', namespace: namespaceUrl)?.innerText.trim()
      ..episodeType = element.getElement('episodeType', namespace: namespaceUrl)?.innerText.trim()
      ..block = element.getElement('block', namespace: namespaceUrl)?.innerText.trim()
      ..summary = element.getElement('summary', namespace: namespaceUrl)?.innerText.trim();

    element.ifPresentXml(
      'image',
      (value) {
        final url = value.getAttribute('href') ?? value.getAttribute('url');
        if (url != null) ii.image = Image(url.trim());
      },
      ns: namespaceUrl,
    );

    item.podcast = ii;
  }
}
