bool emailValidator(String value) {
  // Biểu thức chính quy để kiểm tra tính hợp lệ của địa chỉ email
  final RegExp regex = RegExp(
    r'^[a-zA-Z0-9.a-zA-Z0-9.!#%&*+-=?^_`{|}~]+@([\w-]+\.)+[\w-]{2,4}$',
    caseSensitive: false,
    multiLine: false,
  );
  if (!regex.hasMatch(value)) return false;
  return true;
}
