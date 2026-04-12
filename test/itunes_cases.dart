import 'package:universal_feed/universal_feed.dart';

typedef TestFx = bool Function(UniversalFeed r);

Map<String, TestFx> itunesTests() {
  return {
    'itunes_channel_block.xml': (r) => r.podcast?.block == 'yes',
    'itunes_channel_block_false.xml': (r) => r.podcast?.block == 'false',
    'itunes_channel_block_no.xml': (r) => r.podcast?.block == 'no',
    'itunes_channel_block_uppercase.xml': (r) => r.podcast?.block == 'YES',
    'itunes_channel_block_whitespace.xml': (r) => r.podcast?.block == 'yes',
    'itunes_channel_category.xml': (r) =>
        r.podcast?.categories.first.label == 'Technology' && r.podcast!.categories.first.children.isEmpty,
    'itunes_channel_category_nested.xml': (r) {
      final cats = r.podcast?.categories;
      if (cats == null || cats.length != 1) return false;
      return cats.first.label == 'Technology' &&
          cats.first.children.length == 1 &&
          cats.first.children.first.label == 'Gadgets';
    },
    'itunes_channel_category_multiple.xml': (r) {
      final cats = r.podcast?.categories;
      if (cats == null || cats.length != 2) return false;
      return cats[0].label == 'Technology' &&
          cats[0].children.isEmpty &&
          cats[1].label == 'Health' &&
          cats[1].children.isEmpty;
    },
    'itunes_channel_category_multiple_nested.xml': (r) {
      final cats = r.podcast?.categories;
      if (cats == null || cats.length != 2) return false;
      return cats[0].label == 'Society & Culture' &&
          cats[0].children.length == 1 &&
          cats[0].children.first.label == 'Documentary' &&
          cats[1].label == 'Health' &&
          cats[1].children.length == 1 &&
          cats[1].children.first.label == 'Mental Health';
    },
    'itunes_channel_explicit.xml': (r) => r.podcast?.explicit == 'yes',
    'itunes_channel_explicit_clean.xml': (r) => r.podcast?.explicit == 'clean',
    'itunes_channel_explicit_whitespace.xml': (r) => r.podcast?.explicit == 'yes',
    'itunes_channel_image.xml': (r) => r.podcast?.image?.url == 'http://example.com/logo.jpg',
    'itunes_channel_image_no_href.xml': (r) => r.podcast?.image == null,
    'itunes_channel_image_url.xml': (r) => r.podcast?.image?.url == 'http://a.b/i.png',
    'itunes_channel_owner_email.xml': (r) =>
        r.authors.any((a) => a.type == AuthorType.creator && a.email == 'mark@example.com'),
    'itunes_channel_owner_name.xml': (r) =>
        r.authors.any((a) => a.type == AuthorType.creator && a.name == 'Mark Pilgrim'),
    'itunes_channel_author.xml': (r) =>
        r.authors.any((a) => a.type == AuthorType.author && a.name == 'Mark Pilgrim'),
    'itunes_channel_title.xml': (r) => r.podcast?.title == 'Example Title',
    'itunes_channel_type.xml': (r) => r.podcast?.type == 'serial',
    'itunes_channel_newfeedurl.xml': (r) => r.podcast?.newFeedUrl == 'http://a.b/i.png',
    'itunes_channel_complete.xml': (r) => r.podcast?.complete == 'yes',
    'itunes_channel_summary.xml': (r) => r.podcast?.summary == 'Example summary',
    'itunes_channel_keywords.xml': (r) {
      final c = r.podcast?.categories.first;
      return c?.label == 'Technology' && c?.scheme == 'keyword';
    },
    'itunes_channel_keywords_multiple.xml': (r) {
      final f = r.podcast?.categories.first;
      final l = r.podcast?.categories.last;
      return f?.label == 'Technology' && f?.scheme == 'keyword' && l?.label == 'Gadgets' && l?.scheme == 'keyword';
    },
    'itunes_channel_keywords_duplicate.xml': (r) {
      final c = r.podcast?.categories;
      return c?.first.label == 'Technology' && c?.first.scheme == 'keyword' && c?.length == 1;
    },
    'itunes_item_block.xml': (r) => r.items.first.podcast?.block == 'yes',
    'itunes_item_block_uppercase.xml': (r) => r.items.first.podcast?.block == 'YES',
    'itunes_item_block_whitespace.xml': (r) => r.items.first.podcast?.block == 'yes',
    'itunes_item_duration.xml': (r) => r.items.first.podcast?.duration == '3:00',
    'itunes_item_explicit.xml': (r) => r.items.first.podcast?.explicit == 'yes',
    'itunes_item_explicit_uppercase.xml': (r) => r.items.first.podcast?.explicit == 'YES',
    'itunes_item_explicit_whitespace.xml': (r) => r.items.first.podcast?.explicit == 'yes',
    'itunes_item_image.xml': (r) => r.items.first.podcast?.image?.url == 'http://example.com/logo.jpg',
    'itunes_item_image_url.xml': (r) => r.items.first.podcast?.image?.url == 'http://a.b/i.png',
    'itunes_item_episode_type.xml': (r) => r.items.first.podcast?.episodeType == 'trailer',
    'itunes_item_episode.xml': (r) => r.items.first.podcast?.episode == '1',
    'itunes_item_season.xml': (r) => r.items.first.podcast?.season == '3',
    'itunes_item_summary.xml': (r) => r.items.first.podcast?.summary == 'Example summary',
  };
}
