import 'package:xml/xml.dart';

import '../../../src/shared.dart';
import '../../../src/universal_feed_base.dart';

/// An RSS module that supplements the <enclosure> element capabilities of RSS 2.0 to allow for more robust media syndication.
class MediaRss {
  /// <media:group> is a sub-element of <item>. It allows grouping of <media:content>
  /// elements that are effectively the same content, yet different representations.
  List<MediaContent>? group;

  /// <media:content> is a sub-element of either <item> or <media:group>.
  /// Media objects that are not the same content should not be included in the same <media:group> element.
  List<MediaContent>? content;

  /// List of Rating elements
  List<Rating>? rating;

  /// The title of the particular media object.
  TextContent? title;

  /// Short description describing the media object typically a sentence in length.
  TextContent? description;

  /// List of assigned categories
  List<Category>? categories;

  /// List of assigned images
  List<Image>? thumbnails;

  /// Credits related to the object
  List<Credit>? credits;

  /// Allows the media object to be accessed through a web browser media player console.
  Player? player;

  /// Creates a new [MediaRss] object from an [XmlElement]
  factory MediaRss.contentFromXml(RSS rss, XmlElement node) {
    final nsUrl = rss.namespaces.nsUrl(nsMediaNs);
    final m = MediaRss._()
      ..content = getListFromNodes<MediaContent>(
        node,
        'content',
        ns: nsUrl,
        cb: (value) => MediaContent.fromXml(rss, value),
      );

    getListFromElementList<MediaContent>(
      node,
      'group',
      ns: nsUrl,
      start: [],
      generator: (value) => getListFromNodes<MediaContent>(
        value,
        'content',
        ns: nsUrl,
        cb: (xml) => MediaContent.fromXml(rss, xml),
      )!,
      storage: (list) => m.group = list,
    );

    m.rating = getListFromNodes(node, 'rating', ns: nsUrl, cb: Rating.fromXml);
    getElement<XmlElement>(node, 'title', ns: nsUrl, cb: (value) => m.title = TextContent(value));

    getElement<XmlElement>(node, 'description', ns: nsUrl, cb: (value) => m.description = TextContent(value));
    getListFromElementList<Category>(
      node,
      'keywords',
      ns: nsUrl,
      start: m.categories ?? [],
      generator: (xml) => Category.loadTags(xml, defaulScheme: 'keyword'),
      storage: (list) => m.categories = list,
    );
    getListFromXmlList<Category>(
      node,
      'category',
      ns: nsUrl,
      start: m.categories ?? [],
      generator: Category.fromXML,
      storage: (list) => m.categories = list,
    );
    getListFromXmlList<Image>(
      node,
      'thumbnail',
      ns: nsUrl,
      start: m.thumbnails ?? [],
      generator: Image.loadFromAttributes,
      storage: (list) => m.thumbnails = list,
    );
    getElement<XmlElement>(node, 'player', ns: nsUrl, cb: (value) => m.player = Player.fromXml(value));

    getListFromXmlList<Credit>(
      node,
      'credit',
      ns: nsUrl,
      start: m.credits ?? [],
      generator: Credit.fromXml,
      storage: (list) => m.credits = list,
    );

    return m;
  }

  MediaRss._();
}
