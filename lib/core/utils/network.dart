import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:grow_first/core/errors/exceptions.dart';
import 'package:logger/logger.dart';

enum RequestType { get, post, delete }

class NetworkHelper {
  static Future<dynamic> sendRequest(
    Dio dio,
    RequestType type,
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    dynamic data,
  }) async {
    final logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2, // number of method calls to be displayed
        errorMethodCount: 8, // number of method calls if stacktrace is provided
        lineLength: 200, // width of the output
        colors: true, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
      ),
    );

    debugPrint("Payload ${queryParams ?? data}");

    // bool isDeviceConnected = await InternetConnectionChecker().hasConnection;
    // if (!isDeviceConnected) {
    //   runApp(const NoInternetConnection());
    // }else{
    //   runMainApp();
    // }

    try {
      Response response;

      switch (type) {
        case RequestType.get:
          response = await dio.get(
            path,
            queryParameters: queryParams,
            options: Options(headers: headers),
          );
          break;

        case RequestType.post:
          response = await dio.post(
            path,
            options: Options(headers: headers, validateStatus: (code) => true),
            data: queryParams ?? data,
          );
          break;

        case RequestType.delete:
          response = await dio.delete(
            path,
            queryParameters: queryParams,
            options: Options(headers: headers),
          );
          break;

        default:
          return null;
      }

      debugPrint(
        "$path response ${response.statusCode} with ${response.statusMessage}",
      );

      if (response.statusCode == 200) {
        logger.i(jsonEncode(response.data));
        return response.data;
      } else if (response.statusCode == 400 ||
          response.statusCode == 401 ||
          response.statusCode == 202) {
        logger.i(
          'Failed Response ${const JsonEncoder().convert(response.data as Map<String, dynamic>)}',
        );
        throw ServerException(
          message: response.data['message'],
          code: response.statusCode,
        );
      } else {
        throw ServerException(
          message: response.data['message'],
          code: response.statusCode,
        );
      }
    } on ServerException catch (e) {
      throw ServerException(message: e.message, code: e.code);
    } on DioException catch (e) {
      throw ServerException(
        message: e.error is SocketException
            ? 'No Internet Connection'
            : e.error.toString(),
      );
    }
  }
}
