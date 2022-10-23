import 'package:intl/intl.dart';

class _ParseInfo {
  final String label;
  final RegExp rgx;
  final String format;

  _ParseInfo(this.label, this.rgx, this.format);
}

// reference
// https://en.wikipedia.org/wiki/ISO_8601
final List<_ParseInfo> _parseInfo = [
  _ParseInfo(
    'invalid RFC 822 (no seconds)',
    RegExp(r'\d{2}\s\w{3}\s\d{4}\s\d\d:\d\d\sGMT'),
    'd MMM yyy H:mm Z',
  ),
  _ParseInfo(
    'valid RFC 822 (2-digit year)',
    RegExp(r'\w{3},\s\d{2}\s\w{3}\s\d{2}\s([\d:])*\sGMT'),
    'EEE, d MMM yy H:mm:s Z',
  ),
  _ParseInfo(
    'valid RFC 822 (4-digit year)',
    RegExp(r'\w{3},\s\d{2}\s\w{3}\s\d{4}\s([\d:])*\sGMT'),
    'EEE, d MMM yyyy H:mm:s Z',
  ),

  // TODO(nfx): problems with Z option on parser
  // _ParseInfo(
  //   'ascii time',
  //   RegExp(r'\w{3}\s\w{3}\s\d{1,2}\s\d\d:\d\d:\d\d\s\w{3}\s\d{4}'),
  //   'EEE MMM d H:mm:s Z yyyy',
  // ),

  _ParseInfo(
    'invalid RFC 822 (no time)',
    RegExp(r'\d{2}\s\w{3}\s\d{4}'),
    'd MMM yyyy',
  ),
  _ParseInfo(
    'valid W3CDTF (yyyy-mm)',
    RegExp(r'^\d{4}-\d{2}$'),
    'yyyy-MM',
  ),
  // valid ISO 8601 (-yymm) -- deprecated on ISO 8601:2004
  _ParseInfo(
    'valid W3CDTF (yyyy)',
    RegExp(r'^\d{4}$'),
    'yyyy',
  ),
  // valid W3CDTF (yyyy-mm-dd) (internal parser)
  // valid ISO 8601 (yyyymmdd) (internal parser)
  _ParseInfo(
    'valid ISO 8601 (-yy-mm)',
    RegExp(r'^-\d{2}-\d{2}$'),
    '-yy-MM',
  ),
  // valid ISO 8601 (yymmdd) -- deprecated on ISO 8601:2004
  _ParseInfo(
    'bogus RFC 822 (invalid month)',
    RegExp(r'\w{3},\s\d{2}\s\w{3,10}\s\d{4}\s([\d:])*\s\w{3}'),
    'EEE, d MMMM yyyy H:mm:s Z',
  ),
];

/// Makes a best effort to parse different date time formats.
/// The returned DateTime will be in UTC
DateTime? parseDate(String value) {
  try {
    final d = DateTime.parse(value);
    return DateTime.utc(d.year, d.month, d.day, d.hour, d.minute, d.second);
  } on FormatException {
    // noop
  }

  for (final p in _parseInfo) {
    if (p.rgx.hasMatch(value)) return DateFormat(p.format).parseUtc(value);
  }

  return null;
}
