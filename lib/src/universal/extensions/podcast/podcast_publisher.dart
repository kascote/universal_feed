import 'podcast_remote_item.dart';

/// A `<podcast:publisher>` container from the Podcast Index namespace.
///
/// Channel-level, single-valued (last tag wins on duplicate). Points at
/// the parent "publisher feed" via a single [PodcastRemoteItem]. Per
/// spec the inner remoteItem should carry `medium="publisher"`, but the
/// parser does not enforce it — consumers can inspect
/// [PodcastRemoteItem.medium].
///
/// Spec: https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/publisher.md
class PodcastPublisher {
  /// The single remoteItem pointing at the publisher feed. Always
  /// non-null in a parsed instance — the parser returns `null` (not a
  /// wrapper around nothing) when no valid child remoteItem was found.
  final PodcastRemoteItem remoteItem;

  /// Creates a new [PodcastPublisher].
  const PodcastPublisher({required this.remoteItem});
}
