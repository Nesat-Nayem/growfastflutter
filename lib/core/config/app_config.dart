import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class AppConfig {
  final String baseUrl;
  final bool enableDatadog;
  final bool enableSentry;

  AppConfig({
    required this.baseUrl,
    required this.enableDatadog,
    required this.enableSentry,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      baseUrl: json['baseUrl'],
      enableDatadog: json['enableDatadog'] ?? false,
      enableSentry: json['enableSentry'] ?? false,
    );
  }
}

class ConfigLoader {
  static Future<AppConfig> load(String env) async {
    final jsonStr = await rootBundle.loadString('assets/configs/config.json');
    final Map<String, dynamic> data = json.decode(jsonStr);

    if (!data[env].containsKey('baseUrl')) {
      throw Exception("Unknown environment: $env");
    }

    return AppConfig.fromJson(data[env]);
  }
}
