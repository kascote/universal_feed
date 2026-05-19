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
          final (known, isList) = parseMedium(body);
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
          pc.podpingUsesPodping = parseBool(value.getAttribute('usesPodping'));
        },
        ns: namespaceUrl,
      )
      ..forEachElementXml(
        'locked',
        (value) {
          pc
            ..locked = parseBool(value.innerText)
            ..lockedOwner = value.getAttribute('owner');
        },
        ns: namespaceUrl,
      )
      ..forEachElementXml(
        'block',
        (el) {
          final body = el.innerText.trim();
          if (body.isEmpty) return;
          pc.blocks.add(
            PodcastBlock(
              id: trimToNull(el.getAttribute('id')),
              value: body,
              blocked: parseBool(body),
            ),
          );
        },
        ns: namespaceUrl,
      )
      ..forEachElementXml(
        'funding',
        (el) {
          pc.fundings.add(
            PodcastFunding(
              url: trimToNull(el.getAttribute('url')),
              text: trimToNull(el.innerText),
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
        'chat',
        (el) {
          final c = chatFromXml(el);
          if (c != null) pc.chat = c;
        },
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
        'location',
        (el) {
          final loc = locationFromXml(el);
          if (loc != null) pc.locations.add(loc);
        },
        ns: namespaceUrl,
      )
      ..forEachElementXml(
        'image',
        (el) {
          final img = imageFromXml(el);
          if (img != null) pc.images.add(img);
        },
        ns: namespaceUrl,
      )
      ..forEachElementXml(
        'remoteItem',
        (el) {
          final ri = remoteItemFromXml(el);
          if (ri != null) pc.remoteItems.add(ri);
        },
        ns: namespaceUrl,
      )
      ..forEachElementXml(
        'podroll',
        (el) {
          final p = podrollFromXml(el, ns: namespaceUrl);
          if (p != null) pc.podroll = p;
        },
        ns: namespaceUrl,
      )
      ..forEachElementXml(
        'publisher',
        (el) {
          final p = publisherFromXml(el, ns: namespaceUrl);
          if (p != null) pc.publisher = p;
        },
        ns: namespaceUrl,
      )
      ..forEachElementXml(
        'value',
        (el) {
          final v = valueFromXml(el, ns: namespaceUrl);
          if (v != null) pc.values.add(v);
        },
        ns: namespaceUrl,
      )
      ..forEachElementXml(
        'trailer',
        (el) {
          final url = trimToNull(el.getAttribute('url'));
          if (url == null) return;
          final pubdate = trimToNull(el.getAttribute('pubdate'));
          pc.trailers.add(
            PodcastTrailer(
              url: url,
              title: trimToNull(el.innerText),
              pubdate: pubdate == null ? null : Timestamp(pubdate),
              length: trimToNull(el.getAttribute('length')),
              type: trimToNull(el.getAttribute('type')),
              season: trimToNull(el.getAttribute('season')),
            ),
          );
        },
        ns: namespaceUrl,
      )
      ..ifPresentXml(
        'updateFrequency',
        (el) {
          final description = el.innerText.trim();
          final complete = parseBool(el.getAttribute('complete'));
          final dtstart = trimToNull(el.getAttribute('dtstart'));
          final rrule = trimToNull(el.getAttribute('rrule'));
          if (description.isEmpty && complete == null && dtstart == null && rrule == null) return;
          pc.updateFrequency = PodcastUpdateFrequency(
            description: trimToNull(description),
            complete: complete,
            dtstart: dtstart == null ? null : Timestamp(dtstart),
            rrule: rrule,
          );
        },
        ns: namespaceUrl,
      );

    feed.podcast = pc;
  }
}
