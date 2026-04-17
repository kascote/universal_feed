import '../../../../universal_feed.dart';

/// Recognized medium tokens for `<podcast:medium>`.
///
/// The Podcast Index vocabulary is documented as a growing closed set;
/// [other] is the catch-all for present-but-unrecognized values and
/// [absent] for a missing or empty tag. The split lets consumers run an
/// exhaustive `switch` while distinguishing the two states for debug/feed-
/// quality use cases.
///
/// List-ness (the `L`-suffix variants such as `podcastL`, `musicL`, …) is
/// exposed separately via [PodcastChannel.mediumIsList] rather than as a
/// duplicated set of enum cases — this keeps the switch small and exhaustive
/// for consumers who don't care about list-ness. [PodcastChannel.mediumIsList]
/// is set whenever the raw body ends with a literal `L`, including for
/// unrecognized base tokens, because the `L` suffix is a routing signal
/// independent of whether the base token is known.
///
/// Matching is case-insensitive on the base token (after stripping the
/// trailing `L` when present). Spec:
/// https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#medium
enum PodcastMedium {
  /// Audio podcast content.
  podcast,

  /// Music tracks.
  music,

  /// Video content.
  video,

  /// Film content.
  film,

  /// Audiobook content.
  audiobook,

  /// Newsletter content.
  newsletter,

  /// Blog content.
  blog,

  /// Publisher-of-feeds (carries remote-item references).
  publisher,

  /// Course content.
  course,

  /// Mixed medium (multiple content types).
  mixed,

  /// Medium token was present but not recognized (new spec value, typo,
  /// or junk). Useful for logging.
  other,

  /// `<podcast:medium>` tag was absent or its body was empty.
  absent,
}

/// Unified channel-level podcast metadata.
///
/// Populated from the iTunes vocabulary (`xmlns:itunes`) and/or the
/// Podcast Index vocabulary (`xmlns:podcast`,
/// `https://podcastindex.org/namespace/1.0`). The two namespaces describe
/// the same concept and both feed this single model.
class PodcastChannel {
  /// The artwork for the show. **Only**  the url field will be valid.
  Image? image;

  /// The podcast parental advisory information.
  String? explicit;

  /// The show title specific for Apple Podcasts.
  String? title;

  /// The type of show.
  String? type;

  /// The new podcast RSS Feed URL.
  String? newFeedUrl;

  /// The podcast show or hide status.
  String? block;

  /// The podcast update status.
  String? complete;

  /// Little description about the channel
  String? summary;

  /// Holds category information. Top-level `itunes:category` elements.
  /// Subcategories, when present, are available via [Category.children].
  /// If the entry has `itunes:keywords`, they are also appended here with
  /// `scheme: 'keyword'`.
  List<Category> categories = [];

  /// Free-form `<podcast:txt>` entries from the Podcast Index namespace.
  /// Preserves source order. Known purposes include `verify`,
  /// `applepodcastsverify`, `ai-content` — see the spec.
  List<PodcastTxt> txts = [];

  /// Globally unique feed identifier from `<podcast:guid>` (Podcast Index
  /// namespace). UUIDv5 per spec but parsed liberally as a raw string.
  /// Null when absent. See
  /// https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#guid
  String? guid;

  /// Raw `<podcast:medium>` body as it appeared in the feed (e.g. `podcast`,
  /// `musicL`), trimmed. Null when absent. Prefer [knownMedium] for an
  /// ergonomic switch.
  String? medium;

  /// Ergonomic enum derived from [medium]. [PodcastMedium.other] when the feed
  /// declared a medium we don't recognize, [PodcastMedium.absent] when the tag
  /// was missing or empty.
  PodcastMedium knownMedium = PodcastMedium.absent;

  /// True iff the feed declared a list variant (`podcastL`, `musicL`, …),
  /// meaning the channel carries `<podcast:remoteItem>` children rather than
  /// `<item>`s. Only set when the base token was recognized.
  bool mediumIsList = false;

  /// Whether this feed publishes via Podping for real-time update notifications.
  /// Derived from the `usesPodping` attribute of `<podcast:podping>`.
  /// Null when the tag is absent or the attribute is not a recognized boolean.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#podping
  bool? podpingUsesPodping;

  /// Whether this feed is locked against import by other directories.
  /// `true` = `yes`, `false` = `no`. Null when the tag is absent or the body
  /// is not a recognized `yes`/`no` value.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#locked
  bool? locked;

  /// Optional contact email of the feed owner from the `owner` attribute of
  /// `<podcast:locked>`. Null when the attribute is absent.
  String? lockedOwner;

  /// Creates a new empty [PodcastChannel]
  PodcastChannel();
}
