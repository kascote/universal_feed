import 'package:xml/xml.dart';

import '../../../../universal_feed.dart';
import '../../../shared/shared.dart';

/// An RSS module that supplements the `<enclosure>` element capabilities of RSS
/// 2.0 to allow for more robust media syndication.
///
/// RSS enclosures are already being used to syndicate audio files
/// and images. Media RSS extends enclosures to handle other media types, such
/// as short films or TV, as well as provide additional metadata with the media.
/// Media RSS enables content publishers and bloggers to syndicate multimedia
/// content such as TV and video clips, movies, images and audio.
///
/// ref: https://www.rssboard.org/media-rss
class Media {
  Media._();

  /// `<media:group>` is a sub-element of `<item>`. It allows grouping of `<media:content>`
  /// elements that are effectively the same content, yet different representations.
  ///
  /// ref: https://www.rssboard.org/media-rss#media-group
  List<Media> group = [];

  /// `<media:content>` is a sub-element of either `<item>` or `<media:group>`.
  /// Media objects that are not the same content should not be included in the same `<media:group>` element.
  ///
  /// ref: https://www.rssboard.org/media-rss#media-content
  List<MediaContent> content = [];

  /// List of Rating elements
  ///
  /// ref: https://www.rssboard.org/media-rss#media-rating
  List<Rating> rating = [];

  /// The title of the particular media object.
  ///
  /// ref: https://www.rssboard.org/media-rss#media-title
  String? title;

  /// Short description describing the media object typically a sentence in length.
  ///
  /// ref: https://www.rssboard.org/media-rss#media-description
  String? description;

  /// List of assigned categories
  ///
  /// ref: https://www.rssboard.org/media-rss#media-category
  List<Category> categories = [];

  /// List of assigned images
  ///
  /// ref: https://www.rssboard.org/media-rss#media-thumbnails
  List<Image> thumbnails = [];

  /// Credits related to the object
  ///
  /// ref: https://www.rssboard.org/media-rss#media-credit
  List<Credit> credits = [];

  /// Allows the media object to be accessed through a web browser media player console.
  ///
  /// ref: https://www.rssboard.org/media-rss#media-player
  Player? player;

  /// Creates a new [Media] object from an [XmlElement]
  factory Media.contentFromXml(UniversalFeed uf, XmlElement node) {
    final nsUrl = uf.meta.extensions.nsUrl(nsMediaNs);

    final media = Media._();

    getElements<XmlElement>(
      node,
      'content',
      ns: nsUrl,
      cb: (xml) => media.content.add(MediaContent.fromXml(uf, xml)),
    );

    getElements<XmlElement>(
      node,
      'group',
      ns: nsUrl,
      cb: (group) {
        media.group.add(Media.contentFromXml(uf, group));
      },
    );

    getElement<XmlElement>(node, 'title', ns: nsUrl, cb: (value) => media.title = textDecoder('plain', value));
    getElement<XmlElement>(
      node,
      'description',
      ns: nsUrl,
      cb: (value) => media.description = textDecoder('plain', value),
    );

    getElements<XmlElement>(
      node,
      'rating',
      ns: nsUrl,
      cb: (xml) {
        media.rating.add(Rating.fromXml(xml));
      },
    );

    getElements<XmlElement>(
      node,
      'keywords',
      ns: nsUrl,
      cb: (xml) {
        final keywords = Category.loadTags(xml, defaultScheme: 'keyword');
        if (keywords != null) media.categories.addAll(keywords);
      },
    );

    getElements<XmlElement>(
      node,
      'category',
      ns: nsUrl,
      cb: (xml) {
        final category = Category.fromXml(xml);
        if (category != null) media.categories.add(category);
      },
    );

    getElements<XmlElement>(
      node,
      'thumbnail',
      ns: nsUrl,
      cb: (xml) => media.thumbnails.add(Image.fromXmlAttributes(xml)),
    );

    getElement<XmlElement>(node, 'player', ns: nsUrl, cb: (value) => media.player = Player.fromXml(value));

    getElements<XmlElement>(
      node,
      'credit',
      ns: nsUrl,
      cb: (xml) => media.credits.add(Credit.fromXml(xml)),
    );

    return media;
  }
}
