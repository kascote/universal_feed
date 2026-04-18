/// Represents a single `<podcast:block>` entry from the Podcast Index namespace.
///
/// Multiple entries are allowed per channel — one per platform to block. An
/// absent [id] means a global block across all directories (equivalent in
/// intent to `itunes:block`). Spec:
/// https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#block
class PodcastBlock {
  /// Platform slug from the Podcast Index app directory (e.g. `"google"`,
  /// `"spotify"`). Null when the `id` attribute was absent, indicating a
  /// global block across all directories.
  final String? id;

  /// Raw `<podcast:block>` body as it appeared in the feed, trimmed.
  /// Typically `"yes"` or `"no"`. Prefer [blocked] for an ergonomic check.
  final String value;

  /// Ergonomic parse of [value]: `true` for `yes` (case-insensitive),
  /// `false` for `no` (case-insensitive), `null` for anything else.
  final bool? blocked;

  /// Creates a new [PodcastBlock].
  PodcastBlock({required this.id, required this.value, required this.blocked});
}
