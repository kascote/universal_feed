/// Identifies the agent used to generate a feed, for debugging and other purposes.
///
/// ref atom: https://www.rfc-editor.org/rfc/rfc4287.html#section-4.2.4
class UniversalGenerator {
  /// Url advertising the generator
  final String url;

  /// Generator's Version
  final String version;

  /// Generator's Name
  final String name;

  /// Creates a new [UniversalGenerator] object
  const UniversalGenerator(this.name, this.version, this.url);

  /// Creates a new [UniversalGenerator] object from an simple String
  factory UniversalGenerator.create(String name) {
    return UniversalGenerator(name, '', '');
  }

  @override
  String toString() {
    return 'Generator: $name ~ $version ~ $url';
  }
}
