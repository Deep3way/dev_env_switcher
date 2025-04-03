import 'package:dev_env_switcher/dev_env_switcher.dart';
import 'package:flutter/foundation.dart';

/// Entry point of the application.
void main() async {
  /// Initializes the environment switcher.
  final switcher = EnvSwitcher();

  /// Defines and adds the development environment.
  switcher.addEnvironment('dev', {
    'apiUrl': 'https://dev.api.com',
    'debug': true,
  });

  /// Defines and adds the production environment.
  switcher.addEnvironment('prod', {
    'apiUrl': 'https://prod.api.com',
    'debug': false,
  });

  /// Switches to the development environment.
  ///
  /// This will store the selected environment in `SharedPreferences`.
  await switcher.switchTo('dev');

  /// Prints the current environment and its API URL.
  if (kDebugMode) {
    print('Current env: ${switcher.currentEnv}');
  }
  if (kDebugMode) {
    print('API URL: ${switcher.currentConfig['apiUrl']}');
  }

  /// Exports the environment configurations to a JSON string.
  final json = switcher.exportToJson();
  if (kDebugMode) {
    print('Exported JSON: $json');
  }
}
