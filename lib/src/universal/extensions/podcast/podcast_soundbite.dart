/// A `<podcast:soundbite>` entry from the Podcast Index namespace.
///
/// Item-level, multi-valued. Marks a notable clip inside the episode by
/// `startTime` + `duration` (both seconds). Spec:
/// https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/soundbite.md
class PodcastSoundbite {
  /// `startTime` attribute — offset from start of episode, in seconds
  /// (float in spec examples). Stored raw to keep parsing liberal;
  /// matches `PodcastItem.duration` and `Enclosure.length`. Always
  /// non-null in a parsed instance — the parser skips entries without it.
  final String startTime;

  /// `duration` attribute — soundbite length in seconds (float in spec
  /// examples; spec recommends 15–120s, not a hard cap). Stored raw.
  /// Always non-null in a parsed instance.
  final String duration;

  /// Optional title (element body, trimmed). Null when the body was
  /// empty — per spec, an empty body is the prescribed signal for "no
  /// title; consumer may substitute the episode title". Spec recommends
  /// ≤128 chars; not enforced here.
  final String? title;

  /// Creates a new [PodcastSoundbite].
  const PodcastSoundbite({
    required this.startTime,
    required this.duration,
    this.title,
  });
}
