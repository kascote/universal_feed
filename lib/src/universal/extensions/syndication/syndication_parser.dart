import 'package:xml/xml.dart';

import '../../../../universal_feed.dart';
import '../extension_parser.dart';
import 'syndication.dart';

/// Syndication extension parser - only works at channel level
class SyndicationParser implements ChannelExtensionParser {
  /// Creates a new [SyndicationParser] with the given namespace URL
  SyndicationParser(this.namespaceUrl);

  @override
  final String namespaceUrl;

  @override
  void parseChannel(UniversalFeed feed, XmlElement channel) {
    feed.syndication = Syndication(
      updatePeriod: channel.getElement('updatePeriod', namespace: namespaceUrl)?.innerText.trim() ?? 'daily',
      updateFrequency: channel.getElement('updateFrequency', namespace: namespaceUrl)?.innerText.trim() ?? '1',
      updateBase: channel.getElement('updateBase', namespace: namespaceUrl)?.innerText.trim(),
    );
  }
}
