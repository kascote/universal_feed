// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:universal_feed/universal_feed.dart';

void main(List<String> args) async {
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
  print('feed kind: ${feed.meta.kind}');
  print('feed extensions: ${feed.meta.extensions}');
  print('feed version: ${feed.meta.version}');
  print('...<');
  print('feed title: ${feed.title}');
  print('feed description: ${feed.description}');
  print('site link: ${feed.htmlLink}');
  print('feed link: ${feed.htmlLink}');
  print('...<');
  final itemsLength = min(feed.items.length, 5);
  for (var i = 0; i < itemsLength; i++) {
    final item = feed.items[i];
    print('item title: ${item.title}');
    print('item description: ${item.description}');
    print('item link: ${item.links.first}');
  }
}

// function to read a file from internet
Future<String> readUrl(String url) async {
  final httpClient = HttpClient();
  final request = await httpClient.getUrl(Uri.parse(url));
  final response = await request.close();
  final contents = await response.transform<String>(utf8.decoder).join();
  return contents;
}
