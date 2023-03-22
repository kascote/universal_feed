import 'package:universal_feed/universal_feed.dart';

typedef TestFx = bool Function(UniversalFeed r);

Map<String, TestFx> syndicationTests() {
  return {
    'update_period.xml': (r) => r.syndication?.updatePeriod == 'hourly',
    'update_period_default.xml': (r) => r.syndication?.updatePeriod == 'daily',
    'update_frequency.xml': (r) => r.syndication?.updateFrequency == '2',
    'update_frequency_default.xml': (r) => r.syndication?.updateFrequency == '1',
    'update_base.xml': (r) => r.syndication?.updateBase == '2000-01-01T12:00+00:00',
  };
}
