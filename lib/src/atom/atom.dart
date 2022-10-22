import 'package:xml/xml.dart';

import './atom_head.dart';
import '../../src/errors.dart';
import '../../src/namespaces.dart';
import '../../src/shared.dart';
import '../common/entry.dart';

/// Enum with the Atom versions
enum AtomVersion {
  /// Unknown version
  unknown,

  /// Atom version v0.3
  v03,

  /// Atom version 1.0
  v1,
}

/// Class that holds an Atom feed representation
///
/// This is the spec for the Atom feed
/// https://www.rfc-editor.org/rfc/rfc4287.html
class Atom {
  static const _nsUrl = 'http://www.w3.org/2005/Atom';
  late AtomVersion _version;

  /// Content of the feed's tags except [entries] [AtomHead]
  late AtomHead head;

  /// [Namespaces] defined on the feed
  late Namespaces namespaces;

  /// Containes each one of the entries in the Atom feed
  List<Entry>? entries;

  /// Parse an Atom feed from an string into an [Atom] object
  factory Atom.parseFromString(String xml) {
    final doc = XmlDocument.parse(xml);
    final root = doc.rootElement;

    if (root.localName != 'feed') {
      throw FeedError('Invalid root element: ${root.localName}');
    }

    return Atom._parseFromXML(root);
  }

  /// Parse an Atom feed from an [XmlElement] into an [Atom] object
  factory Atom.parseFromXml(XmlElement node) {
    return Atom._parseFromXML(node);
  }

  Atom._();

  /// Returns the [AtomVersion] of the parsed feed
  AtomVersion get version => _version;

  factory Atom._parseFromXML(XmlElement node) {
    final atom = Atom._();
    atom
      ..namespaces = Namespaces(node.attributes)
      .._parseVersion(node)
      ..head = AtomHead.fromXml(atom, node)
      ..entries = getListFromNodes<Entry>(node, 'entry', cb: (entry) => Entry.fromXml(atom, entry));

    return atom;
  }

  void _parseVersion(XmlElement node) {
    _version = AtomVersion.unknown;

    final v = node.getAttribute('version');
    if (v != null) {
      if (v == '0.3') {
        _version = AtomVersion.v03;
        return;
      }
    }

    if (namespaces.nsUrl('xmlns') == _nsUrl) {
      _version = AtomVersion.v1;
      return;
    }
    return;
  }
}
