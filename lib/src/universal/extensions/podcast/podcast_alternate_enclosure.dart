import 'podcast_enclosure_source.dart';
import 'podcast_integrity.dart';

/// A `<podcast:alternateEnclosure>` entry from the Podcast Index
/// namespace.
///
/// Item-level, multi-valued. Each entry advertises one media variant —
/// a different codec, bitrate, language, or transport scheme — for the
/// same logical episode. Always carries one or more
/// [PodcastEnclosureSource] children (the parser skips wrappers with no
/// valid sources). Spec:
/// https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/alternate-enclosure.md
///
/// Companion proposal (recommended reading for semantics of `rel`,
/// `default`, transport vs media type, etc.):
/// https://github.com/Podcastindex-org/podcast-namespace/blob/main/proposal-docs/alternateEnclosure/alternateEnclosure.md
class PodcastAlternateEnclosure {
  /// MIME type of the underlying media asset (e.g. `audio/mpeg`,
  /// `video/mp4`). Required by spec; nullable here for liberal parsing.
  final String? type;

  /// File size in bytes, raw string. Matches the convention used by
  /// `Enclosure.length`.
  final String? length;

  /// Average encoding bitrate (bits/sec), raw string. Spec allows
  /// float values (e.g. `160707.74`).
  final String? bitrate;

  /// Video height in pixels, raw string.
  final String? height;

  /// BCP-47 language tag for this variant (e.g. `en-US`).
  final String? lang;

  /// Human-readable variant name (e.g. `"Standard"`, `"High quality"`).
  final String? title;

  /// Grouping key. `"default"` or null groups this variant with the
  /// RSS `<enclosure>` (i.e. it's an alternate transport for the same
  /// content); other values group "companion" media (e.g.
  /// `"Behind the Scenes"`). Not interpreted here.
  final String? rel;

  /// RFC-6381 codec string for this variant.
  final String? codecs;

  /// Whether this variant should be preferred when the player can
  /// support it. `null` when the attribute was absent — per spec, that
  /// means false; the resolution is the consumer's call.
  final bool? isDefault;

  /// Transport URIs for this variant, in source order. Always
  /// non-empty in a parsed instance — the parser skips wrappers with
  /// no valid sources.
  final List<PodcastEnclosureSource> sources;

  /// Integrity checks for the media, in source order. Empty when
  /// absent or when every `<podcast:integrity>` child was missing
  /// required attrs. Multiple are allowed (e.g. one `sri` + one
  /// `pgp-signature`) so a consumer that only supports one scheme can
  /// still find a usable entry. Per-tag doc says Single, proposal-doc
  /// says multiple — going multiple for liberal capture.
  final List<PodcastIntegrity> integrity;

  /// Creates a new [PodcastAlternateEnclosure].
  const PodcastAlternateEnclosure({
    required this.sources,
    this.type,
    this.length,
    this.bitrate,
    this.height,
    this.lang,
    this.title,
    this.rel,
    this.codecs,
    this.isDefault,
    this.integrity = const [],
  });
}
