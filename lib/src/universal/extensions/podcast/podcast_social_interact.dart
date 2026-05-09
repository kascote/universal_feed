/// A `<podcast:socialInteract>` entry from the Podcast Index namespace.
///
/// Item-level, multi-valued. Points consumers at the canonical
/// social-media post that anchors the conversation about the episode,
/// so comments/replies can be surfaced in the player. Spec:
/// https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/socialInteract.md
class PodcastSocialInteract {
  /// `protocol` attribute — identifier for the social platform/protocol
  /// (e.g. `activitypub`, `twitter`, `lemmy`, `mastodon`, `nostr`).
  /// Always non-null in a parsed instance — the parser skips entries
  /// without it. Stored verbatim because the upstream vocabulary is
  /// open-ended.
  ///
  /// Sentinel value `"disabled"` is the publisher's opt-out signal —
  /// when present, [uri] may be null.
  final String protocol;

  /// `uri` attribute — root URL of the conversation/post. Non-null in
  /// every parsed instance *except* when [protocol] is `"disabled"`,
  /// in which case it may be null (the opt-out form has no target URL).
  final String? uri;

  /// `accountId` attribute — handle/account that posted the root
  /// (e.g. `@dave`). Null when absent.
  final String? accountId;

  /// `accountUrl` attribute — profile URL for [accountId]. Null when
  /// absent.
  final String? accountUrl;

  /// `priority` attribute — hint for ordering when multiple entries
  /// are present. Stored raw to keep parsing liberal; matches
  /// `PodcastItem.season` / `episode`. Null when absent.
  final String? priority;

  /// Creates a new [PodcastSocialInteract].
  const PodcastSocialInteract({
    required this.protocol,
    this.uri,
    this.accountId,
    this.accountUrl,
    this.priority,
  });
}
