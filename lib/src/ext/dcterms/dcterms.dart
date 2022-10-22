import 'package:xml/xml.dart';

import './dcperiod.dart';
import '../../../src/shared.dart';
import '../../../src/universal_feed_base.dart';

/// DcTerms is an extension to Dublin core
///
/// https://web.resource.org/rss/1.0/modules/dcterms/
class DcTerms {
  /// Date of creation of the resource.
  String? created;

  /// Date of formal issuance (e.g., publication) of the resource.
  String? issued;

  /// Date on which the resource was changed.
  String? modified;

  /// Date (often a range) of validity of a resource.
  DcPeriod? valid;

  /// Date (often a range) that the resource will become or did become available.
  DcPeriod? available;

  DcTerms._();

  ///
  factory DcTerms.parseFomXml(RSS rss, XmlElement node) {
    final nsUrl = rss.namespaces.nsUrl(nsDcTermsNs);
    final terms = DcTerms._()
      ..created = node.getElement('created', namespace: nsUrl)?.text
      ..issued = node.getElement('issued', namespace: nsUrl)?.text
      ..modified = node.getElement('modified', namespace: nsUrl)?.text;
    getElement<String>(node, 'valid', ns: nsUrl, cb: (value) => terms.valid = DcPeriod.fromString(value));
    getElement<String>(node, 'available', ns: nsUrl, cb: (value) => terms.available = DcPeriod.fromString(value));

    return terms;
  }
}
