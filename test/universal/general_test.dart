import 'package:test/test.dart';
import 'package:universal_feed/src/shared/shared.dart';
import 'package:universal_feed/universal_feed.dart';
import 'package:xml/xml.dart';

void main() {
  test('must throw exception if feed type unknown', () {
    expect(
      () {
        try {
          UniversalFeed.parseFromString('<something />');
        } catch (e) {
          e.toString();
          rethrow;
        }
      },
      throwsA(const TypeMatcher<FeedError>()),
    );
  });

  test('must throw exception if text type unknown', () {
    final doc = XmlDocument.parse('<something />');
    expect(
      () => textDecoder('something', doc.rootElement),
      throwsA(const TypeMatcher<FeedError>()),
    );
  });

  test('must return null if document is invalid', () {
    final rc = UniversalFeed.tryParse('content');
    expect(rc, isNull);
  });

  test('must return null if document is malformed', () {
    final rc = UniversalFeed.tryParse('<content>');
    expect(rc, isNull);
  });
}
