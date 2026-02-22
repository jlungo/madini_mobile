import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum AppEnvironment { dev, staging, prod }

/// Global application configuration.
/// API base URL is read from .env (API_BASE_URL); falls back if unset.
@immutable
class AppConfig {
  final AppEnvironment env;
  final String apiBaseUrl;

  const AppConfig({
    required this.env,
    required this.apiBaseUrl,
  });

  /// API base URL from dotenv (API_BASE_URL), with fallback.
  static String get apiBaseUrlFromEnv =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000/api/v1';

  static const String apiVersion = '/api/v1';

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static const Duration connectTimeout = Duration(seconds: 60);
  static const Duration receiveTimeout = Duration(seconds: 60);
  static const Duration sendTimeout = Duration(seconds: 60);
}

/// Default config; uses API_BASE_URL from .env.
final AppConfig kDefaultAppConfig = AppConfig(
  env: AppEnvironment.dev,
  apiBaseUrl: AppConfig.apiBaseUrlFromEnv,
);

