import 'package:xml/xml.dart';

import '../../src/shared.dart';

/// Container to hold an Image reference
class Image {
  /// URL to the image
  String url;

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

  /// Creates a new [Image] object from an url
  Image(this.url);

  /// Creates a new [Image] object from an [XmlElement]
  factory Image.fromXML(XmlElement node) {
    final img = Image(node.getElement('url')?.text ?? '');
    getElement<String>(node, 'title', cb: (value) => img.title = value);
    getElement<String>(node, 'link', cb: (value) => img.link = value);
    getElement<String>(node, 'width', cb: (value) => img.width = value);
    getElement<String>(node, 'height', cb: (value) => img.height = value);
    getElement<String>(node, 'description', cb: (value) => img.description = value);

    return img;
  }

  /// Creates a new [Image] from the [XmlElement] attributes
  factory Image.loadFromAttributes(XmlElement node) {
    final img = Image(node.getAttribute('url') ?? '');
    getAttribute(node, 'width', cb: (value) => img.width = value);
    getAttribute(node, 'height', cb: (value) => img.height = value);
    return img;
  }

  @override
  String toString() {
    final sb = StringBuffer()
      ..writeln('Image')
      ..writeln('\turl: $url');
    if (title != null) sb.writeln('\ttitle: $title');
    if (link != null) sb.writeln('\tlink: $link');
    if (width != null) sb.writeln('\twidth: $width');
    if (height != null) sb.writeln('\theight: $height');
    if (description != null) sb.writeln('\tdescription: $description');
    return sb.toString();
  }
}
