import 'package:test/test.dart';
import 'package:universal_feed/universal_feed.dart';

void main() {
  group('FeedError', () {
    test('creates error with message', () {
      final error = FeedError('test error message');
      expect(error.message, 'test error message');
    });

    test('toString returns message', () {
      final error = FeedError('test error');
      expect(error.toString(), 'test error');
    });
  });

  group('FeedException', () {
    test('creates exception with message', () {
      final exception = FeedException('test exception message');
      expect(exception.message, 'test exception message');
    });

    test('toString returns message', () {
      final exception = FeedException('test exception');
      expect(exception.toString(), 'test exception');
    });
  });

  group('UnsupportedFeedFormatException', () {
    test('creates exception with detected format', () {
      final exception = UnsupportedFeedFormatException(detectedFormat: 'custom');
      expect(exception.detectedFormat, 'custom');
      expect(exception.message, 'Unsupported feed format: custom');
    });

    test('creates exception without detected format', () {
      final exception = UnsupportedFeedFormatException();
      expect(exception.detectedFormat, isNull);
      expect(exception.message, 'Unsupported feed format');
    });

    test('toString returns formatted message', () {
      final exception = UnsupportedFeedFormatException(detectedFormat: 'unknown');
      expect(exception.toString(), 'Unsupported feed format: unknown');
    });
  });

  group('MissingRequiredFieldException', () {
    test('creates exception with field name and feed type', () {
      final exception = MissingRequiredFieldException(
        fieldName: 'version',
        feedType: 'JSON Feed',
      );
      expect(exception.fieldName, 'version');
      expect(exception.feedType, 'JSON Feed');
      expect(exception.message, 'JSON Feed missing required field: version');
    });

    test('toString returns formatted message', () {
      final exception = MissingRequiredFieldException(
        fieldName: 'title',
        feedType: 'RSS',
      );
      expect(exception.toString(), 'RSS missing required field: title');
    });
  });

  group('InvalidFieldValueException', () {
    test('creates exception with field details', () {
      final exception = InvalidFieldValueException(
        fieldName: 'version',
        actualValue: 'invalid',
        expectedType: 'URI',
      );
      expect(exception.fieldName, 'version');
      expect(exception.actualValue, 'invalid');
      expect(exception.expectedType, 'URI');
      expect(
        exception.message,
        'Invalid value for field "version": expected URI, got invalid',
      );
    });

    test('toString returns formatted message', () {
      final exception = InvalidFieldValueException(
        fieldName: 'count',
        actualValue: 'abc',
        expectedType: 'number',
      );
      expect(
        exception.toString(),
        'Invalid value for field "count": expected number, got abc',
      );
    });
  });
}
