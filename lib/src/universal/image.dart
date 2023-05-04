import 'package:xml/xml.dart';

import '../shared/shared.dart';

/// Information related to an image attached to an entry or feed.
class Image {
  /// URL to the image
  final String url;

  /// Image's title
  String? title;

  /// Link pointing to the image
  String? link;

  /// Image's width
  String? width;

  /// Image's height
  String? height;

  /// Image's description
  String? description;

  /// Specifies the time offset in relation to the media object.
  String? time;

  /// Creates a new [Image] object from an url
  Image(this.url);

  /// Creates a new [Image] object from an [XmlElement]
  factory Image.fromXml(XmlElement node) {
    final img = Image(node.getElement('url')?.text ?? '');
    getElement<String>(node, 'title', cb: (value) => img.title = value);
    getElement<String>(node, 'link', cb: (value) => img.link = value);
    getElement<String>(node, 'width', cb: (value) => img.width = value);
    getElement<String>(node, 'height', cb: (value) => img.height = value);
    getElement<String>(node, 'description', cb: (value) => img.description = value);

    return img;
  }

  /// Creates a new [Image] object from an [XmlElement] but using the
  /// attributes instead of the child elements (RSS Media)
  factory Image.fromXmlAttributes(XmlElement node) {
    final img = Image(node.getAttribute('url') ?? '')
      ..width = node.getAttribute('width')
      ..height = node.getAttribute('height')
      ..time = node.getAttribute('time');

    return img;
  }

  @override
  String toString() {
    return 'UniversalImage: url=$url, title=$title, link=$link, width=$width, height=$height, description=$description';
  }
}
