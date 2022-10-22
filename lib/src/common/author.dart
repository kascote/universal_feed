// like an email
final _isEmailRx = RegExp(r'^(.+)@(.+)$');
// Help to extract name and email
// ex: Example editor (me+span@example.com)
final _nameEmailRx = RegExp(r'(.+?(?=[\(<]))[\(<](.*)[\)>]');

/// Hold information about the Author of an entry or feed
class Author {
  /// Author's name
  late String name;

  /// Author's email
  late String email;

  /// Author's url
  String? url;

  /// Creates a new [Author] object
  Author({required this.name, required this.email, this.url});

  /// Creates a new [Author] object from an string
  ///
  /// Is able to parse values like
  /// `author name (author@email.com)` or
  /// `author@email.com (author name)`
  factory Author.fromString(String value) {
    final match = _nameEmailRx.firstMatch(value);
    String name;
    String email;
    if (match != null) {
      final group1 = match.group(1) ?? '';
      if (_isEmailRx.hasMatch(group1)) {
        name = (match.group(2) ?? '').trim();
        email = group1.trim();
      } else {
        name = group1.trim();
        email = (match.group(2) ?? '').trim();
      }
    } else {
      if (_isEmailRx.hasMatch(value)) {
        email = value.trim();
        name = '';
      } else {
        name = value.trim();
        email = '';
      }
    }

    final a = Author(name: name, email: email);
    return a;
  }

  /// Will return the author as `author name (author@email.com)`
  String get value => '${name.isEmpty ? '' : name} ${email.isEmpty ? '' : '($email)'}'.trim();

  @override
  String toString() {
    return 'Author: $name $email $url';
  }
}
