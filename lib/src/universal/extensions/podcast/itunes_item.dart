import '../../../../universal_feed.dart';

/// Singe Itunes item
class ItunesItem {
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

  /// Creates a new empty [ItunesItem]
  ItunesItem();
}
