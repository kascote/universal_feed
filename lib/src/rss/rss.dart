import 'package:xml/xml.dart';

import './rss_channel.dart';
import './rss_item.dart';
import '../shared.dart';
import '../universal_feed_base.dart';

/// Really Simple Syndication (RSS) is an XML-based document format for the syndication of web content
/// so that it can be republished on other sites or downloaded periodically and presented to users.
class RSS {
  late RSSVersion _version;

  /// Information related to the Feed and the publisher
  late RSSChannel channel;

  /// Identify the [Namespaces] used on this Feed
  late Namespaces namespaces;

  /// Entries associated to this feed
  List<RSSItem>? entries;

  /// Creates a [RSS] from an string
  factory RSS.parseFromString(String xml) {
    final doc = XmlDocument.parse(xml);
    final root = doc.rootElement;
    return RSS._parseFromXML(root);
  }

  /// Creates a [RSS] from an [XmlElement]
  factory RSS.parseFromXML(XmlElement node) {
    return RSS._parseFromXML(node);
  }

  RSS._();

  /// Returns the [RSSVersion] of the feed
  RSSVersion get version => _version;

  void _parseVersion(XmlElement root) {
    var rc = RSSVersion.unknown;

    if (root.qualifiedName == 'rdf:RDF') {
      _version = RSSVersion.rss090;
      return;
      /* if (root.attributes.any((a) => a.value == rss90ns)) { */
      /*   _version = RSSVersion.rss090; */
      /*   return; */
      /* } */
    } else {
      final vIdx = root.attributes.indexWhere((a) => a.localName == 'version');
      if (vIdx < 0) {
        _version = RSSVersion.rss;
        return;
      }
      final ele = root.attributes[vIdx];

      if (ele.value == '0.91') {
        final docType = root.document?.doctypeElement;
        if ((docType != null) && (docType.externalId?.publicId == rss91n)) {
          rc = RSSVersion.rss091n;
        } else {
          rc = RSSVersion.rss091u;
        }
      } else if (ele.value == '0.92') {
        rc = RSSVersion.rss092;
      } else if (ele.value == '0.93') {
        rc = RSSVersion.rss093;
      } else if (ele.value == '0.94') {
        rc = RSSVersion.rss094;
      } else if (ele.value == '2.0' || ele.value == '2.01' || ele.value == '2.1') {
        rc = RSSVersion.rss20;
      }
    }

    _version = rc;
  }

  factory RSS._parseFromXML(XmlElement node) {
    final rss = RSS._()
      .._parseVersion(node)
      ..namespaces = Namespaces(node.attributes);

    getElement<XmlElement>(
      node,
      'channel',
      cb: (xml) => rss.channel = RSSChannel.fromXML(rss, xml),
    );
    // ignore: unnecessary_null_comparison
    if (rss.channel == null) throw FeedError('Missing channel tag on feed');

    if (rss.version == RSSVersion.rss090) {
      rss.entries = getListFromNodes<RSSItem>(
        node,
        'item',
        cb: (item) => RSSItem.fromXML(rss, item),
      );
    } else {
      rss.entries = getListFromNodes<RSSItem>(
        node.getElement('channel')!,
        'item',
        cb: (item) => RSSItem.fromXML(rss, item),
      );
    }

    return rss;
  }
}

/// Enum the possible versions of the feed
enum RSSVersion {
  /// The type of feed is unknown
  unknown,

  /// Original RSS feed
  rss,

  /// This is the RSS 0.90 specification published by Netscape on March 15, 1999.
  rss090,

  /// This is the RSS 0.91 specification published by Netscape on July 10, 1999.
  rss091n,

  /// This is the RSS 0.91 specification published by UserLand Software on June 2000.
  rss091u,

  /// This is the RSS 0.92 specification published by UserLand Software on December 2000.
  rss092,

  /// This is the RSS 0.93 specification published by UserLand Software on April 2001.
  rss093,

  /// This is the RSS 0.94 specification published by UserLand Software on August 2002.
  rss094,

  /// This is the original RSS 2.0 specification published by UserLand Software on August 2002.
  rss20,
}
