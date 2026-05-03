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
