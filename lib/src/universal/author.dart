import 'package:xml/xml.dart';

// like an email
final _isEmailRx = RegExp(r'^(.+)@(.+)$');
// Help to extract name and email
// ex: Example editor (me+span@example.com)
final _nameEmailRx = RegExp(r'(.+?(?=[\(<]))[\(<](.*)[\)>]');

/// Parametrized values of the `type` attribute of the [Author] class
enum AuthorType {
  /// unknown type
  other,

  /// The author of the entry.
  ///
  /// This is the person or organization who wrote the entry. The author of an entry may have a different name than the author of the feed.
  /// If an entry has multiple authors, then the atom:author elements should contain all of them.
  author,

  /// The person or organization who contributed to the entry.
  ///
  /// This is similar to the atom:author element, but implies a different degree of participation. For example, a contributor might be a person who translated the entry or wrote a review of it.
  contributor,

  /// The person or organization responsible for editorial content.
  ///
  /// This is typically used for blogs and other editorial sites to indicate the person or organization that wrote the entry.
  editor,

  /// The person or organization responsible for technical issues relating to the feed.
  ///
  /// This is typically used for blogs and other editorial sites to indicate the person or organization that wrote the entry.
  webMaster,

  /// The person or organization who published the feed.
  ///
  /// This is typically used for blogs and other editorial sites to indicate the person or organization that wrote the entry.
  publisher,

  /// The person or organization who created the feed.
  ///
  /// This is typically used for blogs and other editorial sites to indicate the person or organization that wrote the entry.
  creator,
}

/// Person/Entity that indicates the author of the entry or feed.
class Author {
  /// Author's name
  late String name;

  /// Author's email
  late String email;

  /// Author's url
  String? url;

  /// Author relation with the feed/entry
  AuthorType? type;

  /// Creates a new [Author] object
  Author({required this.name, required this.email, this.url, this.type});

  /// Creates a new [Author] object from an string
  ///
  /// Is able to parse values like
  /// `author name (author@email.com)` or
  /// `author@email.com (author name)`
  factory Author.fromString(String value) {
    final match = _nameEmailRx.firstMatch(value);
    var name = '';
    var email = '';

    if (match == null) {
      if (_isEmailRx.hasMatch(value)) {
        email = value.trim();
      } else {
        name = value.trim();
      }
    } else {
      final group1 = match.group(1) ?? '';
      if (_isEmailRx.hasMatch(group1)) {
        name = (match.group(2) ?? '').trim();
        email = group1.trim();
      } else {
        name = group1.trim();
        email = (match.group(2) ?? '').trim();
      }
    }

    return Author(name: name, email: email);
  }

  /// Creates a new [Author] object from an [XmlElement]
  factory Author.fromXml(XmlElement element) {
    return Author(
      name: element.getElement('name')?.innerText ?? '',
      email: element.getElement('email')?.innerText ?? '',
      url: element.getElement('uri')?.innerText ?? element.getElement('url')?.innerText ?? '',
      type: AuthorType.author,
    );
  }

  /// Creates a new [Author] object from a JSON object
  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      name: json['name'] as String? ?? '',
      email: '',
      url: json['url'] as String?,
      type: AuthorType.author,
    );
  }

  /// Returns the parser author's value
  ///
  /// Depending on [name] and [email] content could returns:
  /// - (empty)
  /// - `name`
  /// - `email`
  /// - `name (email)`
  String get value {
    final sb = StringBuffer();
    if (name.trim().isNotEmpty) {
      sb.write(name);
      if (email.trim().isNotEmpty) {
        sb.write(' ($email)');
      }
    } else {
      if (email.trim().isNotEmpty) {
        sb.write(email);
      }
    }
    return sb.toString();
  }

  @override
  String toString() {
    return 'Author: [$name] [$email] [$url]';
  }
}
