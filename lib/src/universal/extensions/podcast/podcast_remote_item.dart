import 'podcast_channel.dart' show PodcastMedium;

/// A `<podcast:remoteItem>` pointer from the Podcast Index namespace.
///
/// Reusable primitive: appears as a direct child of `<channel>` (when
/// the feed declares a list-variant `<podcast:medium>` such as
/// `podcastL` / `musicL`), and is also nested inside the upcoming
/// `<podcast:podroll>`, `<podcast:publisher>`, and
/// `<podcast:valueTimeSplit>` containers — all parents share this
/// value class.
///
/// Spec: https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/remote-item.md
class PodcastRemoteItem {
  /// `feedGuid` attribute — the remote feed's `<podcast:guid>` (UUIDv5
  /// per spec, stored raw). Always non-null in a parsed instance —
  /// elements without `feedGuid` are skipped at parse time.
  final String feedGuid;

  /// `feedUrl` attribute — fallback URL for consumers that cannot
  /// resolve [feedGuid] via a directory. Per spec, [feedGuid] should
  /// win when both are present and the consumer can resolve it.
  final String? feedUrl;

  /// `itemGuid` attribute — points at a specific `<item>` within the
  /// remote feed (the value of that item's `<guid>`). Null when the
  /// pointer targets the feed as a whole.
  final String? itemGuid;

  /// `medium` attribute, raw — matches the `<podcast:medium>`
  /// vocabulary including the `L` list-suffix variants. Null when
  /// absent. Use [knownMedium] / [mediumIsList] for ergonomic access.
  final String? medium;

  /// Derived from [medium]. [PodcastMedium.absent] when [medium] is
  /// null; [PodcastMedium.other] when present but unrecognized.
  final PodcastMedium knownMedium;

  /// True iff [medium] carried the `L` list-suffix
  /// (`podcastL`, `musicL`, …). False when [medium] is null.
  final bool mediumIsList;

  /// `title` attribute — display hint provided by the publisher so
  /// apps can render a preview without fetching the remote feed.
  /// Null when absent.
  final String? title;

  /// Creates a new [PodcastRemoteItem].
  const PodcastRemoteItem({
    required this.feedGuid,
    this.feedUrl,
    this.itemGuid,
    this.medium,
    this.knownMedium = PodcastMedium.absent,
    this.mediumIsList = false,
    this.title,
  });
}
