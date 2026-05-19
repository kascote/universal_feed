import 'podcast_value.dart';
import 'podcast_value_time_split.dart';

/// A `<podcast:valueRecipient>` child of [PodcastValue] or
/// [PodcastValueTimeSplit].
///
/// Names one party to be paid (or have a fee deducted) as part of a
/// Podcasting-2.0 value-for-value payment. All three of [type],
/// [address], and [split] are required by spec — the parser returns
/// `null` (skip) when any is missing or empty.
///
/// Spec: https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/value-recipient.md
class PodcastValueRecipient {
  /// Free-text identifier for the recipient. Display hint. Null when
  /// absent.
  final String? name;

  /// Address kind — `node` (lightning), `lnaddress`, `ethereum`, …
  /// Always non-null in a parsed instance — entries missing `type` are
  /// skipped at parse time. Stored raw; not validated.
  final String type;

  /// Destination address (lightning pubkey, hive account, …). Always
  /// non-null in a parsed instance — entries missing `address` are
  /// skipped at parse time.
  final String address;

  /// Share weight (integer per spec; raw string here for liberal
  /// parsing — some feeds emit decimals). Always non-null in a parsed
  /// instance — entries missing `split` are skipped at parse time.
  /// Consumers should treat the sum across recipients as a relative
  /// weight, not a strict percentage.
  final String split;

  /// Routing identifier paired with [customValue] (e.g. lightning
  /// keysend custom record). Null when absent.
  final String? customKey;

  /// Companion to [customKey]. Captured even when [customKey] is
  /// absent (liberal). Null when absent.
  final String? customValue;

  /// Whether this entry is a service fee rather than a content-creator
  /// payout. `null` when the attribute was absent — per spec, that
  /// means false; the resolution is the consumer's call.
  final bool? fee;

  /// Creates a new [PodcastValueRecipient].
  const PodcastValueRecipient({
    required this.type,
    required this.address,
    required this.split,
    this.name,
    this.customKey,
    this.customValue,
    this.fee,
  });
}
