import 'package:universal_feed/universal_feed.dart';

typedef TestFx = bool Function(UniversalFeed r);

Map<String, TestFx> atomTests() {
  return {
    'atom_namespace_1.xml': (r) => r.meta.version == '0.3',
    'feed_author_email.xml': (r) => r.authors.first.email == 'me@example.com',
    'feed_title.xml': (r) => r.title == 'Example Atom',
    'feed_title_base64.xml': (r) => r.title == 'Example <b>Atom</b>',
    'feed_title_base64_2.xml': (r) => r.title == '<p>History of the &lt;blink&gt; tag</p>',
    'feed_title_content_mode_base64.xml': (r) => r.title == 'Example <b>Atom</b>',
    'feed_title_content_mode_escaped.xml': (r) => r.title == 'Example <b>Atom</b>',
    'feed_title_escaped_markup.xml': (r) => r.title == 'Example <b>Atom</b>',
    'feed_title_content_type.xml': (r) => r.title == 'Example Atom',
    'feed_title_inline_markup.xml': (r) =>
        r.title == '<div xmlns="http://www.w3.org/1999/xhtml">Example <b>Atom</b></div>',
    'feed_title_inline_markup_2.xml': (r) =>
        r.title == '<div xmlns="http://www.w3.org/1999/xhtml">History of the &lt;blink> tag</div>',
    'feed_title_naked_markup.xml': (r) => r.title == 'Example <b>Atom</b>',
    'feed_title_text_plain.xml': (r) => r.title == 'Example Atom',
    'feed_link_alternate_map_link.xml': (r) => r.links.first.href == 'http://www.example.com/',
    'feed_link_alternate_map_link_2.xml': (r) => r.links.first.href == 'http://www.example.com/',
    'feed_link_href.xml': (r) => r.links.first.href == 'http://www.example.com/',
    'feed_link_multiple.xml': (r) =>
        r.links.first.href == 'http://www.example.com/' && r.links.last.href == 'http://www.example.com/post',
    'feed_link_rel.xml': (r) => r.links.first.rel == LinkRelationType.alternate,
    'feed_link_title.xml': (r) => r.links.first.title == 'Example title',
    'feed_link_type.xml': (r) => r.links.first.type == 'text/html',
    'feed_contributor_email.xml': (r) => r.authors.first.email == 'me@example.com',
    // 'feed_contributor_homepage.xml': (r) => r.authors.first.url == 'http://example.com/',
    'feed_contributor_multiple.xml': (r) {
      final one = r.authors.first;
      final two = r.authors.last;
      return one.name == 'Contributor 1' &&
          one.url == 'http://example.com/' &&
          one.email == 'me@example.com' &&
          two.name == 'Contributor 2' &&
          two.url == 'http://two.example.com/' &&
          two.email == 'you@example.com';
    },
    'feed_contributor_name.xml': (r) => r.authors.first.name == 'Example contributor',
    'feed_contributor_uri.xml': (r) => r.authors.first.url == 'http://example.com/',
    'feed_contributor_url.xml': (r) => r.authors.first.url == 'http://example.com/',
    'feed_copyright.xml': (r) => r.copyright == 'Example Atom',
    'feed_copyright_base64.xml': (r) => r.copyright == 'Example <b>Atom</b>',
    'feed_copyright_base64_2.xml': (r) => r.copyright == '<p>History of the &lt;blink&gt; tag</p>',
    'feed_copyright_content_mode_base64.xml': (r) => r.copyright == 'Example <b>Atom</b>',
    'feed_copyright_content_mode_escaped.xml': (r) => r.copyright == 'Example <b>Atom</b>',
    'feed_copyright_content_type.xml': (r) => r.copyright == 'Example Atom',
    'feed_copyright_content_type_text_plain.xml': (r) => r.copyright == 'Example Atom',
    'feed_copyright_content_value.xml': (r) => r.copyright == 'Example Atom',
    'feed_copyright_escaped_markup.xml': (r) => r.copyright == 'Example <b>Atom</b>',
    'feed_copyright_inline_markup.xml': (r) =>
        r.copyright == '<div xmlns="http://www.w3.org/1999/xhtml">Example <b>Atom</b>\n    </div>',
    'feed_copyright_inline_markup_2.xml': (r) =>
        r.copyright == '<div xmlns="http://www.w3.org/1999/xhtml">History of the &lt;blink> tag</div>',
    'feed_copyright_naked_markup.xml': (r) => r.copyright == 'Example Atom',
    'feed_copyright_text_plain.xml': (r) => r.copyright == 'Example Atom',
    'feed_generator.xml': (r) => r.generator!.name == 'Example generator',
    'feed_generator_name.xml': (r) => r.generator!.name == 'Example generator',
    'feed_generator_url.xml': (r) => r.generator!.url == 'http://example.com/',
    'feed_generator_version.xml': (r) => r.generator!.version == '2.65',
    'feed_id.xml': (r) => r.guid == 'http://example.com/',
    'feed_id_map_guid.xml': (r) => r.guid == 'http://example.com/',
    'feed_modified.xml': (r) => r.updated?.value == 'Thu, 01 Jan 2004 19:48:21 GMT',
    'entry_author_email.xml': (r) => r.items.first.authors.first.email == 'me@example.com',
    'entry_author_map_author_2.xml': (r) => r.items.first.authors.first.name == 'Example author',
    'entry_author_name.xml': (r) => r.items.first.authors.first.name == 'Example author',
    'entry_author_uri.xml': (r) => r.items.first.authors.first.url == 'http://example.com/',
    'entry_author_url.xml': (r) => r.items.first.authors.first.url == 'http://example.com/',
    'entry_content_mode_base64.xml': (r) => r.items.first.content.first.value == 'Example <b>Atom</b>',
    'entry_content_mode_escaped.xml': (r) => r.items.first.content.first.value == 'Example <b>Atom</b>',
    'entry_content_type.xml': (r) => r.items.first.content.first.value == 'Example Atom',
    'entry_content_type_text_plain.xml': (r) => r.items.first.content.first.value == 'Example Atom',
    'entry_content_value.xml': (r) => r.items.first.content.first.value == 'Example Atom',
    'entry_contributor_email.xml': (r) {
      final contributor = r.items.first.authors.first;
      return contributor.email == 'me@example.com' && contributor.type == AuthorType.contributor;
    },
    'entry_contributor_multiple.xml': (r) {
      final one = r.items.first.authors.first;
      final two = r.items.first.authors.last;
      return one.name == 'Contributor 1' &&
          one.url == 'http://example.com/' &&
          one.email == 'me@example.com' &&
          two.name == 'Contributor 2' &&
          two.url == 'http://two.example.com/' &&
          two.email == 'you@example.com';
    },
    'entry_contributor_name.xml': (r) => r.items.first.authors.first.name == 'Example contributor',
    'entry_contributor_uri.xml': (r) => r.items.first.authors.first.url == 'http://example.com/',
    'entry_contributor_url.xml': (r) => r.items.first.authors.first.url == 'http://example.com/',
    'entry_created.xml': (r) => r.items.first.published?.value == 'Thu, 01 Jan 2004 19:48:21 GMT',
    'entry_id.xml': (r) => r.items.first.guid == 'http://example.com/',
    'entry_id_map_guid.xml': (r) => r.items.first.guid == 'http://example.com/',
    'entry_issued.xml': (r) => r.items.first.updated?.value == 'Thu, 01 Jan 2004 19:48:21 GMT',
    'entry_link_alternate_map_link.xml': (r) => r.items.first.links.first.href == 'http://www.example.com/',
    'entry_link_alternate_map_link_2.xml': (r) => r.items.first.links.first.href == 'http://www.example.com/',
    'entry_link_href.xml': (r) => r.items.first.links.first.href == 'http://www.example.com/',
    'entry_link_multiple.xml': (r) =>
        r.items.first.links.first.href == 'http://www.example.com/' &&
        r.items.first.links.last.href == 'http://www.example.com/post',
    'entry_link_rel.xml': (r) => r.items.first.links.first.rel == LinkRelationType.alternate,
    'entry_link_title.xml': (r) => r.items.first.links.first.title == 'Example title',
    'entry_link_type.xml': (r) => r.items.first.links.first.type == 'text/html',
    'entry_modified.xml': (r) => r.items.first.updated?.value == 'Thu, 01 Jan 2004 19:48:21 GMT',
    'entry_summary.xml': (r) => r.items.first.description == 'Example Atom',
    'entry_summary_base64.xml': (r) => r.items.first.description == 'Example <b>Atom</b>',
    'entry_summary_base64_2.xml': (r) => r.items.first.description == '<p>History of the &lt;blink&gt; tag</p>',
    'entry_summary_content_mode_base64.xml': (r) => r.items.first.description == 'Example <b>Atom</b>',
    'entry_summary_content_mode_escaped.xml': (r) => r.items.first.description == 'Example <b>Atom</b>',
    'entry_summary_escaped_markup.xml': (r) => r.items.first.description == 'Example <b>Atom</b>',
    'entry_summary_content_type.xml': (r) => r.items.first.description == 'Example Atom',
    'entry_summary_inline_markup.xml': (r) =>
        r.items.first.description == '<div xmlns="http://www.w3.org/1999/xhtml">Example <b>Atom</b></div>',
    'entry_summary_inline_markup_2.xml': (r) =>
        r.items.first.description == '<div xmlns="http://www.w3.org/1999/xhtml">History of the &lt;blink> tag</div>',
    'entry_summary_naked_markup.xml': (r) => r.items.first.description == 'Example Atom',
    'entry_summary_text_plain.xml': (r) => r.items.first.description == 'Example Atom',
    'entry_title.xml': (r) => r.items.first.title == 'Example Atom',
    'entry_title_base64.xml': (r) => r.items.first.title == 'Example <b>Atom</b>',
    'entry_title_base64_2.xml': (r) => r.items.first.title == '<p>History of the &lt;blink&gt; tag</p>',
    'entry_title_content_mode_base64.xml': (r) => r.items.first.title == 'Example <b>Atom</b>',
    'entry_title_content_mode_escaped.xml': (r) => r.items.first.title == 'Example <b>Atom</b>',
    'entry_title_escaped_markup.xml': (r) => r.items.first.title == 'Example <b>Atom</b>',
    'entry_title_content_type.xml': (r) => r.items.first.title == 'Example Atom',
    'entry_title_inline_markup.xml': (r) =>
        r.items.first.title == '<div xmlns="http://www.w3.org/1999/xhtml">Example <b>Atom</b></div>',
    'entry_title_inline_markup_2.xml': (r) =>
        r.items.first.title == '<div xmlns="http://www.w3.org/1999/xhtml">History of the &lt;blink> tag</div>',
    'entry_title_naked_markup.xml': (r) => r.items.first.title == 'Example Atom',
    'entry_title_text_plain.xml': (r) => r.items.first.title == 'Example Atom',
  };
}
