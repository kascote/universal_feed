import 'package:xml/xml.dart';

import '../../../../universal_feed.dart';

/// Geo Spec
///
/// https://en.wikipedia.org/wiki/GeoRSS
class Geo {
  /// A line contains a space separated list of latitude-longitude pairs, with each pair separated by whitespace.
  /// There must be at least two pairs.
  String? line;

  /// A polygon contains a space separated list of latitude-longitude pairs, with each pair separated by whitespace.
  /// There must be at least four pairs, with the last being identical to the first (so a polygon has a minimum
  /// of three actual points).
  String? polygon;

  /// A bounding box is a rectangular region, often used to define the extents of a map or a rough area of interest.
  /// A box contains two space separate latitude-longitude pairs, with each pair separated by whitespace. The first
  /// pair is the lower corner, the second is the upper corner.
  String? box;

  /// A tag associated with the mark, ex: city
  String? featureTypeTag;

  /// ex: is-center-at
  String? relationshipTag;

  /// A name associated with the mark, ex: Podunk
  String? featureName;

  /// Elevation, specified in GeoRSS elements, can be expressed as "elev" or "floor".
  /// elev is meant to contain "common" GPS elevation readings, i.e. height in meters from the WGS84 ellipsoid, which
  /// is a reading that should be easy to get from any GPS device.
  String? elev;

  /// Elevation, specified in GeoRSS elements, can be expressed as "elev" or "floor".
  /// floor is meant to contain the floor number of a building. In some countries the numbering is different than in
  /// other countries, but since we'll know the location of the building, it should be fairly unambiguous.
  String? floor;

  /// Indicates the size in meters of a radius or buffer around the geometry object, for example, radius of
  /// circular area around a point geometry.
  String? radius;

  ///
  factory Geo.fromXml(UniversalFeed uf, XmlElement node) {
    final nsUrl = uf.meta.extensions.nsUrl(nsGeoNs);
    final geo = Geo._()
      ..line = node.getElement('line', namespace: nsUrl)?.text
      ..polygon = node.getElement('polygon', namespace: nsUrl)?.text
      ..box = node.getElement('box', namespace: nsUrl)?.text
      ..featureTypeTag = node.getElement('featuretypetag', namespace: nsUrl)?.text
      ..relationshipTag = node.getElement('relationshiptag', namespace: nsUrl)?.text
      ..featureName = node.getElement('featurename', namespace: nsUrl)?.text
      ..elev = node.getElement('elev', namespace: nsUrl)?.text
      ..floor = node.getElement('floor', namespace: nsUrl)?.text
      ..radius = node.getElement('radius', namespace: nsUrl)?.text;

    return geo;
  }

  Geo._();
}
