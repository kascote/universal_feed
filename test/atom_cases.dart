// import 'package:universal_feed/universal_feed.dart';

// typedef TestFx = bool Function(Atom r);

// Map<String, TestFx> atomTests() {
//   return {
//     'atom_namespace_1.xml': (r) => r.version == AtomVersion.v03,
//     'feed_author_email.xml': (r) => r.head.authors!.first.email == 'me@example.com',
//     'feed_title.xml': (r) => r.head.title == 'Example Atom',
//     'feed_title_base64.xml': (r) => r.head.title == 'Example <b>Atom</b>',
//     'feed_title_base64_2.xml': (r) => r.head.title == '<p>History of the &lt;blink&gt; tag</p>',
//     'feed_title_content_mode_base64.xml': (r) => r.head.title == 'Example <b>Atom</b>',
//     'feed_title_content_mode_escaped.xml': (r) => r.head.title == 'Example <b>Atom</b>',
//     'feed_title_escaped_markup.xml': (r) => r.head.title == 'Example <b>Atom</b>',
//     'feed_title_content_type.xml': (r) => r.head.title == 'Example Atom',
//     'feed_title_inline_markup.xml': (r) =>
//         r.head.title == '<div xmlns="http://www.w3.org/1999/xhtml">Example <b>Atom</b></div>',
//     'feed_title_inline_markup_2.xml': (r) =>
//         r.head.title == '<div xmlns="http://www.w3.org/1999/xhtml">History of the &lt;blink> tag</div>',
//     'feed_title_naked_markup.xml': (r) => r.head.title == 'Example <b>Atom</b>',
//     'feed_title_text_plain.xml': (r) => r.head.title == 'Example Atom',
//     'feed_link_alternate_map_link.xml': (r) => r.head.links!.first.href == 'http://www.example.com/',
//     'feed_link_alternate_map_link_2.xml': (r) => r.head.links!.first.href == 'http://www.example.com/',
//     'feed_link_href.xml': (r) => r.head.links!.first.href == 'http://www.example.com/',
//     'feed_link_multiple.xml': (r) =>
//         r.head.links!.first.href == 'http://www.example.com/' &&
//         r.head.links!.last.href == 'http://www.example.com/post',
//     'feed_link_rel.xml': (r) => r.head.links!.first.rel == 'alternate',
//     'feed_link_title.xml': (r) => r.head.links!.first.title == 'Example title',
//     'feed_link_type.xml': (r) => r.head.links!.first.type == 'text/html',
//     'feed_contributor_email.xml': (r) => r.head.contributors!.first.email == 'me@example.com',
//     'feed_contributor_homepage.xml': (r) => r.head.contributors!.first.url == 'http://example.com/',
//     'feed_contributor_multiple.xml': (r) {
//       final one = r.head.contributors!.first;
//       final two = r.head.contributors!.last;
//       return one.name == 'Contributor 1' &&
//           one.url == 'http://example.com/' &&
//           one.email == 'me@example.com' &&
//           two.name == 'Contributor 2' &&
//           two.url == 'http://two.example.com/' &&
//           two.email == 'you@example.com';
//     },
//     'feed_contributor_name.xml': (r) => r.head.contributors!.first.name == 'Example contributor',
//     'feed_contributor_uri.xml': (r) => r.head.contributors!.first.url == 'http://example.com/',
//     'feed_contributor_url.xml': (r) => r.head.contributors!.first.url == 'http://example.com/',
//     /* 'feed_copyright.xml': (r) => r.head.copyright == 'Example Atom', */
//     /* 'feed_copyright_base64.xml': (r) => r.head.copyright == 'Example <b>Atom</b>', */
//     /* 'feed_copyright_base64_2.xml': (r) => r.head.copyright == '<p>History of the &lt;blink&gt; tag</p>', */
//     /* 'feed_copyright_content_mode_base64.xml': (r) => r.head.copyright == 'Example <b>Atom</b>', */
//     /* 'feed_copyright_content_mode_escaped.xml': (r) => r.head.copyright == 'Example <b>Atom</b>', */
//     /* 'feed_copyright_content_type.xml': (r) => r.head.copyright == 'Example Atom', */
//     /* 'feed_copyright_content_type_text_plain.xml': (r) => r.head.copyright == 'Example Atom', */
//     /* 'feed_copyright_content_value.xml': (r) => r.head.copyright == 'Example Atom', */
//     /* 'feed_copyright_escaped_markup.xml': (r) => r.head.copyright == 'Example <b>Atom</b>', */
//     /* 'feed_copyright_inline_markup.xml': (r) => */
//     /*     r.head.copyright == '<div xmlns="http://www.w3.org/1999/xhtml">Example <b>Atom</b></div>', */
//     /* 'feed_copyright_inline_markup_2.xml': (r) => */
//     /*     r.head.copyright == '<div xmlns="http://www.w3.org/1999/xhtml">History of the &lt;blink> tag</div>', */
//     /* 'feed_copyright_naked_markup.xml': (r) => r.head.copyright == 'Example <b>Atom</b>', */
//     /* 'feed_copyright_text_plain.xml': (r) => r.head.copyright == 'Example Atom', */
//     'feed_generator.xml': (r) => r.head.generator!.name == 'Example generator',
//     'feed_generator_name.xml': (r) => r.head.generator!.name == 'Example generator',
//     'feed_generator_url.xml': (r) => r.head.generator!.url == 'http://example.com/',
//     'feed_generator_version.xml': (r) => r.head.generator!.version == '2.65',
//     'feed_id.xml': (r) => r.head.id == 'http://example.com/',
//     'feed_id_map_guid.xml': (r) => r.head.guid == 'http://example.com/',
//     'feed_info.xml': (r) => r.head.info == 'Example Atom',
//     'feed_info_base64.xml': (r) => r.head.info == 'Example <b>Atom</b>',
//     'feed_info_base64_2.xml': (r) => r.head.info == '<p>History of the &lt;blink&gt; tag</p>',
//     'feed_info_content_mode_base64.xml': (r) => r.head.info == 'Example <b>Atom</b>',
//     'feed_info_content_mode_escaped.xml': (r) => r.head.info == 'Example <b>Atom</b>',
//     'feed_info_escaped_markup.xml': (r) => r.head.info == 'Example <b>Atom</b>',
//     'feed_info_content_type.xml': (r) => r.head.info == 'Example Atom',
//     'feed_info_inline_markup.xml': (r) =>
//         r.head.info == '<div xmlns="http://www.w3.org/1999/xhtml">Example <b>Atom</b></div>',
//     'feed_info_inline_markup_2.xml': (r) =>
//         r.head.info == '<div xmlns="http://www.w3.org/1999/xhtml">History of the &lt;blink> tag</div>',
//     'feed_info_naked_markup.xml': (r) => r.head.info == 'Example <b>Atom</b>',
//     'feed_info_text_plain.xml': (r) => r.head.info == 'Example Atom',
//     'feed_modified.xml': (r) => r.head.updated == 'Thu, 01 Jan 2004 19:48:21 GMT',
//     'feed_tagline.xml': (r) => r.head.tagline == 'Example Atom',
//     'feed_tagline_base64.xml': (r) => r.head.tagline == 'Example <b>Atom</b>',
//     'feed_tagline_base64_2.xml': (r) => r.head.tagline == '<p>History of the &lt;blink&gt; tag</p>',
//     'feed_tagline_content_mode_base64.xml': (r) => r.head.tagline == 'Example <b>Atom</b>',
//     'feed_tagline_content_mode_escaped.xml': (r) => r.head.tagline == 'Example <b>Atom</b>',
//     'feed_tagline_escaped_markup.xml': (r) => r.head.tagline == 'Example <b>Atom</b>',
//     'feed_tagline_content_type.xml': (r) => r.head.tagline == 'Example Atom',
//     'feed_tagline_inline_markup.xml': (r) =>
//         r.head.tagline == '<div xmlns="http://www.w3.org/1999/xhtml">Example <b>Atom</b></div>',
//     'feed_tagline_inline_markup_2.xml': (r) =>
//         r.head.tagline == '<div xmlns="http://www.w3.org/1999/xhtml">History of the &lt;blink> tag</div>',
//     'feed_tagline_naked_markup.xml': (r) => r.head.tagline == 'Example <b>Atom</b>',
//     'feed_tagline_text_plain.xml': (r) => r.head.tagline == 'Example Atom',
//     'entry_author_email.xml': (r) => r.entries!.first.authors!.first.email == 'me@example.com',
//     'entry_author_homepage.xml': (r) => r.entries!.first.authors!.first.url == 'http://example.com/',
//     'entry_author_map_author_2.xml': (r) => r.entries!.first.authors!.first.name == 'Example author',
//     'entry_author_name.xml': (r) => r.entries!.first.authors!.first.name == 'Example author',
//     'entry_author_uri.xml': (r) => r.entries!.first.authors!.first.url == 'http://example.com/',
//     'entry_author_url.xml': (r) => r.entries!.first.authors!.first.url == 'http://example.com/',
//     'entry_content_mode_base64.xml': (r) => r.entries!.first.content!.first.value == 'Example <b>Atom</b>',
//     'entry_content_mode_escaped.xml': (r) => r.entries!.first.content!.first.value == 'Example <b>Atom</b>',
//     'entry_content_type.xml': (r) => r.entries!.first.content!.first.value == 'Example Atom',
//     'entry_content_type_text_plain.xml': (r) => r.entries!.first.content!.first.value == 'Example Atom',
//     'entry_content_value.xml': (r) => r.entries!.first.content!.first.value == 'Example Atom',
//     'entry_contributor_email.xml': (r) => r.entries!.first.contributors!.first.email == 'me@example.com',
//     'entry_contributor_homepage.xml': (r) => r.entries!.first.contributors!.first.url == 'http://example.com/',
//     'entry_contributor_multiple.xml': (r) {
//       final one = r.entries!.first.contributors!.first;
//       final two = r.entries!.first.contributors!.last;
//       return one.name == 'Contributor 1' &&
//           one.url == 'http://example.com/' &&
//           one.email == 'me@example.com' &&
//           two.name == 'Contributor 2' &&
//           two.url == 'http://two.example.com/' &&
//           two.email == 'you@example.com';
//     },
//     'entry_contributor_name.xml': (r) => r.entries!.first.contributors!.first.name == 'Example contributor',
//     'entry_contributor_uri.xml': (r) => r.entries!.first.contributors!.first.url == 'http://example.com/',
//     'entry_contributor_url.xml': (r) => r.entries!.first.contributors!.first.url == 'http://example.com/',
//     'entry_created.xml': (r) => r.entries!.first.created?.value == 'Thu, 01 Jan 2004 19:48:21 GMT',
//     'entry_id.xml': (r) => r.entries!.first.id == 'http://example.com/',
//     'entry_id_map_guid.xml': (r) => r.entries!.first.id == 'http://example.com/',
//     'entry_issued.xml': (r) => r.entries!.first.published?.value == 'Thu, 01 Jan 2004 19:48:21 GMT',
//     'entry_link_alternate_map_link.xml': (r) => r.entries!.first.links!.first.href == 'http://www.example.com/',
//     'entry_link_alternate_map_link_2.xml': (r) => r.entries!.first.links!.first.href == 'http://www.example.com/',
//     'entry_link_href.xml': (r) => r.entries!.first.links!.first.href == 'http://www.example.com/',
//     'entry_link_multiple.xml': (r) =>
//         r.entries!.first.links!.first.href == 'http://www.example.com/' &&
//         r.entries!.first.links!.last.href == 'http://www.example.com/post',
//     'entry_link_rel.xml': (r) => r.entries!.first.links!.first.rel == 'alternate',
//     'entry_link_title.xml': (r) => r.entries!.first.links!.first.title == 'Example title',
//     'entry_link_type.xml': (r) => r.entries!.first.links!.first.type == 'text/html',
//     'entry_modified.xml': (r) => r.entries!.first.updated?.value == 'Thu, 01 Jan 2004 19:48:21 GMT',
//     'entry_published_parsed_date_overwriting.xml': (r) =>
//         r.entries!.first.published?.value == 'Sat, 01 Jan 2010 19:48:21 GMT',
//     'entry_summary.xml': (r) => r.entries!.first.summary == 'Example Atom',
//     'entry_summary_base64.xml': (r) => r.entries!.first.summary == 'Example <b>Atom</b>',
//     'entry_summary_base64_2.xml': (r) => r.entries!.first.summary == '<p>History of the &lt;blink&gt; tag</p>',
//     'entry_summary_content_mode_base64.xml': (r) => r.entries!.first.summary == 'Example <b>Atom</b>',
//     'entry_summary_content_mode_escaped.xml': (r) => r.entries!.first.summary == 'Example <b>Atom</b>',
//     'entry_summary_escaped_markup.xml': (r) => r.entries!.first.summary == 'Example <b>Atom</b>',
//     'entry_summary_content_type.xml': (r) => r.entries!.first.summary == 'Example Atom',
//     'entry_summary_inline_markup.xml': (r) =>
//         r.entries!.first.summary == '<div xmlns="http://www.w3.org/1999/xhtml">Example <b>Atom</b></div>',
//     'entry_summary_inline_markup_2.xml': (r) =>
//         r.entries!.first.summary == '<div xmlns="http://www.w3.org/1999/xhtml">History of the &lt;blink> tag</div>',
//     'entry_summary_naked_markup.xml': (r) => r.entries!.first.summary == 'Example <b>Atom</b>',
//     'entry_summary_text_plain.xml': (r) => r.entries!.first.summary == 'Example Atom',
//     'entry_title.xml': (r) => r.entries!.first.title == 'Example Atom',
//     'entry_title_base64.xml': (r) => r.entries!.first.title == 'Example <b>Atom</b>',
//     'entry_title_base64_2.xml': (r) => r.entries!.first.title == '<p>History of the &lt;blink&gt; tag</p>',
//     'entry_title_content_mode_base64.xml': (r) => r.entries!.first.title == 'Example <b>Atom</b>',
//     'entry_title_content_mode_escaped.xml': (r) => r.entries!.first.title == 'Example <b>Atom</b>',
//     'entry_title_escaped_markup.xml': (r) => r.entries!.first.title == 'Example <b>Atom</b>',
//     'entry_title_content_type.xml': (r) => r.entries!.first.title == 'Example Atom',
//     'entry_title_inline_markup.xml': (r) =>
//         r.entries!.first.title == '<div xmlns="http://www.w3.org/1999/xhtml">Example <b>Atom</b></div>',
//     'entry_title_inline_markup_2.xml': (r) =>
//         r.entries!.first.title == '<div xmlns="http://www.w3.org/1999/xhtml">History of the &lt;blink> tag</div>',
//     'entry_title_naked_markup.xml': (r) => r.entries!.first.title == 'Example <b>Atom</b>',
//     'entry_title_text_plain.xml': (r) => r.entries!.first.title == 'Example Atom',
//   };
// }
