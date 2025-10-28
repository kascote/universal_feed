import 'package:test/test.dart';
import 'package:universal_feed/src/shared/extensions.dart';
import 'package:universal_feed/universal_feed.dart';

void main() {
  group('Integration Tests', () {
    test('Podcast feed with custom metadata extraction', () {
      // Realistic podcast RSS feed with iTunes extension and custom fields
      const podcastFeed = '''
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0"
     xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd"
     xmlns:custom="http://example.com/podcast">
  <channel>
    <title>Tech Talk Weekly</title>
    <link>https://example.com/podcast</link>
    <description>Weekly discussions about technology trends</description>
    <language>en-us</language>
    <itunes:author>Tech Podcasters Inc</itunes:author>
    <itunes:explicit>no</itunes:explicit>
    <itunes:category text="Technology"/>
    <custom:sponsorTier>premium</custom:sponsorTier>
    <custom:subscriptionUrl>https://example.com/subscribe</custom:subscriptionUrl>

    <item>
      <title>Episode 1: AI Revolution</title>
      <link>https://example.com/podcast/ep1</link>
      <description>Discussion about recent AI breakthroughs</description>
      <enclosure url="https://example.com/episodes/ep1.mp3" type="audio/mpeg" length="45000000"/>
      <pubDate>Mon, 01 Jan 2024 12:00:00 GMT</pubDate>
      <itunes:duration>45:30</itunes:duration>
      <itunes:explicit>no</itunes:explicit>
      <custom:transcriptUrl>https://example.com/transcripts/ep1.txt</custom:transcriptUrl>
      <custom:guestCount>2</custom:guestCount>
      <custom:sponsorAd>true</custom:sponsorAd>
      <custom:topic>Artificial Intelligence</custom:topic>
      <custom:topic>Machine Learning</custom:topic>
      <custom:topic>Ethics</custom:topic>
    </item>

    <item>
      <title>Episode 2: Quantum Computing</title>
      <link>https://example.com/podcast/ep2</link>
      <description>Introduction to quantum computing</description>
      <enclosure url="https://example.com/episodes/ep2.mp3" type="audio/mpeg" length="38000000"/>
      <pubDate>Mon, 08 Jan 2024 12:00:00 GMT</pubDate>
      <itunes:duration>38:15</itunes:duration>
      <itunes:explicit>no</itunes:explicit>
      <custom:transcriptUrl>https://example.com/transcripts/ep2.txt</custom:transcriptUrl>
      <custom:guestCount>1</custom:guestCount>
      <custom:sponsorAd>false</custom:sponsorAd>
      <custom:topic>Quantum Computing</custom:topic>
      <custom:topic>Physics</custom:topic>
    </item>

    <item>
      <title>Episode 3: Web3 and Blockchain</title>
      <link>https://example.com/podcast/ep3</link>
      <description>Exploring decentralized technologies</description>
      <enclosure url="https://example.com/episodes/ep3.mp3" type="audio/mpeg" length="52000000"/>
      <pubDate>Mon, 15 Jan 2024 12:00:00 GMT</pubDate>
      <itunes:duration>52:45</itunes:duration>
      <itunes:explicit>no</itunes:explicit>
      <custom:transcriptUrl>https://example.com/transcripts/ep3.txt</custom:transcriptUrl>
      <custom:guestCount>3</custom:guestCount>
      <custom:sponsorAd>true</custom:sponsorAd>
      <custom:topic>Blockchain</custom:topic>
      <custom:topic>Web3</custom:topic>
      <custom:topic>Decentralization</custom:topic>
    </item>
  </channel>
</rss>''';

      // Define typed storage for podcast metadata
      final podcastMetadata = PodcastChannelMetadata();
      final episodeMetadata = <String, EpisodeMetadata>{};

      // Parse with custom extraction callbacks
      final feed = UniversalFeed.parseFromString(
        podcastFeed,
        onChannelParse: (feed, raw) {
          if (raw is XmlRawElement) {
            // Extract custom channel-level fields
            raw.element.ifPresent('sponsorTier', (value) {
              podcastMetadata.sponsorTier = value;
            }, ns: 'http://example.com/podcast');

            raw.element.ifPresent('subscriptionUrl', (value) {
              podcastMetadata.subscriptionUrl = value;
            }, ns: 'http://example.com/podcast');
          }
        },
        onItemParse: (item, raw) {
          if (raw is XmlRawElement) {
            String? transcriptUrl;
            int? guestCount;
            var hasSponsorAd = false;
            final topics = <String>[];

            // Extract custom item-level fields
            raw.element.ifPresent('transcriptUrl', (value) => transcriptUrl = value, ns: 'http://example.com/podcast');

            raw.element.ifPresent('guestCount', (value) {
              guestCount = int.tryParse(value);
            }, ns: 'http://example.com/podcast');

            raw.element.ifPresent('sponsorAd', (value) {
              hasSponsorAd = value.toLowerCase() == 'true';
            }, ns: 'http://example.com/podcast');

            raw.element.forEachElement('topic', topics.add, ns: 'http://example.com/podcast');

            // Store using stable itemId
            episodeMetadata[item.itemId] = EpisodeMetadata(
              title: item.title ?? '',
              duration: item.podcast?.duration ?? '',
              transcriptUrl: transcriptUrl,
              guestCount: guestCount ?? 0,
              hasSponsorAd: hasSponsorAd,
              topics: topics,
            );
          }
        },
      );

      // Verify feed-level data
      expect(feed.title, 'Tech Talk Weekly');
      expect(feed.description, 'Weekly discussions about technology trends');
      expect(feed.language, 'en-us');
      expect(feed.items.length, 3);

      // Verify podcast extension was parsed
      expect(feed.podcast, isNotNull);
      expect(feed.podcast!.author, 'Tech Podcasters Inc');
      expect(feed.podcast!.explicit, 'no');

      // Verify custom channel metadata
      expect(podcastMetadata.sponsorTier, 'premium');
      expect(podcastMetadata.subscriptionUrl, 'https://example.com/subscribe');

      // Verify episodes and custom metadata
      expect(episodeMetadata.length, 3);

      // Episode 1
      final ep1 = feed.items[0];
      expect(ep1.itemId, 'item_0');
      expect(ep1.title, 'Episode 1: AI Revolution');
      expect(ep1.podcast?.duration, '45:30');
      expect(ep1.enclosures.length, 1);
      expect(ep1.enclosures[0].url, 'https://example.com/episodes/ep1.mp3');

      final ep1Meta = episodeMetadata['item_0']!;
      expect(ep1Meta.title, 'Episode 1: AI Revolution');
      expect(ep1Meta.duration, '45:30');
      expect(ep1Meta.transcriptUrl, 'https://example.com/transcripts/ep1.txt');
      expect(ep1Meta.guestCount, 2);
      expect(ep1Meta.hasSponsorAd, true);
      expect(ep1Meta.topics, ['Artificial Intelligence', 'Machine Learning', 'Ethics']);

      // Episode 2
      final ep2 = feed.items[1];
      expect(ep2.itemId, 'item_1');
      expect(ep2.title, 'Episode 2: Quantum Computing');

      final ep2Meta = episodeMetadata['item_1']!;
      expect(ep2Meta.guestCount, 1);
      expect(ep2Meta.hasSponsorAd, false);
      expect(ep2Meta.topics, ['Quantum Computing', 'Physics']);

      // Episode 3
      final ep3 = feed.items[2];
      expect(ep3.itemId, 'item_2');

      final ep3Meta = episodeMetadata['item_2']!;
      expect(ep3Meta.guestCount, 3);
      expect(ep3Meta.topics.length, 3);

      // Test stable IDs after filtering
      final aiEpisodes = feed.items.where((item) {
        final meta = episodeMetadata[item.itemId]!;
        return meta.topics.any((topic) => topic.contains('Intelligence'));
      }).toList();

      expect(aiEpisodes.length, 1);
      expect(aiEpisodes[0].itemId, 'item_0');

      // Can still access custom metadata after filtering
      final aiEpisodeMeta = episodeMetadata[aiEpisodes[0].itemId]!;
      expect(aiEpisodeMeta.title, 'Episode 1: AI Revolution');

      // Test filtering by sponsor ad presence
      final sponsoredEpisodes = feed.items.where((item) {
        final meta = episodeMetadata[item.itemId]!;
        return meta.hasSponsorAd;
      }).toList();

      expect(sponsoredEpisodes.length, 2); // Episodes 1 and 3
      expect(sponsoredEpisodes[0].itemId, 'item_0');
      expect(sponsoredEpisodes[1].itemId, 'item_2');

      // Test filtering by guest count
      final multiGuestEpisodes = feed.items.where((item) {
        final meta = episodeMetadata[item.itemId]!;
        return meta.guestCount >= 2;
      }).toList();

      expect(multiGuestEpisodes.length, 2); // Episodes 1 and 3
    });

    test('E-commerce blog feed with product metadata', () {
      // Realistic blog feed with custom product review fields
      const blogFeed = '''
{
  "version": "https://jsonfeed.org/version/1",
  "title": "Tech Product Reviews",
  "home_page_url": "https://reviews.example.com",
  "feed_url": "https://reviews.example.com/feed.json",
  "items": [
    {
      "id": "review-1",
      "title": "Best Programming Keyboards of 2024",
      "url": "https://reviews.example.com/keyboards-2024",
      "summary": "Comprehensive review of mechanical keyboards",
      "date_published": "2024-01-15T10:00:00Z",
      "product_category": "Keyboards",
      "average_rating": 4.5,
      "price_range": {
        "min": 89,
        "max": 249,
        "currency": "USD"
      },
      "products_reviewed": 12,
      "affiliate_links": true,
      "tags": ["keyboards", "mechanical", "productivity"]
    },
    {
      "id": "review-2",
      "title": "Top Monitors for Developers",
      "url": "https://reviews.example.com/monitors-2024",
      "summary": "Best displays for coding and development",
      "date_published": "2024-01-22T10:00:00Z",
      "product_category": "Monitors",
      "average_rating": 4.7,
      "price_range": {
        "min": 299,
        "max": 899,
        "currency": "USD"
      },
      "products_reviewed": 8,
      "affiliate_links": true,
      "tags": ["monitors", "displays", "4k"]
    },
    {
      "id": "review-3",
      "title": "Budget Laptop Stands",
      "url": "https://reviews.example.com/laptop-stands",
      "summary": "Affordable ergonomic laptop stands",
      "date_published": "2024-01-29T10:00:00Z",
      "product_category": "Accessories",
      "average_rating": 4.2,
      "price_range": {
        "min": 19,
        "max": 59,
        "currency": "USD"
      },
      "products_reviewed": 15,
      "affiliate_links": false,
      "tags": ["accessories", "ergonomics", "budget"]
    }
  ]
}''';

      final reviewMetadata = <String, ProductReview>{};

      final feed = UniversalFeed.parseFromString(
        blogFeed,
        onItemParse: (item, raw) {
          if (raw is JsonRawElement) {
            String? productCategory;
            double? averageRating;
            int? productsReviewed;
            var affiliateLinks = false;
            PriceRange? priceRange;
            List<String>? tags;

            // Extract custom fields
            raw.json.ifPresent<String>('product_category', (value) => productCategory = value);
            raw.json.ifPresent<double>('average_rating', (value) => averageRating = value);
            raw.json.ifPresent<int>('products_reviewed', (value) => productsReviewed = value);
            raw.json.ifPresent<bool>('affiliate_links', (value) => affiliateLinks = value);
            raw.json.ifPresent<List<String>>('tags', (value) => tags = value);

            // Extract nested price range object
            raw.json.ifPresent<Map<String, dynamic>>('price_range', (priceRangeJson) {
              int? min;
              int? max;
              String? currency;

              priceRangeJson
                ..ifPresent<int>('min', (value) => min = value)
                ..ifPresent<int>('max', (value) => max = value)
                ..ifPresent<String>('currency', (value) => currency = value);

              if (min != null && max != null && currency != null) {
                priceRange = PriceRange(min: min!, max: max!, currency: currency!);
              }
            });

            reviewMetadata[item.itemId] = ProductReview(
              productCategory: productCategory ?? '',
              averageRating: averageRating ?? 0.0,
              priceRange: priceRange,
              productsReviewed: productsReviewed ?? 0,
              affiliateLinks: affiliateLinks,
              tags: tags ?? [],
            );
          }
        },
      );

      // Verify feed-level data
      expect(feed.title, 'Tech Product Reviews');
      expect(feed.items.length, 3);

      // Verify review metadata
      expect(reviewMetadata.length, 3);

      // Review 1 - Keyboards
      final review1 = reviewMetadata['item_0']!;
      expect(review1.productCategory, 'Keyboards');
      expect(review1.averageRating, 4.5);
      expect(review1.productsReviewed, 12);
      expect(review1.affiliateLinks, true);
      expect(review1.priceRange, isNotNull);
      expect(review1.priceRange!.min, 89);
      expect(review1.priceRange!.max, 249);
      expect(review1.priceRange!.currency, 'USD');
      expect(review1.tags, ['keyboards', 'mechanical', 'productivity']);

      // Review 2 - Monitors
      final review2 = reviewMetadata['item_1']!;
      expect(review2.averageRating, 4.7);
      expect(review2.productsReviewed, 8);

      // Test filtering by category
      final monitorReviews = feed.items.where((item) {
        final meta = reviewMetadata[item.itemId]!;
        return meta.productCategory == 'Monitors';
      }).toList();

      expect(monitorReviews.length, 1);
      expect(monitorReviews[0].itemId, 'item_1');

      // Test filtering by rating
      final highRatedReviews = feed.items.where((item) {
        final meta = reviewMetadata[item.itemId]!;
        return meta.averageRating >= 4.5;
      }).toList();

      expect(highRatedReviews.length, 2);

      // Test filtering by price range
      final budgetReviews = feed.items.where((item) {
        final meta = reviewMetadata[item.itemId]!;
        return meta.priceRange != null && meta.priceRange!.max < 100;
      }).toList();

      expect(budgetReviews.length, 1);
      expect(budgetReviews[0].itemId, 'item_2'); // Laptop stands
    });
  });
}

// Custom data classes for integration tests

class PodcastChannelMetadata {
  String sponsorTier = '';
  String subscriptionUrl = '';
}

class EpisodeMetadata {
  final String title;
  final String duration;
  final String? transcriptUrl;
  final int guestCount;
  final bool hasSponsorAd;
  final List<String> topics;

  EpisodeMetadata({
    required this.title,
    required this.duration,
    required this.guestCount,
    required this.hasSponsorAd,
    required this.topics,
    this.transcriptUrl,
  });
}

class ProductReview {
  final String productCategory;
  final double averageRating;
  final PriceRange? priceRange;
  final int productsReviewed;
  final bool affiliateLinks;
  final List<String> tags;

  ProductReview({
    required this.productCategory,
    required this.averageRating,
    required this.productsReviewed,
    required this.affiliateLinks,
    required this.tags,
    this.priceRange,
  });
}

class PriceRange {
  final int min;
  final int max;
  final String currency;

  PriceRange({
    required this.min,
    required this.max,
    required this.currency,
  });
}
