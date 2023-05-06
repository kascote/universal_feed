import 'package:xml/xml.dart';

/// RSS 0.9 URI
const rss90ns = 'http://my.netscape.com/rdf/simple/0.9/';

/// RSS 0.91 URI
const rss91n = '-//Netscape Communications//DTD RSS 0.91//EN';

/// Atom namespace
const nsAtomNs = 'xmlns:atom';

/// Content namespace
const nsContentNs = 'xmlns:content';

/// DCTerms namespace
const nsDcTermsNs = 'xmlns:dcterms';

/// Dublin Core namespace
const nsDublinCoreNs = 'xmlns:dc';

/// GeoRSS namespace
const nsGeoNs = 'xmlns:georss';

/// RSS Media namespace
const nsMediaNs = 'xmlns:media';

/// Syndication namespace
const nsSyndicationNs = 'xmlns:sy';

/// ITunes Namespace
const nsItunesNs = 'xmlns:itunes';

/// Namespaces keeps track of the namespaces defined on the feed
class Namespaces {
  final Map<String, String> _extensions = {};
  final Map<String, String> _attributes = {};

  /// Creates a new Namespace object utilizing the root node
  Namespaces(List<XmlAttribute> attributes) {
    for (final attribute in attributes) {
      if (attribute.name.qualified.startsWith('xml')) {
        _extensions[attribute.name.qualified] = attribute.value;
      } else {
        _attributes[attribute.name.qualified] = attribute.value;
      }
    }
  }

  /// Returns true if the feed has the Atom namespace
  bool get hasAtom => _extensions.containsKey(nsAtomNs);

  /// Returns true if the default namespace is Atom
  bool get hasAtomDefault => _extensions['xmlns'] == 'http://www.w3.org/2005/Atom';

  /// Returns true if the feed has the Content namespace
  bool get hasContent => _extensions.containsKey(nsContentNs);

  /// Returns true if the feed has the Dublin Core namespace
  bool get hasDc => _extensions.containsKey(nsDublinCoreNs);

  /// Returns true if the feed has the Dublin Core Terms namespace
  bool get hasDcTerms => _extensions.containsKey(nsDcTermsNs);

  /// Returns true if the feed has the Media namespace
  bool get hasMedia => _extensions.containsKey(nsMediaNs);

  /// Returns true if the feed has the Itunes namespace
  bool get hasItunes => _extensions.containsKey(nsItunesNs);

  /// Returns true if the feed has the Syndication namespace
  bool get hasSyndication => _extensions.containsKey(nsSyndicationNs);

  /// Returns true if the feed has the GeoRss namespace
  bool get hasGeoRss => _extensions.containsKey(nsGeoNs);

  /// Will return the url for a given namespace as defined on the feed
  String? nsUrl(String name) => _extensions[name];

  /// Returns true if the feed has no namespaces
  bool get extensionsIsEmpty => _extensions.isEmpty;

  @override
  String toString() => _extensions.keys.join(' ~ ');
}
