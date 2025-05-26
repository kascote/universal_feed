import 'package:universal_feed/universal_feed.dart';

typedef TestFx = bool Function(UniversalFeed r);

Map<String, TestFx> json11Tests() {
  return {
    'meta_version_11.json': (r) => r.meta.version == '1.1',
    'feed_title.json': (r) => r.title == 'Example JSON',
    'feed_home_page_url.json': (r) => r.htmlLink?.href == 'http://www.example.com/',
    'feed_feed_url.json': (r) => r.xmlLink?.href == 'http://www.example.com/feed.json',
    'feed_description.json': (r) => r.description == 'Example JSON',
    'feed_icon.json': (r) => r.icon?.url == 'http://www.example.com/favicon.ico',
    'feed_favicon.json': (r) => r.image?.url == 'http://www.example.com/favicon.ico',
    'feed_language.json': (r) => r.language == 'en',
    'feed_authors.json': (r) => r.authors.length == 2,
    'feed_authors_name.json': (r) => r.authors.first.name == 'Example author',
    'feed_authors_url.json': (r) => r.authors.first.url == 'http://example.com/',

    // Entry test cases
    'entry_id.json': (r) => r.items.isNotEmpty && r.items.first.guid == 'entry-001',
    'entry_title.json': (r) => r.items.isNotEmpty && r.items.first.title == 'Entry Title',
    'entry_summary.json': (r) => r.items.isNotEmpty && r.items.first.description == 'This is a summary of the entry',
    'entry_url.json': (r) => r.items.isNotEmpty && r.items.first.link?.href == 'https://example.com/entry-001',
    'entry_external_url.json': (r) =>
        r.items.isNotEmpty && r.items.first.links.any((link) => link.href == 'https://external.com/source'),
    'entry_date_published.json': (r) => r.items.isNotEmpty && r.items.first.published?.value == '2025-01-15T10:30:00Z',
    'entry_date_modified.json': (r) => r.items.isNotEmpty && r.items.first.updated?.value == '2025-01-16T14:45:00Z',
    'entry_content_text.json': (r) =>
        r.items.isNotEmpty &&
        r.items.first.content.any((c) => c.value == 'This is the plain text content of the entry.' && c.type == 'text'),
    'entry_content_html.json': (r) =>
        r.items.isNotEmpty &&
        r.items.first.content.any(
          (c) => c.value == '<p>This is the <strong>HTML</strong> content of the entry.</p>' && c.type == 'html',
        ),
    'entry_image.json': (r) => r.items.isNotEmpty && r.items.first.image?.url == 'https://example.com/image.jpg',
    'entry_authors.json': (r) =>
        r.items.isNotEmpty && r.items.first.authors.length == 2 && r.items.first.authors.first.name == 'John Doe',
    'entry_authors_name.json': (r) =>
        r.items.isNotEmpty && r.items.first.authors.isNotEmpty && r.items.first.authors.first.name == 'John Doe',
    'entry_tags.json': (r) =>
        r.items.isNotEmpty &&
        r.items.first.categories.length == 3 &&
        r.items.first.categories.any((c) => c.label == 'technology'),
    'entry_attachments.json': (r) =>
        r.items.isNotEmpty &&
        r.items.first.enclosures.isNotEmpty &&
        r.items.first.enclosures.first.url == 'https://example.com/file.pdf',
    'entry_multiple.json': (r) =>
        r.items.length == 2 && r.items.first.title == 'First Entry' && r.items.last.title == 'Second Entry',
    'entry_comprehensive.json': (r) =>
        r.items.isNotEmpty &&
        r.items.first.guid == 'entry-comprehensive' &&
        r.items.first.title == 'Comprehensive Entry' &&
        r.items.first.authors.isNotEmpty,
  };
}
