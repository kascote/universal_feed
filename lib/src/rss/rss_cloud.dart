import 'package:xml/xml.dart';

///
class RSSCloud {
  ///
  final String domain;

  ///
  final String port;

  ///
  final String path;

  ///
  final String registerProcedure;

  ///
  final String protocol;

  ///
  const RSSCloud({
    this.domain = '',
    this.port = '',
    this.path = '',
    this.registerProcedure = '',
    this.protocol = '',
  });

  ///
  factory RSSCloud.fromXML(XmlElement node) {
    return RSSCloud(
      domain: node.getAttribute('domain') ?? '',
      port: node.getAttribute('port') ?? '',
      path: node.getAttribute('path') ?? '',
      registerProcedure: node.getAttribute('registerProcedure') ?? '',
      protocol: node.getAttribute('protocol') ?? '',
    );
  }
}
