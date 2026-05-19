import 'podcast_value_recipient.dart';
import 'podcast_value_time_split.dart';

/// A `<podcast:value>` block from the Podcast Index namespace.
///
/// Channel- or item-scoped. The per-tag doc lists cardinality as
/// `Multiple`, so `PodcastChannel.values` / `PodcastItem.values` hold a
/// list (source order preserved). Most real-world feeds emit a single
/// block; multi-scheme feeds may emit several (`type="lightning"` +
/// `type="webmonetization"`).
///
/// Declares a Podcasting-2.0 value-for-value payment configuration:
/// payment scheme ([type] / [method]), an optional [suggested] amount,
/// the [recipients] to be paid, and optional [timeSplits] that re-route
/// payments during specific playback windows.
///
/// Per spec the block is item-scoped via item-level "override";
/// channel-level acts as the default. The two surfaces
/// (`PodcastChannel.values` and `PodcastItem.values`) stay independent
/// — override resolution is the consumer's call. Matches the existing
/// `chat` precedent.
///
/// Spec: https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/value.md
///
/// Companion proposal (recommended reading for semantics of
/// `suggested`, fee handling, multi-scheme support, etc.):
/// https://github.com/Podcastindex-org/podcast-namespace/blob/main/proposal-docs/value/value.md
class PodcastValue {
  /// Payment scheme — `lightning`, `hive`, `webmonetization`, …
  /// Always non-null in a parsed instance; blocks missing `type` are
  /// skipped at parse time. Stored raw; not validated.
  final String type;

  /// Per-scheme method — `keysend` (for lightning), `amp` (for hive),
  /// … Always non-null in a parsed instance; blocks missing `method`
  /// are skipped at parse time. Stored raw; not validated.
  final String method;

  /// Suggested amount of [type]'s base unit, per minute. Float in
  /// spec (e.g. `0.00000005000` BTC). Stored raw. Null when absent.
  final String? suggested;

  /// Recipients to be paid, in source order. Empty when no valid
  /// `<podcast:valueRecipient>` was present at this level (a block
  /// may still be useful for scheme/method discovery — see spec).
  /// Note: `<podcast:valueTimeSplit>` may override this list during
  /// specific windows; see [timeSplits].
  final List<PodcastValueRecipient> recipients;

  /// Time-based payment-routing overrides, in source order. Empty
  /// when absent. Spec ties semantics to playback time (item-scoped),
  /// but the parser captures them on channel-level blocks too —
  /// consumers may ignore for irrelevant scopes.
  final List<PodcastValueTimeSplit> timeSplits;

  /// Creates a new [PodcastValue].
  const PodcastValue({
    required this.type,
    required this.method,
    this.suggested,
    this.recipients = const [],
    this.timeSplits = const [],
  });
}
