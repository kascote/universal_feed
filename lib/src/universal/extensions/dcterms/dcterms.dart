import 'package:xml/xml.dart';

import './dcperiod.dart';
import '../../../../universal_feed.dart';
import '../../../shared/shared.dart';

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
  factory DcTerms.parseFomXml(UniversalFeed uf, XmlElement node) {
    final nsUrl = uf.meta.extensions.nsUrl(nsDcTermsNs);
    final terms = DcTerms._()
      ..created = node.getElement('created', namespace: nsUrl)?.innerText
      ..issued = node.getElement('issued', namespace: nsUrl)?.innerText
      ..modified = node.getElement('modified', namespace: nsUrl)?.innerText;
    getElement<String>(node, 'valid', ns: nsUrl, cb: (value) => terms.valid = DcPeriod.fromString(value));
    getElement<String>(node, 'available', ns: nsUrl, cb: (value) => terms.available = DcPeriod.fromString(value));

    return terms;
  }
}
