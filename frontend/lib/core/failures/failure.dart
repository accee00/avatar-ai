class AppFailure {
  final String message;

  AppFailure([this.message = "An unknown error occurred."]);

  @override
  String toString() => 'AppFailure(message: $message)';
}
