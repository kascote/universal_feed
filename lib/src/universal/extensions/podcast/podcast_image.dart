/// A `<podcast:image>` entry from the Podcast Index namespace.
///
/// Multi-valued at `<channel>`, `<item>`, and (deferred) `<podcast:liveItem>`
/// level. Each entry advertises an image (or video poster) variant for the
/// show or episode, with optional aspect-ratio / purpose hints so apps can
/// pick the right asset for their UI.
///
/// Replaces the deprecated `<podcast:images srcset>` tag — that older form
/// is **not** parsed by this library.
///
/// Spec: https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/image.md
class PodcastImage {
  /// Asset URL from the `href` attribute. Always non-null in a parsed
  /// instance — elements without `href` are skipped at parse time.
  final String href;

  /// `alt` attribute — accessibility text alternative. Null when absent.
  final String? alt;

  /// `aspect-ratio` attribute — CSS aspect-ratio value (e.g. `1/1`,
  /// `16/9`, `9/16`, `1.85`). Stored raw. Null when absent.
  final String? aspectRatio;

  /// `width` attribute — pixel width as a raw string. Matches the
  /// convention used by `Image.width`. Null when absent.
  final String? width;

  /// `height` attribute — pixel height as a raw string. Null when absent.
  final String? height;

  /// `type` attribute — MIME type of the asset (e.g. `image/jpeg`,
  /// `video/mp4`). Null when absent. Note the spec allows video MIME
  /// types here (poster / canvas usage).
  final String? type;

  /// `purpose` attribute, raw — space-separated case-insensitive token
  /// set as it appeared in the feed. Null when absent. Use
  /// [purposeTokens] for an iterable, lowercased view.
  final String? purpose;

  /// Derived from [purpose]: split on whitespace, lowercased, empties
  /// dropped, source order kept (no dedup). Empty when [purpose] is null.
  /// Common tokens include `artwork`, `social`, `canvas`, `banner`,
  /// `publisher`, `circular`, `poster`; the set is open and apps may
  /// define their own (e.g. `apple/showcase-hero`).
  final List<String> purposeTokens;

  /// Creates a new [PodcastImage].
  const PodcastImage({
    required this.href,
    this.alt,
    this.aspectRatio,
    this.width,
    this.height,
    this.type,
    this.purpose,
    this.purposeTokens = const [],
  });
}
