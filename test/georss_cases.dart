import 'package:universal_feed/universal_feed.dart';

typedef TestFx = bool Function(RSS r);

Map<String, TestFx> geoRssTests() {
  return {
    'geo_line.xml': (r) => r.entries!.first.georss!.line == '45.256 -110.45 46.46 -109.48 43.84 -109.86',
    'geo_polygon.xml': (r) =>
        r.entries!.first.georss!.polygon == '45.256 -110.45 46.46 -109.48 43.84 -109.86 45.256 -110.45',
    'geo_box.xml': (r) => r.entries!.first.georss!.box == '42.943 -71.032 43.039 -69.856',
    'geo_feature_typetag.xml': (r) => r.entries!.first.georss!.featureTypeTag == 'city',
    'geo_relationshiptag.xml': (r) => r.entries!.first.georss!.relationshipTag == 'is-centered-at',
    'geo_featurename.xml': (r) => r.entries!.first.georss!.featureName == 'Podunk',
    'geo_elev.xml': (r) => r.entries!.first.georss!.elev == '313',
    'geo_floor.xml': (r) => r.entries!.first.georss!.floor == '2',
    'geo_radius.xml': (r) => r.entries!.first.georss!.radius == '500',
  };
}

typedef TestFxAtom = bool Function(Atom r);
Map<String, TestFxAtom> geoAtomTests() {
  return {
    'geo_atom_line.xml': (r) => r.entries!.first.georss!.line == '45.256 -110.45 46.46 -109.48 43.84 -109.86',
    'geo_atom_polygon.xml': (r) =>
        r.entries!.first.georss!.polygon == '45.256 -110.45 46.46 -109.48 43.84 -109.86 45.256 -110.45',
    'geo_atom_box.xml': (r) => r.entries!.first.georss!.box == '42.943 -71.032 43.039 -69.856',
    'geo_atom_feature_typetag.xml': (r) => r.entries!.first.georss!.featureTypeTag == 'city',
    'geo_atom_relationshiptag.xml': (r) => r.entries!.first.georss!.relationshipTag == 'is-centered-at',
    'geo_atom_featurename.xml': (r) => r.entries!.first.georss!.featureName == 'Podunk',
    'geo_atom_elev.xml': (r) => r.entries!.first.georss!.elev == '313',
    'geo_atom_floor.xml': (r) => r.entries!.first.georss!.floor == '2',
    'geo_atom_radius.xml': (r) => r.entries!.first.georss!.radius == '500',
  };
}
