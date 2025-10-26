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
      throwsA(const TypeMatcher<UnsupportedFeedFormatException>()),
    );
  });

  test('must return empty string for unknown text encoding type', () {
    final doc = XmlDocument.parse('<something />');
    final result = textDecoder('something', doc.rootElement);
    expect(result, isEmpty);
  });

  test('must return null if document is invalid', () {
    final rc = UniversalFeed.tryParse('content');
    expect(rc, isNull);
  });

  test('must return null if document is malformed', () {
    final rc = UniversalFeed.tryParse('<content>');
    expect(rc, isNull);
  });

  test('tryParse must throw ArgumentError for empty content', () {
    expect(
      () => UniversalFeed.tryParse(''),
      throwsArgumentError,
    );
  });

  test('tryParse must return null for unknown feed format', () {
    final rc = UniversalFeed.tryParse('<something />');
    expect(rc, isNull);
  });

  test('tryParse must return null for invalid JSON', () {
    final rc = UniversalFeed.tryParse('{invalid json}');
    expect(rc, isNull);
  });

  test('tryParse must return null for JSON Feed missing required fields', () {
    final rc = UniversalFeed.tryParse('{"version": "https://jsonfeed.org/version/1.1"}');
    expect(rc, isNull);
  });

  test('parseFromString must throw ArgumentError for empty content', () {
    expect(
      () => UniversalFeed.parseFromString(''),
      throwsArgumentError,
    );
  });

  test('parseFromString must throw MissingRequiredFieldException with field details', () {
    try {
      UniversalFeed.parseFromString('{"version": "https://jsonfeed.org/version/1.1"}');
      fail('Expected MissingRequiredFieldException');
    } on MissingRequiredFieldException catch (e) {
      expect(e.fieldName, equals('title'));
      expect(e.feedType, equals('JSON Feed'));
      expect(e.message, contains('title'));
    }
  });

  test('parseFromString must throw InvalidFieldValueException for invalid JSON Feed version', () {
    try {
      UniversalFeed.parseFromString('{"version": "ht tp://invalid", "title": "Test"}');
      fail('Expected InvalidFieldValueException');
    } on InvalidFieldValueException catch (e) {
      expect(e.fieldName, equals('version'));
      expect(e.actualValue, equals('ht tp://invalid'));
      expect(e.expectedType, equals('valid JSON Feed URI'));
      expect(e.message, contains('version'));
      expect(e.message, contains('ht tp://invalid'));
    }
  });
}
