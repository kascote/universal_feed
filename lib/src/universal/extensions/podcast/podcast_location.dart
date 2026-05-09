/// A `<podcast:location>` entry from the Podcast Index namespace.
///
/// Channel- or item-level, multi-valued. Describes the place the show
/// or episode is *about* (`rel="subject"`, default per spec) or where
/// it was *recorded/produced* (`rel="creator"`). Per spec, a feed may
/// carry both kinds — surfaced as a list, source order preserved.
/// Spec: https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/location.md
class PodcastLocation {
  /// Element body, trimmed — the spec's "Node Value": a free-form
  /// human-readable display string. Spec disclaims any parseable
  /// meaning ("shouldn't be depended on to be parseable in any
  /// specific way… mostly intended as a 'display' value"), so this
  /// field is named `text` rather than `name` — matches
  /// `PodcastFunding.text` / `PodcastLicense.text`. Always non-blank
  /// in a parsed instance — the parser skips elements whose body is
  /// empty.
  final String text;

  /// `rel` attribute, raw string. Spec values today: `subject`
  /// (default, what the content is about) or `creator` (where it was
  /// made). Default **not** back-filled — a hard-coded fallback would
  /// drift if the spec changes. Consumers apply defaults themselves.
  final String? rel;

  /// RFC 5870 geo URI, raw string (e.g. `geo:30.2711286,-97.7436995`).
  /// Null when absent. Not parsed into lat/lon — see the GeoRSS
  /// extension (`Geo`) for that surface.
  final String? geo;

  /// OpenStreetMap identifier, raw string (e.g. `R113314` — prefix
  /// `N`/`W`/`R` + numeric id). Null when absent.
  final String? osm;

  /// ISO 3166-1 alpha-2 two-letter country code, raw string (e.g.
  /// `US`, `GB`). Null when absent. Not validated, not uppercased.
  final String? country;

  /// Creates a new [PodcastLocation].
  const PodcastLocation({
    required this.text,
    this.rel,
    this.geo,
    this.osm,
    this.country,
  });
}
