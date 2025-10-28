import 'package:test/test.dart';
import 'package:universal_feed/universal_feed.dart';

void main() {
  group('ID Generation', () {
    group('RSS', () {
      test('generates sequential itemIds', () {
        const xml = '''
<?xml version="1.0"?>
<rss version="2.0">
  <channel>
    <title>Test Feed</title>
    <link>https://example.com</link>
    <description>Test</description>
    <item>
      <title>Item 1</title>
    </item>
    <item>
      <title>Item 2</title>
    </item>
    <item>
      <title>Item 3</title>
    </item>
  </channel>
</rss>''';

        final feed = UniversalFeed.parseFromString(xml);
        expect(feed.items.length, 3);
        expect(feed.items[0].itemId, 'item_0');
        expect(feed.items[1].itemId, 'item_1');
        expect(feed.items[2].itemId, 'item_2');
      });

      test('generates feedId from link', () {
        const xml = '''
<?xml version="1.0"?>
<rss version="2.0">
  <channel>
    <title>Test Feed</title>
    <link>https://example.com</link>
    <description>Test</description>
  </channel>
</rss>''';

        final feed = UniversalFeed.parseFromString(xml);
        expect(feed.feedId, 'https://example.com');
      });

      test('generates fallback feedId when no link', () {
        const xml = '''
<?xml version="1.0"?>
<rss version="2.0">
  <channel>
    <title>Test Feed</title>
    <description>Test</description>
  </channel>
</rss>''';

        final feed = UniversalFeed.parseFromString(xml);
        expect(feed.feedId, startsWith('feed_'));
        expect(feed.feedId.split('_').length, 3); // feed_{timestamp}_{random}
      });

      test('itemIds remain stable after filtering', () {
        const xml = '''
<?xml version="1.0"?>
<rss version="2.0">
  <channel>
    <title>Test Feed</title>
    <link>https://example.com</link>
    <description>Test</description>
    <item>
      <title>Dart Article</title>
    </item>
    <item>
      <title>Python Article</title>
    </item>
    <item>
      <title>Dart Tutorial</title>
    </item>
  </channel>
</rss>''';

        final feed = UniversalFeed.parseFromString(xml);
        final dartItems = feed.items.where((i) => i.title?.contains('Dart') ?? false).toList();

        expect(dartItems.length, 2);
        expect(dartItems[0].itemId, 'item_0'); // Still has original ID
        expect(dartItems[1].itemId, 'item_2'); // Still has original ID
      });
    });

    group('Atom', () {
      test('generates sequential itemIds', () {
        const xml = '''
<?xml version="1.0"?>
<feed xmlns="http://www.w3.org/2005/Atom">
  <title>Test Feed</title>
  <id>urn:uuid:test-feed</id>
  <updated>2023-01-01T00:00:00Z</updated>
  <entry>
    <title>Entry 1</title>
    <id>urn:uuid:entry-1</id>
    <updated>2023-01-01T00:00:00Z</updated>
  </entry>
  <entry>
    <title>Entry 2</title>
    <id>urn:uuid:entry-2</id>
    <updated>2023-01-01T00:00:00Z</updated>
  </entry>
</feed>''';

        final feed = UniversalFeed.parseFromString(xml);
        expect(feed.items.length, 2);
        expect(feed.items[0].itemId, 'item_0');
        expect(feed.items[1].itemId, 'item_1');
      });

      test('generates feedId from id element', () {
        const xml = '''
<?xml version="1.0"?>
<feed xmlns="http://www.w3.org/2005/Atom">
  <title>Test Feed</title>
  <id>urn:uuid:test-feed-12345</id>
  <updated>2023-01-01T00:00:00Z</updated>
</feed>''';

        final feed = UniversalFeed.parseFromString(xml);
        expect(feed.feedId, 'urn:uuid:test-feed-12345');
      });

      test('generates fallback feedId when no id', () {
        const xml = '''
<?xml version="1.0"?>
<feed xmlns="http://www.w3.org/2005/Atom">
  <title>Test Feed</title>
  <updated>2023-01-01T00:00:00Z</updated>
</feed>''';

        final feed = UniversalFeed.parseFromString(xml);
        expect(feed.feedId, startsWith('feed_'));
        expect(feed.feedId.split('_').length, 3);
      });
    });

    group('JSON Feed', () {
      test('generates sequential itemIds', () {
        const json = '''
{
  "version": "https://jsonfeed.org/version/1",
  "title": "Test Feed",
  "items": [
    {
      "id": "1",
      "content_text": "Item 1"
    },
    {
      "id": "2",
      "content_text": "Item 2"
    },
    {
      "id": "3",
      "content_text": "Item 3"
    }
  ]
}''';

        final feed = UniversalFeed.parseFromString(json);
        expect(feed.items.length, 3);
        expect(feed.items[0].itemId, 'item_0');
        expect(feed.items[1].itemId, 'item_1');
        expect(feed.items[2].itemId, 'item_2');
      });

      test('generates feedId from feed_url', () {
        const json = '''
{
  "version": "https://jsonfeed.org/version/1",
  "title": "Test Feed",
  "feed_url": "https://example.com/feed.json"
}''';

        final feed = UniversalFeed.parseFromString(json);
        expect(feed.feedId, 'https://example.com/feed.json');
      });

      test('generates fallback feedId when no feed_url', () {
        const json = '''
{
  "version": "https://jsonfeed.org/version/1",
  "title": "Test Feed"
}''';

        final feed = UniversalFeed.parseFromString(json);
        expect(feed.feedId, startsWith('feed_'));
        expect(feed.feedId.split('_').length, 3);
      });
    });

    group('Fallback ID Format', () {
      test('feedId has correct format', () {
        const xml = '''
<?xml version="1.0"?>
<rss version="2.0">
  <channel>
    <title>Test Feed</title>
    <description>Test</description>
  </channel>
</rss>''';

        final feed = UniversalFeed.parseFromString(xml);
        final parts = feed.feedId.split('_');

        expect(parts[0], 'feed');
        expect(int.tryParse(parts[1]), isNotNull); // timestamp
        expect(int.tryParse(parts[2]), isNotNull); // random
        expect(int.parse(parts[2]), lessThan(999999));
      });

      test('multiple feeds get different fallback IDs', () {
        const xml = '''
<?xml version="1.0"?>
<rss version="2.0">
  <channel>
    <title>Test Feed</title>
    <description>Test</description>
  </channel>
</rss>''';

        final feed1 = UniversalFeed.parseFromString(xml);
        final feed2 = UniversalFeed.parseFromString(xml);

        // IDs should be different due to timestamp/random
        expect(feed1.feedId, isNot(equals(feed2.feedId)));
      });
    });
  });
}
