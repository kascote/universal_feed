import 'package:xml/xml.dart';

import './namespaces.dart';
import '../shared/errors.dart';

/// Supported feed types
enum FeedKind {
  /// RSS feed
  rss,

  /// Atom feed
  atom,
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
  Map<String, String>? extensions;

  ///
  MetaData(this.kind, this.version, {this.encoding, this.extensions});

  /// Creates a new MetaData object from the [XmlDocument]
  factory MetaData.rssFromXml(XmlDocument xmlDoc) {
    final root = xmlDoc.rootElement;
    var version = root.getAttribute('version') ?? '';
    final encoding = root.getAttribute('encoding') ?? '';
    final extensions = _getExtensions(root);

    switch (root.localName) {
      case 'feed':
        if (version.isEmpty && extensions['xmlns'] == 'http://www.w3.org/2005/Atom') {
          version = '1.0';
        }
        return MetaData(FeedKind.atom, version, encoding: encoding, extensions: extensions);
      case 'rss':
        if (version == '0.91') {
          final docType = root.document?.doctypeElement;
          if ((docType != null) && (docType.externalId?.publicId == rss91n)) {
            version = '0.91n';
          } else {
            version = '0.91u';
          }
        }
        return MetaData(FeedKind.rss, version, encoding: encoding, extensions: extensions);
      case 'RDF':
        return MetaData(FeedKind.rss, '0.90', encoding: encoding, extensions: extensions);
      default:
        throw FeedError('Unknown feed type: ${root.localName}');
    }
  }

  // TODO(nelson): Unify with Namespaces
  static Map<String, String> _getExtensions(XmlElement ele) {
    final extensions = <String, String>{};
    for (final attr in ele.attributes) {
      final value = attr.name.toString();
      if (value.startsWith('xml')) {
        extensions[value] = attr.value;
      }
    }
    return extensions;
  }
}
