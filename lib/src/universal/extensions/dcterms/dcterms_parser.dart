import 'package:xml/xml.dart';

import '../../../../universal_feed.dart';
import '../../../shared/extensions.dart';
import '../extension_parser.dart';
import 'dcperiod.dart';
import 'dcterms.dart';

/// DcTerms extension parser - only works at item level
class DcTermsParser implements ItemExtensionParser {
  /// Creates a new [DcTermsParser] with the given namespace URL
  DcTermsParser(this.namespaceUrl);

  @override
  final String namespaceUrl;

  @override
  void parseItem(UniversalFeed feed, Item item, XmlElement element) {
    final terms = DcTerms()
      ..created = element.getElement('created', namespace: namespaceUrl)?.innerText
      ..issued = element.getElement('issued', namespace: namespaceUrl)?.innerText
      ..modified = element.getElement('modified', namespace: namespaceUrl)?.innerText;

    element
      ..ifPresent(
        'valid',
        (value) => terms.valid = DcPeriod.fromString(value),
        ns: namespaceUrl,
      )
      ..ifPresent(
        'available',
        (value) => terms.available = DcPeriod.fromString(value),
        ns: namespaceUrl,
      );

    item.dcterms = terms;
  }
}
