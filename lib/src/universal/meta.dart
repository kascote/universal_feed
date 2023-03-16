import 'package:xml/xml.dart';

import './namespaces.dart';
import '../errors.dart';

/// Enum that list the supported feeds
enum FeedKind {
  /// RSS feed
  rss,

  /// Atom feed
  atom,
}

///
class UniversalMeta {
  ///
  late final FeedKind kind;

  ///
  late final String version;

  ///
  String? encoding;

  ///
  Map<String, String>? extensions;

  ///
  UniversalMeta(this.kind, this.version, {this.encoding, this.extensions});

  ///
  factory UniversalMeta.rssFromXml(XmlDocument xmlDoc) {
    final root = xmlDoc.rootElement;
    var version = root.getAttribute('version') ?? '';
    final encoding = root.getAttribute('encoding') ?? '';
    final extensions = _getExtensions(root);

    switch (root.localName) {
      case 'feed':
        return UniversalMeta(FeedKind.atom, version, encoding: encoding, extensions: extensions);
      case 'rss':
        if (version == '0.91') {
          final docType = root.document?.doctypeElement;
          if ((docType != null) && (docType.externalId?.publicId == rss91n)) {
            version = '0.91n';
          } else {
            version = '0.91u';
          }
        }
        return UniversalMeta(FeedKind.rss, version, encoding: encoding, extensions: extensions);
      case 'RDF':
        return UniversalMeta(FeedKind.rss, '0.90', encoding: encoding, extensions: extensions);
      default:
        throw FeedError('Unknown feed type: ${root.localName}');
    }
  }

  // TODO: Unify with Namespaces
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
