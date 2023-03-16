// ignore_for_file: avoid_print
// import 'dart:io';
// import 'dart:math';

// import 'package:universal_feed/universal_feed.dart';

void main(List<String> args) {
  // final file = File(args[0]);
  // final content = file.readAsStringSync();

  // final uf = UniversalFeed(content);
  // if (uf.kind == FeedKind.rss) {
  //   debugRss(uf.rss);
  // } else {
  //   debugAtom(uf.atom);
  // }
}

// void debugRss(RSS uf) {
//   print(uf.version);
//   print('isDc ${uf.namespaces.hasDc}');
//   print('ns ${uf.namespaces}');
//   print('-------');
//   print('title ${uf.channel.title}');
//   print('link ${uf.channel.link?.href}');

//   if (uf.entries == null) {
//     print('NO ENTRIES');
//     return;
//   }

//   for (var i = 0; i < min(5, uf.entries!.length); i++) {
//     print('-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=');
//     final item = uf.entries![i];
//     print('title ${item.title}');
//     print('link ${item.link?.href}');
//   }
// }

// void debugAtom(Atom uf) {
//   print(uf.version);
//   print('isDc ${uf.namespaces.hasDc}');
//   print('ns ${uf.namespaces}');
//   print('-------');
//   print('title ${uf.head.title}');
//   print('links ${uf.head.links?.join(' - ')}');

//   if (uf.entries == null) {
//     print('NO ENTRIES');
//     return;
//   }

//   for (final entry in uf.entries!) {
//     print('-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=');
//     print('title ${entry.title}');
//     print('links ${entry.links?.map((a) => a.toString()).join(' - ')}');
//   }
// }
