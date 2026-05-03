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

  /// Creates a new empty [PodcastItem]
  PodcastItem();
}
