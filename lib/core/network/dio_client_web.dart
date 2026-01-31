import 'package:dio/dio.dart';

/// Configure Dio for web platform (dart:html)
/// Web doesn't need special certificate handling
void configureDio(Dio dio) {
  // No special configuration needed for web
  // Browser handles certificates automatically
}
