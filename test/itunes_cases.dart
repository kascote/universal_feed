import 'package:universal_feed/universal_feed.dart';

typedef TestFx = bool Function(RSS r);

Map<String, TestFx> itunesTests() {
  return {
    'itunes_channel_block.xml': (r) => r.channel.itunes?.block == 'yes',
    'itunes_channel_block_false.xml': (r) => r.channel.itunes?.block == 'false',
    'itunes_channel_block_no.xml': (r) => r.channel.itunes?.block == 'no',
    'itunes_channel_block_uppercase.xml': (r) => r.channel.itunes?.block == 'YES',
    'itunes_channel_block_whitespace.xml': (r) => r.channel.itunes?.block == 'yes',
    'itunes_channel_category.xml': (r) => r.channel.itunes?.categories?.first.label == 'Technology',
    'itunes_channel_category_nested.xml': (r) => r.channel.itunes?.categories?.last.label == 'Gadgets',
    'itunes_channel_explicit.xml': (r) => r.channel.itunes?.explicit == 'yes',
    'itunes_channel_explicit_clean.xml': (r) => r.channel.itunes?.explicit == 'clean',
    'itunes_channel_explicit_whitespace.xml': (r) => r.channel.itunes?.explicit == 'yes',
    'itunes_channel_image.xml': (r) => r.channel.itunes?.image?.url == 'http://example.com/logo.jpg',
    'itunes_channel_image_no_href.xml': (r) => r.channel.itunes?.image == null,
    'itunes_channel_image_url.xml': (r) => r.channel.itunes?.image?.url == 'http://a.b/i.png',
    'itunes_channel_owner_email.xml': (r) => r.channel.itunes?.owner?.email == 'mark@example.com',
    'itunes_channel_owner_name.xml': (r) => r.channel.itunes?.owner?.name == 'Mark Pilgrim',
    'itunes_channel_author.xml': (r) => r.channel.itunes?.author == 'Mark Pilgrim',
    'itunes_channel_title.xml': (r) => r.channel.itunes?.title == 'Example Title',
    'itunes_channel_type.xml': (r) => r.channel.itunes?.type == 'serial',
    'itunes_channel_newfeedurl.xml': (r) => r.channel.itunes?.newFeedUrl == 'http://a.b/i.png',
    'itunes_channel_complete.xml': (r) => r.channel.itunes?.complete == 'yes',
    'itunes_channel_summary.xml': (r) => r.channel.itunes?.summary == 'Example summary',
    'itunes_channel_keywords.xml': (r) {
      final c = r.channel.itunes?.categories?.first;
      return c?.label == 'Technology' && c?.scheme == 'keyword';
    },
    'itunes_channel_keywords_multiple.xml': (r) {
      final f = r.channel.itunes?.categories?.first;
      final l = r.channel.itunes?.categories?.last;
      return f?.label == 'Technology' && f?.scheme == 'keyword' && l?.label == 'Gadgets' && l?.scheme == 'keyword';
    },
    'itunes_channel_keywords_duplicate.xml': (r) {
      final c = r.channel.itunes?.categories;
      return c?.first.label == 'Technology' && c?.first.scheme == 'keyword' && c?.length == 1;
    },
    'itunes_item_block.xml': (r) => r.entries?.first.itunes?.block == 'yes',
    'itunes_item_block_uppercase.xml': (r) => r.entries?.first.itunes?.block == 'YES',
    'itunes_item_block_whitespace.xml': (r) => r.entries?.first.itunes?.block == 'yes',
    'itunes_item_duration.xml': (r) => r.entries?.first.itunes?.duration == '3:00',
    'itunes_item_explicit.xml': (r) => r.entries?.first.itunes?.explicit == 'yes',
    'itunes_item_explicit_uppercase.xml': (r) => r.entries?.first.itunes?.explicit == 'YES',
    'itunes_item_explicit_whitespace.xml': (r) => r.entries?.first.itunes?.explicit == 'yes',
    'itunes_item_image.xml': (r) => r.entries?.first.itunes?.image?.url == 'http://example.com/logo.jpg',
    'itunes_item_image_url.xml': (r) => r.entries?.first.itunes?.image?.url == 'http://a.b/i.png',
    'itunes_item_episode_type.xml': (r) => r.entries?.first.itunes?.episodeType == 'trailer',
    'itunes_item_episode.xml': (r) => r.entries?.first.itunes?.episode == '1',
    'itunes_item_season.xml': (r) => r.entries?.first.itunes?.season == '3',
    'itunes_item_summary.xml': (r) => r.entries?.first.itunes?.summary == 'Example summary',
  };
}
