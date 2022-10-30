import 'package:universal_feed/universal_feed.dart';

typedef TestFx = bool Function(RSS r);

Map<String, TestFx> rssTests() {
  return {
    'channel_author.xml': (r) => r.channel.authors!.first.value == 'Example editor (me@example.com)',
    'channel_author_map_author_detail_email.xml': (r) => r.channel.authors!.first.email == 'me@example.com',
    'channel_author_map_author_detail_email_2.xml': (r) => r.channel.authors!.first.email == 'me+spam@example.com',
    'channel_author_map_author_detail_email_3.xml': (r) => r.channel.authors!.first.email == 'me@example.com',
    'channel_author_map_author_detail_name.xml': (r) => r.channel.authors!.first.name == 'Example editor',
    'channel_author_map_author_detail_name_2.xml': (r) => r.channel.authors!.first.name == 'Example editor',
    'channel_category.xml': (r) => r.channel.categories!.first.value == 'Example category',
    'channel_category_domain.xml': (r) => r.channel.categories!.first.scheme == 'http://www.example.com/',
    'channel_category_multiple.xml': (r) => r.channel.categories!.last.value == 'Example category 2',
    'channel_category_multiple_2.xml': (r) => r.channel.categories!.last.value == 'Example category 2',
    'channel_category_empty.xml': (r) => r.channel.categories == null,
    'channel_cloud_domain.xml': (r) => r.channel.cloud!.domain == 'rpc.sys.com',
    'channel_cloud_path.xml': (r) => r.channel.cloud!.path == '/RPC2',
    'channel_cloud_port.xml': (r) => r.channel.cloud!.port == '80',
    'channel_cloud_protocol.xml': (r) => r.channel.cloud!.protocol == 'xml-rpc',
    'channel_cloud_registerProcedure.xml': (r) => r.channel.cloud!.registerProcedure == 'myCloud.rssPleaseNotify',
    'channel_copyright.xml': (r) => r.channel.copyright == 'Example copyright',

    'channel_dc_author.xml': (r) => r.channel.authors!.first.value == 'Example editor',
    'channel_dc_author_map_author_detail_email.xml': (r) => r.channel.authors!.first.email == 'me@example.com',
    'channel_dc_author_map_author_detail_name.xml': (r) => r.channel.authors!.first.name == 'Example editor',
    'channel_dc_contributor.xml': (r) => r.channel.contributors!.first.value == 'Example contributor',
    'channel_dc_creator.xml': (r) => r.channel.authors!.first.value == 'Example editor',
    'channel_dc_creator_map_author_detail_email.xml': (r) => r.channel.authors!.first.email == 'me@example.com',
    'channel_dc_creator_map_author_detail_name.xml': (r) => r.channel.authors!.first.name == 'Example editor',
    'channel_dc_date.xml': (r) => r.channel.updated!.value == '2003-12-31T10:14:55Z',
    'channel_dc_publisher.xml': (r) => r.channel.publisher!.value == 'Example editor',
    'channel_dc_publisher_email.xml': (r) => r.channel.publisher!.email == 'me@example.com',
    'channel_dc_publisher_name.xml': (r) => r.channel.publisher!.name == 'Example editor',
    'channel_dc_rights.xml': (r) => r.channel.copyright == 'Example copyright',
    'channel_dc_subject.xml': (r) => r.channel.categories!.first.label == 'Example category',
    'channel_dc_subject_multiple.xml': (r) => r.channel.categories![1].label == 'Example category 2',
    'channel_dc_title.xml': (r) => r.channel.title == 'Example title',

    'channel_description.xml': (r) => r.channel.description == 'Example description',
    'channel_description_escaped_markup.xml': (r) => r.channel.description == '<p>Example description</p>',
    'channel_description_naked_markup.xml': (r) => r.channel.description == '<p>Example description</p>',
    'channel_description_shorttag.xml': (r) => r.channel.description == '',
    'channel_docs.xml': (r) => r.channel.docs == 'http://www.example.com/',
    'channel_generator.xml': (r) => r.channel.generator == 'Example generator',
    'channel_image_description.xml': (r) => r.channel.image!.description == 'Available in Netscape RSS 0.91',
    'channel_image_height.xml': (r) => r.channel.image!.height == '15',
    'channel_image_link.xml': (r) => r.channel.image!.link == 'http://example.org/link',
    /* 'channel_image_link_bleed.xml': (r) => r.channel.links.length == 1, */
    'channel_image_link_conflict.xml': (r) => r.channel.link?.href == 'http://channel.example.com/',
    'channel_image_title.xml': (r) => r.channel.image!.title == 'Sample image',
    'channel_image_title_conflict.xml': (r) => r.channel.title == 'Real title',
    'channel_image_url.xml': (r) => r.channel.image!.url == 'http://example.org/url',
    'channel_image_width.xml': (r) => r.channel.image!.width == '80',
    'channel_lastbuilddate.xml': (r) => r.channel.updated!.value == 'Sat, 07 Sep 2002 00:00:01 GMT',
    'channel_link.xml': (r) => r.channel.link?.href == 'http://example.com/',
    'channel_managingEditor.xml': (r) => r.channel.authors!.first.value == 'Example editor',
    'channel_managingEditor_map_author_detail_email.xml': (r) => r.channel.authors!.first.email == 'me@example.com',
    'channel_managingEditor_map_author_detail_name.xml': (r) => r.channel.authors!.first.name == 'Example editor',
    'channel_pubdate.xml': (r) => r.channel.published!.value == 'Thu, 01 Jan 2004 19:48:21 GMT',
    'channel_title.xml': (r) => r.channel.title == 'Example feed',
    /* 'channel_title_apos.xml': (r) => r.channel.title == 'Mark&apos;s title', */
    'channel_title_gt.xml': (r) => r.channel.title == '2 > 1',
    'channel_title_lt.xml': (r) => r.channel.title == '1 < 2',
    'channel_ttl.xml': (r) => r.channel.ttl == '60',
    'channel_webmaster.xml': (r) => r.channel.publisher!.value == 'Example editor',
    'channel_webmaster_email.xml': (r) => r.channel.publisher!.name == 'Example editor',
    'channel_webmaster_name.xml': (r) => r.channel.publisher!.email == 'me@example.com',
    /* 'channel_rating.xml': (r) => r.channel.rating == '(PICS-1.1 "http://www.classify.org/safesurf/" 1 r (SS~~000 1))', */
    /* 'channel_language.xml': (r) => r.channel.language == 'en-us', */

    'item_author.xml': (r) => r.entries!.first.authors!.first.value == 'Example editor',
    'item_author_map_author_detail_email.xml': (r) => r.entries!.first.authors!.first.email == 'me@example.com',
    'item_author_map_author_detail_email2.xml': (r) {
      final author = r.entries!.first.authors!.first;
      return author.value == 'Example editor (me@example.com)' &&
          author.name == 'Example editor' &&
          author.email == 'me@example.com';
    },
    'item_author_map_author_detail_email3.xml': (r) {
      final author = r.entries!.first.authors!.first;
      return author.value == 'Example editor (me@example.com)' &&
          author.name == 'Example editor' &&
          author.email == 'me@example.com';
    },
    'item_author_map_author_detail_name.xml': (r) =>
        r.entries!.first.authors!.first.value == 'Example editor (me@example.com)',
    'item_author_map_author_detail_name2.xml': (r) =>
        r.entries!.first.authors!.first.value == 'Example editor (me@example.com)' &&
        r.entries!.first.authors!.first.email == 'me@example.com',
    'item_author_map_author_detail_name3.xml': (r) =>
        r.entries!.first.authors!.first.value == 'Example editor (me@example.com)',
    'item_category.xml': (r) => r.entries!.first.categories!.first.value == 'Example category',
    'item_category_domain.xml': (r) => r.entries!.first.categories!.first.scheme == 'http://www.example.com/',
    'item_category_empty.xml': (r) => r.entries!.first.categories == null,
    'item_category_image.xml': (r) => r.entries!.first.categories!.first.value == 'Example category',
    'item_category_multiple.xml': (r) => r.entries!.last.categories!.last.scheme == 'http://www.example.com/2',
    'item_category_multiple_2.xml': (r) => r.entries!.last.categories!.last.value == 'Example category 2',
    'item_comments.xml': (r) => r.entries!.first.comments == 'http://example.com/',
    'item_content_encoded.xml': (r) => r.entries!.first.content!.first.value == '<p>Example content</p>',
    'item_content_encoded_type.xml': (r) => r.entries!.first.content!.first.type == 'text/html',
    'item_content_encoded_mode.xml': (r) => r.entries!.first.content!.first.value == '<p>Example content</p>',

    'item_dc_author.xml': (r) => r.entries!.first.authors!.first.value == 'Example editor',
    'item_dc_author_map_author_detail_email.xml': (r) => r.entries!.first.authors!.first.email == 'me@example.com',
    'item_dc_author_map_author_detail_name.xml': (r) => r.entries!.first.authors!.first.name == 'Example editor',

    'item_dc_contributor.xml': (r) => r.entries!.first.contributors!.first.value == 'Example contributor',
    'item_dc_creator.xml': (r) => r.entries!.first.authors!.first.value == 'Example editor',
    'item_dc_creator_map_author_detail_email.xml': (r) => r.entries!.first.authors!.first.name == 'Example editor',
    'item_dc_creator_map_author_detail_name.xml': (r) => r.entries!.first.authors!.first.email == 'me@example.com',

    'item_dc_date.xml': (r) => r.entries!.first.updated!.value == '2003-12-31T10:14:55Z',
    'item_dc_description.xml': (r) => r.entries!.first.description == 'Example description',
    'item_dc_publisher.xml': (r) => r.entries!.first.publisher!.value == 'Example editor',
    'item_dc_publisher_email.xml': (r) => r.entries!.first.publisher!.email == 'me@example.com',
    'item_dc_publisher_name.xml': (r) => r.entries!.first.publisher!.name == 'Example editor',
    'item_dc_rights.xml': (r) => r.entries!.first.copyright == 'Example copyright',
    'item_dc_subject.xml': (r) => r.entries!.first.categories!.first.label == 'Example category',
    'item_dc_subject_multiple.xml': (r) => r.entries!.first.categories![1].label == 'Example category 2',
    'item_dc_title.xml': (r) => r.entries!.first.title == 'Example title',

    'item_description.xml': (r) => r.entries!.first.description == 'Example description',
    'item_description_and_summary.xml': (r) =>
        r.entries!.first.description == 'Example description' && r.entries!.first.summary == 'Example summary',
    'item_description_br.xml': (r) =>
        r.entries!.first.description == 'article title<br /><br /> article byline<br/><br/>text of article',
    'item_description_br_shorttag.xml': (r) => r.entries!.first.description == '<b>x</b><br/>',
    'item_description_code_br.xml': (r) => r.entries!.first.description == '<code>&lt;br /></code>',
    'item_description_escaped_markup.xml': (r) => r.entries!.first.description == '<p>Example description</p>',

    'item_description_naked_markup.xml': (r) => r.entries!.first.description == '<p>Example description</p>',
    /* 'item_description_not_a_doctype.xml': (r) => r.items.first.description == '<!\' <a href="foo">', */
    /* 'item_description_not_a_doctype2.xml': (r) => r.items.first.description == '<!\' <a href="foo">', */

    'item_enclosure_length.xml': (r) => r.entries!.first.enclosure!.first.length == '100000',
    'item_enclosure_multiple.xml': (r) {
      final item = r.entries!.first;
      return item.enclosure![1].length == '200000' &&
          item.enclosure![1].type == 'image/gif' &&
          item.enclosure![1].url == 'http://example.com/2';
    },
    'item_enclosure_type.xml': (r) => r.entries!.first.enclosure!.first.type == 'image/jpeg',
    'item_enclosure_url.xml': (r) => r.entries!.first.enclosure!.first.url == 'http://example.com/',

    'item_expirationDate.xml': (r) => r.entries!.first.expired!.value == 'Thu, 01 Jan 2004 19:48:21 GMT',
    'item_expirationDate_multiple_values.xml': (r) =>
        r.entries!.first.expired!.value == 'Thu, 01 Jan 2004 19:48:21 GMT',

    // fullItem ?

    'item_guid.xml': (r) => r.entries!.first.guid == 'http://guid.example.com/',
    'item_guid_conflict_link.xml': (r) => r.entries!.first.link?.href == 'http://link.example.com/',
    'item_guid_isPermaLink_conflict_link.xml': (r) => r.entries!.first.link?.href == 'http://link.example.com/',
    'item_guid_isPermaLink_map_link.xml': (r) => r.entries!.first.link?.href == 'http://guid.example.com/',
    'item_guid_not_permalink_not_url.xml': (r) => r.entries!.first.guid == 'abc',

    'item_image_link_bleed.xml': (r) => r.entries!.first.link?.href == 'http://item.TEST/',
    'item_image_link_conflict.xml': (r) => r.entries!.first.link?.href == 'http://item.TEST/',
    'item_link.xml': (r) => r.entries!.first.link?.href == 'http://example.com/',

    'item_madeup_tags_element.xml': (r) {
      final item = r.entries!.first;
      return item.categories?[0].label == 'category one' &&
          item.categories?[1].label == 'tag one' &&
          item.categories?[2].label == 'tag two';
    },
    'item_multiple_dc_creator.xml': (r) =>
        r.entries!.first.authors!.first.value == 'First Author' &&
        r.entries!.first.authors!.last.value == 'Second Author',
    'item_pubDate.xml': (r) => r.entries!.first.published!.value == 'Thu, 01 Jan 2004 19:48:21 GMT',
    'item_source.xml': (r) => r.entries!.first.source?.title == 'Example source',
    'item_source_url.xml': (r) => r.entries!.first.source?.url == 'http://example.com/',
    'item_summary_and_description.xml': (r) =>
        r.entries!.first.description == 'Example description' && r.entries!.first.summary == 'Example summary',
    'item_title.xml': (r) => r.entries!.first.title == 'Item 1 title',

    'rss_version_090.xml': (r) => r.version == RSSVersion.rss090,
    'rss_version_091_netscape.xml': (r) => r.version == RSSVersion.rss091n,
    'rss_version_091_userland.xml': (r) => r.version == RSSVersion.rss091u,
    'rss_version_092.xml': (r) => r.version == RSSVersion.rss092,
    'rss_version_093.xml': (r) => r.version == RSSVersion.rss093,
    'rss_version_094.xml': (r) => r.version == RSSVersion.rss094,
    'rss_version_20.xml': (r) => r.version == RSSVersion.rss20,
    'rss_version_201.xml': (r) => r.version == RSSVersion.rss20,
    'rss_version_21.xml': (r) => r.version == RSSVersion.rss20,
    'rss_version_missing.xml': (r) => r.version == RSSVersion.rss,

    'channel_hours.xml': (r) {
      if (r.channel.skipHours!.length != 3) {
        // ignore: avoid_print
        print('ERROR: skipHours length do not match');
        return false;
      }
      final values = r.channel.skipHours!.fold<String>('', (acc, h) => '${acc.isEmpty ? '' : '$acc-'}${h.value}');
      if (values != '01-05-23') {
        // ignore: avoid_print
        print('ERROR: skipHours values do not match: $values');
        return false;
      }

      return true;
    },
    'channel_days.xml': (r) {
      if (r.channel.skipDays!.length != 2) {
        // ignore: avoid_print
        print('ERROR: skipDays length do not match');
        return false;
      }
      final values = r.channel.skipDays!.fold<String>('', (acc, h) => '${acc.isEmpty ? '' : '$acc-'}${h.value}');
      if (values != 'Tuesday-Friday') {
        // ignore: avoid_print
        print('ERROR: skipDays values do not match: $values');
        return false;
      }

      return true;
    },

    //----
    'item_category_cdata.xml': (r) => r.entries!.first.categories!.first.value == 'Blog',
  };
}
