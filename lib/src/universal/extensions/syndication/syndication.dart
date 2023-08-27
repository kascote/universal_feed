import 'package:xml/xml.dart';

import '../../../../universal_feed.dart';

/// Provides syndication hints to aggregators and others picking up this RDF
/// Site Summary (RSS) feed regarding how often it is updated. For example,
/// if you updated your file twice an hour, updatePeriod would be "hourly" and
/// updateFrequency would be "2". The syndication module borrows from Ian
/// Davis's Open Content Syndication (OCS) directory format. It supersedes the
/// RSS 0.91 skipDay and skipHour elements.
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
  factory Syndication.fromXml(UniversalFeed uf, XmlElement node) {
    final nsUrl = uf.meta.extensions.nsUrl(nsSyndicationNs);
    return Syndication(
      updatePeriod: node.getElement('updatePeriod', namespace: nsUrl)?.innerText.trim() ?? 'daily',
      updateFrequency: node.getElement('updateFrequency', namespace: nsUrl)?.innerText.trim() ?? '1',
      updateBase: node.getElement('updateBase', namespace: nsUrl)?.innerText.trim(),
    );
  }

  @override
  String toString() {
    return 'Syndication: $updatePeriod ~ $updateFrequency ~ $updateBase';
  }
}
