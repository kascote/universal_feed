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
  final Map<String, String> _names = {};

  /// Creates a new Namespace object utilizing the root node
  Namespaces(List<XmlAttribute> attributes) {
    for (final attribute in attributes) {
      _names[attribute.name.qualified] = attribute.value;
    }
  }

  /// Returns true if the feed has the Atom namespace
  bool get hasAtom => _names.containsKey(nsAtomNs);

  /// Returns true if the feed has the Content namespace
  bool get hasContent => _names.containsKey(nsContentNs);

  /// Returns true if the feed has the Dublin Core namespace
  bool get hasDc => _names.containsKey(nsDublinCoreNs);

  /// Returns true if the feed has the Dublin Core Terms namespace
  bool get hasDcTerms => _names.containsKey(nsDcTermsNs);

  /// Returns true if the feed has the Media namespace
  bool get hasMedia => _names.containsKey(nsMediaNs);

  /// Returns true if the feed has the Itunes namespace
  bool get hasItunes => _names.containsKey(nsItunesNs);

  /// Returns true if the feed has the Syndication namespace
  bool get hasSyndication => _names.containsKey(nsSyndicationNs);

  /// Returns true if the feed has the GeoRss namespace
  bool get hasGeoRss => _names.containsKey(nsGeoNs);

  /// Will return the url for a given namespace as defined on the feed
  String? nsUrl(String name) => _names[name];

  @override
  String toString() => _names.keys.join(' ~ ');
}
