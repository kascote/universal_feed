import 'package:xml/xml.dart';

import '../../../../universal_feed.dart';
import '../../../shared/shared.dart';

/// An RSS module that supplements the <enclosure> element capabilities of RSS 2.0 to allow for more robust media syndication.
///
/// https://www.rssboard.org/media-rss
class MediaContent {
  /// should specify the direct URL to the media object. If not included, a <media:player> element must be specified.
  String url;

  /// is the number of bytes of the media object. It is an optional attribute.
  String? fileSize;

  /// is the standard MIME type of the object. It is an optional attribute.
  String? type;

  /// is the type of object (image | audio | video | document | executable). While this attribute can at times seem
  /// redundant if type is supplied, it is included because it simplifies decision making on the reader side, as well
  /// as flushes out any ambiguities between MIME type and object type. It is an optional attribute.
  String? medium;

  /// determines if this is the default object that should be used for the <media:group>. There should only be one
  /// default object per <media:group>. It is an optional attribute.
  String? isDefault;

  /// determines if the object is a sample or the full version of the object, or even if it is a continuous stream
  /// (sample | full | nonstop). Default value is "full". It is an optional attribute.
  String? expression;

  /// is the kilobits per second rate of media. It is an optional attribute.
  String? bitrate;

  /// is the number of frames per second for the media object. It is an optional attribute.
  String? framerate;

  /// is the number of samples per second taken to create the media object. It is expressed in thousands of samples
  /// per second (kHz). It is an optional attribute.
  String? samplingrate;

  /// is number of audio channels in the media object. It is an optional attribute.
  String? channels;

  /// is the number of seconds the media object plays. It is an optional attribute.
  String? duration;

  /// is the height of the media object. It is an optional attribute.
  String? height;

  /// is the width of the media object. It is an optional attribute.
  String? width;

  /// is the primary language encapsulated in the media object. Language codes possible are detailed in RFC 3066.
  /// This attribute is used similar to the xml:lang attribute detailed in the XML 1.0 Specification (Third Edition).
  /// It is an optional attribute.
  String? lang;

  /// This allows the permissible audience to be declared. If this element is not included, it assumes that no
  /// restrictions are necessary.
  List<Rating> rating = [];

  /// The title of the particular media object. It
  String? title;

  /// hort description describing the media object typically a sentence in length.
  String? description;

  /// Allows a taxonomy to be set that gives an indication of the type of media content, and its particular contents.
  List<Category> categories = [];

  /// Allows particular images to be used as representative images for the media object.
  List<Image> thumbnails = [];

  /// Allows the media object to be accessed through a web browser media player console.
  Player? player;

  /// Notable entity and the contribution to the creation of the media object.
  List<Credit> credits = [];

  /// <media:content> is a sub-element of either <item> or <media:group>. Media objects that are not the same content
  /// should not be included in the same <media:group> element. The sequence of these items implies the order of
  /// presentation. While many of the attributes appear to be audio/video specific, this element can be used to
  /// publish any type of media. It contains 14 attributes, most of which are optional.
  ///
  /// ref: https://www.rssboard.org/media-rss
  MediaContent(this.url);

  /// Creates a new [MediaContent] object from an [XmlElement]
  factory MediaContent.fromXml(UniversalFeed uf, XmlElement node) {
    final nsUrl = uf.namespaces.nsUrl(nsMediaNs);
    final mc = MediaContent(node.getAttribute('url') ?? '')
      ..fileSize = node.getAttribute('fileSize')
      ..type = node.getAttribute('type')
      ..medium = node.getAttribute('medium')
      ..isDefault = node.getAttribute('isDefault')
      ..expression = node.getAttribute('expression')
      ..bitrate = node.getAttribute('bitrate')
      ..framerate = node.getAttribute('framerate')
      ..samplingrate = node.getAttribute('samplingrate')
      ..channels = node.getAttribute('channels')
      ..duration = node.getAttribute('duration')
      ..height = node.getAttribute('height')
      ..width = node.getAttribute('width')
      ..lang = node.getAttribute('lang');

    getElements<XmlElement>(
      node,
      'rating',
      ns: nsUrl,
      cb: (xml) => mc.rating.add(Rating.fromXml(xml)),
    );

    getElement<XmlElement>(node, 'title', ns: nsUrl, cb: (value) => mc.title = textDecoder('plain', value));
    getElement<XmlElement>(node, 'description', ns: nsUrl, cb: (value) => mc.description = textDecoder('plain', value));
    getElements<XmlElement>(
      node,
      'keywords',
      ns: nsUrl,
      cb: (xml) {
        final categories = Category.loadTags(xml, defaultScheme: 'keyword');
        if (categories != null) mc.categories.addAll(categories);
      },
    );

    getElements<XmlElement>(
      node,
      'category',
      ns: nsUrl,
      cb: (xml) {
        final category = Category.fromXml(xml);
        if (category != null) mc.categories.add(category);
      },
    );

    getElements<XmlElement>(
      node,
      'thumbnail',
      ns: nsUrl,
      cb: (xml) => mc.thumbnails.add(Image.fromXmlAttributes(xml)),
    );

    getElement<XmlElement>(node, 'player', ns: nsUrl, cb: (value) => mc.player = Player.fromXml(value));

    getElement<XmlElement>(
      node,
      'credit',
      ns: nsUrl,
      cb: (xml) => mc.credits.add(Credit.fromXml(xml)),
    );

    return mc;
  }
}
