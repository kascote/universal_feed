import '../../time_stamp.dart';

/// Recognized values of the `<podcast:liveItem status="…">` attribute.
///
/// Closed set per the upstream per-tag spec
/// (https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/live-item.md):
/// `pending`, `live`, `ended`. [other] catches present-but-unrecognized
/// values (typos, future spec additions); [absent] means the attribute
/// was missing or empty. Mirrors the `PodcastMedium` pattern.
///
/// Per spec, this attribute — not [PodcastLive.start] — is the
/// canonical indicator of whether streaming has commenced.
enum PodcastLiveStatus {
  /// Stream is scheduled but has not started.
  pending,

  /// Stream is currently live.
  live,

  /// Stream has finished.
  ended,

  /// `status` attribute was present but the token was not recognized.
  /// Useful for logging / forward-compat.
  other,

  /// `status` attribute was absent or empty.
  absent,
}

/// Live-stream metadata from `<podcast:liveItem>` (Podcast Index
/// namespace). Lives on `PodcastItem.live`; non-null only when the
/// source element was `<podcast:liveItem>` (the discriminator that
/// tells you the parent `Item` represents a live stream rather than
/// an episode).
///
/// Per spec, the [status] attribute is the canonical indicator of
/// streaming state; [start] and [end] are intent-only and may not be
/// adhered to in practice.
///
/// Spec: https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/live-item.md
class PodcastLive {
  /// Raw `status` attribute body as it appeared in the feed, trimmed.
  /// Empty string when the attribute was absent. Prefer [knownStatus]
  /// for an ergonomic switch; [status] is kept for round-trip and
  /// forward-compat (unknown future tokens are visible here verbatim).
  final String status;

  /// Ergonomic enum derived from [status]. [PodcastLiveStatus.other]
  /// when the feed declared a status we don't recognize,
  /// [PodcastLiveStatus.absent] when the attribute was missing or
  /// empty.
  final PodcastLiveStatus knownStatus;

  /// Intended stream start time (ISO 8601 per spec, parsed liberally
  /// by [Timestamp]). Null when the attribute was absent or empty.
  /// Per spec, this is intent-only — apps should rely on [status] for
  /// actual stream state.
  final Timestamp? start;

  /// Intended stream end time (ISO 8601 per spec). Null when the
  /// attribute was absent or empty. Recommended by spec but not
  /// required.
  final Timestamp? end;

  /// Creates a new [PodcastLive].
  const PodcastLive({
    required this.status,
    required this.knownStatus,
    this.start,
    this.end,
  });
}
