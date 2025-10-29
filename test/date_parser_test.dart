import 'package:test/test.dart';
import 'package:universal_feed/universal_feed.dart';

void main() {
  test('valid RFC 822 (2-digit year)', () {
    final d = Timestamp('Thu, 01 Jan 04 19:48:21 GMT');
    expect(d.parseValue()?.toIso8601String(), '2004-01-01T19:48:21.000Z');
  });

  test('valid RFC 822 (4-digit year)', () {
    final d = Timestamp('Thu, 01 Jan 2004 19:48:21 GMT');
    expect(d.parseValue()?.toIso8601String(), '2004-01-01T19:48:21.000Z');
  });

  test('valid RFC 822 (4-digit year) numeric timezone UTC', () {
    final d = Timestamp('Fri, 23 Sep 2022 12:44:42 +0000');
    expect(d.parseValue()?.toIso8601String(), '2022-09-23T12:44:42.000Z');
  });

  test('valid RFC 822 (4-digit year) numeric timezone', () {
    final d = Timestamp('Mon, 31 Oct 2022 16:13:29 -0400');
    expect(d.parseValue()?.toIso8601String(), '2022-10-31T20:13:29.000Z');
  });

  test('valid RFC 822 (4-digit year) TZ with name', () {
    final d = Timestamp('Mon, 19 Sep 2022 18:01:41 PDT'); // gmt -7
    expect(d.parseValue()?.toIso8601String(), '2022-09-20T01:01:41.000Z');
  });

  test('valid RFC 822 (4-digit year) no seconds', () {
    final d = Timestamp('Sat, 24 Sep 2022 16:36 GMT');
    expect(d.parseValue()?.toIso8601String(), '2022-09-24T16:36:00.000Z');
  });

  test('invalid RFC 822 (no time)', () {
    final d = Timestamp('01 Jan 2004');
    expect(d.parseValue()?.toIso8601String(), '2004-01-01T00:00:00.000Z');
  });

  test('invalid RFC 822 (no seconds)', () {
    final d = Timestamp('01 Jan 2004 22:20 GMT');
    expect(d.parseValue()?.toIso8601String(), '2004-01-01T22:20:00.000Z');
  });

  test('invalid RFC 822', () {
    final d = Timestamp('Mon, 31 Oct 2022 17:48:08 Z');
    expect(d.parseValue()?.toIso8601String(), '2022-10-31T17:48:08.000Z');
  });

  test('valid W3CDTF (numeric timezone)', () {
    final d = Timestamp('2003-12-31T10:14:55-08:00');
    expect(d.parseValue()?.toIso8601String(), '2003-12-31T18:14:55.000Z');
  });

  test('valid W3CDTF (UTC timezone)', () {
    final d = Timestamp('2003-12-31T10:14:55Z');
    expect(d.parseValue()?.toIso8601String(), '2003-12-31T10:14:55.000Z');
  });

  test('valid W3CDTF (yyyy)', () {
    final d = Timestamp('2003');
    expect(d.parseValue()?.toIso8601String(), '2003-01-01T00:00:00.000Z');
  });

  test('valid W3CDTF (yyyy-mm)', () {
    final d = Timestamp('2003-12');
    expect(d.parseValue()?.toIso8601String(), '2003-12-01T00:00:00.000Z');
  });

  test('valid W3CDTF (yyyy-mm-dd)', () {
    final d = Timestamp('2003-12-31');
    expect(d.parseValue()?.toIso8601String(), '2003-12-31T00:00:00.000Z');
  });

  test('valid ISO 8601 (yyyymmdd)', () {
    final d = Timestamp('20031231');
    expect(d.parseValue()?.toIso8601String(), '2003-12-31T00:00:00.000Z');
  });

  test('valid W3CDTF (yyyy-mm-dd)', () {
    final d = Timestamp('2003-12-31');
    expect(d.parseValue()?.toIso8601String(), '2003-12-31T00:00:00.000Z');
  });

  test('valid ISO 8601 (yyyymmdd)', () {
    final d = Timestamp('20031231');
    expect(d.parseValue()?.toIso8601String(), '2003-12-31T00:00:00.000Z');
  });

  test('valid ISO 8601 (-yy-mm)', () {
    final d = Timestamp('-03-12');
    expect(d.parseValue()?.toIso8601String(), '2003-12-01T00:00:00.000Z');
  });

  // test('ascii time', () {
  //   const d = Timestamp('Sun Jan 4 16:29:06 PST 2004');
  //   expect(() => d.parseValue(), returnsNormally);
  //   expect(d.parseValue().toIso8601String(), '2003-12-31T00:00:00.000');
  // });

  test('bogus RFC 822 (invalid day/month)', () {
    final d = Timestamp('Thu, 31 Jun 2004 19:48:21 GMT');
    expect(d.parseValue()?.toIso8601String(), '2004-07-01T19:48:21.000Z');
  });

  test('bogus RFC 822 (invalid month)', () {
    final d = Timestamp('Mon, 26 January 2004 16:31:00 EST');
    expect(d.parseValue()?.toIso8601String(), '2004-01-26T16:31:00.000Z');
  });

  test('bogus W3CDTF (invalid hour)', () {
    final d = Timestamp('2003-12-31T25:14:55Z');
    expect(d.parseValue()?.toIso8601String(), '2004-01-01T01:14:55.000Z');
  });

  test('bogus W3CDTF (invalid minute)', () {
    final d = Timestamp('2003-12-31T10:61:55Z');
    expect(d.parseValue()?.toIso8601String(), '2003-12-31T11:01:55.000Z');
  });

  test('bogus W3CDTF (invalid second)', () {
    final d = Timestamp('2003-12-31T10:14:61Z');
    expect(d.parseValue()?.toIso8601String(), '2003-12-31T10:15:01.000Z');
  });

  test('bogus (MSSQL)', () {
    final d = Timestamp('2004-07-08 23:56:58.0');
    expect(d.parseValue()?.toIso8601String(), '2004-07-08T23:56:58.000Z');
  });

  test('bogus (MSSQL-ish, without fractional second)', () {
    final d = Timestamp('2004-07-08 23:56:58');
    expect(d.parseValue()?.toIso8601String(), '2004-07-08T23:56:58.000Z');
  });

  test('valid RFC 822 (1-digit day)', () {
    final d = Timestamp('Thu, 2 Feb 2017 10:40:19 +0000');
    expect(d.parseValue()?.toIso8601String(), '2017-02-02T10:40:19.000Z');
  });

  test('invalid date returns null', () {
    final d = Timestamp('completely invalid date');
    expect(d.parseValue(), isNull);
  });

  test('malformed RFC 822 with invalid month abbrev', () {
    final d = Timestamp('99 XXX 2004 22:20 GMT');
    expect(d.parseValue(), isNull);
  });

  test('malformed RFC 822 with invalid numeric TZ', () {
    final d = Timestamp('Thu, 99 XXX 2004 19:48:21 +9999');
    expect(d.parseValue(), isNull);
  });

  test('malformed RFC 822 with invalid named TZ', () {
    final d = Timestamp('Thu, 99 XXX 2004 19:48:21 ZZZZ');
    expect(d.parseValue(), isNull);
  });

  test('malformed W3CDTF yyyy', () {
    final d = Timestamp('999X');
    expect(d.parseValue(), isNull);
  });

  test('malformed W3CDTF yyyy-mm', () {
    final d = Timestamp('2004-XX');
    expect(d.parseValue(), isNull);
  });

  test('malformed ISO 8601 -yy-mm', () {
    final d = Timestamp('-XX-99');
    expect(d.parseValue(), isNull);
  });

  group('UTC conversion verification', () {
    test('DateTime.parse formats WITH timezone return UTC', () {
      final withZ = Timestamp('2003-12-31T10:14:55Z');
      final withOffset = Timestamp('2003-12-31T10:14:55-05:00');

      final parsedWithZ = withZ.parseValue();
      final parsedWithOffset = withOffset.parseValue();

      expect(parsedWithZ?.isUtc, isTrue, reason: 'Format with Z should be UTC');
      expect(parsedWithOffset?.isUtc, isTrue, reason: 'Format with offset should be UTC');

      expect(parsedWithZ?.toIso8601String(), '2003-12-31T10:14:55.000Z');
      expect(parsedWithOffset?.toIso8601String(), '2003-12-31T15:14:55.000Z');
    });

    test('DateTime.parse formats WITHOUT timezone converted to UTC', () {
      final dateOnly = Timestamp('2003-12-31');
      final mssql = Timestamp('2004-07-08 23:56:58');
      final isoNoTz = Timestamp('20031231');

      final parsedDate = dateOnly.parseValue();
      final parsedMssql = mssql.parseValue();
      final parsedIso = isoNoTz.parseValue();

      // All must be UTC after parseDate()
      expect(parsedDate?.isUtc, isTrue, reason: 'Date-only format should be converted to UTC');
      expect(parsedMssql?.isUtc, isTrue, reason: 'MSSQL format should be converted to UTC');
      expect(parsedIso?.isUtc, isTrue, reason: 'ISO compact format should be converted to UTC');

      // When TZ=UTC, these are midnight UTC
      expect(parsedDate?.toIso8601String(), '2003-12-31T00:00:00.000Z');
      expect(parsedMssql?.toIso8601String(), '2004-07-08T23:56:58.000Z');
      expect(parsedIso?.toIso8601String(), '2003-12-31T00:00:00.000Z');
    });
  });
}
