import 'package:xml/xml.dart';

import '../../../src/shared.dart';
import '../../../src/universal_feed_base.dart';

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

  /// Creates an [ItunesItem] from an [XmlElement]
  factory ItunesItem.fromXml(RSS rss, XmlElement node) {
    final nsUrl = rss.namespaces.nsUrl(nsItunesNs);
    final ii = ItunesItem._()
      ..duration = node.getElement('duration', namespace: nsUrl)?.text.trim()
      ..explicit = node.getElement('explicit', namespace: nsUrl)?.text.trim()
      ..title = node.getElement('title', namespace: nsUrl)?.text.trim()
      ..episode = node.getElement('episode', namespace: nsUrl)?.text.trim()
      ..season = node.getElement('season', namespace: nsUrl)?.text.trim()
      ..episodeType = node.getElement('episodeType', namespace: nsUrl)?.text.trim()
      ..block = node.getElement('block', namespace: nsUrl)?.text.trim()
      ..summary = node.getElement('summary', namespace: nsUrl)?.text.trim();
    getElement<XmlElement>(
      node,
      'image',
      ns: nsUrl,
      cb: (value) {
        final url = value.getAttribute('href') ?? value.getAttribute('url');
        if (url != null) ii.image = Image(url.trim());
      },
    );

    return ii;
  }

  ItunesItem._();
}
