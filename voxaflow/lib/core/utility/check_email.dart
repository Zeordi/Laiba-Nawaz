


bool isValidEmail(String email) {
  // Regular expression pattern for validating email
  final RegExp emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  return emailRegex.hasMatch(email);
}
