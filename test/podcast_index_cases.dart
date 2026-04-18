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
    'item_transcript_single.xml': (r) {
      final ts = r.items.first.podcast?.transcripts;
      if (ts == null || ts.length != 1) return false;
      final t = ts.first;
      return t.url == 'https://example.com/ep1/transcript.vtt' &&
          t.type == 'text/vtt' &&
          t.knownType == PodcastTranscriptType.vtt &&
          t.language == null &&
          t.rel == null;
    },
    'item_transcript_multiple.xml': (r) {
      final ts = r.items.first.podcast?.transcripts;
      if (ts == null || ts.length != 3) return false;
      return ts[0].url == 'https://example.com/ep1/transcript.vtt' &&
          ts[0].type == 'text/vtt' &&
          ts[0].knownType == PodcastTranscriptType.vtt &&
          ts[0].language == 'en' &&
          ts[0].rel == null &&
          ts[1].url == 'https://example.com/ep1/transcript.srt' &&
          ts[1].type == 'application/srt' &&
          ts[1].knownType == PodcastTranscriptType.srt &&
          ts[1].language == 'en' &&
          ts[1].rel == null &&
          ts[2].url == 'https://example.com/ep1/transcript.json' &&
          ts[2].type == 'application/json' &&
          ts[2].knownType == PodcastTranscriptType.json &&
          ts[2].language == 'es' &&
          ts[2].rel == 'captions';
    },
    'item_transcript_captions_rel.xml': (r) {
      final ts = r.items.first.podcast?.transcripts;
      if (ts == null || ts.length != 1) return false;
      final t = ts.first;
      return t.language == 'es' && t.rel == 'captions' && t.knownType == PodcastTranscriptType.vtt;
    },
    'item_transcript_unknown_type.xml': (r) {
      final ts = r.items.first.podcast?.transcripts;
      if (ts == null || ts.length != 1) return false;
      final t = ts.first;
      return t.type == 'application/x-futureformat' && t.knownType == PodcastTranscriptType.other;
    },
    'item_transcript_missing_attrs.xml': (r) {
      final ts = r.items.first.podcast?.transcripts;
      if (ts == null || ts.length != 1) return false;
      final t = ts.first;
      return t.url == null &&
          t.type == null &&
          t.language == null &&
          t.rel == null &&
          t.knownType == PodcastTranscriptType.absent;
    },
    'item_no_transcript.xml': (r) {
      final ts = r.items.first.podcast?.transcripts;
      return ts != null && ts.isEmpty;
    },
    'channel_guid.xml': (r) {
      return r.podcast?.guid == '917393e3-1b1e-5cef-ace4-edaa54e1f810';
    },
    'channel_guid_empty.xml': (r) {
      return r.podcast != null && r.podcast?.guid == null;
    },
    'channel_guid_duplicate.xml': (r) {
      return r.podcast?.guid == '22222222-2222-5222-a222-222222222222';
    },
    'channel_no_guid.xml': (r) {
      return r.podcast != null && r.podcast?.guid == null;
    },
    'channel_medium_podcast.xml': (r) {
      final pc = r.podcast;
      return pc != null && pc.medium == 'podcast' && pc.knownMedium == PodcastMedium.podcast && !pc.mediumIsList;
    },
    'channel_medium_music_list.xml': (r) {
      final pc = r.podcast;
      return pc != null && pc.medium == 'musicL' && pc.knownMedium == PodcastMedium.music && pc.mediumIsList;
    },
    'channel_medium_mixed_case.xml': (r) {
      final pc = r.podcast;
      return pc != null && pc.medium == 'Podcast' && pc.knownMedium == PodcastMedium.podcast && !pc.mediumIsList;
    },
    'channel_medium_unknown.xml': (r) {
      final pc = r.podcast;
      return pc != null && pc.medium == 'hologram' && pc.knownMedium == PodcastMedium.other && !pc.mediumIsList;
    },
    'channel_medium_unknown_l_suffix.xml': (r) {
      final pc = r.podcast;
      return pc != null && pc.medium == 'hologramL' && pc.knownMedium == PodcastMedium.other && pc.mediumIsList;
    },
    'channel_medium_empty.xml': (r) {
      final pc = r.podcast;
      return pc != null && pc.medium == null && pc.knownMedium == PodcastMedium.absent && !pc.mediumIsList;
    },
    'channel_medium_duplicate.xml': (r) {
      final pc = r.podcast;
      return pc != null && pc.medium == 'music' && pc.knownMedium == PodcastMedium.music && !pc.mediumIsList;
    },
    'channel_no_medium.xml': (r) {
      final pc = r.podcast;
      return pc != null && pc.medium == null && pc.knownMedium == PodcastMedium.absent && !pc.mediumIsList;
    },
    'channel_podping_true.xml': (r) {
      return r.podcast?.podpingUsesPodping ?? false;
    },
    'channel_podping_false.xml': (r) {
      final pc = r.podcast;
      return pc != null && !(pc.podpingUsesPodping ?? true);
    },
    'channel_podping_no_attr.xml': (r) {
      final pc = r.podcast;
      return pc != null && pc.podpingUsesPodping == null;
    },
    'channel_no_podping.xml': (r) {
      final pc = r.podcast;
      return pc != null && pc.podpingUsesPodping == null;
    },
    'channel_podping_duplicate.xml': (r) {
      final pc = r.podcast;
      return pc != null && !(pc.podpingUsesPodping ?? true);
    },
    'channel_locked_yes.xml': (r) {
      final pc = r.podcast;
      return pc != null && (pc.locked ?? false) && pc.lockedOwner == 'owner@example.com';
    },
    'channel_locked_no.xml': (r) {
      final pc = r.podcast;
      return pc != null && !(pc.locked ?? true) && pc.lockedOwner == null;
    },
    'channel_locked_empty.xml': (r) {
      final pc = r.podcast;
      return pc != null && pc.locked == null;
    },
    'channel_no_locked.xml': (r) {
      final pc = r.podcast;
      return pc != null && pc.locked == null && pc.lockedOwner == null;
    },
    'channel_locked_duplicate.xml': (r) {
      final pc = r.podcast;
      return pc != null && !(pc.locked ?? true) && pc.lockedOwner == null;
    },
    'channel_block_yes.xml': (r) {
      final blocks = r.podcast?.blocks;
      return blocks != null &&
          blocks.length == 1 &&
          blocks[0].id == null &&
          blocks[0].value == 'yes' &&
          (blocks[0].blocked ?? false);
    },
    'channel_block_no.xml': (r) {
      final blocks = r.podcast?.blocks;
      return blocks != null && blocks.length == 1 && blocks[0].blocked == false;
    },
    'channel_block_with_id.xml': (r) {
      final blocks = r.podcast?.blocks;
      return blocks != null &&
          blocks.length == 1 &&
          blocks[0].id == 'google' &&
          (blocks[0].blocked ?? false);
    },
    'channel_block_multiple.xml': (r) {
      final blocks = r.podcast?.blocks;
      return blocks != null &&
          blocks.length == 3 &&
          blocks[0].id == null &&
          (blocks[0].blocked ?? false) &&
          blocks[1].id == 'google' &&
          (blocks[1].blocked ?? false) &&
          blocks[2].id == 'spotify' &&
          blocks[2].blocked == false;
    },
    'channel_block_uppercase.xml': (r) {
      final blocks = r.podcast?.blocks;
      return blocks != null &&
          blocks.length == 1 &&
          blocks[0].value == 'YES' &&
          (blocks[0].blocked ?? false);
    },
    'channel_block_unknown_value.xml': (r) {
      final blocks = r.podcast?.blocks;
      return blocks != null &&
          blocks.length == 1 &&
          blocks[0].value == 'maybe' &&
          blocks[0].blocked == null;
    },
    'channel_block_empty_body.xml': (r) => r.podcast?.blocks.isEmpty ?? false,
    'channel_block_whitespace_body.xml': (r) => r.podcast?.blocks.isEmpty ?? false,
    'channel_block_id_whitespace.xml': (r) {
      final blocks = r.podcast?.blocks;
      return blocks != null && blocks.length == 1 && blocks[0].id == 'google';
    },
    'channel_block_id_empty.xml': (r) {
      final blocks = r.podcast?.blocks;
      return blocks != null && blocks.length == 1 && blocks[0].id == null;
    },
    'channel_update_frequency_full.xml': (r) {
      final uf = r.podcast?.updateFrequency;
      return uf != null &&
          uf.description == 'Weekly on Thursdays' &&
          uf.complete == false &&
          uf.dtstart == '2021-10-07T00:00:00.000Z' &&
          uf.rrule == 'FREQ=WEEKLY;BYDAY=TH';
    },
    'channel_update_frequency_minimal.xml': (r) {
      final uf = r.podcast?.updateFrequency;
      return uf != null &&
          uf.description == 'Daily' &&
          uf.complete == null &&
          uf.dtstart == null &&
          uf.rrule == null;
    },
    'channel_update_frequency_complete.xml': (r) {
      final uf = r.podcast?.updateFrequency;
      return uf != null && (uf.complete ?? false) && uf.rrule == null && uf.dtstart == null;
    },
    'channel_update_frequency_empty.xml': (r) {
      return r.podcast != null && r.podcast?.updateFrequency == null;
    },
    'channel_no_update_frequency.xml': (r) {
      return r.podcast != null && r.podcast?.updateFrequency == null;
    },
    'item_season_name.xml': (r) {
      final pi = r.items.first.podcast;
      return pi != null && pi.season == '3' && pi.seasonName == 'Summer';
    },
    'item_season_no_name.xml': (r) {
      final pi = r.items.first.podcast;
      return pi != null && pi.season == '2' && pi.seasonName == null;
    },
    'item_season_itunes_override.xml': (r) {
      final pi = r.items.first.podcast;
      return pi != null && pi.season == '5' && pi.seasonName == 'Final';
    },
    'item_episode_display.xml': (r) {
      final pi = r.items.first.podcast;
      return pi != null && pi.episode == '42' && pi.episodeDisplay == 'Episode 42';
    },
    'item_episode_no_display.xml': (r) {
      final pi = r.items.first.podcast;
      return pi != null && pi.episode == '7' && pi.episodeDisplay == null;
    },
    'item_episode_itunes_override.xml': (r) {
      final pi = r.items.first.podcast;
      return pi != null && pi.episode == '99' && pi.episodeDisplay == 'Finale';
    },
  };
}
