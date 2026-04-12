/// Which podcast vocabulary wins when the iTunes and Podcast Index
/// namespaces both provide a value for the same unified field.
///
/// Implementation detail: precedence maps to parser registration order.
/// The "loser" parser runs first; the "winner" runs second and overwrites.
///
/// Note: the default value may change in future major versions. No
/// overlap field currently lives in the unified podcast model, so the
/// default is unvalidated. It will be re-evaluated once the first
/// overlap field is collapsed.
enum PodcastPrecedence {
  /// Podcast Index overrides iTunes on overlap fields. Matches the
  /// behaviour of modern podcast apps.
  podcastIndex,

  /// iTunes overrides Podcast Index. For feeds where iTunes is the
  /// source of truth and `podcast:*` data is secondary.
  itunes,
}
