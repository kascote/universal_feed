import 'package:universal_feed/universal_feed.dart';

typedef TestFx = bool Function(UniversalFeed r);

Map<String, TestFx> atom10Tests() {
  return {
    'atom10_version.xml': (r) => r.meta.version == '1.0',
    'entry_author_email.xml': (r) => r.items.first.authors.first.email == 'me@example.com',
    'entry_author_map_author_2.xml': (r) => r.items.first.authors.first.name == 'Example author',
    'entry_author_name.xml': (r) => r.items.first.authors.first.name == 'Example author',
    'entry_author_uri.xml': (r) => r.items.first.authors.first.url == 'http://example.com/',
    'entry_author_url.xml': (r) => r.items.first.authors.first.url == 'http://example.com/',
    'entry_authors_email.xml': (r) =>
        r.items.first.authors.first.email == 'one@one.com' && r.items.first.authors.last.email == 'two@two.com',
    'entry_authors_name.xml': (r) =>
        r.items.first.authors.first.name == 'one' && r.items.first.authors.last.name == 'two',
    'entry_authors_uri.xml': (r) =>
        r.items.first.authors.first.url == 'http://one.com/' && r.items.first.authors.last.url == 'http://two.com/',
    'entry_authors_url.xml': (r) =>
        r.items.first.authors.first.url == 'http://one.com/' && r.items.first.authors.last.url == 'http://two.com/',
    'entry_category_label.xml': (r) => r.items.first.categories.first.label == 'Atom 1.0 tests',
    'entry_category_scheme.xml': (r) => r.items.first.categories.first.scheme == 'http://feedparser.org/tests/',
    'entry_category_term.xml': (r) => r.items.first.categories.first.term == 'atom10',
    'entry_category_term_non_ascii.xml': (r) => r.items.first.categories.first.term == 'Freiräume',
    'entry_content_application_xml.xml': (r) =>
        r.items.first.content.first.value == '<div xmlns="http://www.w3.org/1999/xhtml">Example <b>Atom</b></div>',
    'entry_content_base64.xml': (r) => r.items.first.content.first.value == 'Example <b>Atom</b>',
    'entry_content_base64_2.xml': (r) => r.items.first.content.first.value == '<p>History of the &lt;blink&gt; tag</p>',
    'entry_content_div_escaped_markup.xml': (r) => r.items.first.content.first.value == 'Example <b>Atom</b>',
    'entry_content_escaped_markup.xml': (r) => r.items.first.content.first.value == 'Example <b>Atom</b>',
    'entry_content_inline_markup.xml': (r) =>
        r.items.first.content.first.value == '<div xmlns="http://www.w3.org/1999/xhtml">Example <b>Atom</b></div>',
    'entry_content_inline_markup_2.xml': (r) =>
        r.items.first.content.first.value ==
        '<div xmlns="http://www.w3.org/1999/xhtml">History of the &lt;blink> tag</div>',
    'entry_content_src.xml': (r) => r.items.first.content.first.src == 'http://example.com/movie.mp4',
    'entry_content_text_plain.xml': (r) => r.items.first.content.first.value == 'Example Atom',
    'entry_content_text_plain_brackets.xml': (r) => r.items.first.content.first.value == 'History of the <blink> tag',
    'entry_content_type.xml': (r) => r.items.first.content.first.value == 'Example Atom',
    'entry_content_type_text.xml': (r) => r.items.first.content.first.value == 'Example Atom',
    'entry_content_value.xml': (r) => r.items.first.content.first.value == 'Example Atom',
    'entry_contributor_email.xml': (r) => r.items.first.authors.first.email == 'me@example.com',
    'entry_contributor_multiple.xml': (r) {
      final one = r.items.first.authors.first;
      final two = r.items.first.authors.last;
      return one.name == 'Contributor 1' &&
          one.url == 'http://example.com/' &&
          one.email == 'me@example.com' &&
          one.type == AuthorType.contributor &&
          two.name == 'Contributor 2' &&
          two.url == 'http://two.example.com/' &&
          two.type == AuthorType.contributor &&
          two.email == 'you@example.com';
    },
    'entry_contributor_name.xml': (r) => r.items.first.authors.first.name == 'Example contributor',
    'entry_contributor_uri.xml': (r) => r.items.first.authors.first.url == 'http://example.com/',
    'entry_contributor_url.xml': (r) => r.items.first.authors.first.url == 'http://example.com/',
    'entry_id.xml': (r) => r.items.first.guid == 'http://example.com/',
    'entry_id_map_guid.xml': (r) => r.items.first.guid == 'http://example.com/',
    'entry_id_no_normalization_1.xml': (r) => r.items.first.guid == 'http://www.example.org/thing',
    'entry_id_no_normalization_2.xml': (r) => r.items.first.guid == 'http://www.example.org/Thing',
    'entry_id_no_normalization_3.xml': (r) => r.items.first.guid == 'http://www.EXAMPLE.org/thing',
    'entry_id_no_normalization_4.xml': (r) => r.items.first.guid == 'HTTP://www.example.org/thing',
    'entry_id_no_normalization_5.xml': (r) => r.items.first.guid == 'http://www.example.com/~bob',
    'entry_id_no_normalization_6.xml': (r) => r.items.first.guid == 'http://www.example.com/%7ebob',
    'entry_id_no_normalization_7.xml': (r) => r.items.first.guid == 'http://www.example.com/%7Ebob',
    'entry_id_with_attributes.xml': (r) => r.items.first.guid == 'right',
    'entry_link_alternate_map_link.xml': (r) => r.items.first.links.first.href == 'http://www.example.com/',
    'entry_link_alternate_map_link_2.xml': (r) => r.items.first.links.first.href == 'http://www.example.com/',
    'entry_link_alternate_map_link_3.xml': (r) => r.items.first.links.first.href == 'http://www.example.com/alternate',
    'entry_link_href.xml': (r) => r.items.first.links.first.href == 'http://www.example.com/',
    'entry_link_hreflang.xml': (r) => r.items.first.links.first.href == 'http://www.example.com/',
    'entry_link_length.xml': (r) => r.items.first.links.first.length == '42301',
    'entry_link_multiple.xml': (r) =>
        r.items.first.links.first.href == 'http://www.example.com/' &&
        r.items.first.links.last.href == 'http://www.example.com/post',
    'entry_link_no_rel.xml': (r) => r.items.first.links.first.href == 'http://www.example.com/',
    'entry_link_rel.xml': (r) => r.items.first.links.first.href == 'http://www.example.com/',
    'entry_link_rel_enclosure.xml': (r) => r.items.first.links.first.href == 'http://www.example.com/',
    'entry_link_rel_enclosure_map_enclosure_length.xml': (r) => r.items.first.links.first.length == '42301',
    'entry_link_rel_enclosure_map_enclosure_type.xml': (r) => r.items.first.links.first.type == 'video/mpeg4',
    'entry_link_rel_enclosure_map_enclosure_url.xml': (r) =>
        r.items.first.links.first.href == 'http://www.example.com/movie.mp4',
    'entry_link_rel_license.xml': (r) =>
        r.items.first.links.first.rel == LinkRelationType.other &&
        r.items.first.links.first.originalRel == 'license' &&
        r.items.first.links.first.href == 'http://www.creativecommons.org/licenses/by-nc/1.0',
    'entry_link_rel_other.xml': (r) =>
        r.items.first.links.first.rel == LinkRelationType.other &&
        r.items.first.links.first.originalRel == 'http://feedparser.org/rel/test',
    'entry_link_rel_related.xml': (r) => r.items.first.links.first.rel == LinkRelationType.related,
    'entry_link_rel_self.xml': (r) => r.items.first.links.first.rel == LinkRelationType.self,
    'entry_link_rel_via.xml': (r) => r.items.first.links.first.rel == LinkRelationType.via,
    'entry_link_title.xml': (r) => r.items.first.links.first.title == 'Example title',
    'entry_link_type.xml': (r) => r.items.first.links.first.type == 'text/html',
    'entry_rights.xml': (r) => r.items.first.copyright == 'Example Atom',
    'entry_rights_content_value.xml': (r) => r.items.first.copyright == 'Example Atom',
    'entry_rights_escaped_markup.xml': (r) => r.items.first.copyright == 'Example <b>Atom</b>',
    'entry_rights_inline_markup.xml': (r) =>
        r.items.first.copyright == '<div xmlns="http://www.w3.org/1999/xhtml">Example <b>Atom</b></div>',
    'entry_rights_inline_markup_2.xml': (r) =>
        r.items.first.copyright == '<div xmlns="http://www.w3.org/1999/xhtml">History of the &lt;blink> tag</div>',
    'entry_rights_text_plain.xml': (r) => r.items.first.copyright == 'Example Atom',
    'entry_rights_text_plain_brackets.xml': (r) => r.items.first.copyright == 'History of the <blink> tag',
    'entry_rights_type_default.xml': (r) => r.items.first.copyright == 'Example Atom',
    'entry_rights_type_text.xml': (r) => r.items.first.copyright == 'Example Atom',
    'entry_source_author_email.xml': (r) => r.items.first.sourceEntry?.authors.first.email == 'me@example.com',
    'entry_source_author_map_author_2.xml': (r) => r.items.first.sourceEntry?.authors.first.name == 'Example author',
    'entry_source_author_name.xml': (r) => r.items.first.sourceEntry?.authors.first.name == 'Example author',
    'entry_source_author_uri.xml': (r) => r.items.first.sourceEntry?.authors.first.url == 'http://example.com/',
    'entry_source_authors_email.xml': (r) =>
        r.items.first.sourceEntry?.authors.first.email == 'one@one.com' &&
        r.items.first.sourceEntry?.authors.last.email == 'two@two.com',
    'entry_source_authors_name.xml': (r) =>
        r.items.first.sourceEntry?.authors.first.name == 'one' && r.items.first.sourceEntry?.authors.last.name == 'two',
    'entry_source_authors_uri.xml': (r) =>
        r.items.first.sourceEntry?.authors.first.url == 'http://one.com/' &&
        r.items.first.sourceEntry?.authors.last.url == 'http://two.com/',
    'entry_source_authors_url.xml': (r) =>
        r.items.first.sourceEntry?.authors.first.url == 'http://one.com/' &&
        r.items.first.sourceEntry?.authors.last.url == 'http://two.com/',
    'entry_source_category_label.xml': (r) => r.items.first.sourceEntry?.categories.first.label == 'Atom 1.0 tests',
    'entry_source_category_scheme.xml': (r) =>
        r.items.first.sourceEntry?.categories.first.scheme == 'http://feedparser.org/tests/',
    'entry_source_category_term.xml': (r) => r.items.first.sourceEntry?.categories.first.term == 'atom10',
    'entry_source_category_term_non_ascii.xml': (r) => r.items.first.sourceEntry?.categories.first.term == 'Freiräume',
    'entry_source_contributor_email.xml': (r) => r.items.first.sourceEntry?.authors.first.email == 'me@example.com',
    'entry_source_contributor_multiple.xml': (r) {
      final one = r.items.first.sourceEntry?.authors.first;
      final two = r.items.first.sourceEntry?.authors.last;
      return one?.name == 'Contributor 1' &&
          one?.url == 'http://example.com/' &&
          one?.email == 'me@example.com' &&
          two?.name == 'Contributor 2' &&
          two?.url == 'http://two.example.com/' &&
          two?.email == 'you@example.com';
    },
    'entry_source_contributor_name.xml': (r) => r.items.first.sourceEntry?.authors.first.name == 'Example contributor',
    'entry_source_contributor_uri.xml': (r) => r.items.first.sourceEntry?.authors.first.url == 'http://example.com/',
    'entry_title.xml': (r) => r.items.first.title == 'Example Atom',
    'entry_title_base64.xml': (r) => r.items.first.title == 'Example <b>Atom</b>',
    'entry_title_base64_2.xml': (r) => r.items.first.title == '<p>History of the &lt;blink&gt; tag</p>',
    'entry_title_content_value.xml': (r) => r.items.first.title == 'Example Atom',
    'entry_title_escaped_markup.xml': (r) => r.items.first.title == 'Example <b>Atom</b>',
    'entry_title_inline_markup.xml': (r) =>
        r.items.first.title == '<div xmlns="http://www.w3.org/1999/xhtml">Example <b>Atom</b></div>',
    'entry_title_inline_markup_2.xml': (r) =>
        r.items.first.title == '<div xmlns="http://www.w3.org/1999/xhtml">History of the &lt;blink> tag</div>',
    'entry_title_text_plain.xml': (r) => r.items.first.title == 'Example Atom',
    'entry_title_text_plain_brackets.xml': (r) => r.items.first.title == 'History of the <blink> tag',
    'entry_title_type_default.xml': (r) => r.items.first.title == 'Example Atom',
    'entry_title_type_empty-no-crash.xml': (r) => r.items.first.title == 'evil',
    'entry_title_type_text.xml': (r) => r.items.first.title == 'Example Atom',
    'entry_summary.xml': (r) => r.items.first.description == 'Example Atom',
    'entry_summary_base64.xml': (r) => r.items.first.description == 'Example <b>Atom</b>',
    'entry_summary_base64_2.xml': (r) => r.items.first.description == '<p>History of the &lt;blink&gt; tag</p>',
    'entry_summary_content_value.xml': (r) => r.items.first.description == 'Example Atom',
    'entry_summary_escaped_markup.xml': (r) => r.items.first.description == 'Example <b>Atom</b>',
    'entry_summary_inline_markup.xml': (r) =>
        r.items.first.description == '<div xmlns="http://www.w3.org/1999/xhtml">Example <b>Atom</b></div>',
    'entry_summary_inline_markup_2.xml': (r) =>
        r.items.first.description == '<div xmlns="http://www.w3.org/1999/xhtml">History of the &lt;blink> tag</div>',
    'entry_summary_text_plain.xml': (r) => r.items.first.description == 'Example Atom',
    'entry_summary_type_default.xml': (r) => r.items.first.description == 'Example Atom',
    'entry_summary_type_text.xml': (r) => r.items.first.description == 'Example Atom',
    'feed_author_email.xml': (r) => r.authors.first.email == 'me@example.com',
    'feed_author_map_author_2.xml': (r) => r.authors.first.name == 'Example author',
    'feed_author_name.xml': (r) => r.authors.first.name == 'Example author',
    'feed_author_uri.xml': (r) => r.authors.first.url == 'http://example.com/',
    'feed_author_url.xml': (r) => r.authors.first.url == 'http://example.com/',
    'feed_authors_email.xml': (r) => r.authors.first.email == 'one@one.com' && r.authors.last.email == 'two@two.com',
    'feed_authors_name.xml': (r) => r.authors.first.name == 'one' && r.authors.last.name == 'two',
    'feed_authors_uri.xml': (r) => r.authors.first.url == 'http://one.com/' && r.authors.last.url == 'http://two.com/',
    'feed_authors_url.xml': (r) => r.authors.first.url == 'http://one.com/' && r.authors.last.url == 'http://two.com/',
    'feed_contributor_email.xml': (r) => r.authors.first.email == 'me@example.com',
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
    'feed_generator.xml': (r) => r.generator!.name == 'Example generator',
    'feed_generator_name.xml': (r) => r.generator!.name == 'Example generator',
    'feed_generator_url.xml': (r) => r.generator!.url == 'http://example.com/',
    'feed_generator_version.xml': (r) => r.generator!.version == '2.65',
    'feed_icon.xml': (r) => r.icon?.url == 'http://example.com/favicon.ico',
    'feed_id.xml': (r) => r.guid == 'http://example.com/',
    'feed_id_map_guid.xml': (r) => r.guid == 'http://example.com/',
    'feed_link_alternate_map_link.xml': (r) => r.links.first.href == 'http://www.example.com/',
    'feed_link_alternate_map_link_2.xml': (r) => r.links.first.href == 'http://www.example.com/',
    'feed_link_href.xml': (r) => r.links.first.href == 'http://www.example.com/',
    'feed_link_hreflang.xml': (r) => r.links.first.href == 'http://www.example.com/',
    'feed_link_length.xml': (r) => r.links.first.length == '42301',
    'feed_link_multiple.xml': (r) =>
        r.links.first.href == 'http://www.example.com/' && r.links.last.href == 'http://www.example.com/post',
    'feed_link_no_rel.xml': (r) {
      return r.links.first.href == 'http://www.example.com/' &&
          r.links.first.rel == LinkRelationType.other &&
          r.htmlLink == null &&
          r.xmlLink == null;
    },
    'feed_link_rel.xml': (r) =>
        r.links.first.href == 'http://www.example.com/' &&
        r.links.first.rel == LinkRelationType.alternate &&
        r.htmlLink?.href == 'http://www.example.com/' &&
        r.xmlLink == null,
    'feed_link_rel_other.xml': (r) =>
        r.links.first.rel == LinkRelationType.other &&
        r.links.first.originalRel == 'http://feedparser.org/rel/test' &&
        r.htmlLink == null &&
        r.xmlLink == null,
    'feed_link_rel_related.xml': (r) => r.links.first.rel == LinkRelationType.related,
    'feed_link_rel_self.xml': (r) =>
        r.links.first.rel == LinkRelationType.self &&
        r.xmlLink?.href == 'http://www.example.com/' &&
        r.htmlLink == null,
    'feed_link_rel_via.xml': (r) => r.links.first.rel == LinkRelationType.via,
    'feed_link_title.xml': (r) => r.links.first.title == 'Example title',
    'feed_link_type.xml': (r) => r.links.first.type == 'text/html',
    'feed_logo.xml': (r) => r.image?.url == 'http://example.com/logo.jpg',
    'feed_rights.xml': (r) => r.copyright == 'Example Atom',
    'feed_rights_base64.xml': (r) => r.copyright == 'Example <b>Atom</b>',
    'feed_rights_base64_2.xml': (r) => r.copyright == '<p>History of the &lt;blink&gt; tag</p>',
    'feed_rights_content_type.xml': (r) => r.copyright == 'Example Atom',
    'feed_rights_content_type_text.xml': (r) => r.copyright == 'Example Atom',
    'feed_rights_content_value.xml': (r) => r.copyright == 'Example Atom',
    'feed_rights_escaped_markup.xml': (r) => r.copyright == 'Example <b>Atom</b>',
    'feed_rights_inline_markup.xml': (r) =>
        r.copyright == '<div xmlns="http://www.w3.org/1999/xhtml">Example <b>Atom</b></div>',
    'feed_rights_inline_markup_2.xml': (r) =>
        r.copyright == '<div xmlns="http://www.w3.org/1999/xhtml">History of the &lt;blink> tag</div>',
    'feed_rights_text_plain.xml': (r) => r.copyright == 'Example Atom',
    'feed_subtitle.xml': (r) => r.description == 'Example Atom',
    'feed_subtitle_base64.xml': (r) => r.description == 'Example <b>Atom</b>',
    'feed_subtitle_base64_2.xml': (r) => r.description == '<p>History of the &lt;blink&gt; tag</p>',
    'feed_subtitle_content_type.xml': (r) => r.description == 'Example Atom',
    'feed_subtitle_content_type_text.xml': (r) => r.description == 'Example Atom',
    'feed_subtitle_content_value.xml': (r) => r.description == 'Example Atom',
    'feed_subtitle_escaped_markup.xml': (r) => r.description == 'Example <b>Atom</b>',
    'feed_subtitle_inline_markup.xml': (r) =>
        r.description == '<div xmlns="http://www.w3.org/1999/xhtml">Example <b>Atom</b></div>',
    'feed_subtitle_inline_markup_2.xml': (r) =>
        r.description == '<div xmlns="http://www.w3.org/1999/xhtml">History of the &lt;blink> tag</div>',
    'feed_subtitle_text_plain.xml': (r) => r.description == 'Example Atom',
    'feed_title.xml': (r) => r.title == 'Example Atom',
    'feed_title_base64.xml': (r) => r.title == 'Example <b>Atom</b>',
    'feed_title_base64_2.xml': (r) => r.title == '<p>History of the &lt;blink&gt; tag</p>',
    'feed_title_content_type.xml': (r) => r.title == 'Example Atom',
    'feed_title_content_type_text.xml': (r) => r.title == 'Example Atom',
    'feed_title_content_value.xml': (r) => r.title == 'Example Atom',
    'feed_title_escaped_markup.xml': (r) => r.title == 'Example <b>Atom</b>',
    'feed_title_inline_markup.xml': (r) =>
        r.title == '<div xmlns="http://www.w3.org/1999/xhtml">Example <b>Atom</b></div>',
    'feed_title_inline_markup_2.xml': (r) =>
        r.title == '<div xmlns="http://www.w3.org/1999/xhtml">History of the &lt;blink> tag</div>',
    'feed_title_text_plain.xml': (r) => r.title == 'Example Atom',
    'missing_quote_in_attr.xml': (r) => r.title == '<a href=http://example.com/">example</a>',
    'qna.xml': (r) => r.items.first.title == 'Q&A session',
    'quote_in_attr.xml': (r) =>
        r.title == '<div xmlns="http://www.w3.org/1999/xhtml"><a title=\'"test"\'>test</a></div>',
    'tag_in_attr.xml': (r) => r.title == '<img src="http://example.com/cat-dog.jpg" alt="cat<br />dog">',
  };
}
