import 'package:universal_feed/universal_feed.dart';

typedef TestFx = bool Function(RSS r);

Map<String, TestFx> mediaRssTests() {
  return {
    'item_media_content_url.xml': (r) => r.entries!.first.media!.content!.first.url == 'http://www.foo.com/movie.mov',
    'item_media_content_filesize.xml': (r) => r.entries!.first.media!.content!.first.fileSize == '12216320',
    'item_media_content_type.xml': (r) => r.entries!.first.media!.content!.first.type == 'video/quicktime',
    'item_media_content_medium.xml': (r) => r.entries!.first.media!.content!.first.medium == 'video',
    'item_media_content_default.xml': (r) => r.entries!.first.media!.content!.first.isDefault == 'true',
    'item_media_content_expression.xml': (r) => r.entries!.first.media!.content!.first.expression == 'full',
    'item_media_content_bitrate.xml': (r) => r.entries!.first.media!.content!.first.bitrate == '128',
    'item_media_content_framerate.xml': (r) => r.entries!.first.media!.content!.first.framerate == '25',
    'item_media_content_samplingrate.xml': (r) => r.entries!.first.media!.content!.first.samplingrate == '44.1',
    'item_media_content_channels.xml': (r) => r.entries!.first.media!.content!.first.channels == '2',
    'item_media_content_duration.xml': (r) => r.entries!.first.media!.content!.first.duration == '185',
    'item_media_content_height.xml': (r) => r.entries!.first.media!.content!.first.height == '200',
    'item_media_content_width.xml': (r) => r.entries!.first.media!.content!.first.width == '300',
    'item_media_content_lang.xml': (r) => r.entries!.first.media!.content!.first.lang == 'en',
    'item_media_content_rating.xml': (r) {
      final rtg = r.entries!.first.media!.content!.first.rating!;
      return rtg.first.scheme == 'urn:icra' &&
          rtg.first.value == 'r (cz 1 lz 1 nz 1 oz 1 vz 1)' &&
          rtg.last.scheme == 'urn:mpaa' &&
          rtg.last.value == 'pg';
    },
    'item_media_content_title.xml': (r) => r.entries!.first.media!.content!.first.title!.value == 'Example title',
    'item_media_content_title_markup.xml': (r) =>
        r.entries!.first.media!.content!.first.title!.value == 'Example <b>title</b>',
    'item_media_content_description.xml': (r) =>
        r.entries!.first.media!.content!.first.description!.value == 'Example description',
    'item_media_content_keywords.xml': (r) {
      final kw = r.entries!.first.media!.content!.first.categories!;
      return kw.first.label == 'kitty' &&
          kw.first.scheme == 'keyword' &&
          kw[1].label == 'cat' &&
          kw.last.label == 'fluffy';
    },
    'item_media_content_thumbnail.xml': (r) {
      final tn = r.entries!.first.media!.content!.first.thumbnails!.first;
      return tn.url == 'http://www.foo.com/keyframe.jpg' && tn.width == '75' && tn.height == '50';
    },
    'item_media_content_categories.xml': (r) {
      final cats = r.entries!.first.media!.content!.first.categories!;
      return cats.first.scheme == 'http://search.yahoo.com/mrss/category_ schema' &&
          cats.first.label == 'music/artist/album/song' &&
          cats.last.label == 'Ace Ventura - Pet Detective' &&
          cats.last.value == 'Arts/Movies/Titles/A/Ace_Ventura_Series/Ace_Ventura_ -_Pet_Detective';
    },
    'item_media_content_player.xml': (r) {
      final p = r.entries!.first.media!.content!.first.player!;
      return p.url == 'http://www.foo.com/player?id=1111' && p.height == '200' && p.width == '400';
    },
    'item_media_group.xml': (r) {
      final g1 = r.entries!.first.media!.group!;
      final g2 = r.entries!.last.media!.group!;
      return g1.first.url == 'http://www.foo.com/movie.mov' &&
          g1[1].url == 'http://www.foo.com/movie2.mov' &&
          g2.last.url == 'http://www.foo.com/movie3.mov';
    }
  };
}
