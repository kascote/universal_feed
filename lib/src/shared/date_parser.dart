import 'package:intl/intl.dart';

import './tz_data.dart';

/// Callback used by [ParseInfo] to parse custom DateTime formats
typedef ParserCallback = DateTime Function(String value, ParseInfo pi);

/// Callback used to preformat the DateTime string before send to the formatter
typedef FormatterCallback = String Function(String value, ParseInfo pi);

/// ParseInfo handles parse information for each type of date format
/// supported
class ParseInfo {
  /// Friendly name of the parser. For debug purpose only
  final String label;

  /// Regular expression to find the date format
  final RegExp rgx;

  /// Final format used to try to parse the string
  final String format;

  /// Callback used to parse the string if the regular expression matches
  ParserCallback? cb;

  /// Callback used to preformat the date string value before send to the parser
  FormatterCallback? fcb;

  /// ParseInfo constructor
  ParseInfo(this.label, this.rgx, this.format, {this.cb, this.fcb});
}

/// Makes a best effort to parse different date time formats.
/// The returned DateTime will be in UTC
DateTime? parseDate(String value) {
  try {
    final d = DateTime.parse(value);
    return DateTime.utc(d.year, d.month, d.day, d.hour, d.minute, d.second);
  } on FormatException {
    // noop
  }

  for (final p in parseInfo) {
    if (p.rgx.hasMatch(value)) {
      try {
        return (p.cb != null) ? p.cb!(value.trim(), p) : defaultParser(value.trim(), p);
      } on FormatException catch (e) {
        throw FormatException(
          'Error parsing date: [$value] with [${p.format}]',
          e.source,
          e.offset,
        );
      }
    }
  }

  return null;
}

/// The default parser will use DateFormat and with a know to parse format
DateTime defaultParser(String value, ParseInfo pi) {
  try {
    return DateFormat(pi.format).parseUtc(removeEndingZ(value));
  } on FormatException catch (e) {
    throw FormatException(
      'Error parsing date: [$value] with [${pi.format}]',
      e.source,
      e.offset,
    );
  }
}

/// Parse a dateTime string with a numeric TZ like +300
///
/// Dart do not support parsing of Z on DateFormat and always will default to UTC
/// this is a hacky way to move the date offset manually.
/// this will not use DST or any other external information, just the offset
///
/// reference: https://github.com/dart-lang/intl/issues/19
DateTime parseWithNumericTz(String value, ParseInfo pi) {
  final dateStr = (pi.fcb != null) ? pi.fcb!(value, pi) : value;
  try {
    final tmp = DateFormat(pi.format).parseUtc(dateStr);
    final matchStr = pi.rgx.matchAsPrefix(dateStr);

    if (matchStr != null && matchStr.group(2) != null) {
      final offsetStr = matchStr.group(2)!;
      final offsetInt = int.parse(matchStr.group(2)!);
      final duration = Duration(
        hours: int.parse(offsetStr.substring(1, 3)),
        minutes: int.parse(offsetStr.substring(3)),
      );

      return (offsetInt < 0) ? tmp.add(duration) : tmp.subtract(duration);
    }

    return tmp;
  } on FormatException {
    throw FormatException('(parseWithNumericTz) format error: [$dateStr] with [${pi.format}]');
  }
}

/// Parse a DateTime string with a named TZ like PDT
///
/// Dart do not support parsing of Z on DateFormat and always will default to UTC
/// this is a hacky way to move the date offset manually.
/// this will not use DST or any other external information, just the offset
///
/// reference: https://github.com/dart-lang/intl/issues/19
DateTime parseWithNamedTz(String value, ParseInfo pi) {
  final dateStr = (pi.fcb != null) ? pi.fcb!(value, pi) : value;
  try {
    final tmp = DateFormat(pi.format).parseUtc(dateStr);
    final matchStr = pi.rgx.matchAsPrefix(dateStr);

    if (matchStr != null) {
      final tzName = matchStr.group(2);
      final data = tzInfoDb[tzName];

      if (data != null) {
        final duration = Duration(minutes: data.offset.abs());
        return (data.offset < 0) ? tmp.add(duration) : tmp.subtract(duration);
      }
    }

    return tmp;
  } on FormatException {
    throw FormatException('(parseWithNamedTz) format error: [$dateStr] with [${pi.format}]');
  }
}

/// Removes the last character if it is Z
String removeEndingZ(String value) {
  return value.endsWith('Z') ? value.substring(0, value.length) : value;
}

/// ParseInfo holds the data of all date formats supported and how to parse them
/// the order of this list important because some regular expression could match
/// different values.
///
/// dates reference: https://en.wikipedia.org/wiki/ISO_8601
final List<ParseInfo> parseInfo = [
  ParseInfo(
    'invalid RFC 822 (no seconds)',
    RegExp(r'^\d{2}\s\w{3}\s\d{4}\s\d\d:\d\d\s[GMTUTC]*$'),
    'd MMM yyy H:mm',
  ),

  ParseInfo(
    'valid RFC 822 (4-digit year) no seconds, offset with letters',
    RegExp(r'\w{3},\s\d{2}\s\w{3}\s\d{4}\s\d\d:\d\d\s([GMTUTC])*'),
    'EEE, d MMM yyyy H:mm',
  ),

  ParseInfo(
    'valid RFC 822 (4-digit year) offset with digits',
    RegExp(r'\w{3},\s\d{2}\s\w{3}\s\d{4}\s([\d:])*\s([+\-]\d{4})'),
    'EEE, d MMM yyyy H:mm:s',
    cb: parseWithNumericTz,
  ),

  ParseInfo(
    'valid RFC 822 (2-digit year)',
    RegExp(r'\w{3},\s\d{2}\s\w{3}\s\d{2}\s([\d:])*\s([GMTUTC])*'),
    'EEE, d MMM yy H:mm:s',
  ),

  ParseInfo(
    'valid RFC 822 (4-digit year) offset with letters',
    RegExp(r'\w{3},\s\d{2}\s\w{3}\s\d{4}\s([\d:])*\s([A-Z]{3,4})'),
    'EEE, d MMM yyyy H:mm:s',
    cb: parseWithNamedTz,
  ),

  // _ParseInfo(
  //   'ascii time',
  //   RegExp(r'\w{3}\s\w{3}\s\d{1,2}\s\d\d:\d\d:\d\d\s\w{3}\s\d{4}'),
  //   'EEE MMM d H:mm:s Z yyyy',
  // ),

  ParseInfo(
    'invalid RFC 822 (no time)',
    RegExp(r'^\d{2}\s\w{3}\s\d{4}$'),
    'd MMM yyyy',
  ),
  ParseInfo(
    'valid W3CDTF (yyyy-mm)',
    RegExp(r'^\d{4}-\d{2}$'),
    'yyyy-MM',
  ),
  // valid ISO 8601 (-yymm) -- deprecated on ISO 8601:2004
  ParseInfo(
    'valid W3CDTF (yyyy)',
    RegExp(r'^\d{4}$'),
    'yyyy',
  ),
  // valid W3CDTF (yyyy-mm-dd) (internal parser)
  // valid ISO 8601 (yyyymmdd) (internal parser)
  ParseInfo(
    'valid ISO 8601 (-yy-mm)',
    RegExp(r'^-\d{2}-\d{2}$'),
    '-yy-MM',
  ),
  // valid ISO 8601 (yymmdd) -- deprecated on ISO 8601:2004
  ParseInfo(
    'bogus RFC 822 (invalid month)',
    RegExp(r'\w{3},\s\d{2}\s\w{3,10}\s\d{4}\s([\d:])*\s\w{3}'),
    'EEE, d MMMM yyyy H:mm:s',
  ),

  ParseInfo(
    'invalid RFC 822 with a Z at the end',
    RegExp(r'^\w{3},\s\d{2}\s\w{3}\s\d{4}\s([\d:])*\sZ$'),
    'EEE, d MMM yyyy H:mm:s',
  ),
];
