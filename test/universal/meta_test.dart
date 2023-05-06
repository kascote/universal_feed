import 'package:test/test.dart';
import 'package:universal_feed/universal_feed.dart';
import 'package:xml/xml.dart';

void main() {
  test('must parse rss version', () {
    final xml = XmlDocument.parse('<rss version="0.90"></rss>');
    final meta = MetaData.rssFromXml(xml);

    expect(meta.kind, FeedKind.rss);
    expect(meta.version, '0.90');
    expect(meta.encoding, '');
    expect(meta.extensions.extensionsIsEmpty, true);
  });

  test('must parse version 0.91u if has no publicId', () {
    final xml = XmlDocument.parse('<rss version="0.91"></rss>');
    final meta = MetaData.rssFromXml(xml);

    expect(meta.version, '0.91u');
  });

  test('must parse version 0.91n if has Netscape ID', () {
    final xml = XmlDocument.parse('''
<!DOCTYPE rss PUBLIC "-//Netscape Communications//DTD RSS 0.91//EN" "http://my.netscape.com/publish/formats/rss-0.91.dtd">
<rss version="0.91">
  <channel />
</rss>
''');
    final meta = MetaData.rssFromXml(xml);

    expect(meta.version, '0.91n');
  });

  test('must parse rss namespace extensions', () {
    final xml = XmlDocument.parse(
      '<rss version="2.0" xml:base="http://example.com" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"></rss>',
    );
    final meta = MetaData.rssFromXml(xml);

    expect(meta.kind, FeedKind.rss);
    expect(meta.version, '2.0');
    expect(meta.extensions.nsUrl('xml:base'), 'http://example.com');
    expect(meta.extensions.nsUrl('xmlns:rdf'), 'http://www.w3.org/1999/02/22-rdf-syntax-ns#');
  });

  test('must parse rdf format', () {
    final xml = XmlDocument.parse(
      '<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns="http://my.netscape.com/rdf/simple/0.9/"></rdf:RDF>',
    );

    final meta = MetaData.rssFromXml(xml);

    expect(meta.kind, FeedKind.rss);
    expect(meta.version, '0.90');
  });

  test('must throw exception if format unknown', () {
    final xml = XmlDocument.parse('<some-element></some-element>');
    expect(() => MetaData.rssFromXml(xml), throwsException);
  });
}
