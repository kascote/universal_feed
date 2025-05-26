import 'package:universal_feed/universal_feed.dart';

typedef TestFx = bool Function(UniversalFeed r);

Map<String, TestFx> json10Tests() {
  return {
    'meta_version_10.json': (r) => r.meta.version == '1',
    'feed_author.json': (r) =>
        r.authors.length == 1 &&
        r.authors.first.name == 'Example author' &&
        r.authors.first.url == 'http://example.com/',
    'feed_author_name.json': (r) {
      return r.authors.first.name == 'Example author' && r.authors.first.url == null;
    },

    // Entry test cases
    'entry_author.json': (r) =>
        r.items.isNotEmpty &&
        r.items.first.authors.length == 1 &&
        r.items.first.authors.first.name == 'Jane Smith' &&
        r.items.first.authors.first.url == 'https://janesmith.example.com',
    'entry_author_name.json': (r) =>
        r.items.isNotEmpty && r.items.first.authors.isNotEmpty && r.items.first.authors.first.name == 'John Doe',
  };
}
