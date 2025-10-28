import 'package:test/test.dart';
import 'package:universal_feed/src/shared/extensions.dart';
import 'package:universal_feed/universal_feed.dart';

void main() {
  group('RSS Callbacks', () {
    test('onChannelParse receives parsed feed and XmlRawElement', () {
      const xml = '''
<?xml version="1.0"?>
<rss version="2.0">
  <channel>
    <title>Test Feed</title>
    <link>https://example.com</link>
    <description>Test Description</description>
    <custom:field xmlns:custom="http://example.com/custom">Custom Value</custom:field>
  </channel>
</rss>''';

      UniversalFeed? capturedFeed;
      RawElement? capturedRaw;

      final feed = UniversalFeed.parseFromString(
        xml,
        onChannelParse: (feed, raw) {
          capturedFeed = feed;
          capturedRaw = raw;
        },
      );

      expect(capturedFeed, isNotNull);
      expect(capturedRaw, isNotNull);

      expect(capturedFeed, same(feed));

      expect(capturedFeed!.title, 'Test Feed');
      expect(capturedFeed!.htmlLink?.href, 'https://example.com');
      expect(capturedFeed!.description, 'Test Description');
      expect(capturedRaw!.id, 'https://example.com');
      expect(capturedFeed!.feedId, 'https://example.com');
    });

    test('onItemParse receives parsed item and XmlRawElement', () {
      const xml = '''
<?xml version="1.0"?>
<rss version="2.0">
  <channel>
    <title>Test Feed</title>
    <link>https://example.com</link>
    <description>Test</description>
    <item>
      <title>Item 1</title>
      <link>https://example.com/item1</link>
      <description>First item</description>
      <custom:field xmlns:custom="http://example.com/custom">Custom Item Value</custom:field>
    </item>
  </channel>
</rss>''';

      Item? capturedItem;
      RawElement? capturedRaw;

      UniversalFeed.parseFromString(
        xml,
        onItemParse: (item, raw) {
          capturedItem = item;
          capturedRaw = raw;
        },
      );

      expect(capturedItem, isNotNull);
      expect(capturedRaw, isNotNull);

      expect(capturedItem!.title, 'Item 1');
      expect(capturedItem!.link?.href, 'https://example.com/item1');
      expect(capturedItem!.description, 'First item');
      expect(capturedRaw!.id, 'item_0');
      expect(capturedItem!.itemId, 'item_0');
    });

    test('callbacks receive correct XmlElement for custom field extraction', () {
      const xml = '''
<?xml version="1.0"?>
<rss version="2.0">
  <channel>
    <title>Test Feed</title>
    <link>https://example.com</link>
    <description>Test</description>
    <item>
      <title>Article Title</title>
      <link>https://example.com/article</link>
      <readingTime>5</readingTime>
      <author>John Doe</author>
      <tag>Dart</tag>
      <tag>Programming</tag>
    </item>
  </channel>
</rss>''';

      String? extractedReadingTime;
      String? extractedAuthor;
      final extractedTags = <String>[];

      UniversalFeed.parseFromString(
        xml,
        onItemParse: (item, raw) {
          if (raw is XmlRawElement) {
            raw.element
              ..ifPresent('readingTime', (value) => extractedReadingTime = value)
              ..ifPresent('author', (value) => extractedAuthor = value)
              ..forEachElement('tag', extractedTags.add);
          }
        },
      );

      expect(extractedReadingTime, '5');
      expect(extractedAuthor, 'John Doe');
      expect(extractedTags, ['Dart', 'Programming']);
    });

    test('multiple items trigger callback for each', () {
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
      expect(capturedItems[0].title, 'Item 1');
      expect(capturedItems[1].title, 'Item 2');
      expect(capturedItems[2].title, 'Item 3');

      expect(capturedIds, ['item_0', 'item_1', 'item_2']);
    });

    test('custom data extraction with stable IDs', () {
      const xml = '''
<?xml version="1.0"?>
<rss version="2.0">
  <channel>
    <title>Tech Blog</title>
    <link>https://example.com</link>
    <description>Test</description>
    <item>
      <title>Dart Article</title>
      <readingTime>5</readingTime>
    </item>
    <item>
      <title>Python Article</title>
      <readingTime>8</readingTime>
    </item>
    <item>
      <title>Dart Tutorial</title>
      <readingTime>12</readingTime>
    </item>
  </channel>
</rss>''';

      final customData = <String, int>{};

      final feed = UniversalFeed.parseFromString(
        xml,
        onItemParse: (item, raw) {
          if (raw is XmlRawElement) {
            raw.element.ifPresent('readingTime', (value) {
              customData[item.itemId] = int.parse(value);
            });
          }
        },
      );

      expect(customData['item_0'], 5);
      expect(customData['item_1'], 8);
      expect(customData['item_2'], 12);

      final dartItems = feed.items.where((i) => i.title?.contains('Dart') ?? false).toList();
      expect(dartItems.length, 2);

      expect(customData[dartItems[0].itemId], 5); // item_0
      expect(customData[dartItems[1].itemId], 12); // item_2
    });

    test('callback can access both parsed fields and custom fields', () {
      const xml = '''
<?xml version="1.0"?>
<rss version="2.0">
  <channel>
    <title>Test Feed</title>
    <link>https://example.com</link>
    <description>Test</description>
    <item>
      <title>Standard Title</title>
      <description>Standard Description</description>
      <customAuthor>Custom Author Name</customAuthor>
      <customRating>4.5</customRating>
    </item>
  </channel>
</rss>''';

      String? standardTitle;
      String? standardDescription;
      String? customAuthor;
      String? customRating;

      UniversalFeed.parseFromString(
        xml,
        onItemParse: (item, raw) {
          standardTitle = item.title;
          standardDescription = item.description;

          if (raw is XmlRawElement) {
            raw.element.ifPresent('customAuthor', (value) => customAuthor = value);
            raw.element.ifPresent('customRating', (value) => customRating = value);
          }
        },
      );

      expect(standardTitle, 'Standard Title');
      expect(standardDescription, 'Standard Description');
      expect(customAuthor, 'Custom Author Name');
      expect(customRating, '4.5');
    });
  });
}
