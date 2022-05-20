class EmailExist implements Exception {
  final String message;
  EmailExist(this.message);
}