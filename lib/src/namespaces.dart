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

/// Helper class to hold the namespaces used by the parsed feed
class Namespaces {
  /// Map where each key will be the qualified namespace name and the value the url
  Map<String, String> names = {};

  /// Creates a new Namespace object utilizing the root node
  Namespaces(List<XmlAttribute> attributes) {
    for (final attribute in attributes) {
      names[attribute.name.qualified] = attribute.value;
    }
  }

  /// Returns true if the feed has the Atom namespace
  bool get hasAtom => names.containsKey(nsAtomNs);

  /// Returns true if the feed has the Content namespace
  bool get hasContent => names.containsKey(nsContentNs);

  /// Returns true if the feed has the Dublin Core namespace
  bool get hasDc => names.containsKey(nsDublinCoreNs);

  /// Returns true if the feed has the Dublin Core Terms namespace
  bool get hasDcTerms => names.containsKey(nsDcTermsNs);

  /// Returns true if the feed has the Media namespace
  bool get hasMedia => names.containsKey(nsMediaNs);

  /// Returns true if the feed has the Itunes namespace
  bool get hasItunes => names.containsKey(nsItunesNs);

  /// Returns true if the feed has the Syndication namespace
  bool get hasSyndication => names.containsKey(nsSyndicationNs);

  /// Returns true if the feed has the GeoRss namespace
  bool get hasGeoRss => names.containsKey(nsGeoNs);

  /// Will return the url for a given namespace as defined on the feed
  String? nsUrl(String name) => names[name];

  @override
  String toString() => names.keys.join(' ~ ');
}
