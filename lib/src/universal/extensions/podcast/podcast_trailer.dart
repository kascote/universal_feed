import '../../time_stamp.dart';

/// A `<podcast:trailer>` entry from the Podcast Index namespace.
///
/// Channel-level, multi-valued. Each entry advertises a teaser/preview
/// media file, optionally scoped to a season.
/// Spec: https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#trailer
class PodcastTrailer {
  /// URL of the trailer media file. Always non-null in a parsed instance —
  /// elements without a `url` attribute are skipped at parse time.
  final String url;

  /// Human-readable title of the trailer (element body, trimmed).
  /// Null when the body was empty.
  final String? title;

  /// `pubdate` attribute (RFC-2822 by spec) wrapped in [Timestamp].
  /// Raw string lives in `pubdate.value`; `pubdate.parseValue()` returns
  /// a lazily-parsed [DateTime?]. Null when the attribute was absent.
  final Timestamp? pubdate;

  /// Raw `length` attribute — file size in bytes as a string. Matches the
  /// convention used by `Enclosure.length`.
  final String? length;

  /// MIME type of the trailer media (e.g. `audio/mp3`, `video/mp4`).
  final String? type;

  /// Season number this trailer belongs to, raw string. Matches the
  /// convention used by `PodcastItem.season`. Null when unscoped.
  final String? season;

  /// Creates a new [PodcastTrailer].
  const PodcastTrailer({
    required this.url,
    this.title,
    this.pubdate,
    this.length,
    this.type,
    this.season,
  });
}
