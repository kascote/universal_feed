import 'package:xml/xml.dart';

import '../../../../universal_feed.dart';
import '../../../shared/shared.dart';

/// Itunes Channel information
class ItunesChannel {
  /// The artwork for the show. **Only**  the url field will be valid.
  UniversalImage? image;

  /// The podcast parental advisory information.
  String? explicit;

  /// The group responsible for creating the show.
  String? author;

  /// The podcast owner contact information.
  UniversalAuthor? owner;

  /// The show title specific for Apple Podcasts.
  String? title;

  /// The type of show.
  String? type;

  /// The new podcast RSS Feed URL.
  String? newFeedUrl;

  /// The podcast show or hide status.
  String? block;

  /// The podcast update status.
  String? complete;

  /// Little description about the channel
  String? summary;

  /// The show category information.
  /// if exists, category and subcategory will be the first and second elements on the list
  /// if the entry has 'keywords', they will be added here to with the scheme 'keyword'
  List<UniversalCategory> categories = [];

  ItunesChannel._();

  /// Creates a new [ItunesChannel] from an [XmlElement]
  factory ItunesChannel.fromXml(UniversalFeed rf, XmlElement node) {
    final nsUrl = rf.namespaces.nsUrl(nsItunesNs);
    final ic = ItunesChannel._();

    getElement<XmlElement>(
      node,
      'image',
      ns: nsUrl,
      cb: (value) {
        final url = value.getAttribute('href') ?? value.getAttribute('url');
        if (url != null) ic.image = UniversalImage(url.trim());
      },
    );
    getElement<XmlElement>(
      node,
      'category',
      ns: nsUrl,
      cb: (value) {
        final cat = value.getAttribute('text')?.trim();
        if (cat == null || cat.isEmpty) return;

        ic.categories.add(UniversalCategory(label: cat));
        final subCat = value.getElement('category', namespace: nsUrl)?.getAttribute('text')?.trim();
        if (subCat != null && subCat.isNotEmpty) ic.categories.add(UniversalCategory(label: subCat));
      },
    );

    getElement<XmlElement>(
      node,
      'owner',
      ns: nsUrl,
      cb: (value) {
        ic.owner = UniversalAuthor(
          name: value.getElement('name', namespace: nsUrl)?.text ?? '',
          email: value.getElement('email', namespace: nsUrl)?.text ?? '',
        );
      },
    );

    ic
      ..explicit = node.getElement('explicit', namespace: nsUrl)?.text.trim()
      ..author = node.getElement('author', namespace: nsUrl)?.text.trim()
      ..title = node.getElement('title', namespace: nsUrl)?.text.trim()
      ..type = node.getElement('type', namespace: nsUrl)?.text.trim()
      ..newFeedUrl = node.getElement('new-feed-url', namespace: nsUrl)?.text.trim()
      ..block = node.getElement('block', namespace: nsUrl)?.text.trim()
      ..complete = node.getElement('complete', namespace: nsUrl)?.text.trim()
      ..summary = node.getElement('summary', namespace: nsUrl)?.text.trim();

    getElement<XmlElement>(
      node,
      'keywords',
      ns: nsUrl,
      cb: (xml) {
        final kws = Set.of(xml.text.split(',').map((e) => e.trim())).where((e) => e.isNotEmpty);
        if (kws.isEmpty) return;
        final cats = List<UniversalCategory>.generate(
          kws.length,
          (p) => UniversalCategory(label: kws.elementAt(p), scheme: 'keyword'),
        );
        ic.categories.addAll(cats);
      },
    );

    return ic;
  }
}
