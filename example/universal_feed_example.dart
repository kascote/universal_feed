// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:universal_feed/universal_feed.dart';

Future<void> main(List<String> args) async {
  const feeds = [
    'https://www.nasa.gov/rss/dyn/breaking_news.rss',
    'https://pub.dev/feed.atom',
  ];

  for (final feed in feeds) {
    final feedContent = await readUrl(feed);
    final uf = UniversalFeed.parseFromString(feedContent);
    showContent(uf);
    print('-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=');
  }
}

void showContent(UniversalFeed feed) {
  logData('feed kind: ', feed.meta.kind.toString());
  logData('feed extensions: ', feed.meta.extensions.toString());
  logData('feed version: ', feed.meta.version);
  logData('...<', ' ');
  logData('feed title: ', feed.title ?? '');
  logData('feed description: ', feed.description ?? '');
  logData('site link: ', feed.htmlLink?.href ?? '');
  logData('feed link: ', feed.xmlLink?.href ?? '');
  logData('feed published: ', join([feed.published?.value, feed.published?.parseValue()?.toIso8601String()]));
  logData('feed updated: ', join([feed.updated?.value, feed.updated?.parseValue()?.toIso8601String()]));
  logData('...<', ' ');
  final itemsLength = min(feed.items.length, 5);
  for (var i = 0; i < itemsLength; i++) {
    final item = feed.items[i];
    logData('item title: ', item.title ?? '');
    logData('item description: ', item.description ?? '');
    logData('item link: ', item.links.first.href);
    logData('item published: ', join([item.published?.value, item.published?.parseValue()?.toIso8601String()]));
    logData('item updated: ', join([item.updated?.value, item.updated?.parseValue()?.toIso8601String()]));
    print('>-----');
  }
}

String join(List<String?> values) {
  values.removeWhere((element) => element == null || element.isEmpty);
  return values.join(' / ');
}

void logData(String label, String data) {
  if (data.isNotEmpty) print('$label $data');
}

// function to read a file from internet
Future<String> readUrl(String url) async {
  final httpClient = HttpClient();
  final request = await httpClient.getUrl(Uri.parse(url));
  final response = await request.close();
  final contents = await response.transform<String>(utf8.decoder).join();
  return contents;
}
