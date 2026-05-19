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
    'channel_podping_on.xml': (r) {
      final pc = r.podcast;
      return pc != null && (pc.podpingUsesPodping ?? false);
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
    'channel_locked_true.xml': (r) {
      final pc = r.podcast;
      return pc != null && (pc.locked ?? false);
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
      return blocks != null && blocks.length == 1 && blocks[0].id == 'google' && (blocks[0].blocked ?? false);
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
      return blocks != null && blocks.length == 1 && blocks[0].value == 'YES' && (blocks[0].blocked ?? false);
    },
    'channel_block_unknown_value.xml': (r) {
      final blocks = r.podcast?.blocks;
      return blocks != null && blocks.length == 1 && blocks[0].value == 'maybe' && blocks[0].blocked == null;
    },
    'channel_block_one.xml': (r) {
      final blocks = r.podcast?.blocks;
      return blocks != null && blocks.length == 1 && blocks[0].value == '1' && (blocks[0].blocked ?? false);
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
          uf.dtstart?.value == '2021-10-07T00:00:00.000Z' &&
          uf.rrule == 'FREQ=WEEKLY;BYDAY=TH';
    },
    'channel_update_frequency_minimal.xml': (r) {
      final uf = r.podcast?.updateFrequency;
      return uf != null && uf.description == 'Daily' && uf.complete == null && uf.dtstart == null && uf.rrule == null;
    },
    'channel_update_frequency_complete.xml': (r) {
      final uf = r.podcast?.updateFrequency;
      return uf != null && (uf.complete ?? false) && uf.rrule == null && uf.dtstart == null;
    },
    'channel_update_frequency_complete_yes.xml': (r) {
      final uf = r.podcast?.updateFrequency;
      return uf != null && (uf.complete ?? false);
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
    // funding
    'channel_funding_single.xml': (r) {
      final f = r.podcast?.fundings;
      return f != null && f.length == 1 && f[0].url == 'https://ko-fi.com/example' && f[0].text == 'Support the show';
    },
    'channel_funding_multiple.xml': (r) {
      final f = r.podcast?.fundings;
      if (f == null || f.length != 2) return false;
      return f[0].url == 'https://ko-fi.com/example' &&
          f[0].text == 'Ko-fi' &&
          f[1].url == 'https://patreon.com/example' &&
          f[1].text == 'Patreon';
    },
    'channel_funding_no_url.xml': (r) {
      final f = r.podcast?.fundings;
      return f != null && f.length == 1 && f[0].url == null && f[0].text == 'Donate';
    },
    'channel_funding_empty_text.xml': (r) {
      final f = r.podcast?.fundings;
      return f != null && f.length == 1 && f[0].url == 'https://example.com' && f[0].text == null;
    },
    // license (channel)
    'channel_license_full.xml': (r) {
      final l = r.podcast?.license;
      return l != null &&
          l.spdx == 'CC-BY-4.0' &&
          l.url == 'https://creativecommons.org/licenses/by/4.0/' &&
          l.text == 'Creative Commons';
    },
    'channel_license_spdx_only.xml': (r) {
      final l = r.podcast?.license;
      return l != null && l.spdx == 'MIT' && l.url == null && l.text == null;
    },
    'channel_license_no_spdx.xml': (r) {
      final l = r.podcast?.license;
      return l != null && l.spdx == null && l.url == 'https://example.com/license' && l.text == 'Custom License';
    },
    'channel_license_duplicate.xml': (r) => r.podcast?.license?.spdx == 'Apache-2.0',
    // license (item)
    'item_license.xml': (r) {
      final l = r.items.first.podcast?.license;
      return l != null &&
          l.spdx == 'CC-BY-4.0' &&
          l.url == 'https://creativecommons.org/licenses/by/4.0/' &&
          l.text == 'Creative Commons';
    },
    // trailer
    'channel_trailer_full.xml': (r) {
      final t = r.podcast?.trailers;
      if (t == null || t.length != 1) return false;
      final tr = t.first;
      return tr.url == 'https://example.org/trailers/teaser.mp3' &&
          tr.title == 'Coming April 1st, 2021' &&
          tr.pubdate?.value == 'Thu, 01 Apr 2021 08:00:00 EST' &&
          tr.pubdate?.parseValue() != null &&
          tr.length == '12345678' &&
          tr.type == 'audio/mp3' &&
          tr.season == '1';
    },
    'channel_trailer_minimal.xml': (r) {
      final t = r.podcast?.trailers;
      if (t == null || t.length != 1) return false;
      final tr = t.first;
      return tr.url == 'https://example.org/teaser.mp3' &&
          tr.title == 'Teaser' &&
          tr.pubdate == null &&
          tr.length == null &&
          tr.type == null &&
          tr.season == null;
    },
    'channel_trailer_multiple.xml': (r) {
      final t = r.podcast?.trailers ?? const [];
      return t.length == 2 &&
          t[0].season == '1' &&
          t[1].season == '2' &&
          t[0].title == 'Season 1 trailer' &&
          t[1].title == 'Season 2 trailer';
    },
    'channel_trailer_no_url.xml': (r) => (r.podcast?.trailers ?? const []).isEmpty,
    'channel_trailer_empty_url.xml': (r) => (r.podcast?.trailers ?? const []).isEmpty,
    'channel_trailer_empty_body.xml': (r) {
      final t = r.podcast?.trailers;
      return t != null && t.length == 1 && t.first.title == null && t.first.url == 'https://example.org/teaser.mp3';
    },
    'channel_trailer_season_only.xml': (r) {
      final t = r.podcast?.trailers;
      return t != null && t.length == 1 && t.first.season == '2' && t.first.title == null;
    },
    // person
    'channel_person_full.xml': (r) {
      final ps = r.podcast?.persons;
      if (ps == null || ps.length != 1) return false;
      final p = ps.first;
      return p.name == 'Alice Example' &&
          p.role == 'Host' &&
          p.group == 'Cast' &&
          p.img == 'https://example.org/avatars/alice.jpg' &&
          p.href == 'https://example.org/about/alice';
    },
    'channel_person_minimal.xml': (r) {
      final ps = r.podcast?.persons;
      if (ps == null || ps.length != 1) return false;
      final p = ps.first;
      return p.name == 'Alice Example' &&
          p.role == null &&
          p.group == null &&
          p.img == null &&
          p.href == null &&
          p.effectiveRole == 'host' &&
          p.effectiveGroup == 'cast';
    },
    'channel_person_multiple.xml': (r) {
      final ps = r.podcast?.persons ?? const [];
      return ps.length == 2 &&
          ps[0].name == 'Alice Example' &&
          ps[0].role == 'Host' &&
          ps[1].name == 'Bob Example' &&
          ps[1].role == 'Producer' &&
          ps[1].group == 'Crew';
    },
    'channel_person_empty_body.xml': (r) => (r.podcast?.persons ?? const []).isEmpty,
    'channel_person_whitespace.xml': (r) => (r.podcast?.persons ?? const []).isEmpty,
    'item_person_full.xml': (r) {
      final ps = r.items.first.podcast?.persons;
      if (ps == null || ps.length != 1) return false;
      final p = ps.first;
      return p.name == 'Alice Example' &&
          p.role == 'Guest' &&
          p.group == 'Cast' &&
          p.img == 'https://example.org/avatars/alice.jpg' &&
          p.href == 'https://example.org/about/alice';
    },
    'item_person_multiple.xml': (r) {
      final ps = r.items.first.podcast?.persons ?? const [];
      return ps.length == 2 &&
          ps[0].name == 'Alice Example' &&
          ps[0].role == 'Host' &&
          ps[1].name == 'Bob Example' &&
          ps[1].role == 'Guest';
    },
    'channel_and_item_person.xml': (r) {
      final cp = r.podcast?.persons ?? const [];
      final ip = r.items.first.podcast?.persons ?? const [];
      return cp.length == 1 &&
          ip.length == 1 &&
          cp.first.name == 'Alice Example' &&
          cp.first.role == 'Host' &&
          ip.first.name == 'Bob Example' &&
          ip.first.role == 'Guest';
    },
    // location
    'channel_location_full.xml': (r) {
      final ls = r.podcast?.locations;
      if (ls == null || ls.length != 1) return false;
      final l = ls.first;
      return l.text == 'Austin' &&
          l.rel == 'creator' &&
          l.geo == 'geo:30.2711286,-97.7436995' &&
          l.osm == 'R113314' &&
          l.country == 'US';
    },
    'channel_location_minimal.xml': (r) {
      final ls = r.podcast?.locations;
      if (ls == null || ls.length != 1) return false;
      final l = ls.first;
      return l.text == 'Austin' && l.rel == null && l.geo == null && l.osm == null && l.country == null;
    },
    'channel_location_creator.xml': (r) {
      final ls = r.podcast?.locations ?? const [];
      return ls.length == 1 && ls.first.rel == 'creator';
    },
    'channel_location_no_rel.xml': (r) {
      final ls = r.podcast?.locations ?? const [];
      return ls.length == 1 && ls.first.rel == null;
    },
    'channel_location_pair.xml': (r) {
      final ls = r.podcast?.locations ?? const [];
      return ls.length == 2 &&
          ls[0].rel == 'creator' &&
          ls[0].text == 'Marlow' &&
          ls[1].rel == 'subject' &&
          ls[1].text == 'Dreamworld';
    },
    'channel_location_empty_body.xml': (r) => (r.podcast?.locations ?? const []).isEmpty,
    'channel_location_whitespace.xml': (r) => (r.podcast?.locations ?? const []).isEmpty,
    'channel_location_country_only.xml': (r) {
      final ls = r.podcast?.locations ?? const [];
      return ls.length == 1 && ls.first.country == 'US' && ls.first.geo == null && ls.first.osm == null;
    },
    'item_location_full.xml': (r) {
      final ls = r.items.first.podcast?.locations ?? const [];
      return ls.length == 1 &&
          ls.first.text == 'Austin' &&
          ls.first.rel == 'subject' &&
          ls.first.osm == 'R113314' &&
          ls.first.country == 'US';
    },
    'item_location_pair.xml': (r) {
      final ls = r.items.first.podcast?.locations ?? const [];
      return ls.length == 2 && ls[0].text == 'Marlow' && ls[1].text == 'Dreamworld';
    },
    'channel_and_item_location.xml': (r) {
      final cl = r.podcast?.locations ?? const [];
      final il = r.items.first.podcast?.locations ?? const [];
      return cl.length == 1 && il.length == 1 && cl.first.text == 'Austin' && il.first.text == 'Birmingham';
    },
    // soundbite
    'item_soundbite_full.xml': (r) {
      final s = r.items.first.podcast?.soundbites;
      if (s == null || s.length != 1) return false;
      final sb = s.first;
      return sb.startTime == '73.0' && sb.duration == '60.0' && sb.title == 'Why the egg drop song?';
    },
    'item_soundbite_self_closing.xml': (r) {
      final s = r.items.first.podcast?.soundbites;
      return s != null &&
          s.length == 1 &&
          s.first.title == null &&
          s.first.startTime == '73.0' &&
          s.first.duration == '60.0';
    },
    'item_soundbite_empty_body.xml': (r) {
      final s = r.items.first.podcast?.soundbites;
      return s != null && s.length == 1 && s.first.title == null;
    },
    'item_soundbite_multiple.xml': (r) {
      final s = r.items.first.podcast?.soundbites ?? const [];
      return s.length == 2 && s[0].startTime == '10.5' && s[1].startTime == '120.0';
    },
    'item_soundbite_no_start_time.xml': (r) => (r.items.first.podcast?.soundbites ?? const []).isEmpty,
    'item_soundbite_empty_start_time.xml': (r) => (r.items.first.podcast?.soundbites ?? const []).isEmpty,
    'item_soundbite_no_duration.xml': (r) => (r.items.first.podcast?.soundbites ?? const []).isEmpty,
    'item_soundbite_empty_duration.xml': (r) => (r.items.first.podcast?.soundbites ?? const []).isEmpty,
    // socialInteract
    'item_social_interact_full.xml': (r) {
      final s = r.items.first.podcast?.socialInteracts;
      if (s == null || s.length != 1) return false;
      final si = s.first;
      return si.protocol == 'activitypub' &&
          si.uri == 'https://podcastindex.social/web/@dave/108013847520053401' &&
          si.accountId == '@dave' &&
          si.accountUrl == 'https://podcastindex.social/web/@dave' &&
          si.priority == '1';
    },
    'item_social_interact_minimal.xml': (r) {
      final s = r.items.first.podcast?.socialInteracts;
      if (s == null || s.length != 1) return false;
      final si = s.first;
      return si.protocol == 'activitypub' &&
          si.uri != null &&
          si.accountId == null &&
          si.accountUrl == null &&
          si.priority == null;
    },
    'item_social_interact_disabled.xml': (r) {
      final s = r.items.first.podcast?.socialInteracts;
      return s != null && s.length == 1 && s.first.protocol == 'disabled' && s.first.uri == null;
    },
    'item_social_interact_multiple.xml': (r) {
      final s = r.items.first.podcast?.socialInteracts ?? const [];
      return s.length == 2 &&
          s[0].protocol == 'activitypub' &&
          s[0].priority == '1' &&
          s[1].protocol == 'twitter' &&
          s[1].priority == '2';
    },
    'item_social_interact_no_protocol.xml': (r) => (r.items.first.podcast?.socialInteracts ?? const []).isEmpty,
    'item_social_interact_empty_protocol.xml': (r) => (r.items.first.podcast?.socialInteracts ?? const []).isEmpty,
    'item_social_interact_no_uri.xml': (r) => (r.items.first.podcast?.socialInteracts ?? const []).isEmpty,
    'item_social_interact_empty_uri.xml': (r) => (r.items.first.podcast?.socialInteracts ?? const []).isEmpty,
    'item_social_interact_self_closing.xml': (r) {
      final s = r.items.first.podcast?.socialInteracts;
      return s != null && s.length == 1 && s.first.protocol == 'activitypub';
    },

    // chat
    'channel_chat_full.xml': (r) {
      final c = r.podcast?.chat;
      return c != null &&
          c.server == 'irc.libera.chat' &&
          c.protocol == 'irc' &&
          c.accountId == '@dave' &&
          c.space == '#noagendashow';
    },
    'channel_chat_minimal.xml': (r) {
      final c = r.podcast?.chat;
      return c != null &&
          c.server == 'irc.libera.chat' &&
          c.protocol == 'irc' &&
          c.accountId == null &&
          c.space == null;
    },
    'channel_chat_no_server.xml': (r) => r.podcast?.chat == null,
    'channel_chat_empty_server.xml': (r) => r.podcast?.chat == null,
    'channel_chat_no_protocol.xml': (r) => r.podcast?.chat == null,
    'channel_chat_duplicate.xml': (r) {
      final c = r.podcast?.chat;
      return c != null && c.server == 'second.example.org' && c.protocol == 'matrix';
    },
    'item_chat_full.xml': (r) {
      final c = r.items.first.podcast?.chat;
      return c != null &&
          c.server == 'matrix.example.org' &&
          c.protocol == 'matrix' &&
          c.accountId == '@dave:example.org' &&
          c.space == '#show';
    },
    'item_chat_minimal.xml': (r) {
      final c = r.items.first.podcast?.chat;
      return c != null &&
          c.server == 'matrix.example.org' &&
          c.protocol == 'matrix' &&
          c.accountId == null &&
          c.space == null;
    },
    'channel_and_item_chat.xml': (r) {
      final cc = r.podcast?.chat;
      final ic = r.items.first.podcast?.chat;
      return cc != null && ic != null && cc.protocol == 'irc' && ic.protocol == 'matrix' && cc.server != ic.server;
    },
    'channel_image_full.xml': (r) {
      final imgs = r.podcast?.images;
      if (imgs == null || imgs.length != 1) return false;
      final i = imgs.first;
      return i.href == 'https://example.com/images/ep1/pci_landscape-massive.jpg' &&
          i.alt == 'An antenna emanating signal waves' &&
          i.aspectRatio == '16/9' &&
          i.width == '1200' &&
          i.height == '675' &&
          i.type == 'image/jpeg' &&
          i.purpose == 'artwork social' &&
          i.purposeTokens.length == 2 &&
          i.purposeTokens[0] == 'artwork' &&
          i.purposeTokens[1] == 'social';
    },
    'channel_image_minimal.xml': (r) {
      final imgs = r.podcast?.images;
      if (imgs == null || imgs.length != 1) return false;
      final i = imgs.first;
      return i.href.isNotEmpty &&
          i.alt == null &&
          i.aspectRatio == null &&
          i.width == null &&
          i.height == null &&
          i.type == null &&
          i.purpose == null &&
          i.purposeTokens.isEmpty;
    },
    'channel_image_multiple.xml': (r) {
      final imgs = r.podcast?.images ?? const [];
      return imgs.length == 3 &&
          imgs[0].aspectRatio == '1/1' &&
          imgs[1].aspectRatio == '16/9' &&
          imgs[2].aspectRatio == '9/16';
    },
    'channel_image_no_href.xml': (r) => (r.podcast?.images ?? const []).isEmpty,
    'channel_image_empty_href.xml': (r) => (r.podcast?.images ?? const []).isEmpty,
    'channel_image_purpose_tokens.xml': (r) {
      final imgs = r.podcast?.images;
      if (imgs == null || imgs.length != 1) return false;
      final t = imgs.first.purposeTokens;
      return t.length == 3 && t[0] == 'artwork' && t[1] == 'social' && t[2] == 'canvas';
    },
    'channel_image_video_type.xml': (r) {
      final imgs = r.podcast?.images;
      return imgs != null && imgs.length == 1 && imgs.first.type == 'video/mp4';
    },
    'channel_image_alongside_itunes.xml': (r) {
      return (r.podcast?.image?.url.isNotEmpty ?? false) &&
          (r.podcast?.images.length ?? 0) == 1 &&
          r.podcast!.image!.url != r.podcast!.images.first.href;
    },
    'item_image_full.xml': (r) {
      final imgs = r.items.first.podcast?.images;
      return imgs != null && imgs.length == 1 && imgs.first.purposeTokens.contains('artwork');
    },
    'item_image_multiple.xml': (r) {
      final imgs = r.items.first.podcast?.images ?? const [];
      return imgs.length == 2;
    },
    'item_image_no_href.xml': (r) {
      final imgs = r.items.first.podcast?.images ?? const [];
      return imgs.isEmpty;
    },
    'channel_remoteitem_full.xml': (r) {
      final ris = r.podcast?.remoteItems;
      if (ris == null || ris.length != 1) return false;
      final ri = ris.first;
      return ri.feedGuid == '917393e3-1b1e-5cef-ace4-edaa54e1f810' &&
          ri.feedUrl == 'https://feeds.example.org/917393e3-1b1e-5cef-ace4-edaa54e1f810/rss.xml' &&
          ri.itemGuid == 'asdf089j0-ep240-20230510' &&
          ri.medium == 'music' &&
          ri.knownMedium == PodcastMedium.music &&
          !ri.mediumIsList &&
          ri.title == 'Here Comes the Sun';
    },
    'channel_remoteitem_minimal.xml': (r) {
      final ris = r.podcast?.remoteItems;
      if (ris == null || ris.length != 1) return false;
      final ri = ris.first;
      return ri.feedGuid.isNotEmpty &&
          ri.feedUrl == null &&
          ri.itemGuid == null &&
          ri.medium == null &&
          ri.knownMedium == PodcastMedium.absent &&
          !ri.mediumIsList &&
          ri.title == null;
    },
    'channel_remoteitem_multiple.xml': (r) {
      final ris = r.podcast?.remoteItems ?? const [];
      return ris.length == 3 &&
          ris[0].feedGuid == 'guid-1' &&
          ris[1].feedGuid == 'guid-2' &&
          ris[2].feedGuid == 'guid-3';
    },
    'channel_remoteitem_no_feedguid.xml': (r) => (r.podcast?.remoteItems ?? const []).isEmpty,
    'channel_remoteitem_empty_feedguid.xml': (r) => (r.podcast?.remoteItems ?? const []).isEmpty,
    'channel_remoteitem_medium_list.xml': (r) {
      final ri = r.podcast?.remoteItems.firstOrNull;
      return ri != null && ri.medium == 'musicL' && ri.knownMedium == PodcastMedium.music && ri.mediumIsList;
    },
    'channel_remoteitem_medium_unknown.xml': (r) {
      final ri = r.podcast?.remoteItems.firstOrNull;
      return ri != null && ri.medium == 'podverse' && ri.knownMedium == PodcastMedium.other && !ri.mediumIsList;
    },
    'channel_remoteitem_list_feed.xml': (r) {
      final pc = r.podcast;
      return pc != null &&
          pc.knownMedium == PodcastMedium.podcast &&
          pc.mediumIsList &&
          pc.remoteItems.length == 2 &&
          r.items.isEmpty;
    },
    // podroll
    'channel_podroll_single.xml': (r) {
      final p = r.podcast?.podroll;
      if (p == null || p.items.length != 1) return false;
      final ri = p.items.first;
      return ri.feedGuid == '917393e3-1b1e-5cef-ace4-edaa54e1f810' &&
          ri.feedUrl == 'https://feeds.podcastindex.org/pc20.xml' &&
          ri.title == 'Podcasting 2.0';
    },
    'channel_podroll_multiple.xml': (r) {
      final items = r.podcast?.podroll?.items ?? const [];
      return items.length == 3 &&
          items[0].feedGuid == 'guid-1' &&
          items[1].feedGuid == 'guid-2' &&
          items[2].feedGuid == 'guid-3';
    },
    'channel_podroll_minimal.xml': (r) {
      final items = r.podcast?.podroll?.items ?? const [];
      return items.length == 1 &&
          items.first.feedGuid.isNotEmpty &&
          items.first.feedUrl == null &&
          items.first.title == null;
    },
    'channel_podroll_skips_invalid.xml': (r) {
      final items = r.podcast?.podroll?.items ?? const [];
      return items.length == 1 && items.first.feedGuid == 'guid-valid';
    },
    'channel_podroll_all_invalid.xml': (r) => r.podcast?.podroll == null,
    'channel_podroll_empty.xml': (r) => r.podcast?.podroll == null,
    'channel_podroll_duplicate.xml': (r) {
      final items = r.podcast?.podroll?.items ?? const [];
      return items.length == 1 && items.first.feedGuid == 'second-tag-guid';
    },
    'channel_podroll_ignores_other.xml': (r) {
      final items = r.podcast?.podroll?.items ?? const [];
      return items.length == 1 && items.first.feedGuid == 'real-guid';
    },
    // publisher
    'channel_publisher_full.xml': (r) {
      final p = r.podcast?.publisher;
      if (p == null) return false;
      final ri = p.remoteItem;
      return ri.feedGuid == '003af0a0-6a45-55cf-b765-68e3d349551a' &&
          ri.feedUrl == 'https://agilesetmedia.com/assets/static/feeds/publisher.xml' &&
          ri.medium == 'publisher' &&
          ri.knownMedium == PodcastMedium.publisher;
    },
    'channel_publisher_minimal.xml': (r) {
      final p = r.podcast?.publisher;
      return p != null &&
          p.remoteItem.feedGuid.isNotEmpty &&
          p.remoteItem.feedUrl == null &&
          p.remoteItem.medium == null;
    },
    'channel_publisher_no_medium.xml': (r) {
      final p = r.podcast?.publisher;
      return p != null && p.remoteItem.medium == null && p.remoteItem.knownMedium == PodcastMedium.absent;
    },
    'channel_publisher_first_wins.xml': (r) {
      final p = r.podcast?.publisher;
      return p != null && p.remoteItem.feedGuid == 'first-guid';
    },
    'channel_publisher_skips_invalid_first.xml': (r) {
      final p = r.podcast?.publisher;
      return p != null && p.remoteItem.feedGuid == 'second-guid';
    },
    'channel_publisher_no_remoteitem.xml': (r) => r.podcast?.publisher == null,
    'channel_publisher_invalid_only.xml': (r) => r.podcast?.publisher == null,
    'channel_publisher_duplicate.xml': (r) {
      final p = r.podcast?.publisher;
      return p != null && p.remoteItem.feedGuid == 'second-tag-guid';
    },
    'item_alternate_enclosure_full.xml': (r) {
      final aes = r.items.first.podcast?.alternateEnclosures ?? const [];
      if (aes.length != 1) return false;
      final ae = aes.first;
      return ae.type == 'audio/mpeg' &&
          ae.length == '43200000' &&
          ae.bitrate == '128000' &&
          ae.height == '1080' &&
          ae.lang == 'en-US' &&
          ae.title == 'Standard' &&
          ae.rel == 'default' &&
          ae.codecs == 'mp4a.40.2' &&
          (ae.isDefault ?? false) &&
          ae.sources.length == 2 &&
          ae.sources[0].uri == 'https://example.com/file-0.mp3' &&
          ae.sources[1].uri == 'ipfs://Qm…' &&
          ae.integrity.length == 1 &&
          ae.integrity.first.type == 'sri' &&
          ae.integrity.first.value == 'sha384-ABC';
    },
    'item_alternate_enclosure_minimal.xml': (r) {
      final aes = r.items.first.podcast?.alternateEnclosures ?? const [];
      if (aes.length != 1) return false;
      final ae = aes.first;
      return ae.type == 'audio/mpeg' &&
          ae.sources.length == 1 &&
          ae.length == null &&
          ae.bitrate == null &&
          ae.height == null &&
          ae.lang == null &&
          ae.title == null &&
          ae.rel == null &&
          ae.codecs == null &&
          ae.isDefault == null &&
          ae.integrity.isEmpty;
    },
    'item_alternate_enclosure_multiple.xml': (r) {
      final aes = r.items.first.podcast?.alternateEnclosures ?? const [];
      return aes.length == 3 && aes[0].bitrate == '128000' && aes[1].bitrate == '96000' && aes[2].bitrate == '16000';
    },
    'item_alternate_enclosure_no_source.xml': (r) => (r.items.first.podcast?.alternateEnclosures ?? const []).isEmpty,
    'item_alternate_enclosure_empty_uri.xml': (r) {
      final aes = r.items.first.podcast?.alternateEnclosures ?? const [];
      return aes.length == 1 &&
          aes.first.sources.length == 1 &&
          aes.first.sources.first.uri == 'https://example.com/file.mp3';
    },
    'item_alternate_enclosure_all_sources_invalid.xml': (r) =>
        (r.items.first.podcast?.alternateEnclosures ?? const []).isEmpty,
    'item_alternate_enclosure_no_type.xml': (r) {
      final aes = r.items.first.podcast?.alternateEnclosures ?? const [];
      return aes.length == 1 && aes.first.type == null && aes.first.sources.length == 1;
    },
    'item_alternate_enclosure_default_true.xml': (r) {
      final aes = r.items.first.podcast?.alternateEnclosures ?? const [];
      return aes.length == 1 && (aes.first.isDefault ?? false);
    },
    'item_alternate_enclosure_default_yes.xml': (r) {
      final aes = r.items.first.podcast?.alternateEnclosures ?? const [];
      return aes.length == 1 && (aes.first.isDefault ?? false);
    },
    'item_alternate_enclosure_default_false.xml': (r) {
      final aes = r.items.first.podcast?.alternateEnclosures ?? const [];
      return aes.length == 1 && aes.first.isDefault == false;
    },
    'item_alternate_enclosure_default_garbage.xml': (r) {
      final aes = r.items.first.podcast?.alternateEnclosures ?? const [];
      return aes.length == 1 && aes.first.isDefault == null;
    },
    'item_alternate_enclosure_integrity_sri.xml': (r) {
      final aes = r.items.first.podcast?.alternateEnclosures ?? const [];
      if (aes.length != 1) return false;
      final ae = aes.first;
      return ae.integrity.length == 1 && ae.integrity.first.type == 'sri' && ae.integrity.first.value.isNotEmpty;
    },
    'item_alternate_enclosure_integrity_pgp.xml': (r) {
      final aes = r.items.first.podcast?.alternateEnclosures ?? const [];
      if (aes.length != 1) return false;
      final ae = aes.first;
      return ae.integrity.length == 1 && ae.integrity.first.type == 'pgp-signature';
    },
    'item_alternate_enclosure_integrity_missing_type.xml': (r) {
      final aes = r.items.first.podcast?.alternateEnclosures ?? const [];
      if (aes.length != 1) return false;
      final ae = aes.first;
      return ae.integrity.isEmpty && ae.sources.isNotEmpty;
    },
    'item_alternate_enclosure_integrity_missing_value.xml': (r) {
      final aes = r.items.first.podcast?.alternateEnclosures ?? const [];
      return aes.length == 1 && aes.first.integrity.isEmpty;
    },
    'item_alternate_enclosure_integrity_multiple_types.xml': (r) {
      final aes = r.items.first.podcast?.alternateEnclosures ?? const [];
      if (aes.length != 1) return false;
      final ae = aes.first;
      return ae.integrity.length == 2 && ae.integrity[0].type == 'sri' && ae.integrity[1].type == 'pgp-signature';
    },
    'item_alternate_enclosure_integrity_partial_invalid.xml': (r) {
      final aes = r.items.first.podcast?.alternateEnclosures ?? const [];
      if (aes.length != 1) return false;
      final ae = aes.first;
      return ae.integrity.length == 1 && ae.integrity.first.type == 'sri';
    },
    'item_alternate_enclosure_source_content_type.xml': (r) {
      final aes = r.items.first.podcast?.alternateEnclosures ?? const [];
      if (aes.length != 1) return false;
      final ae = aes.first;
      if (ae.sources.length != 2) return false;
      return ae.sources[0].contentType == null && ae.sources[1].contentType == 'application/x-bittorrent';
    },
    'item_alternate_enclosure_alongside_enclosure.xml': (r) {
      final item = r.items.first;
      final aes = item.podcast?.alternateEnclosures ?? const [];
      return item.enclosures.isNotEmpty && aes.length == 1 && aes.first.sources.length == 2;
    },
    'item_alternate_enclosure_float_bitrate.xml': (r) {
      final aes = r.items.first.podcast?.alternateEnclosures ?? const [];
      return aes.length == 1 && aes.first.bitrate == '160707.74';
    },

    // channel-level value
    'channel_value_full.xml': (r) {
      final vs = r.podcast?.values ?? const [];
      if (vs.length != 1) return false;
      final v = vs.first;
      if (v.type != 'lightning' || v.method != 'keysend') return false;
      if (v.suggested != '0.00000005000') return false;
      if (v.recipients.length != 3) return false;
      final fees = v.recipients.where((x) => x.fee ?? false).toList();
      if (fees.length != 1 || v.recipients.first.split != '50') return false;
      return v.timeSplits.length == 1 &&
          v.timeSplits.first.startTime == '60' &&
          v.timeSplits.first.recipients.length == 1;
    },
    'channel_value_minimal.xml': (r) {
      final vs = r.podcast?.values ?? const [];
      if (vs.length != 1) return false;
      final v = vs.first;
      return v.type.isNotEmpty &&
          v.method.isNotEmpty &&
          v.suggested == null &&
          v.recipients.length == 1 &&
          v.timeSplits.isEmpty;
    },
    'channel_value_no_type.xml': (r) => (r.podcast?.values ?? const []).isEmpty,
    'channel_value_no_method.xml': (r) => (r.podcast?.values ?? const []).isEmpty,
    'channel_value_no_recipients.xml': (r) {
      final vs = r.podcast?.values ?? const [];
      return vs.length == 1 && vs.first.recipients.isEmpty && vs.first.timeSplits.isEmpty;
    },
    'channel_value_skips_invalid_recipient.xml': (r) {
      final vs = r.podcast?.values ?? const [];
      return vs.length == 1 && vs.first.recipients.length == 1 && vs.first.recipients.first.address == '03good';
    },
    'channel_value_multi_scheme.xml': (r) {
      final vs = r.podcast?.values ?? const [];
      return vs.length == 2 && vs[0].type == 'lightning' && vs[1].type == 'webmonetization';
    },
    'channel_value_recipient_fee_true.xml': (r) => r.podcast?.values.first.recipients.first.fee ?? false,
    'channel_value_recipient_fee_yes.xml': (r) => r.podcast?.values.first.recipients.first.fee ?? false,
    'channel_value_recipient_fee_false.xml': (r) {
      final fee = r.podcast?.values.first.recipients.first.fee;
      return fee != null && !fee;
    },
    'channel_value_recipient_fee_garbage.xml': (r) => r.podcast?.values.first.recipients.first.fee == null,
    'channel_value_recipient_float_split.xml': (r) => r.podcast?.values.first.recipients.first.split == '50.5',
    'channel_value_recipient_custom_key_value.xml': (r) {
      final rec = r.podcast?.values.first.recipients.first;
      return rec?.customKey == '696969' && rec?.customValue == 'user-id-123';
    },

    // item-level value
    'item_value_full.xml': (r) {
      final vs = r.items.first.podcast?.values ?? const [];
      if (vs.length != 1) return false;
      final v = vs.first;
      return v.type == 'lightning' &&
          v.recipients.length == 2 &&
          v.timeSplits.length == 1 &&
          v.timeSplits.first.recipients.isNotEmpty;
    },
    'item_value_minimal.xml': (r) {
      final vs = r.items.first.podcast?.values ?? const [];
      return vs.length == 1 && vs.first.recipients.length == 1 && vs.first.timeSplits.isEmpty;
    },
    'item_value_overrides_channel.xml': (r) {
      final ch = r.podcast?.values ?? const [];
      final it = r.items.first.podcast?.values ?? const [];
      return ch.length == 1 && it.length == 1 && ch.first.recipients.first.address != it.first.recipients.first.address;
    },
    'item_value_no_type.xml': (r) => (r.items.first.podcast?.values ?? const []).isEmpty,
    'item_value_multi_scheme.xml': (r) {
      final vs = r.items.first.podcast?.values ?? const [];
      return vs.length == 2 && vs[0].type != vs[1].type;
    },

    // valueTimeSplit
    'item_value_time_split_recipients.xml': (r) {
      final ts = r.items.first.podcast?.values.first.timeSplits.first;
      return ts != null &&
          ts.startTime == '60' &&
          ts.duration == '237' &&
          ts.recipients.length == 2 &&
          ts.remoteItem == null;
    },
    'item_value_time_split_remote_item.xml': (r) {
      final ts = r.items.first.podcast?.values.first.timeSplits.first;
      return ts != null &&
          ts.remoteItem != null &&
          ts.remoteItem!.feedGuid.isNotEmpty &&
          ts.remotePercentage == '95' &&
          ts.remoteStartTime == '0' &&
          ts.recipients.isEmpty;
    },
    'item_value_time_split_both.xml': (r) {
      final ts = r.items.first.podcast?.values.first.timeSplits.first;
      return ts != null && ts.recipients.isNotEmpty && ts.remoteItem != null;
    },
    'item_value_time_split_multiple.xml': (r) {
      final splits = r.items.first.podcast?.values.first.timeSplits ?? const [];
      return splits.length == 3 &&
          splits[0].startTime == '60' &&
          splits[1].startTime == '500' &&
          splits[2].startTime == '900';
    },
    'item_value_time_split_missing_starttime.xml': (r) {
      final splits = r.items.first.podcast?.values.first.timeSplits ?? const [];
      return splits.length == 1 && splits.first.startTime == '500';
    },
    'item_value_time_split_missing_duration.xml': (r) {
      final splits = r.items.first.podcast?.values.first.timeSplits ?? const [];
      return splits.length == 1 && splits.first.duration == '60';
    },
    'item_value_time_split_empty_body.xml': (r) {
      final ts = r.items.first.podcast?.values.first.timeSplits.first;
      return ts != null && ts.recipients.isEmpty && ts.remoteItem == null;
    },
    'item_value_time_split_invalid_remote.xml': (r) {
      final ts = r.items.first.podcast?.values.first.timeSplits.first;
      return ts != null && ts.remoteItem == null;
    },
    'item_value_time_split_remote_item_first_wins.xml': (r) {
      final ts = r.items.first.podcast?.values.first.timeSplits.first;
      return ts?.remoteItem?.feedGuid == 'first-guid';
    },

    // contentLink on regular items
    'item_content_link_single.xml': (r) {
      final cls = r.items.first.podcast?.contentLinks ?? const [];
      return cls.length == 1 &&
          cls.first.href == 'https://example.com/youtube' &&
          cls.first.text == 'Watch on YouTube!';
    },
    'item_content_link_multi.xml': (r) {
      final cls = r.items.first.podcast?.contentLinks ?? const [];
      return cls.length == 3 &&
          cls[0].href.contains('youtube') &&
          cls[1].href.contains('twitter') &&
          cls[2].href.contains('html');
    },
    'item_content_link_no_href.xml': (r) {
      final cls = r.items.first.podcast?.contentLinks ?? const [];
      return cls.length == 1 && cls.first.href.isNotEmpty;
    },
    'item_content_link_empty_body.xml': (r) {
      final cls = r.items.first.podcast?.contentLinks ?? const [];
      return cls.length == 1 && cls.first.text == null;
    },
    'item_content_link_whitespace_body.xml': (r) {
      final cls = r.items.first.podcast?.contentLinks ?? const [];
      return cls.length == 1 && cls.first.text == null;
    },

    // liveItem shape
    'live_item_full.xml': (r) {
      if (r.liveItems.length != 1) return false;
      final li = r.liveItems.first;
      final live = li.podcast?.live;
      if (live == null) return false;
      return live.knownStatus == PodcastLiveStatus.live &&
          live.start != null &&
          live.end != null &&
          li.title == 'Podcasting 2.0 Live Show' &&
          li.enclosures.length == 1 &&
          (li.podcast?.contentLinks.length ?? 0) == 3 &&
          (li.podcast?.persons.length ?? 0) >= 1 &&
          (li.podcast?.alternateEnclosures.length ?? 0) == 1;
    },
    'live_item_minimal.xml': (r) {
      final li = r.liveItems.first;
      return li.podcast?.live?.knownStatus == PodcastLiveStatus.live &&
          li.guid == 'e32b4890-983b-4ce5-8b46-f2d6bc1d8819' &&
          (li.podcast?.contentLinks.length ?? 0) == 1;
    },
    'live_item_status_pending.xml': (r) =>
        r.liveItems.first.podcast?.live?.knownStatus == PodcastLiveStatus.pending,
    'live_item_status_live.xml': (r) =>
        r.liveItems.first.podcast?.live?.knownStatus == PodcastLiveStatus.live,
    'live_item_status_ended.xml': (r) =>
        r.liveItems.first.podcast?.live?.knownStatus == PodcastLiveStatus.ended,
    'live_item_status_unknown.xml': (r) {
      final live = r.liveItems.first.podcast?.live;
      return live?.knownStatus == PodcastLiveStatus.other && live?.status == 'starting';
    },
    'live_item_status_case_insensitive.xml': (r) {
      final live = r.liveItems.first.podcast?.live;
      return live?.knownStatus == PodcastLiveStatus.live && live?.status == 'LIVE';
    },
    'live_item_no_status.xml': (r) {
      final live = r.liveItems.first.podcast?.live;
      return live != null && live.knownStatus == PodcastLiveStatus.absent && live.status.isEmpty;
    },
    'live_item_no_start.xml': (r) {
      final live = r.liveItems.first.podcast?.live;
      return live != null && live.start == null;
    },
    'live_item_no_end.xml': (r) {
      final live = r.liveItems.first.podcast?.live;
      return live != null && live.start != null && live.end == null;
    },
    'live_item_multiple.xml': (r) {
      if (r.liveItems.length != 2) return false;
      return r.liveItems[0].itemId == 'live_0' && r.liveItems[1].itemId == 'live_1';
    },
    'live_item_with_items.xml': (r) {
      return r.items.length == 2 &&
          r.liveItems.length == 2 &&
          r.items.first.itemId == 'item_0' &&
          r.liveItems.first.itemId == 'live_0';
    },
    'live_item_with_chat.xml': (r) => r.liveItems.first.podcast?.chat != null,
    'live_item_with_value.xml': (r) => (r.liveItems.first.podcast?.values ?? const []).length == 1,
    'live_item_with_location.xml': (r) => (r.liveItems.first.podcast?.locations ?? const []).length == 1,
    'live_item_with_person.xml': (r) => (r.liveItems.first.podcast?.persons ?? const []).length == 1,
    'live_item_with_alternate_enclosure.xml': (r) =>
        (r.liveItems.first.podcast?.alternateEnclosures ?? const []).length == 1,
    'live_item_with_dcterms.xml': (r) => r.liveItems.first.dcterms != null,
    'live_item_content_link_required_multi.xml': (r) =>
        (r.liveItems.first.podcast?.contentLinks ?? const []).length == 3,
    'live_item_namespace_not_declared.xml': (r) => r.liveItems.isEmpty,
  };
}
