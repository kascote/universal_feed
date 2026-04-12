/// Represents a `<podcast:chapters>` entry from the Podcast Index namespace.
///
/// Points to an external sidecar file (typically JSON) containing chapter
/// data for an episode. Spec:
/// https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/chapters.md
///
/// Both attributes are marked required by the spec; this library parses
/// liberally and exposes them as nullable.
class PodcastChapters {
  /// URL where the chapters file is located.
  final String? url;

  /// Mime type of the chapters file (JSON preferred,
  /// `application/json+chapters`).
  final String? type;

  /// Creates a new [PodcastChapters]
  PodcastChapters({this.url, this.type});
}
