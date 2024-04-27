import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_http_cache_lts/dio_http_cache_lts.dart';
import 'package:flutter_chat_app/common/api_url.dart';
import 'package:flutter_chat_app/common/shared_preferences.dart';

class HttpService {
  String host = ApiURL.apiUrl;
  BaseOptions? baseOptions;
  Dio? dio;

  Future<Map<String, String>> getHeaders() async {
    final userToken = SharedPreference.getUserToken();
    return {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $userToken",
      // "lang": "vi",
    };
  }

  HttpService() {
    baseOptions = BaseOptions(
      baseUrl: host,
      validateStatus: (status) {
        return status != null && status <= 500;
      },
      // connectTimeout: 300,
    );
    dio = Dio(baseOptions);
    dio!.interceptors.add(getCacheManager().interceptor);
  }

  DioCacheManager getCacheManager() {
    return DioCacheManager(
      CacheConfig(
        baseUrl: host,
        defaultMaxAge: const Duration(hours: 1),
      ),
    );
  }

  //for get api calls
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    bool includeHeaders = true,
  }) async {
    //preparing the post options if header is required
    final mOptions = !includeHeaders
        ? null
        : Options(
            headers: await getHeaders(),
          );

    Response response;

    try {
      response = await dio!.get(
        url,
        options: mOptions,
        queryParameters: queryParameters,
      );
    } on DioError catch (error) {
      response = formatDioExecption(error);
    }
    return response;
  }

  //for post api calls
  Future<Response> post(
    String url,
    body, {
    bool includeHeaders = true,
  }) async {
    //preparing the post options if header is required
    final mOptions = !includeHeaders
        ? null
        : Options(
            headers: await getHeaders(),
          );

    Response response;
    try {
      response = await dio!.post(
        url,
        data: body,
        options: mOptions,
      );
    } on DioError catch (error) {
      response = formatDioExecption(error);
    }

    return response;
  }

  //for post api calls with file upload
  Future<Response> postWithFiles(
    String url,
    body, {
    bool includeHeaders = true,
  }) async {
    //preparing the post options if header is required
    final mOptions = !includeHeaders
        ? null
        : Options(
            headers: await getHeaders(),
          );

    Response response;
    try {
      response = await dio!.post(
        url,
        data: body is FormData ? body : FormData.fromMap(body),
        options: mOptions,
      );
    } on DioError catch (error) {
      response = formatDioExecption(error);
    }

    return response;
  }

  //for patch api calls
  Future<Response> patch(String url, Map<String, dynamic> body) async {
    Response response;
    try {
      response = await dio!.patch(
        url,
        data: body,
        options: Options(
          headers: await getHeaders(),
        ),
      );
    } on DioError catch (error) {
      response = formatDioExecption(error);
    }

    return response;
  }

  Future<Response> patchWithFiles(String url, dynamic body) async {
    Response response;

    try {
      response = await dio!.post(
        url,
        data: body is FormData ? body : FormData.fromMap(body),
        options: Options(
          headers: await getHeaders(),
        ),
      );
    } on DioError catch (error) {
      response = formatDioExecption(error);
    }

    return response;
  }

  //for delete api calls
  Future<Response> delete(
    String url,
  ) async {
    Response response;
    try {
      response = await dio!.delete(
        url,
        options: Options(
          headers: await getHeaders(),
        ),
      );
    } on DioError catch (error) {
      response = formatDioExecption(error);
    }
    return response;
  }

  Response formatDioExecption(DioError ex) {
    var response = Response(requestOptions: ex.requestOptions);
    print("type ==> ${ex.type}");
    response.statusCode = 400;
    String? msg = response.statusMessage;

    try {
      if (ex.type == DioErrorType.connectTimeout) {
        msg = "Connection timeout. Please check your internet connection and try again";
      } else if (ex.type == DioErrorType.sendTimeout) {
        msg = "Timeout. Please check your internet connection and try again";
      } else if (ex.type == DioErrorType.receiveTimeout) {
        msg = "Timeout. Please check your internet connection and try again";
      } else if (ex.type == DioErrorType.response) {
        msg = "Connection timeout. Please check your internet connection and try again";
      } else {
        msg = "Please check your internet connection and try again";
      }
      response.data = {"message": msg};
    } catch (error) {
      response.statusCode = 400;
      msg = "Please check your internet connection and try again";
      response.data = {"message": msg};
    }

    throw msg;
  }

  //NEUTRALS
  Future<Response> getExternal(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return dio!.get(
      url,
      queryParameters: queryParameters,
    );
  }
}
