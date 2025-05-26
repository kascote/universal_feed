import 'package:universal_feed/src/universal/namespaces.dart';
import 'package:xml/xml.dart';

import '../shared/errors.dart';

/// Supported feed types
enum FeedKind {
  /// RSS feed
  rss,

  /// Atom feed
  atom,

  /// JSON feed
  json,
}

/// Metadata information related to the feed
class MetaData {
  /// Type of feed
  late final FeedKind kind;

  /// Feed version
  late final String version;

  /// Encoding of the feed
  String? encoding;

  /// Extensions
  Namespaces extensions;

  /// Creates a new MetaData object
  MetaData(this.kind, this.version, this.extensions, {this.encoding});

  /// Creates a new MetaData object from the [XmlDocument]
  factory MetaData.rssFromXml(XmlDocument xmlDoc) {
    final root = xmlDoc.rootElement;
    var version = root.getAttribute('version') ?? '';
    final encoding = root.getAttribute('encoding') ?? '';
    final namespaces = Namespaces(root.attributes);

    switch (root.localName) {
      case 'feed':
        if (version.isEmpty && namespaces.hasAtomDefault) {
          version = '1.0';
        }
        return MetaData(FeedKind.atom, version, namespaces, encoding: encoding);
      case 'rss':
        if (version == '0.91') {
          final docType = root.document?.doctypeElement;
          if ((docType != null) && (docType.externalId?.publicId == rss91n)) {
            version = '0.91n';
          } else {
            version = '0.91u';
          }
        }
        return MetaData(FeedKind.rss, version, namespaces, encoding: encoding);
      case 'RDF':
        return MetaData(FeedKind.rss, '0.90', namespaces, encoding: encoding);
      default:
        throw FeedError('Unknown feed type: ${root.localName}');
    }
  }
}
