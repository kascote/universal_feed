import 'package:xml/xml.dart';

import '../../../../universal_feed.dart';
import '../../../shared/extensions.dart';
import '../extension_parser.dart';

/// Parses the Podcast Index vocabulary (`<podcast:*>`) into the unified
/// [PodcastChannel] model at channel level.
///
/// Spec: https://github.com/Podcastindex-org/podcast-namespace
class PodcastChannelParser implements ChannelExtensionParser {
  /// Creates a new [PodcastChannelParser] with the given namespace URL
  PodcastChannelParser(this.namespaceUrl);

  @override
  final String namespaceUrl;

  @override
  void parseChannel(UniversalFeed feed, XmlElement channel) {
    final pc = feed.podcast ?? PodcastChannel();

    channel
      ..forEachElementXml(
        'txt',
        (value) {
          pc.txts.add(
            PodcastTxt(
              purpose: value.getAttribute('purpose'),
              value: value.innerText.trim(),
            ),
          );
        },
        ns: namespaceUrl,
      )
      ..forEachElementXml(
        'guid',
        (value) {
          final body = value.innerText.trim();
          pc.guid = body.isEmpty ? null : body;
        },
        ns: namespaceUrl,
      );

    feed.podcast = pc;
  }
}
