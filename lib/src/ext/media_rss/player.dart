import 'package:xml/xml.dart';

/// Allows the media object to be accessed through a web browser media player console.
class Player {
  /// is the URL of the player console that plays the media.
  String url;

  /// is the width of the browser window that the URL should be opened in.
  String? width;

  /// is the height of the browser window that the URL should be opened in.
  String? height;

  /// Creates a new [Player] object
  Player(this.url);

  /// Creates a new [Player] object from an [XmlElement]
  factory Player.fromXml(XmlElement node) {
    return Player(node.getAttribute('url') ?? '')
      ..width = node.getAttribute('width')
      ..height = node.getAttribute('height');
  }

  @override
  String toString() {
    return '$url [$width x $height]';
  }
}
