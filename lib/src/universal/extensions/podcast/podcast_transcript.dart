/// Recognized transcript mime types for `<podcast:transcript>`.
///
/// The Podcast Index spec lists mime types as an open set ("such as"),
/// so [other] is the catch-all for present-but-unrecognized values and
/// [absent] for missing/empty. The split lets consumers run an
/// exhaustive `switch` while still distinguishing the two states for
/// debug/feed-quality use cases.
///
/// Mapping (case-insensitive, trimmed):
///   - `text/vtt` → [vtt]
///   - `text/plain` → [plain]
///   - `text/html` → [html]
///   - `application/json` → [json]
///   - `application/srt` → [srt]
///   - `application/x-subrip` → [subrip]
///   - any other non-empty string → [other]
///   - null or empty after trim → [absent]
///
/// `srt` and `subrip` are kept separate because the spec lists both
/// mime types and both appear in the wild; consumers wanting uniform
/// handling can match both arms.
enum PodcastTranscriptType {
  /// `text/vtt`
  vtt,

  /// `application/srt`
  srt,

  /// `application/x-subrip`
  subrip,

  /// `application/json`
  json,

  /// `text/html`
  html,

  /// `text/plain`
  plain,

  /// Mime type was present but not recognized.
  other,

  /// Mime type attribute was missing or empty.
  absent,
}

/// Represents a `<podcast:transcript>` entry from the Podcast Index
/// namespace.
///
/// Points to an external transcript or closed-caption file for an
/// episode. Multiple entries per item are normal — feeds may publish
/// the same episode in several formats and/or languages. Spec:
/// https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/transcript.md
///
/// `url` and `type` are marked required by the spec; this library
/// parses liberally and exposes them as nullable.
class PodcastTranscript {
  /// URL of the transcript file.
  final String? url;

  /// Raw mime-type string from the feed. Never lossy — see
  /// [knownType] for the recognized-variant view.
  final String? type;

  /// Ergonomic enum view of [type]. Gives an exhaustive state
  /// machine: a recognized mime type, [PodcastTranscriptType.other]
  /// (present but unknown), or [PodcastTranscriptType.absent]
  /// (missing).
  final PodcastTranscriptType knownType;

  /// Transcript language. When absent, the transcript is assumed to
  /// match the feed's `<language>` (consumer-side interpretation).
  final String? language;

  /// Optional `rel` attribute. If `rel="captions"` the file is a
  /// closed-captions file regardless of mime type, and timecodes are
  /// assumed present. Interpretation is consumer-side; not enforced
  /// by the parser.
  final String? rel;

  /// Creates a new [PodcastTranscript].
  PodcastTranscript({
    this.url,
    this.type,
    this.knownType = PodcastTranscriptType.absent,
    this.language,
    this.rel,
  });
}
