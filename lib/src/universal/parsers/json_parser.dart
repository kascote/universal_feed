import 'dart:convert';

import 'package:universal_feed/universal_feed.dart';

import '../../shared/extensions.dart';
import '../../shared/shared.dart';

/// Parses a JSON feed
///
/// https://www.jsonfeed.org/
UniversalFeed jsonParser(UniversalFeed feed, String content) {
  final json = jsonDecode(content) as Map<String, dynamic>;

  final versionStr = _getRequiredElement<String>(json, 'version', 'The version is required.');
  final versionUri = Uri.tryParse(versionStr);
  if (versionUri == null) throw FeedError('The version is not a valid URI.');
  feed
    ..title = _getRequiredElement<String>(json, 'title', 'The title is required.')
    ..meta = MetaData(FeedKind.json, versionUri.pathSegments.last, Namespaces.empty(), encoding: 'utf8');

  _jsonFeedParser(feed, json);
  final items = json['items'] as List<dynamic>?;
  if (items != null) {
    for (final item in items) {
      Item.jsonFromJson(feed, item as Map<String, dynamic>);
    }
  }

  return feed;
}

void _jsonFeedParser(UniversalFeed uf, Map<String, dynamic> json) {
  json
    ..ifPresent<String>(
      'home_page_url',
      (value) => uf.htmlLink = Link.create(href: value, rel: 'alternate', type: 'text/html'),
    )
    ..ifPresent<String>(
      'feed_url',
      (value) => uf.xmlLink = Link.create(href: value, rel: 'self', type: 'application/json'),
    )
    ..ifPresent<String>('description', (value) => uf.description = value)
    ..ifPresent<String>('language', (value) => uf.language = value)
    ..ifPresent<String>('favicon', (value) => uf.image = Image(value))
    ..ifPresent<String>('icon', (value) => uf.icon = Image(value));

  uf.authors.addAll(_parseAuthors(json));
}

/// Parses the entries from a JSON feed
void jsonItemParser(UniversalFeed feed, Item item, Map<String, dynamic> json) {
  json
    ..ifPresent<String>('id', (value) => item.guid = value)
    ..ifPresent<String>('title', (value) => item.title = value)
    ..ifPresent<String>('summary', (value) => item.description = value)
    ..ifPresent<String>(
      'url',
      (value) => item.link = Link.create(href: value, rel: 'self', type: 'text/html'),
    )
    ..ifPresent<String>(
      'external_url',
      (value) => item.links.add(Link.create(href: value, rel: 'related', type: 'text/html')),
    )
    ..ifPresent<String>('date_modified', (value) => item.updated = Timestamp(value))
    ..ifPresent<String>('date_published', (value) => item.published = Timestamp(value))
    ..ifPresent<String>('image', (value) => item.image = Image(value))
    ..ifPresent<String>(
      'content_html',
      (value) => item.content.add(Content(value: value, type: 'html')),
    );

  if (item.content.isEmpty) {
    // Fallback to content_text if content_html is not present
    json.ifPresent<String>(
      'content_text',
      (value) => item.content.add(Content(value: value, type: 'text')),
    );
  }

  item.authors.addAll(_parseAuthors(json));

  getJsElements<String>(
    json,
    'tags',
    cb: (value) => item.categories.add(Category(label: value)),
  );
  getJsElements<Map<String, dynamic>>(
    json,
    'attachments',
    cb: (value) {
      final bytes = value['size_in_bytes'] as int?;
      final duration = value['duration_in_seconds'] as int?;
      item.enclosures.add(
        Enclosure(
          url: value['url'] as String? ?? '',
          type: value['type'] as String? ?? '',
          length: bytes != null ? bytes.toString() : '',
          duration: duration != null ? duration.toString() : '',
        ),
      );
    },
  );

  feed.items.add(item);
}

List<Author> _parseAuthors(Map<String, dynamic> json) {
  final authors = <Author>[];

  final authorsArray = json['authors'] as List<dynamic>?;
  if (authorsArray != null) {
    authors.addAll(authorsArray.map((e) => Author.fromJson(e as Map<String, dynamic>)));
  }

  // Fallback to single author (JSON Feed 1.0)
  if (authors.isEmpty) {
    final author = json['author'] as Map<String, dynamic>?;
    if (author != null) {
      authors.add(Author.fromJson(author));
    }
  }

  return authors;
}

// Validates and retrieves a required field from JSON
T _getRequiredElement<T>(Map<String, dynamic> json, String fieldName, String errorMessage) {
  final value = json.getTyped<T>(fieldName);
  if (value == null) throw FeedError(errorMessage);
  return value;
}
