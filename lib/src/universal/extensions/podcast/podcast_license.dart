import 'podcast_channel.dart';

/// Represents a `<podcast:license>` tag from the Podcast Index namespace.
///
/// One per channel or item (last wins on duplicate). All fields are nullable —
/// liberal parsing. Spec:
/// https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#license
class PodcastLicense {
  /// SPDX identifier from the `spdx` attribute (e.g. `CC-BY-4.0`, `MIT`).
  /// Raw string — no enum, consistent with [PodcastChannel.medium].
  final String? spdx;

  /// URL pointing to the license deed.
  final String? url;

  /// Human-readable license name from the element body. Null when absent.
  final String? text;

  /// Creates a new [PodcastLicense].
  PodcastLicense({this.spdx, this.url, this.text});
}
