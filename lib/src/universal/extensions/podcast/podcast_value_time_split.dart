import 'podcast_remote_item.dart';
import 'podcast_value.dart';
import 'podcast_value_recipient.dart';

/// A `<podcast:valueTimeSplit>` child of [PodcastValue].
///
/// Reroutes payments during a specific playback window — either to a
/// different recipient list ([recipients]) or to the value block of a
/// remote feed/item ([remoteItem]). Both [startTime] and [duration]
/// are required by spec; the parser returns `null` (skip) when either
/// is missing.
///
/// Spec: https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/value-time-split.md
class PodcastValueTimeSplit {
  /// Seconds offset (from start of episode) at which this window
  /// begins. Spec allows floats. Always non-null in a parsed instance.
  final String startTime;

  /// Length of the window in seconds. Spec allows floats. Always
  /// non-null in a parsed instance.
  final String duration;

  /// Offset within [remoteItem] at which replay/payout should begin.
  /// Meaningful only when [remoteItem] is non-null. Null when absent —
  /// per spec the implied default is `0`, but the parser does not
  /// synthesize defaults so consumers can distinguish absent from
  /// explicitly zero.
  final String? remoteStartTime;

  /// Fraction (0–100, integer per spec) of payment routed to
  /// [remoteItem]'s recipients during this window; the remainder goes
  /// to the parent [PodcastValue.recipients]. Meaningful only when
  /// [remoteItem] is non-null. Null when absent — per spec the implied
  /// default is `100` and out-of-range values are clamped to [0, 100];
  /// the parser stores raw (no clamp) and consumers apply defaults.
  final String? remotePercentage;

  /// Override recipient list for this window, in source order. Empty
  /// when no `<podcast:valueRecipient>` children were present (or all
  /// were invalid). May coexist with [remoteItem] (spec says they're
  /// exclusive; parser captures both liberally — consumer decides
  /// precedence).
  final List<PodcastValueRecipient> recipients;

  /// Pointer to a remote feed/item whose `<podcast:value>` block
  /// should govern this window. First valid `<podcast:remoteItem>`
  /// child wins on duplicate. Null when absent or invalid.
  final PodcastRemoteItem? remoteItem;

  /// Creates a new [PodcastValueTimeSplit].
  const PodcastValueTimeSplit({
    required this.startTime,
    required this.duration,
    this.remoteStartTime,
    this.remotePercentage,
    this.recipients = const [],
    this.remoteItem,
  });
}
