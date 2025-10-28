import 'package:test/test.dart';
import 'package:universal_feed/src/shared/extensions.dart';
import 'package:universal_feed/universal_feed.dart';

void main() {
  group('Atom 1.0 Callbacks', () {
    test('onChannelParse receives parsed feed and XmlRawElement', () {
      const xml = '''
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
  <title>Test Feed</title>
  <link href="https://example.com/feed" rel="self"/>
  <link href="https://example.com" rel="alternate"/>
  <updated>2023-01-01T00:00:00Z</updated>
  <id>urn:uuid:test-feed-123</id>
  <subtitle>Test Description</subtitle>
</feed>''';

      UniversalFeed? capturedFeed;
      RawElement? capturedRaw;

      final feed = UniversalFeed.parseFromString(
        xml,
        onChannelParse: (feed, raw) {
          capturedFeed = feed;
          capturedRaw = raw;
        },
      );

      // Verify callback was called
      expect(capturedFeed, isNotNull);
      expect(capturedRaw, isNotNull);

      // Verify we got the same feed object
      expect(capturedFeed, same(feed));

      expect(capturedFeed!.title, 'Test Feed');
      expect(capturedFeed!.description, 'Test Description');
      expect(capturedFeed!.guid, 'urn:uuid:test-feed-123');
      expect(capturedRaw!.id, 'urn:uuid:test-feed-123');
      expect(capturedFeed!.feedId, 'urn:uuid:test-feed-123');
    });

    test('onItemParse receives parsed item and XmlRawElement', () {
      const xml = '''
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
  <title>Test Feed</title>
  <id>urn:uuid:test-feed</id>
  <updated>2023-01-01T00:00:00Z</updated>
  <entry>
    <title>Entry 1</title>
    <link href="https://example.com/entry1"/>
    <id>urn:uuid:entry-1</id>
    <updated>2023-01-01T00:00:00Z</updated>
    <summary>First entry</summary>
  </entry>
</feed>''';

      Item? capturedItem;
      RawElement? capturedRaw;

      UniversalFeed.parseFromString(
        xml,
        onItemParse: (item, raw) {
          capturedItem = item;
          capturedRaw = raw;
        },
      );

      // Verify callback was called
      expect(capturedItem, isNotNull);
      expect(capturedRaw, isNotNull);

      expect(capturedItem!.title, 'Entry 1');
      expect(capturedItem!.description, 'First entry');
      expect(capturedItem!.guid, 'urn:uuid:entry-1');
      expect(capturedRaw!.id, 'item_0');
      expect(capturedItem!.itemId, 'item_0');
    });

    test('callbacks receive correct XmlElement for custom field extraction', () {
      const xml = '''
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom" xmlns:custom="http://example.com/custom">
  <title>Test Feed</title>
  <id>urn:uuid:test-feed</id>
  <updated>2023-01-01T00:00:00Z</updated>
  <entry>
    <title>Article Title</title>
    <link href="https://example.com/article"/>
    <id>urn:uuid:article-1</id>
    <updated>2023-01-01T00:00:00Z</updated>
    <custom:readingTime>5</custom:readingTime>
    <custom:author>John Doe</custom:author>
    <custom:tag>Dart</custom:tag>
    <custom:tag>Programming</custom:tag>
  </entry>
</feed>''';

      String? extractedReadingTime;
      String? extractedAuthor;
      final extractedTags = <String>[];

      UniversalFeed.parseFromString(
        xml,
        onItemParse: (item, raw) {
          if (raw is XmlRawElement) {
            raw.element
              ..ifPresent('readingTime', (value) => extractedReadingTime = value, ns: 'http://example.com/custom')
              ..ifPresent('author', (value) => extractedAuthor = value, ns: 'http://example.com/custom')
              ..forEachElement('tag', extractedTags.add, ns: 'http://example.com/custom');
          }
        },
      );

      expect(extractedReadingTime, '5');
      expect(extractedAuthor, 'John Doe');
      expect(extractedTags, ['Dart', 'Programming']);
    });

    test('multiple entries trigger callback for each', () {
      const xml = '''
<?xml version="1.0" encoding="utf-8"?>
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
  <entry>
    <title>Entry 3</title>
    <id>urn:uuid:entry-3</id>
    <updated>2023-01-01T00:00:00Z</updated>
  </entry>
</feed>''';

      final capturedItems = <Item>[];
      final capturedIds = <String>[];

      UniversalFeed.parseFromString(
        xml,
        onItemParse: (item, raw) {
          capturedItems.add(item);
          capturedIds.add(raw.id);
        },
      );

      expect(capturedItems.length, 3);
      expect(capturedItems[0].title, 'Entry 1');
      expect(capturedItems[1].title, 'Entry 2');
      expect(capturedItems[2].title, 'Entry 3');

      expect(capturedIds, ['item_0', 'item_1', 'item_2']);
    });

    test('custom data extraction with stable IDs', () {
      const xml = '''
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom" xmlns:custom="http://example.com/custom">
  <title>Tech Blog</title>
  <id>urn:uuid:tech-blog</id>
  <updated>2023-01-01T00:00:00Z</updated>
  <entry>
    <title>Dart Article</title>
    <id>urn:uuid:article-1</id>
    <updated>2023-01-01T00:00:00Z</updated>
    <custom:readingTime>5</custom:readingTime>
  </entry>
  <entry>
    <title>Python Article</title>
    <id>urn:uuid:article-2</id>
    <updated>2023-01-01T00:00:00Z</updated>
    <custom:readingTime>8</custom:readingTime>
  </entry>
  <entry>
    <title>Dart Tutorial</title>
    <id>urn:uuid:article-3</id>
    <updated>2023-01-01T00:00:00Z</updated>
    <custom:readingTime>12</custom:readingTime>
  </entry>
</feed>''';

      final customData = <String, int>{};

      final feed = UniversalFeed.parseFromString(
        xml,
        onItemParse: (item, raw) {
          if (raw is XmlRawElement) {
            raw.element.ifPresent('readingTime', (value) {
              customData[item.itemId] = int.parse(value);
            }, ns: 'http://example.com/custom');
          }
        },
      );

      expect(customData['item_0'], 5);
      expect(customData['item_1'], 8);
      expect(customData['item_2'], 12);

      // Filter items - IDs remain stable
      final dartItems = feed.items.where((i) => i.title?.contains('Dart') ?? false).toList();
      expect(dartItems.length, 2);

      expect(customData[dartItems[0].itemId], 5); // item_0
      expect(customData[dartItems[1].itemId], 12); // item_2
    });
  });

  group('Atom 0.3 Callbacks', () {
    test('onChannelParse works with Atom 0.3', () {
      const xml = '''
<?xml version="1.0" encoding="utf-8"?>
<feed version="0.3" xmlns="http://purl.org/atom/ns#">
  <title>Test Feed 0.3</title>
  <link rel="alternate" type="text/html" href="https://example.com"/>
  <modified>2023-01-01T00:00:00Z</modified>
  <id>urn:uuid:test-feed-03</id>
  <tagline>Test Description 0.3</tagline>
</feed>''';

      UniversalFeed? capturedFeed;
      RawElement? capturedRaw;

      final feed = UniversalFeed.parseFromString(
        xml,
        onChannelParse: (feed, raw) {
          capturedFeed = feed;
          capturedRaw = raw;
        },
      );

      // Verify callback was called
      expect(capturedFeed, isNotNull);
      expect(capturedRaw, isNotNull);
      expect(capturedFeed, same(feed));

      expect(capturedFeed!.title, 'Test Feed 0.3');
      expect(capturedFeed!.guid, 'urn:uuid:test-feed-03');
    });

    test('onItemParse works with Atom 0.3', () {
      const xml = '''
<?xml version="1.0" encoding="utf-8"?>
<feed version="0.3" xmlns="http://purl.org/atom/ns#">
  <title>Test Feed</title>
  <id>urn:uuid:test-feed</id>
  <modified>2023-01-01T00:00:00Z</modified>
  <entry>
    <title>Entry 0.3</title>
    <link rel="alternate" type="text/html" href="https://example.com/entry1"/>
    <id>urn:uuid:entry-1</id>
    <modified>2023-01-01T00:00:00Z</modified>
    <summary>First entry 0.3</summary>
  </entry>
</feed>''';

      Item? capturedItem;
      RawElement? capturedRaw;

      UniversalFeed.parseFromString(
        xml,
        onItemParse: (item, raw) {
          capturedItem = item;
          capturedRaw = raw;
        },
      );

      // Verify callback was called
      expect(capturedItem, isNotNull);
      expect(capturedRaw, isNotNull);

      expect(capturedItem!.title, 'Entry 0.3');
      expect(capturedItem!.description, 'First entry 0.3');
      expect(capturedItem!.guid, 'urn:uuid:entry-1');
      expect(capturedItem!.itemId, 'item_0');
    });

    test('custom field extraction works with Atom 0.3', () {
      const xml = '''
<?xml version="1.0" encoding="utf-8"?>
<feed version="0.3" xmlns="http://purl.org/atom/ns#" xmlns:custom="http://example.com/custom">
  <title>Test Feed</title>
  <id>urn:uuid:test-feed</id>
  <modified>2023-01-01T00:00:00Z</modified>
  <entry>
    <title>Article</title>
    <id>urn:uuid:article-1</id>
    <modified>2023-01-01T00:00:00Z</modified>
    <custom:rating>4.5</custom:rating>
  </entry>
</feed>''';

      String? customRating;

      UniversalFeed.parseFromString(
        xml,
        onItemParse: (item, raw) {
          if (raw is XmlRawElement) {
            raw.element.ifPresent('rating', (value) => customRating = value, ns: 'http://example.com/custom');
          }
        },
      );

      expect(customRating, '4.5');
    });
  });
}
