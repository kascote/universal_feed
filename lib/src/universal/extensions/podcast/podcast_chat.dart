/// A `<podcast:chat>` entry from the Podcast Index namespace.
///
/// Single occurrence per parent (`<channel>`, `<item>`, or
/// `<podcast:liveItem>`). Points consumers at a chat server / room
/// associated with the show or episode — typically used for live
/// listener chat alongside a `<podcast:liveItem>`. Spec:
/// https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/chat.md
class PodcastChat {
  /// `server` attribute — FQDN of the bootstrap chat server (e.g.
  /// `irc.libera.chat`, `matrix.example.org`). Always non-null in a
  /// parsed instance — the parser skips entries without it.
  final String server;

  /// `protocol` attribute — chat protocol identifier (e.g. `irc`,
  /// `xmpp`, `nostr`, `matrix`). Stored verbatim; the upstream
  /// vocabulary is open-ended. Always non-null in a parsed instance —
  /// the parser skips entries without it.
  final String protocol;

  /// `accountId` attribute — handle/account of the show host on the
  /// platform. Format is protocol-specific (e.g. `@dave`,
  /// `dave@example.org`, `npub1…`, `@dave:example.org`). Null when
  /// absent.
  final String? accountId;

  /// `space` attribute — room / channel / topic within the server
  /// (e.g. `#noagendashow`). Null when absent.
  final String? space;

  /// Creates a new [PodcastChat].
  const PodcastChat({
    required this.server,
    required this.protocol,
    this.accountId,
    this.space,
  });
}
