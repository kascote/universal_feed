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
          pi.chapters = PodcastChapters(
            url: trimToNull(value.getAttribute('url')),
            type: trimToNull(value.getAttribute('type')),
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
        'chat',
        (el) {
          final c = chatFromXml(el);
          if (c != null) pi.chat = c;
        },
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
        'location',
        (el) {
          final loc = locationFromXml(el);
          if (loc != null) pi.locations.add(loc);
        },
        ns: namespaceUrl,
      )
      ..forEachElementXml(
        'image',
        (el) {
          final img = imageFromXml(el);
          if (img != null) pi.images.add(img);
        },
        ns: namespaceUrl,
      )
      ..forEachElementXml(
        'soundbite',
        (el) {
          final startTime = trimToNull(el.getAttribute('startTime'));
          if (startTime == null) return;
          final duration = trimToNull(el.getAttribute('duration'));
          if (duration == null) return;
          pi.soundbites.add(
            PodcastSoundbite(
              startTime: startTime,
              duration: duration,
              title: trimToNull(el.innerText),
            ),
          );
        },
        ns: namespaceUrl,
      )
      ..forEachElementXml(
        'socialInteract',
        (el) {
          final protocol = trimToNull(el.getAttribute('protocol'));
          if (protocol == null) return;
          final uri = trimToNull(el.getAttribute('uri'));
          if (uri == null && protocol != 'disabled') return;
          pi.socialInteracts.add(
            PodcastSocialInteract(
              protocol: protocol,
              uri: uri,
              accountId: trimToNull(el.getAttribute('accountId')),
              accountUrl: trimToNull(el.getAttribute('accountUrl')),
              priority: trimToNull(el.getAttribute('priority')),
            ),
          );
        },
        ns: namespaceUrl,
      )
      ..forEachElementXml(
        'alternateEnclosure',
        (el) {
          final ae = alternateEnclosureFromXml(el, ns: namespaceUrl);
          if (ae != null) pi.alternateEnclosures.add(ae);
        },
        ns: namespaceUrl,
      )
      ..forEachElementXml(
        'value',
        (el) {
          final v = valueFromXml(el, ns: namespaceUrl);
          if (v != null) pi.values.add(v);
        },
        ns: namespaceUrl,
      )
      ..forEachElementXml(
        'contentLink',
        (el) {
          final cl = contentLinkFromXml(el);
          if (cl != null) pi.contentLinks.add(cl);
        },
        ns: namespaceUrl,
      )
      ..forEachElementXml(
        'transcript',
        (value) {
          final type = trimToNull(value.getAttribute('type'));
          pi.transcripts.add(
            PodcastTranscript(
              url: trimToNull(value.getAttribute('url')),
              type: type,
              knownType: _parseTranscriptType(type),
              language: trimToNull(value.getAttribute('language')),
              rel: trimToNull(value.getAttribute('rel')),
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
