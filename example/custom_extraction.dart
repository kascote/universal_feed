import 'dart:io';

import 'package:universal_feed/src/shared/extensions.dart';
import 'package:universal_feed/universal_feed.dart';
import 'package:xml/xml.dart';

/// Example demonstrating custom entity extraction from feeds.
///
/// This example shows how to:
/// - Define typed custom data classes
/// - Use callbacks to extract custom fields from feeds
/// - Use pattern matching to handle different feed formats (XML vs JSON)
/// - Leverage existing extension methods for parsing
/// - Use stable IDs to match custom data after filtering/sorting
void main() {
  // Example 1: Basic custom field extraction from RSS feed
  basicRssExample();

  stdout.writeln('\n${'=' * 80}\n');

  // Example 2: Custom field extraction from Atom feed with namespaces
  atomWithNamespacesExample();

  stdout.writeln('\n${'=' * 80}\n');

  // Example 3: Custom field extraction from JSON Feed
  jsonFeedExample();

  stdout.writeln('\n${'=' * 80}\n');

  // Example 4: Format-agnostic extraction with pattern matching
  formatAgnosticExample();

  stdout.writeln('\n${'=' * 80}\n');

  // Example 5: Realistic use case - Podcast feed with custom metadata
  podcastExample();
}

/// Example 1: Basic custom field extraction from RSS feed
void basicRssExample() {
  stdout.writeln('Example 1: Basic RSS Custom Field Extraction\n');

  const rssFeed = '''
<?xml version="1.0"?>
<rss version="2.0">
  <channel>
    <title>Tech Blog</title>
    <link>https://example.com</link>
    <description>Latest tech articles</description>
    <item>
      <title>Introduction to Dart</title>
      <link>https://example.com/dart-intro</link>
      <readingTime>5</readingTime>
      <difficulty>beginner</difficulty>
    </item>
    <item>
      <title>Advanced Flutter Patterns</title>
      <link>https://example.com/flutter-patterns</link>
      <readingTime>12</readingTime>
      <difficulty>advanced</difficulty>
    </item>
  </channel>
</rss>''';

  // Define typed storage for custom data
  final articleMetadata = <String, ArticleMetadata>{};

  final feed = UniversalFeed.parseFromString(
    rssFeed,
    onItemParse: (item, raw) {
      if (raw is XmlRawElement) {
        int? readingTime;
        String? difficulty;

        // Use extension methods to extract custom fields
        raw.element.ifPresent('readingTime', (value) {
          readingTime = int.tryParse(value);
        });
        raw.element.ifPresent('difficulty', (value) => difficulty = value);

        // Store using stable itemId
        articleMetadata[item.itemId] = ArticleMetadata(
          title: item.title ?? '',
          readingTime: readingTime ?? 0,
          difficulty: difficulty ?? 'unknown',
        );
      }
    },
  );

  stdout
    ..writeln('Feed: ${feed.title}')
    ..writeln('Articles:');
  for (final item in feed.items) {
    final metadata = articleMetadata[item.itemId]!;
    stdout
      ..writeln('  - ${metadata.title}')
      ..writeln('    Reading time: ${metadata.readingTime} min')
      ..writeln('    Difficulty: ${metadata.difficulty}');
  }
}

/// Example 2: Custom field extraction from Atom feed with namespaces
void atomWithNamespacesExample() {
  stdout.writeln('Example 2: Atom Feed with Namespaced Custom Fields\n');

  const atomFeed = '''
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom" xmlns:custom="http://example.com/custom">
  <title>Science News</title>
  <id>urn:uuid:science-feed</id>
  <updated>2023-01-01T00:00:00Z</updated>
  <entry>
    <title>Quantum Computing Breakthrough</title>
    <id>urn:uuid:article-1</id>
    <updated>2023-01-01T00:00:00Z</updated>
    <custom:impact>high</custom:impact>
    <custom:citations>42</custom:citations>
  </entry>
  <entry>
    <title>New Material Discovery</title>
    <id>urn:uuid:article-2</id>
    <updated>2023-01-02T00:00:00Z</updated>
    <custom:impact>medium</custom:impact>
    <custom:citations>18</custom:citations>
  </entry>
</feed>''';

  final scienceMetadata = <String, ScienceArticle>{};

  final feed = UniversalFeed.parseFromString(
    atomFeed,
    onItemParse: (item, raw) {
      if (raw is XmlRawElement) {
        String? impact;
        int? citations;

        // Extract namespaced custom fields
        raw.element.ifPresent('impact', (value) => impact = value, ns: 'http://example.com/custom');
        raw.element.ifPresent('citations', (value) {
          citations = int.tryParse(value);
        }, ns: 'http://example.com/custom');

        scienceMetadata[item.itemId] = ScienceArticle(
          title: item.title ?? '',
          impact: impact ?? 'unknown',
          citations: citations ?? 0,
        );
      }
    },
  );

  stdout
    ..writeln('Feed: ${feed.title}')
    ..writeln('Articles:');
  for (final item in feed.items) {
    final metadata = scienceMetadata[item.itemId]!;
    stdout
      ..writeln('  - ${metadata.title}')
      ..writeln('    Impact: ${metadata.impact}')
      ..writeln('    Citations: ${metadata.citations}');
  }
}

/// Example 3: Custom field extraction from JSON Feed
void jsonFeedExample() {
  stdout.writeln('Example 3: JSON Feed Custom Field Extraction\n');

  const jsonFeed = '''
{
  "version": "https://jsonfeed.org/version/1",
  "title": "Developer Blog",
  "items": [
    {
      "id": "post-1",
      "title": "Building REST APIs",
      "reading_time": 8,
      "code_samples": 5,
      "technologies": ["Dart", "HTTP", "JSON"]
    },
    {
      "id": "post-2",
      "title": "Database Design Patterns",
      "reading_time": 15,
      "code_samples": 12,
      "technologies": ["SQL", "PostgreSQL", "Indexing"]
    }
  ]
}''';

  final postMetadata = <String, BlogPost>{};

  final feed = UniversalFeed.parseFromString(
    jsonFeed,
    onItemParse: (item, raw) {
      if (raw is JsonRawElement) {
        int? readingTime;
        int? codeSamples;
        List<String>? technologies;

        // Use extension methods to extract custom fields
        raw.json.ifPresent<int>('reading_time', (value) => readingTime = value);
        raw.json.ifPresent<int>('code_samples', (value) => codeSamples = value);
        raw.json.ifPresent<List<String>>('technologies', (value) => technologies = value);

        postMetadata[item.itemId] = BlogPost(
          title: item.title ?? '',
          readingTime: readingTime ?? 0,
          codeSamples: codeSamples ?? 0,
          technologies: technologies ?? [],
        );
      }
    },
  );

  stdout
    ..writeln('Feed: ${feed.title}')
    ..writeln('Posts:');
  for (final item in feed.items) {
    final metadata = postMetadata[item.itemId]!;
    stdout
      ..writeln('  - ${metadata.title}')
      ..writeln('    Reading time: ${metadata.readingTime} min')
      ..writeln('    Code samples: ${metadata.codeSamples}')
      ..writeln('    Technologies: ${metadata.technologies.join(", ")}');
  }
}

/// Example 4: Format-agnostic extraction with pattern matching
void formatAgnosticExample() {
  stdout.writeln('Example 4: Format-Agnostic Extraction\n');

  // This custom data class works with any feed format
  final videoMetadata = <String, VideoMetadata>{};

  // Try with RSS
  const rssFeed = '''
<?xml version="1.0"?>
<rss version="2.0">
  <channel>
    <title>Video Tutorials</title>
    <link>https://example.com</link>
    <description>Video content</description>
    <item>
      <title>Dart Basics</title>
      <duration>PT10M30S</duration>
      <views>1500</views>
    </item>
  </channel>
</rss>''';

  void extractVideoMetadata(Item item, RawElement raw) {
    // Pattern match on format - single callback handles both!
    final metadata = switch (raw) {
      XmlRawElement() => _extractVideoFromXml(raw.element, item.title ?? ''),
      JsonRawElement() => _extractVideoFromJson(raw.json, item.title ?? ''),
    };
    videoMetadata[item.itemId] = metadata;
  }

  final feed = UniversalFeed.parseFromString(
    rssFeed,
    onItemParse: extractVideoMetadata,
  );

  stdout
    ..writeln('Feed: ${feed.title}')
    ..writeln('Videos:');
  for (final item in feed.items) {
    final metadata = videoMetadata[item.itemId]!;
    stdout
      ..writeln('  - ${metadata.title}')
      ..writeln('    Duration: ${metadata.duration}')
      ..writeln('    Views: ${metadata.views}');
  }
}

/// Example 5: Realistic use case - Podcast feed with custom metadata
void podcastExample() {
  stdout.writeln('Example 5: Podcast Feed with Custom Metadata\n');

  const podcastFeed = '''
<?xml version="1.0"?>
<rss version="2.0" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" xmlns:custom="http://example.com/podcast">
  <channel>
    <title>Tech Podcast</title>
    <link>https://example.com/podcast</link>
    <description>Weekly tech discussions</description>
    <custom:sponsorTier>premium</custom:sponsorTier>
    <item>
      <title>Episode 42: AI in 2024</title>
      <enclosure url="https://example.com/ep42.mp3" type="audio/mpeg" length="45000000"/>
      <itunes:duration>45:30</itunes:duration>
      <custom:transcriptUrl>https://example.com/transcripts/ep42.txt</custom:transcriptUrl>
      <custom:guestCount>2</custom:guestCount>
      <custom:topic>Artificial Intelligence</custom:topic>
      <custom:topic>Machine Learning</custom:topic>
    </item>
  </channel>
</rss>''';

  final podcastData = PodcastData();

  final feed = UniversalFeed.parseFromString(
    podcastFeed,
    onChannelParse: (feed, raw) {
      if (raw is XmlRawElement) {
        raw.element.ifPresent('sponsorTier', (value) {
          podcastData.sponsorTier = value;
        }, ns: 'http://example.com/podcast');
      }
    },
    onItemParse: (item, raw) {
      if (raw is XmlRawElement) {
        String? transcriptUrl;
        int? guestCount;
        final topics = <String>[];

        raw.element.ifPresent('transcriptUrl', (value) => transcriptUrl = value, ns: 'http://example.com/podcast');
        raw.element.ifPresent('guestCount', (value) {
          guestCount = int.tryParse(value);
        }, ns: 'http://example.com/podcast');
        raw.element.forEachElement('topic', topics.add, ns: 'http://example.com/podcast');

        podcastData.episodes[item.itemId] = EpisodeMetadata(
          title: item.title ?? '',
          duration: item.podcast?.duration ?? '',
          transcriptUrl: transcriptUrl,
          guestCount: guestCount ?? 0,
          topics: topics,
        );
      }
    },
  );

  stdout
    ..writeln('Podcast: ${feed.title}')
    ..writeln('Sponsor Tier: ${podcastData.sponsorTier}')
    ..writeln('\nEpisodes:');
  for (final item in feed.items) {
    final metadata = podcastData.episodes[item.itemId]!;
    stdout
      ..writeln('  - ${metadata.title}')
      ..writeln('    Duration: ${metadata.duration}')
      ..writeln('    Guests: ${metadata.guestCount}')
      ..writeln('    Topics: ${metadata.topics.join(", ")}');
    if (metadata.transcriptUrl != null) {
      stdout.writeln('    Transcript: ${metadata.transcriptUrl}');
    }
  }

  // Demonstrate stable IDs after filtering
  stdout.writeln('\nFiltering for AI-related episodes:');
  final aiEpisodes = feed.items.where((item) {
    final metadata = podcastData.episodes[item.itemId]!;
    return metadata.topics.any((topic) => topic.contains('Intelligence'));
  }).toList();

  for (final item in aiEpisodes) {
    final metadata = podcastData.episodes[item.itemId]!; // Still works!
    stdout.writeln('  - ${metadata.title}');
  }
}

// Helper functions for format-agnostic example
VideoMetadata _extractVideoFromXml(XmlElement element, String title) {
  String? duration;
  int? views;

  element
    ..ifPresent('duration', (value) => duration = value)
    ..ifPresent('views', (value) => views = int.tryParse(value));

  return VideoMetadata(
    title: title,
    duration: duration ?? '',
    views: views ?? 0,
  );
}

VideoMetadata _extractVideoFromJson(Map<String, dynamic> json, String title) {
  String? duration;
  int? views;

  json
    ..ifPresent<String>('duration', (value) => duration = value)
    ..ifPresent<int>('views', (value) => views = value);

  return VideoMetadata(
    title: title,
    duration: duration ?? '',
    views: views ?? 0,
  );
}

// Custom data classes

class ArticleMetadata {
  final String title;
  final int readingTime;
  final String difficulty;

  ArticleMetadata({
    required this.title,
    required this.readingTime,
    required this.difficulty,
  });
}

class ScienceArticle {
  final String title;
  final String impact;
  final int citations;

  ScienceArticle({
    required this.title,
    required this.impact,
    required this.citations,
  });
}

class BlogPost {
  final String title;
  final int readingTime;
  final int codeSamples;
  final List<String> technologies;

  BlogPost({
    required this.title,
    required this.readingTime,
    required this.codeSamples,
    required this.technologies,
  });
}

class VideoMetadata {
  final String title;
  final String duration;
  final int views;

  VideoMetadata({
    required this.title,
    required this.duration,
    required this.views,
  });
}

class PodcastData {
  String sponsorTier = '';
  final Map<String, EpisodeMetadata> episodes = {};
}

class EpisodeMetadata {
  final String title;
  final String duration;
  final String? transcriptUrl;
  final int guestCount;
  final List<String> topics;

  EpisodeMetadata({
    required this.title,
    required this.duration,
    required this.guestCount,
    required this.topics,
    this.transcriptUrl,
  });
}
