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
      )
      ..forEachElementXml(
        'transcript',
        (value) {
          final url = value.getAttribute('url')?.trim();
          final type = value.getAttribute('type')?.trim();
          final language = value.getAttribute('language')?.trim();
          final rel = value.getAttribute('rel')?.trim();
          pi.transcripts.add(
            PodcastTranscript(
              url: (url == null || url.isEmpty) ? null : url,
              type: (type == null || type.isEmpty) ? null : type,
              knownType: _parseTranscriptType(type),
              language: (language == null || language.isEmpty) ? null : language,
              rel: (rel == null || rel.isEmpty) ? null : rel,
            ),
          );
        },
        ns: namespaceUrl,
      );

    item.podcast = pi;
  }

  PodcastTranscriptType _parseTranscriptType(String? raw) {
    if (raw == null || raw.isEmpty) return PodcastTranscriptType.absent;
    switch (raw.toLowerCase()) {
      case 'text/vtt':
        return PodcastTranscriptType.vtt;
      case 'text/plain':
        return PodcastTranscriptType.plain;
      case 'text/html':
        return PodcastTranscriptType.html;
      case 'application/json':
        return PodcastTranscriptType.json;
      case 'application/srt':
        return PodcastTranscriptType.srt;
      case 'application/x-subrip':
        return PodcastTranscriptType.subrip;
      default:
        return PodcastTranscriptType.other;
    }
  }
}
