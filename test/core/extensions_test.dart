import 'package:test/test.dart';
import 'package:universal_feed/src/shared/extensions.dart';

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
        expect(map.getTyped<Map<String, String>>('map'), equals({'nested': 'value'}));
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

        expect(map.getTyped<List<Map<String, dynamic>>>('nestedList'), isA<List<Map<String, dynamic>>>());
        expect(map.getTyped<Map<String, dynamic>>('nestedMap'), isA<Map<String, dynamic>>());
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

      test('does not call callback when key exists but type does not match', () {
        final map = <String, dynamic>{
          'string': 'hello',
          'int': 42,
        };

        var callbackCalled = false;

        map.ifPresent<int>('string', (value) => callbackCalled = true);
        expect(callbackCalled, isFalse);

        map.ifPresent<String>('int', (value) => callbackCalled = true);
        expect(callbackCalled, isFalse);
      });

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
          ..ifPresent<List<int>>('list', (value) => capturedList = value.cast<int>())
          ..ifPresent<Map<String, dynamic>>('map', (value) => capturedMap = value.cast<String, String>());

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
          ..ifPresent<int>('value', (value) => callCount++); // Should not increment

        expect(callCount, equals(2));
      });
    });
  });
}
