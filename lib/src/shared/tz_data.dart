/// Class to define information about TimeZones and offsets
class TzInfo {
  /// Timezone name
  final String label;

  /// Timezone abbreviation
  final String abbr;

  /// Hours offset for this timezone
  final int hours;

  /// Minutes offset for this timezone
  final int mins;

  /// Offset in minutes
  final int offset;

  /// Creates a new TzInfo object
  const TzInfo(this.label, this.abbr, this.hours, this.mins, this.offset);
}

/// Keeps a record of all the TZ and their offset
const tzInfoDb = {
  'UTC': TzInfo('Coordinated Universal Time', 'UTC', 0, 0, 0),
  'GMT': TzInfo('Greenwich Mean Time', 'GMT', 0, 0, 0),
  'EAT': TzInfo('East Africa Time', 'EAT', 3, 0, 180),
  'CET': TzInfo('Central European Time', 'CET', 1, 0, 60),
  'CEST': TzInfo('Central European Summer Time', 'CEST', 1, 0, 60),
  'CEDT': TzInfo('Central European Daylight Time', 'CEDT', 2, 0, 120),
  'WET': TzInfo('Western European Time', 'WET', 0, 0, 0),
  'WEST': TzInfo('Western European Summer Time', 'WEST', 1, 0, 60),
  'WAT': TzInfo('West Africa Time', 'WAT', 1, 0, 60),
  'CAT': TzInfo('Central Africa Time', 'CAT', 2, 0, 120),
  'EET': TzInfo('Eastern European Time', 'EET', 2, 0, 120),
  'EEST': TzInfo('Eastern European Summer Time', 'EEST', 3, 0, 180),
  'SAST': TzInfo('South African Standard Time', 'SAST', 2, 0, 120),
  'HST': TzInfo('Hawaii–Aleutian Standard Time', 'HST', -10, 0, -600),
  'HDT': TzInfo('Hawaii–Aleutian Daylight Time', 'HDT', -9, 0, -540),
  'AST': TzInfo('Atlantic Standard Time', 'AST', -4, 0, -240),
  'ADT': TzInfo('Atlantic Daylight Time', 'ADT', -3, 0, -180),
  'EST': TzInfo('Eastern Time Zone', 'EST', -5, 0, -300),
  'EDT': TzInfo('Eastern Daylight Time', 'EDT', -4, 0, -240),
  'CST': TzInfo('Central Standard Time', 'CST', -6, 0, -360),
  'CDT': TzInfo('Central Daylight Time', 'CDT', -5, 0, -300),
  'MST': TzInfo('Mountain Standard Time', 'MST', -7, 0, -420),
  'MDT': TzInfo('Mountain Daylight Time', 'MDT', -6, 0, -360),
  'PST': TzInfo('Pacific Time Zone', 'PST', -8, 0, -480),
  'PDT': TzInfo('Pacific Daylight Time', 'PDT', -7, 0, -420),
  'AKST': TzInfo('Alaska Standard Time', 'AKST', -9, 0, -540),
  'AKDT': TzInfo('Alaska Daylight Time', 'AKDT', -8, 0, -480),
  'NST': TzInfo('Newfoundland Standard Time', 'NST', -3, 30, -210),
  'NDT': TzInfo('Newfoundland Daylight Time', 'NDT', -2, 30, -150),
  'AWST': TzInfo('Australian Western Standard Time', 'AWST', 8, 0, 480),
  'ACST': TzInfo('Australian Central Standard Time', 'ACST', 9, 30, 570),
  'ACDT': TzInfo('Australian Central Daylight Time', 'ACDT', 10, 30, 630),
  'AEST': TzInfo('Australian Eastern Standard Time', 'AEST', 10, 0, 600),
  'AEDT': TzInfo('Australian Eastern Daylight Time', 'AEDT', 11, 0, 660),
  'NZST': TzInfo('New Zealand Standard Time', 'NZST', 12, 0, 720),
  'NZDT': TzInfo('New Zealand Daylight Time', 'NZDT', 13, 0, 780),
  'WIB': TzInfo('Western Indonesia Time', 'WIB', 7, 0, 420),
  'WITA': TzInfo('Central Indonesia Time', 'WITA', 8, 0, 480),
  'WIT': TzInfo('Eastern Indonesia Time', 'WIT', 9, 0, 540),
  'IST': TzInfo('Indian Standard Time', 'IST', 5, 30, 330),
  'PKT': TzInfo('Pakistan Standard Time', 'PKT', 5, 0, 300),
  'KST': TzInfo('Korea Standard Time', 'KST', 9, 0, 540),
  'JST': TzInfo('Japan Standard Time', 'JST', 9, 0, 540),
};
