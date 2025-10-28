import 'package:test/test.dart';
import 'package:universal_feed/universal_feed.dart';
import 'package:xml/xml.dart';

void main() {
  group('RawElement', () {
    test('XmlRawElement can be instantiated', () {
      final element = XmlDocument.parse('<item><title>Test</title></item>').rootElement;
      final raw = XmlRawElement('item_0', element);

      expect(raw.id, 'item_0');
      expect(raw.element, element);
    });

    test('JsonRawElement can be instantiated', () {
      final json = {'title': 'Test', 'content': 'Content'};
      final raw = JsonRawElement('item_0', json);

      expect(raw.id, 'item_0');
      expect(raw.json, json);
    });
  });

  group('Callbacks', () {
    test('parseFromString accepts null callbacks', () {
      const xml = '''
<?xml version="1.0"?>
<rss version="2.0">
  <channel>
    <title>Test</title>
    <description>Test</description>
  </channel>
</rss>''';

      expect(
        () => UniversalFeed.parseFromString(xml),
        returnsNormally,
      );
    });

    test('parseFromString accepts onChannelParse only', () {
      const xml = '''
<?xml version="1.0"?>
<rss version="2.0">
  <channel>
    <title>Test</title>
    <description>Test</description>
  </channel>
</rss>''';

      var called = false;
      UniversalFeed.parseFromString(
        xml,
        onChannelParse: (feed, raw) {
          called = true;
        },
      );

      expect(called, true);
    });

    test('parseFromString accepts onItemParse only', () {
      const xml = '''
<?xml version="1.0"?>
<rss version="2.0">
  <channel>
    <title>Test</title>
    <description>Test</description>
    <item><title>Item 1</title></item>
  </channel>
</rss>''';

      var called = false;
      UniversalFeed.parseFromString(
        xml,
        onItemParse: (item, raw) {
          called = true;
        },
      );

      expect(called, true);
    });

    test('parseFromString accepts both callbacks', () {
      const xml = '''
<?xml version="1.0"?>
<rss version="2.0">
  <channel>
    <title>Test</title>
    <description>Test</description>
    <item><title>Item 1</title></item>
  </channel>
</rss>''';

      var channelCalled = false;
      var itemCalled = false;

      UniversalFeed.parseFromString(
        xml,
        onChannelParse: (feed, raw) {
          channelCalled = true;
        },
        onItemParse: (item, raw) {
          itemCalled = true;
        },
      );

      expect(channelCalled, true);
      expect(itemCalled, true);
    });
  });
}
