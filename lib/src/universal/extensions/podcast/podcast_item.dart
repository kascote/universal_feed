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

  /// The episode's season number.
  String? season;

  /// The episode's type.
  String? episodeType;

  /// The episode show or hide status.
  String? block;

  /// Short episode's description
  String? summary;

  /// Free-form `<podcast:txt>` entries from the Podcast Index namespace.
  /// Preserves source order.
  List<PodcastTxt> txts = [];

  /// Creates a new empty [PodcastItem]
  PodcastItem();
}
