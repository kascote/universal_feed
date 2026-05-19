import 'package:xml/xml.dart';

import '../../../../universal_feed.dart';
import '../../../shared/extensions.dart';

/// Shared parsers for `<podcast:*>` tags that appear at both channel and
/// item level. Library-internal — not exported from the public barrel.
///
/// Conventions:
/// * Always-parses cases return a non-null instance.
/// * Skip cases (missing required field) return `null` so callers can
///   filter inline.
/// * All attribute / body extraction trims whitespace and treats empty →
///   `null`.

/// Trims [s] and returns `null` when null or blank-after-trim; otherwise
/// returns the trimmed value. The trim happens inside so callers don't
/// have to remember to do it.
String? trimToNull(String? s) {
  if (s == null) return null;
  final t = s.trim();
  return t.isEmpty ? null : t;
}

/// Liberal boolean parser for podcast-namespace attributes/bodies.
///
/// Accepts (case-insensitive, trimmed):
/// * `true`, `yes`, `on`, `1` → `true`
/// * `false`, `no`, `off`, `0` → `false`
///
/// Returns `null` for null/empty input or any other token. The spec for
/// any given field nominally allows only one pair (e.g. `yes`/`no` for
/// `<podcast:locked>`), but real-world feeds mix forms — this matches
/// the library's liberal-parsing stance.
bool? parseBool(String? raw) {
  if (raw == null) return null;
  return switch (raw.trim().toLowerCase()) {
    'true' || 'yes' || 'on' || '1' => true,
    'false' || 'no' || 'off' || '0' => false,
    _ => null,
  };
}

/// Parses a `<podcast:person>` element into a [PodcastPerson].
/// Returns `null` when the body (the person's name) is absent or empty —
/// caller skips such entries.
PodcastPerson? personFromXml(XmlElement el) {
  final name = el.innerText.trim();
  if (name.isEmpty) return null;
  return PodcastPerson(
    name: name,
    role: trimToNull(el.getAttribute('role')),
    group: trimToNull(el.getAttribute('group')),
    img: trimToNull(el.getAttribute('img')),
    href: trimToNull(el.getAttribute('href')),
  );
}

/// Parses a `<podcast:location>` element into a [PodcastLocation].
/// Returns `null` when the body is blank — caller skips such entries
/// (spec: "This value cannot be blank").
PodcastLocation? locationFromXml(XmlElement el) {
  final text = el.innerText.trim();
  if (text.isEmpty) return null;
  return PodcastLocation(
    text: text,
    rel: trimToNull(el.getAttribute('rel')),
    geo: trimToNull(el.getAttribute('geo')),
    osm: trimToNull(el.getAttribute('osm')),
    country: trimToNull(el.getAttribute('country')),
  );
}

/// Parses a `<podcast:license>` element into a [PodcastLicense].
/// Always returns a non-null instance; absent attributes / empty body
/// surface as `null` fields on the result.
PodcastLicense licenseFromXml(XmlElement el) {
  return PodcastLicense(
    spdx: trimToNull(el.getAttribute('spdx')),
    url: trimToNull(el.getAttribute('url')),
    text: trimToNull(el.innerText),
  );
}

/// Parses a raw `<podcast:medium>` body (or the `medium` attribute on
/// `<podcast:remoteItem>`) into a `(known enum, isList)` tuple.
/// Returns `(PodcastMedium.other, false)` for unrecognized bases. The
/// `L` list-suffix is detected case-sensitively per spec.
(PodcastMedium, bool) parseMedium(String raw) {
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

/// Parses a `<podcast:remoteItem>` element into a [PodcastRemoteItem].
/// Returns `null` when the required `feedGuid` attribute is absent or
/// empty — caller skips such entries.
PodcastRemoteItem? remoteItemFromXml(XmlElement el) {
  final feedGuid = trimToNull(el.getAttribute('feedGuid'));
  if (feedGuid == null) return null;
  final medium = trimToNull(el.getAttribute('medium'));
  final (known, isList) = medium == null ? (PodcastMedium.absent, false) : parseMedium(medium);
  return PodcastRemoteItem(
    feedGuid: feedGuid,
    feedUrl: trimToNull(el.getAttribute('feedUrl')),
    itemGuid: trimToNull(el.getAttribute('itemGuid')),
    medium: medium,
    knownMedium: known,
    mediumIsList: isList,
    title: trimToNull(el.getAttribute('title')),
  );
}

/// Parses a `<podcast:image>` element into a [PodcastImage].
/// Returns `null` when the required `href` attribute is absent or empty
/// — caller skips such entries.
PodcastImage? imageFromXml(XmlElement el) {
  final href = trimToNull(el.getAttribute('href'));
  if (href == null) return null;
  final purpose = trimToNull(el.getAttribute('purpose'));
  final tokens = purpose == null
      ? const <String>[]
      : purpose.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).map((t) => t.toLowerCase()).toList(growable: false);
  return PodcastImage(
    href: href,
    alt: trimToNull(el.getAttribute('alt')),
    aspectRatio: trimToNull(el.getAttribute('aspect-ratio')),
    width: trimToNull(el.getAttribute('width')),
    height: trimToNull(el.getAttribute('height')),
    type: trimToNull(el.getAttribute('type')),
    purpose: purpose,
    purposeTokens: tokens,
  );
}

/// Parses a `<podcast:podroll>` wrapper into a [PodcastPodroll].
/// Iterates `<podcast:remoteItem>` children in [ns]; returns `null`
/// when none survive (matches the spec's "one or more" requirement
/// liberally — an empty podroll has no consumer value).
PodcastPodroll? podrollFromXml(XmlElement el, {required String ns}) {
  final items = <PodcastRemoteItem>[];
  el.forEachElementXml(
    'remoteItem',
    (child) {
      final ri = remoteItemFromXml(child);
      if (ri != null) items.add(ri);
    },
    ns: ns,
  );
  if (items.isEmpty) return null;
  return PodcastPodroll(items: items);
}

/// Parses a `<podcast:publisher>` wrapper into a [PodcastPublisher].
/// Returns the **first** valid `<podcast:remoteItem>` child (per the
/// spec's "exactly one" rule — liberal: first wins on duplicates).
/// Returns `null` when no valid child was found.
PodcastPublisher? publisherFromXml(XmlElement el, {required String ns}) {
  PodcastRemoteItem? picked;
  el.forEachElementXml(
    'remoteItem',
    (child) {
      if (picked != null) return;
      picked = remoteItemFromXml(child);
    },
    ns: ns,
  );
  final r = picked;
  if (r == null) return null;
  return PodcastPublisher(remoteItem: r);
}

/// Parses a `<podcast:source>` child of `<podcast:alternateEnclosure>`.
/// Returns `null` when the required `uri` attribute is missing or
/// empty after trimming — caller skips such entries.
PodcastEnclosureSource? enclosureSourceFromXml(XmlElement el) {
  final uri = trimToNull(el.getAttribute('uri'));
  if (uri == null) return null;
  return PodcastEnclosureSource(
    uri: uri,
    contentType: trimToNull(el.getAttribute('contentType')),
  );
}

/// Parses a `<podcast:integrity>` child of `<podcast:alternateEnclosure>`.
/// Returns `null` when either required attribute (`type`, `value`) is
/// missing or empty after trimming — caller skips such entries.
PodcastIntegrity? integrityFromXml(XmlElement el) {
  final type = trimToNull(el.getAttribute('type'));
  if (type == null) return null;
  final value = trimToNull(el.getAttribute('value'));
  if (value == null) return null;
  return PodcastIntegrity(type: type, value: value);
}

/// Parses a `<podcast:alternateEnclosure>` element into a
/// [PodcastAlternateEnclosure]. Returns `null` when no valid
/// `<podcast:source>` child was found (a media def with no transport
/// is unusable). All valid `<podcast:integrity>` children are captured
/// in source order.
PodcastAlternateEnclosure? alternateEnclosureFromXml(XmlElement el, {required String ns}) {
  final sources = <PodcastEnclosureSource>[];
  el.forEachElementXml(
    'source',
    (child) {
      final s = enclosureSourceFromXml(child);
      if (s != null) sources.add(s);
    },
    ns: ns,
  );
  if (sources.isEmpty) return null;

  final integrity = <PodcastIntegrity>[];
  el.forEachElementXml(
    'integrity',
    (child) {
      final i = integrityFromXml(child);
      if (i != null) integrity.add(i);
    },
    ns: ns,
  );

  return PodcastAlternateEnclosure(
    sources: sources,
    integrity: integrity,
    type: trimToNull(el.getAttribute('type')),
    length: trimToNull(el.getAttribute('length')),
    bitrate: trimToNull(el.getAttribute('bitrate')),
    height: trimToNull(el.getAttribute('height')),
    lang: trimToNull(el.getAttribute('lang')),
    title: trimToNull(el.getAttribute('title')),
    rel: trimToNull(el.getAttribute('rel')),
    codecs: trimToNull(el.getAttribute('codecs')),
    isDefault: parseBool(el.getAttribute('default')),
  );
}

/// Parses a `<podcast:valueRecipient>` element into a
/// [PodcastValueRecipient]. Returns `null` when any required attribute
/// (`type`, `address`, `split`) is missing or empty after trimming.
PodcastValueRecipient? valueRecipientFromXml(XmlElement el) {
  final type = trimToNull(el.getAttribute('type'));
  if (type == null) return null;
  final address = trimToNull(el.getAttribute('address'));
  if (address == null) return null;
  final split = trimToNull(el.getAttribute('split'));
  if (split == null) return null;
  return PodcastValueRecipient(
    type: type,
    address: address,
    split: split,
    name: trimToNull(el.getAttribute('name')),
    customKey: trimToNull(el.getAttribute('customKey')),
    customValue: trimToNull(el.getAttribute('customValue')),
    fee: parseBool(el.getAttribute('fee')),
  );
}

/// Parses a `<podcast:valueTimeSplit>` element into a
/// [PodcastValueTimeSplit]. Returns `null` when either required
/// attribute (`startTime`, `duration`) is missing or empty.
/// Captures both `<podcast:valueRecipient>` children and the first
/// valid `<podcast:remoteItem>` child — consumer decides precedence.
PodcastValueTimeSplit? valueTimeSplitFromXml(XmlElement el, {required String ns}) {
  final startTime = trimToNull(el.getAttribute('startTime'));
  if (startTime == null) return null;
  final duration = trimToNull(el.getAttribute('duration'));
  if (duration == null) return null;

  final recipients = <PodcastValueRecipient>[];
  el.forEachElementXml(
    'valueRecipient',
    (child) {
      final r = valueRecipientFromXml(child);
      if (r != null) recipients.add(r);
    },
    ns: ns,
  );

  PodcastRemoteItem? remoteItem;
  el.forEachElementXml(
    'remoteItem',
    (child) {
      if (remoteItem != null) return;
      remoteItem = remoteItemFromXml(child);
    },
    ns: ns,
  );

  return PodcastValueTimeSplit(
    startTime: startTime,
    duration: duration,
    remoteStartTime: trimToNull(el.getAttribute('remoteStartTime')),
    remotePercentage: trimToNull(el.getAttribute('remotePercentage')),
    recipients: recipients,
    remoteItem: remoteItem,
  );
}

/// Parses a `<podcast:value>` element into a [PodcastValue]. Returns
/// `null` when either required attribute (`type`, `method`) is
/// missing or empty — without them the block is unactionable. Empty
/// `recipients` / `timeSplits` are allowed; consumers can filter.
PodcastValue? valueFromXml(XmlElement el, {required String ns}) {
  final type = trimToNull(el.getAttribute('type'));
  if (type == null) return null;
  final method = trimToNull(el.getAttribute('method'));
  if (method == null) return null;

  final recipients = <PodcastValueRecipient>[];
  el.forEachElementXml(
    'valueRecipient',
    (child) {
      final r = valueRecipientFromXml(child);
      if (r != null) recipients.add(r);
    },
    ns: ns,
  );

  final timeSplits = <PodcastValueTimeSplit>[];
  el.forEachElementXml(
    'valueTimeSplit',
    (child) {
      final ts = valueTimeSplitFromXml(child, ns: ns);
      if (ts != null) timeSplits.add(ts);
    },
    ns: ns,
  );

  return PodcastValue(
    type: type,
    method: method,
    suggested: trimToNull(el.getAttribute('suggested')),
    recipients: recipients,
    timeSplits: timeSplits,
  );
}

/// Parses a `<podcast:contentLink>` element into a [PodcastContentLink].
/// Returns `null` when the required `href` attribute is missing or
/// empty after trimming.
PodcastContentLink? contentLinkFromXml(XmlElement el) {
  final href = trimToNull(el.getAttribute('href'));
  if (href == null) return null;
  return PodcastContentLink(
    href: href,
    text: trimToNull(el.innerText),
  );
}

/// Maps a raw `<podcast:liveItem status="…">` token to its
/// [PodcastLiveStatus] enum value. Case-insensitive. Returns
/// [PodcastLiveStatus.absent] for null/empty input; returns
/// [PodcastLiveStatus.other] for any non-empty token not in the spec's
/// closed set (`pending`, `live`, `ended`).
PodcastLiveStatus parseLiveStatus(String? raw) {
  if (raw == null || raw.isEmpty) return PodcastLiveStatus.absent;
  return switch (raw.toLowerCase()) {
    'pending' => PodcastLiveStatus.pending,
    'live' => PodcastLiveStatus.live,
    'ended' => PodcastLiveStatus.ended,
    _ => PodcastLiveStatus.other,
  };
}

/// Extracts the `status` / `start` / `end` attributes from a
/// `<podcast:liveItem>` element into a [PodcastLive]. Always returns
/// non-null — the caller already knows the element was a liveItem;
/// missing required attrs degrade to [PodcastLiveStatus.absent] /
/// `null` `Timestamp` rather than dropping the whole element.
PodcastLive liveFromXml(XmlElement el) {
  final rawStatus = el.getAttribute('status')?.trim() ?? '';
  final start = trimToNull(el.getAttribute('start'));
  final end = trimToNull(el.getAttribute('end'));
  return PodcastLive(
    status: rawStatus,
    knownStatus: parseLiveStatus(rawStatus),
    start: start == null ? null : Timestamp(start),
    end: end == null ? null : Timestamp(end),
  );
}

/// Parses a `<podcast:chat>` element into a [PodcastChat].
/// Returns `null` when either required attribute (`server`,
/// `protocol`) is absent or empty — caller drops such entries.
PodcastChat? chatFromXml(XmlElement el) {
  final server = trimToNull(el.getAttribute('server'));
  if (server == null) return null;
  final protocol = trimToNull(el.getAttribute('protocol'));
  if (protocol == null) return null;
  return PodcastChat(
    server: server,
    protocol: protocol,
    accountId: trimToNull(el.getAttribute('accountId')),
    space: trimToNull(el.getAttribute('space')),
  );
}
