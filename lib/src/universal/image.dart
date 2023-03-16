import 'package:xml/xml.dart';

import './shared.dart';

/// Container to hold an Image reference
class UniversalImage {
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

  /// Creates a new [UniversalImage] object from an url
  UniversalImage(this.url);

  /// Creates a new [UniversalImage] object from an [XmlElement]
  factory UniversalImage.fromXML(XmlElement node) {
    final img = UniversalImage(node.getElement('url')?.text ?? '');
    getElement<String>(node, 'title', cb: (value) => img.title = value);
    getElement<String>(node, 'link', cb: (value) => img.link = value);
    getElement<String>(node, 'width', cb: (value) => img.width = value);
    getElement<String>(node, 'height', cb: (value) => img.height = value);
    getElement<String>(node, 'description', cb: (value) => img.description = value);

    return img;
  }
}
