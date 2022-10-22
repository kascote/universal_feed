import 'dart:io';

import 'package:test/test.dart';
import 'package:universal_feed/universal_feed.dart';

import 'atom10_cases.dart';
import 'atom_cases.dart';
import 'dcterm_cases.dart';
import 'georss_cases.dart';
import 'itunes_cases.dart';
import 'media_rss_cases.dart';
import 'rss_cases.dart';
import 'syndication_cases.dart';

void main() {
  test(
    'Rss',
    () => rssTests().forEach(
      runner<RSS>(
        './test/wellformed/rss',
        RSS.parseFromString,
      ),
    ),
  );
  test(
    'Atom v0.3',
    () => atomTests().forEach(
      runner<Atom>(
        './test/wellformed/atom',
        Atom.parseFromString,
      ),
    ),
  );
  test(
    'Atom v1.0',
    () => atom10Tests().forEach(
      runner<Atom>(
        './test/wellformed/atom10',
        Atom.parseFromString,
      ),
    ),
  );
  test(
    'Media RSS',
    () => mediaRssTests().forEach(
      runner<RSS>(
        './test/wellformed/media-rss',
        RSS.parseFromString,
      ),
    ),
  );
  test(
    'Itunes Podcast',
    () => itunesTests().forEach(
      runner<RSS>(
        './test/wellformed/itunes',
        RSS.parseFromString,
      ),
    ),
  );
  test(
    'Syndication',
    () => syndycationTests().forEach(
      runner<RSS>(
        './test/wellformed/syndication',
        RSS.parseFromString,
      ),
    ),
  );
  test(
    'Geo RSS',
    () => geoRssTests().forEach(
      runner<RSS>(
        './test/wellformed/georss',
        RSS.parseFromString,
      ),
    ),
  );
  test(
    'Geo Atom',
    () => geoAtomTests().forEach(
      runner<Atom>(
        './test/wellformed/georss',
        Atom.parseFromString,
      ),
    ),
  );
  test(
    'DcTerms',
    () => dctermsTests().forEach(
      runner<RSS>(
        './test/wellformed/dcTerms',
        RSS.parseFromString,
      ),
    ),
  );
}

typedef TGenerator<T> = T Function(String);
typedef TTestCall<T> = bool Function(T);
typedef Tfx<T> = void Function(String, TTestCall<T>);

Tfx<T> runner<T>(String path, TGenerator<T> generator) {
  return (filename, fx) {
    final content = File('$path/$filename').readAsStringSync();

    bool rc;
    final sb = StringBuffer()..writeln('\n$filename: -----<<');
    try {
      final p = generator(content);
      rc = fx(p);
    } catch (err, stk) {
      rc = false;
      sb
        ..writeln(err)
        ..writeln(stk);
    }

    assert(rc, sb.toString());
  };
}
