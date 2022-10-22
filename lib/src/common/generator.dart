/// The "atom:generator" element's content identifies the agent used to
/// generate a feed, for debugging and other purposes.
///
/// spec: https://www.rfc-editor.org/rfc/rfc4287.html#section-4.2.4
class Generator {
  /// Url advertising the generator
  final String url;

  /// Generator's Version
  final String version;

  /// Generator's Name
  final String name;

  /// Creates a new [Generator] object
  const Generator(this.name, this.version, this.url);

  @override
  String toString() {
    return 'Generator: $name ~ $version ~ $url';
  }
}
