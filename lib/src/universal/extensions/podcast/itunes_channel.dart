import '../../../../universal_feed.dart';

/// Itunes Channel information
class ItunesChannel {
  /// The artwork for the show. **Only**  the url field will be valid.
  Image? image;

  /// The podcast parental advisory information.
  String? explicit;

  /// The group responsible for creating the show.
  String? author;

  /// The podcast owner contact information.
  Author? owner;

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

  /// The show category information.
  /// if exists, category and subcategory will be the first and second elements on the list
  /// if the entry has 'keywords', they will be added here to with the scheme 'keyword'
  List<Category> categories = [];

  /// Creates a new empty [ItunesChannel]
  ItunesChannel();
}
