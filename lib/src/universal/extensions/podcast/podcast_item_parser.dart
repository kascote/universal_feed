import 'package:xml/xml.dart';

import '../../../../universal_feed.dart';
import '../../../shared/extensions.dart';
import '../extension_parser.dart';
import 'podcast_parsing.dart';

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
      ..ifPresentXml(
        'season',
        (value) {
          final body = value.innerText.trim();
          if (body.isNotEmpty) pi.season = body;
          final name = value.getAttribute('name')?.trim();
          if (name != null && name.isNotEmpty) pi.seasonName = name;
        },
        ns: namespaceUrl,
      )
      ..ifPresentXml(
        'episode',
        (value) {
          final body = value.innerText.trim();
          if (body.isNotEmpty) pi.episode = body;
          final display = value.getAttribute('display')?.trim();
          if (display != null && display.isNotEmpty) pi.episodeDisplay = display;
        },
        ns: namespaceUrl,
      )
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
        'license',
        (el) => pi.license = licenseFromXml(el),
        ns: namespaceUrl,
      )
      ..forEachElementXml(
        'person',
        (el) {
          final p = personFromXml(el);
          if (p != null) pi.persons.add(p);
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
