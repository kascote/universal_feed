import 'package:test/test.dart';
import 'package:universal_feed/src/shared/extensions.dart';
import 'package:universal_feed/universal_feed.dart';

void main() {
  group('JSON Feed 1.0 Callbacks', () {
    test('onChannelParse receives parsed feed and JsonRawElement', () {
      const json = '''
{
  "version": "https://jsonfeed.org/version/1",
  "title": "Test Feed",
  "home_page_url": "https://example.com",
  "feed_url": "https://example.com/feed.json",
  "description": "Test Description"
}''';

      UniversalFeed? capturedFeed;
      RawElement? capturedRaw;

      final feed = UniversalFeed.parseFromString(
        json,
        onChannelParse: (feed, raw) {
          capturedFeed = feed;
          capturedRaw = raw;
        },
      );

      // Verify callback was called
      expect(capturedFeed, isNotNull);
      expect(capturedRaw, isNotNull);

      expect(capturedFeed, same(feed));

      expect(capturedFeed!.title, 'Test Feed');
      expect(capturedFeed!.description, 'Test Description');
      expect(capturedRaw!.id, 'https://example.com/feed.json');
      expect(capturedFeed!.feedId, 'https://example.com/feed.json');
    });

    test('onItemParse receives parsed item and JsonRawElement', () {
      const json = '''
{
  "version": "https://jsonfeed.org/version/1",
  "title": "Test Feed",
  "items": [
    {
      "id": "item-1",
      "title": "Item 1",
      "url": "https://example.com/item1",
      "summary": "First item",
      "date_published": "2023-01-01T00:00:00Z"
    }
  ]
}''';

      Item? capturedItem;
      RawElement? capturedRaw;

      UniversalFeed.parseFromString(
        json,
        onItemParse: (item, raw) {
          capturedItem = item;
          capturedRaw = raw;
        },
      );

      // Verify callback was called
      expect(capturedItem, isNotNull);
      expect(capturedRaw, isNotNull);

      expect(capturedItem!.title, 'Item 1');
      expect(capturedItem!.description, 'First item');
      expect(capturedItem!.guid, 'item-1');
      expect(capturedRaw!.id, 'item_0');
      expect(capturedItem!.itemId, 'item_0');
    });

    test('callbacks receive correct JSON for custom field extraction', () {
      const json = '''
{
  "version": "https://jsonfeed.org/version/1",
  "title": "Test Feed",
  "items": [
    {
      "id": "article-1",
      "title": "Article Title",
      "url": "https://example.com/article",
      "reading_time": 5,
      "author_bio": "John Doe is a developer",
      "custom_tags": ["Dart", "Programming"]
    }
  ]
}''';

      int? extractedReadingTime;
      String? extractedAuthorBio;
      List<String>? extractedTags;

      UniversalFeed.parseFromString(
        json,
        onItemParse: (item, raw) {
          if (raw is JsonRawElement) {
            raw.json
              ..ifPresent<int>('reading_time', (value) => extractedReadingTime = value)
              ..ifPresent<String>('author_bio', (value) => extractedAuthorBio = value)
              ..ifPresent<List<String>>('custom_tags', (value) => extractedTags = value);
          }
        },
      );

      expect(extractedReadingTime, 5);
      expect(extractedAuthorBio, 'John Doe is a developer');
      expect(extractedTags, ['Dart', 'Programming']);
    });

    test('multiple items trigger callback for each', () {
      const json = '''
{
  "version": "https://jsonfeed.org/version/1",
  "title": "Test Feed",
  "items": [
    {
      "id": "item-1",
      "title": "Item 1"
    },
    {
      "id": "item-2",
      "title": "Item 2"
    },
    {
      "id": "item-3",
      "title": "Item 3"
    }
  ]
}''';

      final capturedItems = <Item>[];
      final capturedIds = <String>[];

      UniversalFeed.parseFromString(
        json,
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
      const json = '''
{
  "version": "https://jsonfeed.org/version/1",
  "title": "Tech Blog",
  "items": [
    {
      "id": "article-1",
      "title": "Dart Article",
      "reading_time": 5
    },
    {
      "id": "article-2",
      "title": "Python Article",
      "reading_time": 8
    },
    {
      "id": "article-3",
      "title": "Dart Tutorial",
      "reading_time": 12
    }
  ]
}''';

      // User-defined typed storage
      final customData = <String, int>{};

      final feed = UniversalFeed.parseFromString(
        json,
        onItemParse: (item, raw) {
          if (raw is JsonRawElement) {
            raw.json.ifPresent<int>('reading_time', (value) {
              customData[item.itemId] = value;
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

    test('nested JSON object extraction', () {
      const json = '''
{
  "version": "https://jsonfeed.org/version/1",
  "title": "Test Feed",
  "items": [
    {
      "id": "item-1",
      "title": "Article",
      "custom_metadata": {
        "category": "Technology",
        "rating": 4.5,
        "stats": {
          "views": 1000,
          "likes": 50
        }
      }
    }
  ]
}''';

      String? category;
      double? rating;
      int? views;
      int? likes;

      UniversalFeed.parseFromString(
        json,
        onItemParse: (item, raw) {
          if (raw is JsonRawElement) {
            raw.json.ifPresent<Map<String, dynamic>>('custom_metadata', (metadata) {
              metadata
                ..ifPresent<String>('category', (value) => category = value)
                ..ifPresent<double>('rating', (value) => rating = value)
                ..ifPresent<Map<String, dynamic>>('stats', (stats) {
                  stats
                    ..ifPresent<int>('views', (value) => views = value)
                    ..ifPresent<int>('likes', (value) => likes = value);
                });
            });
          }
        },
      );

      expect(category, 'Technology');
      expect(rating, 4.5);
      expect(views, 1000);
      expect(likes, 50);
    });

    test('callback can access both parsed fields and custom fields', () {
      const json = '''
{
  "version": "https://jsonfeed.org/version/1",
  "title": "Test Feed",
  "items": [
    {
      "id": "item-1",
      "title": "Standard Title",
      "summary": "Standard Description",
      "custom_author": "Custom Author Name",
      "custom_rating": 4.5
    }
  ]
}''';

      String? standardTitle;
      String? standardDescription;
      String? customAuthor;
      double? customRating;

      UniversalFeed.parseFromString(
        json,
        onItemParse: (item, raw) {
          standardTitle = item.title;
          standardDescription = item.description;

          if (raw is JsonRawElement) {
            raw.json.ifPresent<String>('custom_author', (value) => customAuthor = value);
            raw.json.ifPresent<double>('custom_rating', (value) => customRating = value);
          }
        },
      );

      expect(standardTitle, 'Standard Title');
      expect(standardDescription, 'Standard Description');
      expect(customAuthor, 'Custom Author Name');
      expect(customRating, 4.5);
    });
  });

  group('JSON Feed 1.1 Callbacks', () {
    test('onChannelParse works with JSON Feed 1.1', () {
      const json = '''
{
  "version": "https://jsonfeed.org/version/1.1",
  "title": "Test Feed 1.1",
  "home_page_url": "https://example.com",
  "feed_url": "https://example.com/feed.json",
  "language": "en-US"
}''';

      UniversalFeed? capturedFeed;
      RawElement? capturedRaw;

      final feed = UniversalFeed.parseFromString(
        json,
        onChannelParse: (feed, raw) {
          capturedFeed = feed;
          capturedRaw = raw;
        },
      );

      expect(capturedFeed, isNotNull);
      expect(capturedRaw, isNotNull);
      expect(capturedFeed, same(feed));

      expect(capturedFeed!.title, 'Test Feed 1.1');
      expect(capturedFeed!.language, 'en-US');
    });

    test('onItemParse works with JSON Feed 1.1', () {
      const json = '''
{
  "version": "https://jsonfeed.org/version/1.1",
  "title": "Test Feed",
  "items": [
    {
      "id": "item-1",
      "title": "Entry 1.1",
      "url": "https://example.com/entry1",
      "content_text": "First entry in 1.1"
    }
  ]
}''';

      Item? capturedItem;
      RawElement? capturedRaw;

      UniversalFeed.parseFromString(
        json,
        onItemParse: (item, raw) {
          capturedItem = item;
          capturedRaw = raw;
        },
      );

      expect(capturedItem, isNotNull);
      expect(capturedRaw, isNotNull);

      expect(capturedItem!.title, 'Entry 1.1');
      expect(capturedItem!.guid, 'item-1');
      expect(capturedItem!.itemId, 'item_0');
    });

    test('custom field extraction works with JSON Feed 1.1', () {
      const json = '''
{
  "version": "https://jsonfeed.org/version/1.1",
  "title": "Test Feed",
  "items": [
    {
      "id": "article-1",
      "title": "Article",
      "custom_rating": 4.5
    }
  ]
}''';

      double? customRating;

      UniversalFeed.parseFromString(
        json,
        onItemParse: (item, raw) {
          if (raw is JsonRawElement) {
            raw.json.ifPresent<double>('custom_rating', (value) => customRating = value);
          }
        },
      );

      expect(customRating, 4.5);
    });
  });
}
