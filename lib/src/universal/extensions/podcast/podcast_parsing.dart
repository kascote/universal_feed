import 'package:xml/xml.dart';

import '../../../../universal_feed.dart';

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
