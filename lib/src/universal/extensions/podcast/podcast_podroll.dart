import 'podcast_remote_item.dart';

/// A `<podcast:podroll>` container from the Podcast Index namespace.
///
/// Channel-level, single-valued (last tag wins on duplicate). Carries
/// "you might also like" recommendations as one or more
/// [PodcastRemoteItem] children pointing at other feeds.
///
/// Spec: https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/podroll.md
class PodcastPodroll {
  /// The recommended feeds, in source order. Always non-empty in a
  /// parsed instance — the parser returns `null` (not an empty wrapper)
  /// when every child remoteItem was invalid.
  final List<PodcastRemoteItem> items;

  /// Creates a new [PodcastPodroll].
  const PodcastPodroll({required this.items});
}
