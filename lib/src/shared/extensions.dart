/// Extensions for common types to simplify code and improve readability.
extension JsonMapExtensions on Map<String, dynamic> {
  /// Retrieves a value from the map and casts it to the specified type [T].
  /// Will return `null` if the key does not exist or the value is not of type [T].
  T? getTyped<T>(String key) {
    final value = this[key];
    return value is T ? value : null;
  }

  /// If the key exists and the value is of type [T], calls the provided [callback] with the value.
  void ifPresent<T>(String key, void Function(T value) callback) {
    final value = getTyped<T>(key);
    if (value != null) callback(value);
  }
}
