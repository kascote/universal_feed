/// Library to parse RSS and Atom feeds. It includes support for RSS from
/// version 0.90 to 2.0 and Atom 0.3 and 1.0.
///
/// Out-of-the-box has support for some common extensions like:
///
///   * Dublin Core
///   * Dublin Core Terms
///   * Geo RSS
///   * Media RSS
///   * Syndication
///   * Itunes
///
/// This library makes no assumptions about the data parsed and tries to be
/// quite liberal in reading the feed's content. For example, with time stamps,
/// there is no attempt to parse it when the feed is parsed. The Timestamp
/// object has methods to help with the parsing.

library;

export 'src/shared/date_parser.dart';
export 'src/shared/errors.dart';
export 'src/universal/author.dart';
export 'src/universal/callbacks.dart';
export 'src/universal/category.dart';
export 'src/universal/content.dart';
export 'src/universal/enclosure.dart';
export 'src/universal/extensions/podcast/podcast_channel.dart';
export 'src/universal/extensions/podcast/podcast_chapters.dart';
export 'src/universal/extensions/podcast/podcast_item.dart';
export 'src/universal/extensions/podcast/podcast_txt.dart';
export 'src/universal/generator.dart';
export 'src/universal/image.dart';
export 'src/universal/item.dart';
export 'src/universal/link.dart';
export 'src/universal/meta.dart';
export 'src/universal/namespaces.dart';
export 'src/universal/podcast_precedence.dart';
export 'src/universal/raw_element.dart';
export 'src/universal/source.dart';
export 'src/universal/time_stamp.dart';
export 'src/universal/universal_feed.dart';
