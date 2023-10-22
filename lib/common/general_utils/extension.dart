extension StringExtension on String {

  ///Remove all space and check if it's empty
  ///
  /// if not empty then it contains letters not space
  bool get isBlank {
    return trim().isEmpty;
  }
}
