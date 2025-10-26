import 'package:test/test.dart';
import 'package:universal_feed/src/shared/extensions.dart';
import 'package:universal_feed/universal_feed.dart';
import 'package:xml/xml.dart';

void main() {
  group('JsonMapExtensions', () {
    group('getTyped', () {
      test('returns value when key exists and type matches', () {
        final map = <String, dynamic>{
          'string': 'hello',
          'int': 42,
          'bool': true,
          'list': [1, 2, 3],
          'map': {'nested': 'value'},
          'double': 3.14,
        };

        expect(map.getTyped<String>('string'), equals('hello'));
        expect(map.getTyped<int>('int'), equals(42));
        expect(map.getTyped<bool>('bool'), equals(true));
        expect(map.getTyped<List<int>>('list'), equals([1, 2, 3]));
        expect(
          map.getTyped<Map<String, String>>('map'),
          equals({'nested': 'value'}),
        );
        expect(map.getTyped<double>('double'), equals(3.14));
      });

      test('returns null when key exists but type does not match', () {
        final map = <String, dynamic>{
          'string': 'hello',
          'int': 42,
          'bool': true,
        };

        expect(map.getTyped<int>('string'), isNull);
        expect(map.getTyped<String>('int'), isNull);
        expect(map.getTyped<int>('bool'), isNull);
        expect(map.getTyped<List<int>>('string'), isNull);
      });

      test('returns null when key does not exist', () {
        final map = <String, dynamic>{'existing': 'value'};

        expect(map.getTyped<String>('nonexistent'), isNull);
        expect(map.getTyped<int>('missing'), isNull);
        expect(map.getTyped<bool>('noThere'), isNull);
      });

      test('handles null values correctly', () {
        final map = <String, dynamic>{
          'nullValue': null,
          'string': 'hello',
        };

        expect(map.getTyped<String>('nullValue'), isNull);
        expect(map.getTyped<dynamic>('nullValue'), isNull);
        expect(map.getTyped<String>('string'), equals('hello'));
      });

      test('works with empty map', () {
        final map = <String, dynamic>{};

        expect(map.getTyped<String>('any'), isNull);
        expect(map.getTyped<int>('key'), isNull);
      });

      test('handles complex nested types', () {
        final map = <String, dynamic>{
          'nestedList': [
            {'id': 1, 'name': 'item1'},
            {'id': 2, 'name': 'item2'},
          ],
          'nestedMap': {
            'level1': {
              'level2': ['a', 'b', 'c'],
            },
          },
        };

        expect(
          map.getTyped<List<Map<String, dynamic>>>('nestedList'),
          isA<List<Map<String, dynamic>>>(),
        );
        expect(
          map.getTyped<Map<String, dynamic>>('nestedMap'),
          isA<Map<String, dynamic>>(),
        );
        expect(map.getTyped<String>('nestedList'), isNull);
      });

      test('handles num and its subtypes', () {
        final map = <String, dynamic>{
          'int': 42,
          'double': 3.14,
        };

        expect(map.getTyped<num>('int'), equals(42));
        expect(map.getTyped<num>('double'), equals(3.14));
        expect(map.getTyped<int>('int'), equals(42));
        expect(map.getTyped<double>('double'), equals(3.14));
        expect(map.getTyped<double>('int'), isNull);
        expect(map.getTyped<int>('double'), isNull);
      });
    });

    group('ifPresent', () {
      test('calls callback when key exists and type matches', () {
        final map = <String, dynamic>{
          'string': 'hello',
          'int': 42,
          'bool': true,
        };

        String? capturedString;
        int? capturedInt;
        bool? capturedBool;

        map
          ..ifPresent<String>('string', (value) => capturedString = value)
          ..ifPresent<int>('int', (value) => capturedInt = value)
          ..ifPresent<bool>('bool', (value) => capturedBool = value);

        expect(capturedString, equals('hello'));
        expect(capturedInt, equals(42));
        expect(capturedBool, equals(true));
      });

      test(
        'does not call callback when key exists but type does not match',
        () {
          final map = <String, dynamic>{
            'string': 'hello',
            'int': 42,
          };

          var callbackCalled = false;

          map.ifPresent<int>('string', (value) => callbackCalled = true);
          expect(callbackCalled, isFalse);

          map.ifPresent<String>('int', (value) => callbackCalled = true);
          expect(callbackCalled, isFalse);
        },
      );

      test('does not call callback when key does not exist', () {
        final map = <String, dynamic>{'existing': 'value'};

        var callbackCalled = false;

        map.ifPresent<String>('nonexistent', (value) => callbackCalled = true);
        expect(callbackCalled, isFalse);

        map.ifPresent<int>('missing', (value) => callbackCalled = true);
        expect(callbackCalled, isFalse);
      });

      test('does not call callback for null values', () {
        final map = <String, dynamic>{
          'nullValue': null,
          'string': 'hello',
        };

        var callbackCalled = false;

        map.ifPresent<String>('nullValue', (value) => callbackCalled = true);
        expect(callbackCalled, isFalse);

        map.ifPresent<dynamic>('nullValue', (value) => callbackCalled = true);
        expect(callbackCalled, isFalse);

        // But should call for non-null values
        map.ifPresent<String>('string', (value) => callbackCalled = true);
        expect(callbackCalled, isTrue);
      });

      test('works with empty map', () {
        final map = <String, dynamic>{};

        var callbackCalled = false;
        map.ifPresent<String>('any', (value) => callbackCalled = true);
        expect(callbackCalled, isFalse);
      });

      test('handles complex types in callback', () {
        final map = <String, dynamic>{
          'list': [1, 2, 3],
          'map': {'key': 'value'},
        };

        List<int>? capturedList;
        Map<String, String>? capturedMap;

        map
          ..ifPresent<List<int>>(
            'list',
            (value) => capturedList = value.cast<int>(),
          )
          ..ifPresent<Map<String, dynamic>>(
            'map',
            (value) => capturedMap = value.cast<String, String>(),
          );

        expect(capturedList, equals([1, 2, 3]));
        expect(capturedMap, equals({'key': 'value'}));
      });

      test('callback can modify external state', () {
        final map = <String, dynamic>{
          'numbers': [1, 2, 3, 4, 5],
        };

        var sum = 0;
        map.ifPresent<List<int>>('numbers', (numbers) {
          for (final num in numbers) {
            sum += num;
          }
        });

        expect(sum, equals(15));
      });

      test('multiple calls to ifPresent work independently', () {
        final map = <String, dynamic>{
          'value': 'test',
        };

        var callCount = 0;
        map
          ..ifPresent<String>('value', (value) => callCount++)
          ..ifPresent<String>('value', (value) => callCount++)
          ..ifPresent<int>(
            'value',
            (value) => callCount++,
          ); // Should not increment

        expect(callCount, equals(2));
      });
    });
  });

  group('XmlElementParsing', () {
    group('ifPresent', () {
      test('calls callback when element exists', () {
        final xml = XmlDocument.parse('''
          <root>
            <title>Hello World</title>
            <description>Test description</description>
          </root>
        ''');
        final root = xml.rootElement;

        String? capturedTitle;
        String? capturedDescription;

        root
          ..ifPresent('title', (text) => capturedTitle = text)
          ..ifPresent('description', (text) => capturedDescription = text);

        expect(capturedTitle, equals('Hello World'));
        expect(capturedDescription, equals('Test description'));
      });

      test('does not call callback when element does not exist', () {
        final xml = XmlDocument.parse('''
          <root>
            <title>Hello World</title>
          </root>
        ''');
        final root = xml.rootElement;

        var callbackCalled = false;
        root.ifPresent('nonexistent', (text) => callbackCalled = true);

        expect(callbackCalled, isFalse);
      });

      test('handles elements with namespace', () {
        final xml = XmlDocument.parse('''
          <root xmlns:dc="http://purl.org/dc/elements/1.1/">
            <dc:creator>John Doe</dc:creator>
            <dc:subject>Technology</dc:subject>
          </root>
        ''');
        final root = xml.rootElement;

        String? capturedCreator;
        String? capturedSubject;

        root
          ..ifPresent(
            'creator',
            (text) => capturedCreator = text,
            ns: 'http://purl.org/dc/elements/1.1/',
          )
          ..ifPresent(
            'subject',
            (text) => capturedSubject = text,
            ns: 'http://purl.org/dc/elements/1.1/',
          );

        expect(capturedCreator, equals('John Doe'));
        expect(capturedSubject, equals('Technology'));
      });

      test('does not call callback when namespace does not match', () {
        final xml = XmlDocument.parse('''
          <root xmlns:dc="http://purl.org/dc/elements/1.1/">
            <dc:creator>John Doe</dc:creator>
          </root>
        ''');
        final root = xml.rootElement;

        var callbackCalled = false;
        root.ifPresent(
          'creator',
          (text) => callbackCalled = true,
          ns: 'http://wrong-namespace/',
        );

        expect(callbackCalled, isFalse);
      });

      test('handles empty element text', () {
        final xml = XmlDocument.parse('''
          <root>
            <empty></empty>
            <selfClosing />
          </root>
        ''');
        final root = xml.rootElement;

        String? capturedEmpty;
        String? capturedSelfClosing;

        root
          ..ifPresent('empty', (text) => capturedEmpty = text)
          ..ifPresent('selfClosing', (text) => capturedSelfClosing = text);

        expect(capturedEmpty, equals(''));
        expect(capturedSelfClosing, equals(''));
      });

      test('extracts innerText correctly with nested elements', () {
        final xml = XmlDocument.parse('''
          <root>
            <content>Plain text <b>bold text</b> more text</content>
          </root>
        ''');
        final root = xml.rootElement;

        String? capturedContent;
        root.ifPresent('content', (text) => capturedContent = text);

        expect(capturedContent, equals('Plain text bold text more text'));
      });

      test('handles elements with CDATA', () {
        final xml = XmlDocument.parse('''
          <root>
            <description><![CDATA[<p>HTML content</p>]]></description>
          </root>
        ''');
        final root = xml.rootElement;

        String? capturedDescription;
        root.ifPresent('description', (text) => capturedDescription = text);

        expect(capturedDescription, equals('<p>HTML content</p>'));
      });

      test('handles whitespace in element text', () {
        final xml = XmlDocument.parse('''
          <root>
            <title>
              Multi-line
              text
            </title>
          </root>
        ''');
        final root = xml.rootElement;

        String? capturedTitle;
        root.ifPresent('title', (text) => capturedTitle = text);

        expect(capturedTitle, contains('Multi-line'));
        expect(capturedTitle, contains('text'));
      });
    });

    group('ifPresentXml', () {
      test('calls callback with XmlElement when element exists', () {
        final xml = XmlDocument.parse('''
          <root>
            <item id="1">
              <title>Test Item</title>
            </item>
          </root>
        ''');
        final root = xml.rootElement;

        XmlElement? capturedElement;
        root.ifPresentXml('item', (element) => capturedElement = element);

        expect(capturedElement, isNotNull);
        expect(capturedElement!.getAttribute('id'), equals('1'));
        expect(capturedElement!.findElements('title').first.innerText, equals('Test Item'));
      });

      test('does not call callback when element does not exist', () {
        final xml = XmlDocument.parse('''
          <root>
            <item>Test</item>
          </root>
        ''');
        final root = xml.rootElement;

        var callbackCalled = false;
        root.ifPresentXml('nonexistent', (element) => callbackCalled = true);

        expect(callbackCalled, isFalse);
      });

      test('handles elements with namespace', () {
        final xml = XmlDocument.parse('''
          <root xmlns:media="http://search.yahoo.com/mrss/">
            <media:content url="http://example.com/video.mp4" type="video/mp4" />
          </root>
        ''');
        final root = xml.rootElement;

        XmlElement? capturedElement;
        root.ifPresentXml(
          'content',
          (element) => capturedElement = element,
          ns: 'http://search.yahoo.com/mrss/',
        );

        expect(capturedElement, isNotNull);
        expect(
          capturedElement!.getAttribute('url'),
          equals('http://example.com/video.mp4'),
        );
        expect(capturedElement!.getAttribute('type'), equals('video/mp4'));
      });

      test('does not call callback when namespace does not match', () {
        final xml = XmlDocument.parse('''
          <root xmlns:media="http://search.yahoo.com/mrss/">
            <media:content url="test.mp4" />
          </root>
        ''');
        final root = xml.rootElement;

        var callbackCalled = false;
        root.ifPresentXml(
          'content',
          (element) => callbackCalled = true,
          ns: 'http://wrong-namespace/',
        );

        expect(callbackCalled, isFalse);
      });

      test('allows nested element processing', () {
        final xml = XmlDocument.parse('''
          <root>
            <parent>
              <child>Nested content</child>
            </parent>
          </root>
        ''');
        final root = xml.rootElement;

        String? nestedText;
        root.ifPresentXml('parent', (parent) {
          parent.ifPresent('child', (text) => nestedText = text);
        });

        expect(nestedText, equals('Nested content'));
      });

      test('provides access to element attributes', () {
        final xml = XmlDocument.parse('''
          <root>
            <link href="http://example.com" rel="alternate" type="text/html" />
          </root>
        ''');
        final root = xml.rootElement;

        final attributes = <String, String>{};
        root.ifPresentXml('link', (element) {
          attributes['href'] = element.getAttribute('href') ?? '';
          attributes['rel'] = element.getAttribute('rel') ?? '';
          attributes['type'] = element.getAttribute('type') ?? '';
        });

        expect(attributes['href'], equals('http://example.com'));
        expect(attributes['rel'], equals('alternate'));
        expect(attributes['type'], equals('text/html'));
      });
    });

    group('forEachElement', () {
      test('calls callback for each matching element', () {
        final xml = XmlDocument.parse('''
          <root>
            <item>First</item>
            <item>Second</item>
            <item>Third</item>
          </root>
        ''');
        final root = xml.rootElement;

        final items = <String>[];
        root.forEachElement('item', items.add);

        expect(items, equals(['First', 'Second', 'Third']));
      });

      test('does not call callback when no elements match', () {
        final xml = XmlDocument.parse('''
          <root>
            <item>Test</item>
          </root>
        ''');
        final root = xml.rootElement;

        var callbackCalled = false;
        root.forEachElement('nonexistent', (text) => callbackCalled = true);

        expect(callbackCalled, isFalse);
      });

      test('handles elements with namespace', () {
        final xml = XmlDocument.parse('''
          <root xmlns:dc="http://purl.org/dc/elements/1.1/">
            <dc:creator>Author 1</dc:creator>
            <dc:creator>Author 2</dc:creator>
            <dc:creator>Author 3</dc:creator>
          </root>
        ''');
        final root = xml.rootElement;

        final creators = <String>[];
        root.forEachElement(
          'creator',
          creators.add,
          ns: 'http://purl.org/dc/elements/1.1/',
        );

        expect(creators, equals(['Author 1', 'Author 2', 'Author 3']));
      });

      test('does not call callback when namespace does not match', () {
        final xml = XmlDocument.parse('''
          <root xmlns:dc="http://purl.org/dc/elements/1.1/">
            <dc:creator>Author</dc:creator>
          </root>
        ''');
        final root = xml.rootElement;

        var callbackCalled = false;
        root.forEachElement(
          'creator',
          (text) => callbackCalled = true,
          ns: 'http://wrong-namespace/',
        );

        expect(callbackCalled, isFalse);
      });

      test('handles empty list of elements', () {
        final xml = XmlDocument.parse('<root></root>');
        final root = xml.rootElement;

        final items = <String>[];
        root.forEachElement('item', items.add);

        expect(items, isEmpty);
      });

      test('handles elements with varying content', () {
        final xml = XmlDocument.parse('''
          <root>
            <category>Technology</category>
            <category></category>
            <category>Science</category>
          </root>
        ''');
        final root = xml.rootElement;

        final categories = <String>[];
        root.forEachElement('category', categories.add);

        expect(categories, equals(['Technology', '', 'Science']));
      });

      test('maintains order of elements', () {
        final xml = XmlDocument.parse('''
          <root>
            <num>1</num>
            <num>2</num>
            <num>3</num>
            <num>4</num>
            <num>5</num>
          </root>
        ''');
        final root = xml.rootElement;

        final numbers = <String>[];
        root.forEachElement('num', numbers.add);

        expect(numbers, equals(['1', '2', '3', '4', '5']));
      });

      test('handles nested elements with innerText extraction', () {
        final xml = XmlDocument.parse('''
          <root>
            <item>Text <b>bold</b> more</item>
            <item>Another <i>italic</i> text</item>
          </root>
        ''');
        final root = xml.rootElement;

        final items = <String>[];
        root.forEachElement('item', items.add);

        expect(items[0], equals('Text bold more'));
        expect(items[1], equals('Another italic text'));
      });
    });

    group('forEachElementXml', () {
      test('calls callback with each matching XmlElement', () {
        final xml = XmlDocument.parse('''
          <root>
            <item id="1">First</item>
            <item id="2">Second</item>
            <item id="3">Third</item>
          </root>
        ''');
        final root = xml.rootElement;

        final ids = <String>[];
        final texts = <String>[];
        root.forEachElementXml('item', (element) {
          ids.add(element.getAttribute('id') ?? '');
          texts.add(element.innerText);
        });

        expect(ids, equals(['1', '2', '3']));
        expect(texts, equals(['First', 'Second', 'Third']));
      });

      test('does not call callback when no elements match', () {
        final xml = XmlDocument.parse('''
          <root>
            <item>Test</item>
          </root>
        ''');
        final root = xml.rootElement;

        var callbackCalled = false;
        root.forEachElementXml('nonexistent', (element) => callbackCalled = true);

        expect(callbackCalled, isFalse);
      });

      test('handles elements with namespace', () {
        final xml = XmlDocument.parse('''
          <root xmlns:media="http://search.yahoo.com/mrss/">
            <media:content url="video1.mp4" />
            <media:content url="video2.mp4" />
            <media:content url="video3.mp4" />
          </root>
        ''');
        final root = xml.rootElement;

        final urls = <String>[];
        root.forEachElementXml(
          'content',
          (element) => urls.add(element.getAttribute('url') ?? ''),
          ns: 'http://search.yahoo.com/mrss/',
        );

        expect(urls, equals(['video1.mp4', 'video2.mp4', 'video3.mp4']));
      });

      test('does not call callback when namespace does not match', () {
        final xml = XmlDocument.parse('''
          <root xmlns:media="http://search.yahoo.com/mrss/">
            <media:content url="test.mp4" />
          </root>
        ''');
        final root = xml.rootElement;

        var callbackCalled = false;
        root.forEachElementXml(
          'content',
          (element) => callbackCalled = true,
          ns: 'http://wrong-namespace/',
        );

        expect(callbackCalled, isFalse);
      });

      test('allows nested element processing', () {
        final xml = XmlDocument.parse('''
          <root>
            <item>
              <title>Title 1</title>
              <description>Desc 1</description>
            </item>
            <item>
              <title>Title 2</title>
              <description>Desc 2</description>
            </item>
          </root>
        ''');
        final root = xml.rootElement;

        final items = <Map<String, String>>[];
        root.forEachElementXml('item', (element) {
          final item = <String, String>{};
          element
            ..ifPresent('title', (text) => item['title'] = text)
            ..ifPresent('description', (text) => item['description'] = text);
          items.add(item);
        });

        expect(items.length, equals(2));
        expect(items[0], equals({'title': 'Title 1', 'description': 'Desc 1'}));
        expect(items[1], equals({'title': 'Title 2', 'description': 'Desc 2'}));
      });

      test('handles empty list of elements', () {
        final xml = XmlDocument.parse('<root></root>');
        final root = xml.rootElement;

        final elements = <XmlElement>[];
        root.forEachElementXml('item', elements.add);

        expect(elements, isEmpty);
      });

      test('maintains order of elements', () {
        final xml = XmlDocument.parse('''
          <root>
            <item order="1" />
            <item order="2" />
            <item order="3" />
            <item order="4" />
          </root>
        ''');
        final root = xml.rootElement;

        final orders = <String>[];
        root.forEachElementXml(
          'item',
          (element) => orders.add(element.getAttribute('order') ?? ''),
        );

        expect(orders, equals(['1', '2', '3', '4']));
      });

      test('allows complex transformations on elements', () {
        final xml = XmlDocument.parse('''
          <root>
            <link href="http://example.com/1" rel="alternate" />
            <link href="http://example.com/2" rel="self" />
            <link href="http://example.com/3" rel="alternate" />
          </root>
        ''');
        final root = xml.rootElement;

        final alternateLinks = <String>[];
        root.forEachElementXml('link', (element) {
          if (element.getAttribute('rel') == 'alternate') {
            alternateLinks.add(element.getAttribute('href') ?? '');
          }
        });

        expect(alternateLinks, equals(['http://example.com/1', 'http://example.com/3']));
      });
    });

    group('decodeText', () {
      test('decodes Atom 1.0+ text content', () {
        final xml = XmlDocument.parse('''
          <root>
            <title type="text">Plain Text</title>
          </root>
        ''');
        final element = xml.rootElement.findElements('title').first;

        final result = element.decodeText(FeedKind.atom);
        expect(result, equals('Plain Text'));
      });

      test('decodes Atom 0.3 content with mode attribute', () {
        final xml = XmlDocument.parse('''
          <root>
            <title mode="xml">XML Content</title>
          </root>
        ''');
        final element = xml.rootElement.findElements('title').first;

        final result = element.decodeText(FeedKind.atom, atomVersion: '0.3');
        expect(result, equals('XML Content'));
      });

      test('decodes RSS content', () {
        final xml = XmlDocument.parse('''
          <root>
            <title>RSS Title</title>
          </root>
        ''');
        final element = xml.rootElement.findElements('title').first;

        final result = element.decodeText(FeedKind.rss);
        expect(result, equals('RSS Title'));
      });

      test('throws StateError for JSON feed (unreachable)', () {
        final xml = XmlDocument.parse('''
          <root>
            <title type="text">JSON Title</title>
          </root>
        ''');
        final element = xml.rootElement.findElements('title').first;

        expect(
          () => element.decodeText(FeedKind.json),
          throwsStateError,
        );
      });

      test('uses default text type for Atom when no type attribute', () {
        final xml = XmlDocument.parse('''
          <root>
            <title>Default Text</title>
          </root>
        ''');
        final element = xml.rootElement.findElements('title').first;

        final result = element.decodeText(FeedKind.atom);
        expect(result, equals('Default Text'));
      });
    });

    group('decodeAs', () {
      test('decodes with explicit type', () {
        final xml = XmlDocument.parse('''
          <root>
            <content>Test Content</content>
          </root>
        ''');
        final element = xml.rootElement.findElements('content').first;

        final result = element.decodeAs('text');
        expect(result, equals('Test Content'));
      });
    });
  });
}
