/// Represents a `<podcast:txt>` entry from the Podcast Index namespace.
///
/// Free-form text container used for a variety of purposes — for example
/// `verify`, `applepodcastsverify`, or `ai-content`. Spec:
/// https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/txt.md
class PodcastTxt {
  /// Optional purpose attribute identifying the kind of text entry.
  final String? purpose;

  /// The free-form text value of the entry.
  final String value;

  /// Creates a new [PodcastTxt]
  PodcastTxt({required this.value, this.purpose});
}
