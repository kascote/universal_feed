/// A `<podcast:integrity>` child of `PodcastAlternateEnclosure`.
///
/// Carries either an SRI-compliant integrity string or a base64-encoded
/// PGP signature, per spec. Both attributes are required by spec — the
/// parser returns `null` (skip) when either is missing.
///
/// Spec: https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/tags/integrity.md
class PodcastIntegrity {
  /// Integrity scheme. Spec values: `"sri"` or `"pgp-signature"`.
  /// Stored raw; not validated.
  final String type;

  /// Integrity-check value. Format depends on [type] — e.g. an SRI
  /// string when `type == "sri"`, a base64 PGP signature when
  /// `type == "pgp-signature"`. Stored raw; not validated.
  final String value;

  /// Creates a new [PodcastIntegrity].
  const PodcastIntegrity({required this.type, required this.value});
}
