/// A `<podcast:source>` child of `PodcastAlternateEnclosure`.
///
/// Each source advertises one URI where the parent media file can be
/// fetched (HTTPS, IPFS, magnet, .onion, .torrent, …). Spec:
/// https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/source.md
class PodcastEnclosureSource {
  /// URI of the media asset. Always non-null in a parsed instance —
  /// the parser skips elements without a `uri` attribute.
  final String uri;

  /// MIME type of the data fetched at [uri], when different from the
  /// parent `PodcastAlternateEnclosure.type`. Typical use: a `.torrent`
  /// pointer (`application/x-bittorrent`) for media that ultimately
  /// resolves to audio/video.
  final String? contentType;

  /// Creates a new [PodcastEnclosureSource].
  const PodcastEnclosureSource({required this.uri, this.contentType});
}
