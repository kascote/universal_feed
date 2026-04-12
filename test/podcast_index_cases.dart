import 'package:universal_feed/universal_feed.dart';

typedef TestFx = bool Function(UniversalFeed r);

Map<String, TestFx> podcastIndexTests() {
  return {
    'channel_txt_single.xml': (r) {
      final txts = r.podcast?.txts;
      return txts != null && txts.length == 1 && txts.first.purpose == 'ai-content' && txts.first.value == 'true';
    },
    'channel_txt_multiple.xml': (r) {
      final txts = r.podcast?.txts;
      if (txts == null || txts.length != 3) return false;
      return txts[0].purpose == 'verify' &&
          txts[0].value == 'abc123' &&
          txts[1].purpose == 'applepodcastsverify' &&
          txts[1].value == 'xyz789' &&
          txts[2].purpose == 'ai-content' &&
          txts[2].value == 'true';
    },
    'channel_txt_no_purpose.xml': (r) {
      final txts = r.podcast?.txts;
      return txts != null && txts.length == 1 && txts.first.purpose == null && txts.first.value == 'plain text';
    },
    'item_txt.xml': (r) {
      final txts = r.items.first.podcast?.txts;
      return txts != null && txts.length == 1 && txts.first.purpose == 'ai-content' && txts.first.value == 'true';
    },
    'mixed_txt.xml': (r) {
      final channelTxts = r.podcast?.txts;
      final itemTxts = r.items.first.podcast?.txts;
      if (channelTxts == null || channelTxts.length != 1) return false;
      if (itemTxts == null || itemTxts.length != 1) return false;
      return channelTxts.first.purpose == 'verify' &&
          channelTxts.first.value == 'channel-token' &&
          itemTxts.first.purpose == 'ai-content' &&
          itemTxts.first.value == 'true';
    },
    'podcast_only_no_itunes.xml': (r) {
      final pc = r.podcast;
      return pc != null && pc.txts.length == 1 && pc.txts.first.purpose == 'verify' && pc.txts.first.value == 'abc123';
    },
    'item_chapters.xml': (r) {
      final ch = r.items.first.podcast?.chapters;
      return ch != null && ch.url == 'https://example.com/ep1/chapters.json' && ch.type == 'application/json+chapters';
    },
    'item_chapters_missing_attrs.xml': (r) {
      final ch = r.items.first.podcast?.chapters;
      return ch != null && ch.url == null && ch.type == null;
    },
    'item_chapters_duplicate.xml': (r) {
      final ch = r.items.first.podcast?.chapters;
      return ch != null && ch.url == 'https://example.com/second.json';
    },
    'item_no_chapters.xml': (r) {
      return r.items.first.podcast?.chapters == null;
    },
  };
}
