import '../../../../universal_feed.dart';

/// Unified item-level podcast metadata.
///
/// Populated from the iTunes vocabulary (`xmlns:itunes`) and/or the
/// Podcast Index vocabulary (`xmlns:podcast`). Both namespaces feed this
/// single model.
class PodcastItem {
  /// The duration of an episode.
  String? duration;

  /// The episode artwork.
  Image? image;

  /// The episode parental advisory information.
  String? explicit;

  /// An episode title specific for Apple Podcasts.
  String? title;

  /// An episode number.
  String? episode;

  /// Display string for the episode number (from `podcast:episode display` attr).
  String? episodeDisplay;

  /// The episode's season number.
  String? season;

  /// Display name for the season (from `podcast:season name` attr).
  String? seasonName;

  /// The episode's type.
  String? episodeType;

  /// The episode show or hide status.
  String? block;

  /// Short episode's description
  String? summary;

  /// Free-form `<podcast:txt>` entries from the Podcast Index namespace.
  /// Preserves source order.
  List<PodcastTxt> txts = [];

  /// Link to an external chapters file from `<podcast:chapters>`.
  /// Null when absent.
  PodcastChapters? chapters;

  /// Transcript/closed-caption files from `<podcast:transcript>`.
  /// Source order preserved. Empty when absent. See
  /// [PodcastTranscript] for attribute details.
  List<PodcastTranscript> transcripts = [];

  /// License from `<podcast:license>` (Podcast Index namespace).
  /// Null when absent. Last tag wins on duplicate.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#license
  PodcastLicense? license;

  /// Persons associated with this episode from `<podcast:person>` (Podcast
  /// Index namespace). Preserves source order. Empty when absent. Each
  /// entry has a non-empty [PodcastPerson.name]; elements without a body
  /// are skipped at parse time. Per spec, these override channel-level
  /// persons (see [PodcastChannel.persons]) for this episode.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#person
  List<PodcastPerson> persons = [];

  /// Locations associated with this episode from `<podcast:location>`
  /// (Podcast Index namespace). Preserves source order. Empty when
  /// absent. Multiple entries are valid (e.g. `rel="creator"` +
  /// `rel="subject"`). Per spec, item-level locations override
  /// channel-level for this episode — override semantics are left to
  /// the consumer (the two lists stay independent).
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/location.md
  List<PodcastLocation> locations = [];

  /// Soundbites from `<podcast:soundbite>` (Podcast Index namespace).
  /// Preserves source order. Empty when absent. Each entry has non-empty
  /// [PodcastSoundbite.startTime] and [PodcastSoundbite.duration];
  /// elements missing either are skipped at parse time.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/soundbite.md
  List<PodcastSoundbite> soundbites = [];

  /// Social-interaction entries from `<podcast:socialInteract>` (Podcast
  /// Index namespace). Preserves source order. Empty when absent. Each
  /// entry has a non-empty [PodcastSocialInteract.protocol]; entries
  /// without it — or without `uri` when `protocol != "disabled"` — are
  /// skipped at parse time.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/socialInteract.md
  List<PodcastSocialInteract> socialInteracts = [];

  /// Chat server from `<podcast:chat>` (Podcast Index namespace) at
  /// item level. Null when absent. Last tag wins on duplicate. Per
  /// spec, this overrides [PodcastChannel.chat] for this episode —
  /// override resolution is the consumer's call.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/chat.md
  PodcastChat? chat;

  /// Rich image variants from `<podcast:image>` (Podcast Index namespace)
  /// scoped to this episode. Preserves source order. Empty when absent.
  /// Each entry has a non-empty [PodcastImage.href]; elements without
  /// one are skipped at parse time. Distinct from [image] (singular,
  /// populated from `itunes:image`) — kept separate, no back-fill. Per
  /// spec, item-level entries override channel-level for this episode;
  /// override resolution is the consumer's call. The deprecated
  /// `<podcast:images>` / srcset form is not parsed.
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/image.md
  List<PodcastImage> images = [];

  /// Alternate media variants from `<podcast:alternateEnclosure>`
  /// (Podcast Index namespace). Preserves source order. Empty when
  /// absent. Each entry has a non-empty
  /// [PodcastAlternateEnclosure.sources]; wrappers without any valid
  /// `<podcast:source>` child are skipped at parse time. Distinct from
  /// the standard RSS [Item.enclosures] surface — kept separate (no
  /// back-fill, no merge).
  /// See https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/alternate-enclosure.md
  List<PodcastAlternateEnclosure> alternateEnclosures = [];

  /// Creates a new empty [PodcastItem]
  PodcastItem();
}
