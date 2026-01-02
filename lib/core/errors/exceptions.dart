import 'package:flutter/cupertino.dart';

/// Custom class to catch ServerExceptions.
///
/// [message] field provides reason of the exception in short.
class ServerException implements Exception {
  final int? code;
  final String? message;

  ServerException({
    this.code = 404,
    this.message = 'Could not process your request at the moment.',
  });

  @override
  String toString() {
    debugPrint(message);
    return super.toString();
  }
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}

class UnauthorizedException implements Exception {}
