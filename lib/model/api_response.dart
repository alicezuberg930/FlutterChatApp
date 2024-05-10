import 'package:dio/dio.dart';

class ApiResponse {
  int get totalDataCount => body["meta"]["total"];
  int get totalPageCount => body["pagination"]["total_pages"];
  List get data => body["data"] ?? [];
  bool get allGood => errors == null || errors!.isEmpty;
  bool hasError() => errors != null && ((errors?.length ?? 0) > 0);
  bool hasData() => data.isNotEmpty;
  int? code;
  String? message;
  dynamic body;
  List? errors;

  ApiResponse({this.code, this.message, this.body, this.errors});

  toJson() {
    return {'code': code, 'message': message, 'body': body, 'errors': errors, 'data': data};
  }

  factory ApiResponse.fromResponse(Response response) {
    int code = response.statusCode!;
    dynamic body = response.data;
    List errors = [];
    String message = "";
    switch (code) {
      case 200:
        try {
          message = body is Map ? (body["message"] ?? "") : "";
        } catch (error) {
          print("Message reading error ==> $error");
        }
        break;
      default:
        message = body["message"] ?? "Whoops! Something went wrong, please contact support.";
        errors.add(message);
        break;
    }
    return ApiResponse(
      code: code,
      message: message,
      body: body,
      errors: errors,
    );
  }
}
