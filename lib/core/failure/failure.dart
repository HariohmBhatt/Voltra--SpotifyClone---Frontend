// ignore_for_file: public_member_api_docs, sort_constructors_first
/// The `AppFailure` class in Dart represents a failure in the application with a message describing the
/// failure.
class AppFailure {
  final String message;
  AppFailure(this.message);

  @override
  String toString() => 'AppFailure(message: $message)';
}
