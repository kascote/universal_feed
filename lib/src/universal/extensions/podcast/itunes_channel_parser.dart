import 'package:xml/xml.dart';

import '../../../../universal_feed.dart';
import '../../../shared/extensions.dart';
import '../extension_parser.dart';
import 'itunes_channel.dart';

/// iTunes/Podcast channel extension parser - only works at channel level
class ItunesChannelParser implements ChannelExtensionParser {
  /// Creates a new [ItunesChannelParser] with the given namespace URL
  ItunesChannelParser(this.namespaceUrl);

  @override
  final String namespaceUrl;

  @override
  void parseChannel(UniversalFeed feed, XmlElement channel) {
    final ic = ItunesChannel();

    channel
      ..ifPresentXml(
        'image',
        (value) {
          final url = value.getAttribute('href') ?? value.getAttribute('url');
          if (url != null) ic.image = Image(url.trim());
        },
        ns: namespaceUrl,
      )
      ..ifPresentXml(
        'category',
        (value) {
          final cat = value.getAttribute('text')?.trim();
          if (cat == null || cat.isEmpty) return;

          ic.categories.add(Category(label: cat));
          final subCat = value.getElement('category', namespace: namespaceUrl)?.getAttribute('text')?.trim();
          if (subCat != null && subCat.isNotEmpty) ic.categories.add(Category(label: subCat));
        },
        ns: namespaceUrl,
      )
      ..ifPresentXml(
        'owner',
        (value) {
          ic.owner = Author(
            name: value.getElement('name', namespace: namespaceUrl)?.innerText ?? '',
            email: value.getElement('email', namespace: namespaceUrl)?.innerText ?? '',
          );
        },
        ns: namespaceUrl,
      );

    ic
      ..explicit = channel.getElement('explicit', namespace: namespaceUrl)?.innerText.trim()
      ..author = channel.getElement('author', namespace: namespaceUrl)?.innerText.trim()
      ..title = channel.getElement('title', namespace: namespaceUrl)?.innerText.trim()
      ..type = channel.getElement('type', namespace: namespaceUrl)?.innerText.trim()
      ..newFeedUrl = channel.getElement('new-feed-url', namespace: namespaceUrl)?.innerText.trim()
      ..block = channel.getElement('block', namespace: namespaceUrl)?.innerText.trim()
      ..complete = channel.getElement('complete', namespace: namespaceUrl)?.innerText.trim()
      ..summary = channel.getElement('summary', namespace: namespaceUrl)?.innerText.trim();

    channel.ifPresentXml(
      'keywords',
      (xml) {
        final kws = Set.of(
          xml.innerText.split(',').map((e) => e.trim()),
        ).where((e) => e.isNotEmpty);
        if (kws.isEmpty) return;
        final cats = List<Category>.generate(
          kws.length,
          (p) => Category(label: kws.elementAt(p), scheme: 'keyword'),
        );
        ic.categories.addAll(cats);
      },
      ns: namespaceUrl,
    );

    feed.podcast = ic;
  }
}
