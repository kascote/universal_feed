/// Represents a single `<podcast:funding>` entry from the Podcast Index namespace.
///
/// Multiple entries are allowed per channel — one per funding platform/source.
/// Spec: https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#funding
class PodcastFunding {
  /// URL to the funding page.
  final String? url;

  /// Human-readable call-to-action label (the element body). Null when absent.
  final String? text;

  /// Creates a new [PodcastFunding].
  PodcastFunding({this.url, this.text});
}
