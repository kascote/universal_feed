import 'package:universal_feed/universal_feed.dart';

typedef TestFx = bool Function(UniversalFeed r);

Map<String, TestFx> dctermsTests() {
  return {
    'item_created.xml': (r) => r.items.first.dcterms!.created == '2002-06-26T11:17:35Z',
    'item_issued.xml': (r) => r.items.first.dcterms!.issued == '2002-06-26T11:17:35Z',
    'item_modified.xml': (r) => r.items.first.dcterms!.modified == '2002-06-26T11:17:35Z',
    'item_valid.xml': (r) => r.items.first.dcterms!.valid!.start == '2002-7-5',
    'item_valid_end.xml': (r) => r.items.first.dcterms!.valid!.end == '2002-8-5',
    'item_valid_scheme.xml': (r) => r.items.first.dcterms!.valid!.scheme == 'W3C-DTF',
    'item_valid_name.xml': (r) => r.items.first.dcterms!.valid!.name == 'OO Perl / mod_perl programmer for Web CMS',
    'item_available.xml': (r) => r.items.first.dcterms!.available!.start == '2002-7-5',
    'item_available_end.xml': (r) => r.items.first.dcterms!.available!.end == '2002-8-5',
    'item_available_scheme.xml': (r) => r.items.first.dcterms!.available!.scheme == 'W3C-DTF',
    'item_available_name.xml': (r) =>
        r.items.first.dcterms!.available!.name == 'OO Perl / mod_perl programmer for Web CMS',
  };
}
