/// A `<podcast:contentLink>` child of an `<item>` or `<podcast:liveItem>`
/// from the Podcast Index namespace.
///
/// Points at external content as a fallback for apps that can't render
/// the parent element directly — most commonly a web page that plays a
/// live stream when the host app doesn't support
/// `<podcast:alternateEnclosure>`. Per spec, multiple are allowed (e.g.
/// one YouTube, one Twitch, one HTML fallback).
///
/// [href] is required by spec — entries missing or empty are skipped at
/// parse time, so any parsed instance has a non-empty [href]. [text] is
/// optional — `null` when absent or empty.
///
/// Spec: https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/content-link.md
class PodcastContentLink {
  /// External URI. Always non-empty in a parsed instance.
  final String href;

  /// Free-form display text describing the link. Null when the element
  /// body was absent or empty.
  final String? text;

  /// Creates a new [PodcastContentLink].
  const PodcastContentLink({required this.href, this.text});
}
