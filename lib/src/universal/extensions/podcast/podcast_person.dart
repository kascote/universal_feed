/// A `<podcast:person>` entry from the Podcast Index namespace.
///
/// Channel- and item-level, multi-valued. Each entry describes a person
/// associated with the show (channel) or the episode (item) — host,
/// guest, producer, etc.
/// Spec: https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#person
class PodcastPerson {
  /// The person's name (element body, trimmed). Always non-null in a
  /// parsed instance — elements without a body are skipped at parse time.
  final String name;

  /// Role taxonomy term, raw string (e.g. `host`, `guest`, `producer`).
  /// Spec default when absent is `host`; not back-filled — see
  /// [effectiveRole] for the convenience surface.
  final String? role;

  /// Group taxonomy term, raw string (e.g. `cast`, `crew`, `writing`).
  /// Spec default when absent is `cast`; not back-filled — see
  /// [effectiveGroup].
  final String? group;

  /// URL of an avatar/photo for the person. Null when absent.
  final String? img;

  /// URL of a profile / about page for the person. Null when absent.
  final String? href;

  /// Creates a new [PodcastPerson].
  const PodcastPerson({
    required this.name,
    this.role,
    this.group,
    this.img,
    this.href,
  });

  /// [role] with the spec-defined default applied (`host` when absent).
  String get effectiveRole => role ?? 'host';

  /// [group] with the spec-defined default applied (`cast` when absent).
  String get effectiveGroup => group ?? 'cast';
}
