/// Parsed `<podcast:updateFrequency>` tag from the Podcast Index namespace.
///
/// Spec: https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#update-frequency
class PodcastUpdateFrequency {
  /// Human-readable description of the update schedule (text body of the tag).
  /// Null when the body was absent or empty.
  final String? description;

  /// Whether the feed is complete (no more episodes will be published).
  /// Null when the `complete` attribute was absent or not a recognized boolean.
  final bool? complete;

  /// ISO 8601 datetime string from the `dtstart` attribute.
  /// Stored raw; callers parse as needed.
  final String? dtstart;

  /// iCalendar RRULE string from the `rrule` attribute.
  /// Stored raw; callers parse as needed.
  final String? rrule;

  /// Creates a new [PodcastUpdateFrequency] instance.
  const PodcastUpdateFrequency({
    this.description,
    this.complete,
    this.dtstart,
    this.rrule,
  });
}
