import 'package:xml/xml.dart';

import '../../../universal_feed.dart';

/// Class that holds information about the Syndication spec
///
/// https://web.resource.org/rss/1.0/modules/syndication/
class Syndication {
  /// Describes the period over which the channel format is updated.
  /// Acceptable values are: hourly, daily, weekly, monthly, yearly.
  /// If omitted, daily is assumed.
  String? updatePeriod;

  /// Used to describe the frequency of updates in relation to the
  /// update period. A positive integer indicates how many times in
  /// that period the channel is updated.
  /// If omitted a value of 1 is assumed.
  String? updateFrequency;

  /// Defines a base date to be used in concert with updatePeriod
  /// and updateFrequency to calculate the publishing schedule.
  /// The date format takes the form: yyyy-mm-ddThh:mm
  String? updateBase;

  /// Creates a new [Syndication] object
  Syndication({this.updatePeriod = 'daily', this.updateFrequency = '1', this.updateBase});

  /// Parse a Syndication tag from an [XmlElement]
  factory Syndication.fromXml(RSS rss, XmlElement node) {
    final nsUrl = rss.namespaces.nsUrl(nsSyndicationNs);
    return Syndication(
      updatePeriod: node.getElement('updatePeriod', namespace: nsUrl)?.text.trim() ?? 'daily',
      updateFrequency: node.getElement('updateFrequency', namespace: nsUrl)?.text.trim() ?? '1',
      updateBase: node.getElement('updateBase', namespace: nsUrl)?.text.trim(),
    );
  }

  @override
  String toString() {
    return 'Syndication: $updatePeriod ~ $updateFrequency ~ $updateBase';
  }
}
