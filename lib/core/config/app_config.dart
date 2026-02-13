import 'package:flutter/foundation.dart';

enum AppEnvironment { dev, staging, prod }

/// Global application configuration.
@immutable
class AppConfig {
  final AppEnvironment env;
  final String apiBaseUrl;
  final String authBaseUrl;

  const AppConfig({
    required this.env,
    required this.apiBaseUrl,
    required this.authBaseUrl,
  });
}

/// Default config used for local development.
///
/// Wire different configs via flavors / --dart-define in future.
const AppConfig kDefaultAppConfig = AppConfig(
  env: AppEnvironment.dev,
  apiBaseUrl: 'https://example-ngmris.local/api/v1',
  authBaseUrl: 'https://example-keycloak.local',
);

