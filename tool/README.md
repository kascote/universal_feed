# Feed Analyzer Tool

A command-line utility for testing the Universal Feed parser against real-world RSS, Atom, and JSON feeds.

## Usage

```bash
# Basic usage
dart tool/feed_analyzer.dart <feeds-file>

# With verbose error output
dart tool/feed_analyzer.dart <feeds-file> --verbose
```

## Feed File Format

Create a text file with one feed URL or file path per line:

```txt
# RSS feeds
https://feeds.bbci.co.uk/news/rss.xml
https://rss.nytimes.com/services/xml/rss/nyt/World.xml

# Atom feeds
https://github.com/dart-lang/sdk/commits/main.atom

# Podcasts (RSS with iTunes extensions)
https://feeds.npr.org/510318/podcast.xml

# Local files
test/wellformed/rss/item_pubDate.xml
test/wellformed/atom/entry_title.xml
```

- Lines starting with `#` are treated as comments
- Blank lines are ignored
- Supports both HTTP(S) URLs and local file paths
