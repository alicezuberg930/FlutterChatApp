class RegularExpression {
  static bool emailValidator(String value) {
    final RegExp regex = RegExp(
      r'^[a-zA-Z0-9.a-zA-Z0-9.!#%&*+-=?^_`{|}~]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );
    if (!regex.hasMatch(value)) return false;
    return true;
  }
}
