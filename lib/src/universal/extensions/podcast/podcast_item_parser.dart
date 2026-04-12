import 'package:xml/xml.dart';

import '../../../../universal_feed.dart';
import '../../../shared/extensions.dart';
import '../extension_parser.dart';

/// Parses the Podcast Index vocabulary (`<podcast:*>`) into the unified
/// [PodcastItem] model at item level.
class PodcastItemParser implements ItemExtensionParser {
  /// Creates a new [PodcastItemParser] with the given namespace URL
  PodcastItemParser(this.namespaceUrl);

  @override
  final String namespaceUrl;

  @override
  void parseItem(UniversalFeed feed, Item item, XmlElement element) {
    final pi = item.podcast ?? PodcastItem();

    element
      ..forEachElementXml(
        'txt',
        (value) {
          pi.txts.add(
            PodcastTxt(
              purpose: value.getAttribute('purpose'),
              value: value.innerText.trim(),
            ),
          );
        },
        ns: namespaceUrl,
      )
      ..forEachElementXml(
        'chapters',
        (value) {
          final url = value.getAttribute('url')?.trim();
          final type = value.getAttribute('type')?.trim();
          pi.chapters = PodcastChapters(
            url: (url == null || url.isEmpty) ? null : url,
            type: (type == null || type.isEmpty) ? null : type,
          );
        },
        ns: namespaceUrl,
      );

    item.podcast = pi;
  }
}
