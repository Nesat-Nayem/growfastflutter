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

    // Log request details
    final fullUrl = '${dio.options.baseUrl}$path';
    debugPrint("\n========== API REQUEST ==========");
    debugPrint("URL: $fullUrl");
    debugPrint("Method: ${type.name.toUpperCase()}");
    debugPrint("Payload: ${queryParams ?? data}");
    debugPrint("=================================\n");

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

      // Log response details
      debugPrint("\n========== API RESPONSE ==========");
      debugPrint("URL: $fullUrl");
      debugPrint("Status: ${response.statusCode} ${response.statusMessage}");
      debugPrint("==================================\n");

      if (response.statusCode == 200) {
        if (response.data is String) {
          try {
            final decoded = jsonDecode(response.data);
            return decoded;
          } catch (e) {
            return response.data;
          }
        }
        logger.i(jsonEncode(response.data));
        return response.data;
      } else if (response.statusCode == 400 ||
          response.statusCode == 401 ||
          response.statusCode == 202) {
        String message = "Something went wrong";
        if (response.data is Map) {
          message = response.data['message']?.toString() ?? message;
          logger.i(
            'Failed Response ${const JsonEncoder().convert(response.data as Map<String, dynamic>)}',
          );
        } else {
          logger.e('Failed Response (not a map): ${response.data}');
        }
        throw ServerException(
          message: message,
          code: response.statusCode,
        );
      } else {
        String message = "Server Error";
        if (response.data is Map) {
          message = response.data['message']?.toString() ?? message;
        }
        throw ServerException(
          message: message,
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
