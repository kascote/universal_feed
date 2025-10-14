import 'package:xml/xml.dart';

import '../../../../universal_feed.dart';
import '../../../shared/extensions.dart';

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
  factory ItunesItem.fromXml(UniversalFeed uf, XmlElement node) {
    final nsUrl = uf.meta.extensions.nsUrl(nsItunesNs);
    final ii = ItunesItem._()
      ..duration = node.getElement('duration', namespace: nsUrl)?.innerText.trim()
      ..explicit = node.getElement('explicit', namespace: nsUrl)?.innerText.trim()
      ..title = node.getElement('title', namespace: nsUrl)?.innerText.trim()
      ..episode = node.getElement('episode', namespace: nsUrl)?.innerText.trim()
      ..season = node.getElement('season', namespace: nsUrl)?.innerText.trim()
      ..episodeType = node.getElement('episodeType', namespace: nsUrl)?.innerText.trim()
      ..block = node.getElement('block', namespace: nsUrl)?.innerText.trim()
      ..summary = node.getElement('summary', namespace: nsUrl)?.innerText.trim();
    node.ifPresentXml(
      'image',
      (value) {
        final url = value.getAttribute('href') ?? value.getAttribute('url');
        if (url != null) ii.image = Image(url.trim());
      },
      ns: nsUrl,
    );

    return ii;
  }

  ItunesItem._();
}
