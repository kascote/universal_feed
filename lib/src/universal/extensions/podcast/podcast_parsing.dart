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

/// Parses a `<podcast:person>` element into a [PodcastPerson].
/// Returns `null` when the body (the person's name) is absent or empty —
/// caller skips such entries.
PodcastPerson? personFromXml(XmlElement el) {
  final name = el.innerText.trim();
  if (name.isEmpty) return null;
  final role = el.getAttribute('role')?.trim();
  final group = el.getAttribute('group')?.trim();
  final img = el.getAttribute('img')?.trim();
  final href = el.getAttribute('href')?.trim();
  return PodcastPerson(
    name: name,
    role: (role == null || role.isEmpty) ? null : role,
    group: (group == null || group.isEmpty) ? null : group,
    img: (img == null || img.isEmpty) ? null : img,
    href: (href == null || href.isEmpty) ? null : href,
  );
}

/// Parses a `<podcast:location>` element into a [PodcastLocation].
/// Returns `null` when the body is blank — caller skips such entries
/// (spec: "This value cannot be blank").
PodcastLocation? locationFromXml(XmlElement el) {
  final text = el.innerText.trim();
  if (text.isEmpty) return null;
  final rel = el.getAttribute('rel')?.trim();
  final geo = el.getAttribute('geo')?.trim();
  final osm = el.getAttribute('osm')?.trim();
  final country = el.getAttribute('country')?.trim();
  return PodcastLocation(
    text: text,
    rel: (rel == null || rel.isEmpty) ? null : rel,
    geo: (geo == null || geo.isEmpty) ? null : geo,
    osm: (osm == null || osm.isEmpty) ? null : osm,
    country: (country == null || country.isEmpty) ? null : country,
  );
}

/// Parses a `<podcast:license>` element into a [PodcastLicense].
/// Always returns a non-null instance; absent attributes / empty body
/// surface as `null` fields on the result.
PodcastLicense licenseFromXml(XmlElement el) {
  final spdx = el.getAttribute('spdx')?.trim();
  final url = el.getAttribute('url')?.trim();
  final text = el.innerText.trim();
  return PodcastLicense(
    spdx: (spdx == null || spdx.isEmpty) ? null : spdx,
    url: (url == null || url.isEmpty) ? null : url,
    text: text.isEmpty ? null : text,
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
  final feedGuid = el.getAttribute('feedGuid')?.trim();
  if (feedGuid == null || feedGuid.isEmpty) return null;
  final feedUrl = el.getAttribute('feedUrl')?.trim();
  final itemGuid = el.getAttribute('itemGuid')?.trim();
  final medium = el.getAttribute('medium')?.trim();
  final title = el.getAttribute('title')?.trim();
  final (known, isList) = (medium == null || medium.isEmpty) ? (PodcastMedium.absent, false) : parseMedium(medium);
  return PodcastRemoteItem(
    feedGuid: feedGuid,
    feedUrl: (feedUrl == null || feedUrl.isEmpty) ? null : feedUrl,
    itemGuid: (itemGuid == null || itemGuid.isEmpty) ? null : itemGuid,
    medium: (medium == null || medium.isEmpty) ? null : medium,
    knownMedium: known,
    mediumIsList: isList,
    title: (title == null || title.isEmpty) ? null : title,
  );
}

/// Parses a `<podcast:image>` element into a [PodcastImage].
/// Returns `null` when the required `href` attribute is absent or empty
/// — caller skips such entries.
PodcastImage? imageFromXml(XmlElement el) {
  final href = el.getAttribute('href')?.trim();
  if (href == null || href.isEmpty) return null;
  final alt = el.getAttribute('alt')?.trim();
  final aspectRatio = el.getAttribute('aspect-ratio')?.trim();
  final width = el.getAttribute('width')?.trim();
  final height = el.getAttribute('height')?.trim();
  final type = el.getAttribute('type')?.trim();
  final purpose = el.getAttribute('purpose')?.trim();
  final tokens = (purpose == null || purpose.isEmpty)
      ? const <String>[]
      : purpose.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).map((t) => t.toLowerCase()).toList(growable: false);
  return PodcastImage(
    href: href,
    alt: (alt == null || alt.isEmpty) ? null : alt,
    aspectRatio: (aspectRatio == null || aspectRatio.isEmpty) ? null : aspectRatio,
    width: (width == null || width.isEmpty) ? null : width,
    height: (height == null || height.isEmpty) ? null : height,
    type: (type == null || type.isEmpty) ? null : type,
    purpose: (purpose == null || purpose.isEmpty) ? null : purpose,
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
  final uri = el.getAttribute('uri')?.trim();
  if (uri == null || uri.isEmpty) return null;
  final contentType = el.getAttribute('contentType')?.trim();
  return PodcastEnclosureSource(
    uri: uri,
    contentType: (contentType == null || contentType.isEmpty) ? null : contentType,
  );
}

/// Parses a `<podcast:integrity>` child of `<podcast:alternateEnclosure>`.
/// Returns `null` when either required attribute (`type`, `value`) is
/// missing or empty after trimming — caller skips such entries.
PodcastIntegrity? integrityFromXml(XmlElement el) {
  final type = el.getAttribute('type')?.trim();
  if (type == null || type.isEmpty) return null;
  final value = el.getAttribute('value')?.trim();
  if (value == null || value.isEmpty) return null;
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

  final type = el.getAttribute('type')?.trim();
  final length = el.getAttribute('length')?.trim();
  final bitrate = el.getAttribute('bitrate')?.trim();
  final height = el.getAttribute('height')?.trim();
  final lang = el.getAttribute('lang')?.trim();
  final title = el.getAttribute('title')?.trim();
  final rel = el.getAttribute('rel')?.trim();
  final codecs = el.getAttribute('codecs')?.trim();
  final isDefault = switch (el.getAttribute('default')?.trim().toLowerCase()) {
    'true' => true,
    'false' => false,
    _ => null,
  };

  return PodcastAlternateEnclosure(
    sources: sources,
    integrity: integrity,
    type: (type == null || type.isEmpty) ? null : type,
    length: (length == null || length.isEmpty) ? null : length,
    bitrate: (bitrate == null || bitrate.isEmpty) ? null : bitrate,
    height: (height == null || height.isEmpty) ? null : height,
    lang: (lang == null || lang.isEmpty) ? null : lang,
    title: (title == null || title.isEmpty) ? null : title,
    rel: (rel == null || rel.isEmpty) ? null : rel,
    codecs: (codecs == null || codecs.isEmpty) ? null : codecs,
    isDefault: isDefault,
  );
}

/// Parses a `<podcast:chat>` element into a [PodcastChat].
/// Returns `null` when either required attribute (`server`,
/// `protocol`) is absent or empty — caller drops such entries.
PodcastChat? chatFromXml(XmlElement el) {
  final server = el.getAttribute('server')?.trim();
  if (server == null || server.isEmpty) return null;
  final protocol = el.getAttribute('protocol')?.trim();
  if (protocol == null || protocol.isEmpty) return null;
  final accountId = el.getAttribute('accountId')?.trim();
  final space = el.getAttribute('space')?.trim();
  return PodcastChat(
    server: server,
    protocol: protocol,
    accountId: (accountId == null || accountId.isEmpty) ? null : accountId,
    space: (space == null || space.isEmpty) ? null : space,
  );
}
