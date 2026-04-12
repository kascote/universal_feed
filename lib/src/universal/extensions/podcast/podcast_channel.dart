import '../../../../universal_feed.dart';

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

  /// Holds category information. Top-level `itunes:category` elements.
  /// Subcategories, when present, are available via [Category.children].
  /// If the entry has `itunes:keywords`, they are also appended here with
  /// `scheme: 'keyword'`.
  List<Category> categories = [];

  /// Free-form `<podcast:txt>` entries from the Podcast Index namespace.
  /// Preserves source order. Known purposes include `verify`,
  /// `applepodcastsverify`, `ai-content` — see the spec.
  List<PodcastTxt> txts = [];

  /// Creates a new empty [PodcastChannel]
  PodcastChannel();
}
