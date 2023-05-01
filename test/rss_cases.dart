import 'package:universal_feed/universal_feed.dart';

typedef TestFx = bool Function(UniversalFeed r);

Map<String, TestFx> rssTests() {
  return {
    'rss_version_090.xml': (r) => r.meta.version == '0.90',
    'rss_version_091_netscape.xml': (r) => r.meta.version == '0.91n',
    'rss_version_091_userland.xml': (r) => r.meta.version == '0.91u',
    'rss_version_092.xml': (r) => r.meta.version == '0.92',
    'rss_version_093.xml': (r) => r.meta.version == '0.93',
    'rss_version_094.xml': (r) => r.meta.version == '0.94',
    'rss_version_20.xml': (r) => r.meta.version == '2.0',
    'rss_version_201.xml': (r) => r.meta.version == '2.01',
    'rss_version_21.xml': (r) => r.meta.version == '2.1' && r.namespaces.toString().isNotEmpty,
    'rss_version_missing.xml': (r) => r.meta.version == '',

    'channel_author.xml': (r) {
      if (r.authors.isEmpty) return false;
      return r.authors.first.value == 'Example editor (me@example.com)' && r.authors.first.toString().isNotEmpty;
    },
    'channel_author_map_author_detail_email.xml': (r) {
      if (r.authors.isEmpty) return false;
      return r.authors.first.email == 'me@example.com';
    },
    'channel_author_map_author_detail_email_2.xml': (r) {
      if (r.authors.isEmpty) return false;
      return r.authors.first.email == 'me+spam@example.com';
    },
    'channel_author_map_author_detail_email_3.xml': (r) {
      if (r.authors.isEmpty) return false;
      return r.authors.first.email == 'me@example.com';
    },
    'channel_author_map_author_detail_email_4.xml': (r) {
      if (r.authors.isEmpty) return false;
      return r.authors.first.email == 'me@example.com' &&
          r.authors.first.name.isEmpty &&
          r.authors.first.value == 'me@example.com';
    },
    'channel_author_map_author_detail_name.xml': (r) {
      if (r.authors.isEmpty) return false;
      return r.authors.first.name == 'Example editor';
    },
    'channel_author_map_author_detail_name_2.xml': (r) {
      if (r.authors.isEmpty) return false;
      return r.authors.first.name == 'Example editor';
    },
    'channel_category.xml': (r) {
      if (r.categories.isEmpty) return false;
      return r.categories.first.value == 'Example category';
    },
    'channel_category_domain.xml': (r) {
      if (r.categories.isEmpty) return false;
      return r.categories.first.scheme == 'http://www.example.com/';
    },
    'channel_category_multiple.xml': (r) {
      if (r.categories.isEmpty) return false;
      return r.categories.last.value == 'Example category 2';
    },
    'channel_category_multiple_2.xml': (r) {
      if (r.categories.isEmpty) return false;
      return r.categories.last.value == 'Example category 2';
    },
    'channel_category_empty.xml': (r) => r.categories.isEmpty,
    'channel_copyright.xml': (r) => r.copyright == 'Example copyright',

    'channel_description.xml': (r) => r.description == 'Example description',
    'channel_description_escaped_markup.xml': (r) => r.description == '<p>Example description</p>',
    'channel_description_naked_markup.xml': (r) => r.description == '<p>Example description</p>',
    'channel_description_cdata.xml': (r) => r.description == '<p>Example description</p>',
    'channel_description_shorttag.xml': (r) => r.description == '',
    'channel_docs.xml': (r) => r.docs == 'http://www.example.com/',
    'channel_generator.xml': (r) => r.generator?.name == 'Example generator' && r.generator!.toString().isNotEmpty,
    'channel_image_description.xml': (r) =>
        r.image?.description == 'Available in Netscape RSS 0.91' && r.image!.toString().isNotEmpty,
    'channel_image_height.xml': (r) => r.image?.height == '15',
    'channel_image_link.xml': (r) => r.image?.link == 'http://example.org/link',
    'channel_image_link_bleed.xml': (r) => r.xmlLink?.href == 'http://channel.example.com/',
    'channel_image_link_conflict.xml': (r) => r.xmlLink?.href == 'http://channel.example.com/',
    'channel_image_title.xml': (r) => r.image?.title == 'Sample image',
    'channel_image_title_conflict.xml': (r) => r.title == 'Real title',
    'channel_image_url.xml': (r) => r.image?.url == 'http://example.org/url',
    'channel_image_width.xml': (r) => r.image?.width == '80',
    'channel_lastbuilddate.xml': (r) =>
        r.updated?.value == 'Sat, 07 Sep 2002 00:00:01 GMT' && r.updated.toString().isNotEmpty,
    'channel_link.xml': (r) {
      return r.links.first.href == 'http://example.com/' &&
          r.links.first.type == 'text/html' &&
          r.links.first.rel == LinkRelationType.alternate &&
          r.htmlLink!.href == 'http://example.com/' &&
          r.links.first.toString().isNotEmpty;
    },
    'channel_link_atom.xml': (r) {
      return r.links.first.href == 'http://example.com/' &&
          r.links.first.type == 'text/html' &&
          r.links.first.rel == LinkRelationType.alternate &&
          r.htmlLink!.href == 'http://example.com/' &&
          r.links.last.href == 'https://example.com/feed.xml' &&
          r.links.last.type == 'application/rss+xml' &&
          r.links.last.rel == LinkRelationType.self &&
          r.xmlLink!.href == 'https://example.com/feed.xml';
    },
    'channel_managingEditor.xml': (r) {
      if (r.authors.isEmpty) return false;
      return r.authors.first.value == 'Example editor';
    },
    'channel_managingEditor_map_author_detail_email.xml': (r) {
      if (r.authors.isEmpty) return false;
      return r.authors.first.email == 'me@example.com';
    },
    'channel_managingEditor_map_author_detail_name.xml': (r) {
      if (r.authors.isEmpty) return false;
      return r.authors.first.name == 'Example editor';
    },
    'channel_pubdate.xml': (r) => r.published?.value == 'Thu, 01 Jan 2004 19:48:21 GMT',
    'channel_title.xml': (r) => r.title == 'Example feed',
    'channel_title_apos.xml': (r) => r.title == "Mark's title",
    'channel_title_gt.xml': (r) => r.title == '2 > 1',
    'channel_title_lt.xml': (r) => r.title == '1 < 2',
    'channel_webmaster.xml': (r) {
      if (r.authors.isEmpty) return false;
      return r.authors.first.value == 'Example editor';
    },
    'channel_webmaster_email.xml': (r) {
      if (r.authors.isEmpty) return false;
      return r.authors.first.name == 'Example editor';
    },
    'channel_webmaster_name.xml': (r) {
      if (r.authors.isEmpty) return false;
      return r.authors.first.email == 'me@example.com';
    },
    'channel_language.xml': (r) => r.language == 'en-us',

    // Dublin Core
    'channel_dc_author.xml': (r) {
      if (r.authors.isEmpty) return false;
      return r.authors.first.value == 'Example editor';
    },
    'channel_dc_author_map_author_detail_email.xml': (r) {
      if (r.authors.isEmpty) return false;
      return r.authors.first.email == 'me@example.com';
    },
    'channel_dc_author_map_author_detail_name.xml': (r) {
      if (r.authors.isEmpty) return false;
      return r.authors.first.name == 'Example editor';
    },
    'channel_dc_contributor.xml': (r) => r.authors.first.value == 'Example contributor',
    'channel_dc_creator.xml': (r) {
      if (r.authors.isEmpty) return false;
      return r.authors.first.value == 'Example editor';
    },
    'channel_dc_creator_map_author_detail_email.xml': (r) {
      if (r.authors.isEmpty) return false;
      return r.authors.first.email == 'me@example.com';
    },
    'channel_dc_creator_map_author_detail_name.xml': (r) {
      if (r.authors.isEmpty) return false;
      return r.authors.first.name == 'Example editor';
    },
    'channel_dc_date.xml': (r) => r.updated?.value == '2003-12-31T10:14:55Z',
    'channel_dc_publisher.xml': (r) => r.authors.first.value == 'Example editor',
    'channel_dc_publisher_email.xml': (r) => r.authors.first.email == 'me@example.com',
    'channel_dc_publisher_name.xml': (r) => r.authors.first.name == 'Example editor',
    'channel_dc_rights.xml': (r) => r.copyright == 'Example copyright',
    'channel_dc_subject.xml': (r) {
      if (r.categories.isEmpty) return false;
      return r.categories.first.label == 'Example category';
    },
    'channel_dc_subject_multiple.xml': (r) {
      if (r.categories.isEmpty) return false;
      return r.categories.length == 2 && r.categories[1].label == 'Example category 2';
    },
    'channel_dc_title.xml': (r) => r.title == 'Example title',

    // Rarely used
    // 'channel_cloud_domain.xml': (r) => r.cloud.domain == 'rpc.sys.com',
    // 'channel_cloud_path.xml': (r) => r.cloud.path == '/RPC2',
    // 'channel_cloud_port.xml': (r) => r.cloud.port == '80',
    // 'channel_cloud_protocol.xml': (r) => r.cloud.protocol == 'xml-rpc',
    // 'channel_cloud_registerProcedure.xml': (r) => r.cloud.registerProcedure == 'myCloud.rssPleaseNotify',
    // 'channel_ttl.xml': (r) => r.ttl == '60',
    // 'channel_rating.xml': (r) => r.channel.rating == '(PICS-1.1 "http://www.classify.org/safesurf/" 1 r (SS~~000 1))',

    // ITEMS

    'item_description.xml': (r) => r.items.first.description == 'Example description',
    'item_description_br.xml': (r) =>
        r.items.first.description == 'article title<br /><br /> article byline<br/><br/>text of article',
    'item_description_br_shorttag.xml': (r) => r.items.first.description == '<b>x</b><br/>',
    'item_description_code_br.xml': (r) => r.items.first.description == '<code>&lt;br /></code>',
    'item_description_escaped_markup.xml': (r) => r.items.first.description == '<p>Example description</p>',
    // 'item_description_naked_markup.xml': (r) => r.items.first.description == '<p>Example description</p>',
    // 'item_description_not_a_doctype.xml': (r) => r.items.first.description == '<!\' <a href="foo">',
    // 'item_description_not_a_doctype2.xml': (r) => r.items.first.description == '<!\' <a href="foo">',

    'item_author.xml': (r) => r.items.first.authors.first.value == 'Example editor',
    'item_author_map_author_detail_email.xml': (r) => r.items.first.authors.first.email == 'me@example.com',
    'item_author_map_author_detail_email2.xml': (r) {
      final author = r.items.first.authors.first;
      return author.value == 'Example editor (me@example.com)' &&
          author.name == 'Example editor' &&
          author.email == 'me@example.com';
    },
    'item_author_map_author_detail_email3.xml': (r) {
      final author = r.items.first.authors.first;
      return author.value == 'Example editor (me@example.com)' &&
          author.name == 'Example editor' &&
          author.email == 'me@example.com';
    },
    'item_author_map_author_detail_name.xml': (r) =>
        r.items.first.authors.first.value == 'Example editor (me@example.com)',
    'item_author_map_author_detail_name2.xml': (r) =>
        r.items.first.authors.first.value == 'Example editor (me@example.com)' &&
        r.items.first.authors.first.email == 'me@example.com',
    'item_author_map_author_detail_name3.xml': (r) =>
        r.items.first.authors.first.value == 'Example editor (me@example.com)',
    'item_category.xml': (r) => r.items.first.categories.first.value == 'Example category',
    'item_category_domain.xml': (r) => r.items.first.categories.first.scheme == 'http://www.example.com/',
    'item_category_empty.xml': (r) => r.items.first.categories.isEmpty,
    'item_category_image.xml': (r) => r.items.first.categories.first.value == 'Example category',
    'item_category_multiple.xml': (r) => r.items.last.categories.last.scheme == 'http://www.example.com/2',
    'item_category_multiple_2.xml': (r) => r.items.last.categories.last.value == 'Example category 2',
    'item_category_cdata.xml': (r) => r.items.first.categories.first.value == 'Blog',
    'item_comments.xml': (r) => r.items.first.comments?.href == 'http://example.com/',
    'item_content_encoded.xml': (r) => r.items.first.content.first.value == '<p>Example content</p>',
    'item_content_encoded_type.xml': (r) => r.items.first.content.first.type == 'text',
    'item_content_encoded_mode.xml': (r) =>
        r.items.first.content.first.value == '<p>Example content</p>' &&
        r.items.first.content.first.toString().isNotEmpty,

    'item_enclosure_length.xml': (r) => r.items.first.enclosures.first.length == '100000',
    'item_enclosure_multiple.xml': (r) {
      final item = r.items.first;
      return item.enclosures[1].length == '200000' &&
          item.enclosures[1].type == 'image/gif' &&
          item.enclosures[1].url == 'http://example.com/2';
    },
    'item_enclosure_type.xml': (r) => r.items.first.enclosures.first.type == 'image/jpeg',
    'item_enclosure_url.xml': (r) => r.items.first.enclosures.first.url == 'http://example.com/',

    'item_guid.xml': (r) => r.items.first.guid == 'http://guid.example.com/',
    'item_guid_conflict_link.xml': (r) => r.items.first.link?.href == 'http://link.example.com/',
    'item_guid_isPermaLink_conflict_link.xml': (r) => r.items.first.links.first.href == 'http://link.example.com/',
    'item_guid_isPermaLink_map_link.xml': (r) => r.items.first.link?.href == 'http://guid.example.com/',
    'item_guid_not_permalink_not_url.xml': (r) => r.items.first.guid == 'abc',

    'item_image_link_bleed.xml': (r) => r.items.first.link?.href == 'http://item.TEST/',
    'item_image_link_conflict.xml': (r) => r.items.first.link?.href == 'http://item.TEST/',
    'item_link.xml': (r) => r.items.first.link?.href == 'http://example.com/',

    'item_pubDate.xml': (r) => r.items.first.published?.value == 'Thu, 01 Jan 2004 19:48:21 GMT',
    'item_source.xml': (r) => r.items.first.source?.title == 'Example source',
    'item_source_url.xml': (r) => r.items.first.source?.href == 'http://example.com/',
    'item_title.xml': (r) => r.items.first.title == 'Item 1 title',

    // Dublin Core
    'item_dc_author.xml': (r) => r.items.first.authors.first.value == 'Example editor',
    'item_dc_author_map_author_detail_email.xml': (r) => r.items.first.authors.first.email == 'me@example.com',
    'item_dc_author_map_author_detail_name.xml': (r) => r.items.first.authors.first.name == 'Example editor',
    'item_dc_contributor.xml': (r) => r.items.first.authors.first.value == 'Example contributor',
    'item_dc_creator.xml': (r) => r.items.first.authors.first.value == 'Example editor',
    'item_dc_creator_map_author_detail_email.xml': (r) => r.items.first.authors.first.name == 'Example editor',
    'item_dc_creator_map_author_detail_name.xml': (r) => r.items.first.authors.first.email == 'me@example.com',
    'item_multiple_dc_creator.xml': (r) =>
        r.items.first.authors.first.value == 'First Author' && r.items.first.authors.last.value == 'Second Author',
    'item_dc_date.xml': (r) => r.items.first.updated?.value == '2003-12-31T10:14:55Z',
    'item_dc_description.xml': (r) => r.items.first.description == 'Example description',
    'item_dc_publisher.xml': (r) => r.items.first.authors.first.name == 'Example editor',
    'item_dc_publisher_email.xml': (r) => r.items.first.authors.first.email == 'me@example.com',
    'item_dc_publisher_name.xml': (r) => r.items.first.authors.first.name == 'Example editor',
    // 'item_dc_rights.xml': (r) => r.items.first.copyright == 'Example copyright',
    // 'item_dc_subject.xml': (r) => r.entries!.first.categories!.first.label == 'Example category',
    // 'item_dc_subject_multiple.xml': (r) => r.entries!.first.categories![1].label == 'Example category 2',
    'item_dc_title.xml': (r) => r.items.first.title == 'Example title',
  };
}
