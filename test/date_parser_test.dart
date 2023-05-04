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
}
