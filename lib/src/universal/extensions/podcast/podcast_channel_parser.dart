import 'package:xml/xml.dart';

import '../../../../universal_feed.dart';
import '../../../shared/extensions.dart';
import '../extension_parser.dart';
import 'podcast_parsing.dart';

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
      )
      ..forEachElementXml(
        'medium',
        (value) {
          final body = value.innerText.trim();
          if (body.isEmpty) return;
          final (known, isList) = _parseMedium(body);
          pc
            ..medium = body
            ..knownMedium = known
            ..mediumIsList = isList;
        },
        ns: namespaceUrl,
      )
      ..forEachElementXml(
        'podping',
        (value) {
          final attr = value.getAttribute('usesPodping')?.trim().toLowerCase();
          pc.podpingUsesPodping = switch (attr) {
            'true' || 'yes' => true,
            'false' || 'no' => false,
            _ => null,
          };
        },
        ns: namespaceUrl,
      )
      ..forEachElementXml(
        'locked',
        (value) {
          final body = value.innerText.trim().toLowerCase();
          pc
            ..locked = switch (body) {
              'yes' => true,
              'no' => false,
              _ => null,
            }
            ..lockedOwner = value.getAttribute('owner');
        },
        ns: namespaceUrl,
      )
      ..forEachElementXml(
        'block',
        (el) {
          final body = el.innerText.trim();
          if (body.isEmpty) return;
          final rawId = el.getAttribute('id')?.trim();
          final id = (rawId == null || rawId.isEmpty) ? null : rawId;
          final blocked = _parseBlockedValue(body);
          pc.blocks.add(PodcastBlock(id: id, value: body, blocked: blocked));
        },
        ns: namespaceUrl,
      )
      ..forEachElementXml(
        'funding',
        (el) {
          final url = el.getAttribute('url')?.trim();
          final text = el.innerText.trim();
          pc.fundings.add(
            PodcastFunding(
              url: (url == null || url.isEmpty) ? null : url,
              text: text.isEmpty ? null : text,
            ),
          );
        },
        ns: namespaceUrl,
      )
      ..forEachElementXml(
        'license',
        (el) => pc.license = licenseFromXml(el),
        ns: namespaceUrl,
      )
      ..forEachElementXml(
        'person',
        (el) {
          final p = personFromXml(el);
          if (p != null) pc.persons.add(p);
        },
        ns: namespaceUrl,
      )
      ..forEachElementXml(
        'trailer',
        (el) {
          final url = el.getAttribute('url')?.trim();
          if (url == null || url.isEmpty) return;
          final title = el.innerText.trim();
          final pubdate = el.getAttribute('pubdate')?.trim();
          final length = el.getAttribute('length')?.trim();
          final type = el.getAttribute('type')?.trim();
          final season = el.getAttribute('season')?.trim();
          pc.trailers.add(
            PodcastTrailer(
              url: url,
              title: title.isEmpty ? null : title,
              pubdate: (pubdate == null || pubdate.isEmpty) ? null : Timestamp(pubdate),
              length: (length == null || length.isEmpty) ? null : length,
              type: (type == null || type.isEmpty) ? null : type,
              season: (season == null || season.isEmpty) ? null : season,
            ),
          );
        },
        ns: namespaceUrl,
      )
      ..ifPresentXml(
        'updateFrequency',
        (el) {
          final description = el.innerText.trim();
          final complete = switch (el.getAttribute('complete')?.toLowerCase()) {
            'true' => true,
            'false' => false,
            _ => null,
          };
          final dtstart = el.getAttribute('dtstart');
          final rrule = el.getAttribute('rrule');
          if (description.isEmpty && complete == null && dtstart == null && rrule == null) return;
          pc.updateFrequency = PodcastUpdateFrequency(
            description: description.isEmpty ? null : description,
            complete: complete,
            dtstart: dtstart,
            rrule: rrule,
          );
        },
        ns: namespaceUrl,
      );

    feed.podcast = pc;
  }

  bool? _parseBlockedValue(String raw) => switch (raw.toLowerCase()) {
    'yes' => true,
    'no' => false,
    _ => null,
  };

  (PodcastMedium, bool) _parseMedium(String raw) {
    final hasListSuffix = raw.endsWith('L');
    final base = hasListSuffix ? raw.substring(0, raw.length - 1).toLowerCase() : raw.toLowerCase();
    final known = switch (base) {
      'podcast' => PodcastMedium.podcast,
      'music' => PodcastMedium.music,
      'video' => PodcastMedium.video,
      'film' => PodcastMedium.film,
      'audiobook' => PodcastMedium.audiobook,
      'newsletter' => PodcastMedium.newsletter,
      'blog' => PodcastMedium.blog,
      'publisher' => PodcastMedium.publisher,
      'course' => PodcastMedium.course,
      'mixed' => PodcastMedium.mixed,
      _ => PodcastMedium.other,
    };
    return (known, hasListSuffix);
  }
}
