import 'package:dev_env_switcher/dev_env_switcher.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Runs tests for the `EnvSwitcher` class.
void main() {
  /// Initializes the test environment before each test case.
  ///
  /// Ensures that Flutter bindings are initialized and sets up
  /// a mock instance of `SharedPreferences` to avoid errors related
  /// to accessing persistent storage.
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({}); // Mock SharedPreferences.
  });

  group('EnvSwitcher', () {
    /// Tests if environments can be added and switched successfully.
    test('adds and switches environments', () async {
      final switcher = EnvSwitcher();

      // Add a test environment.
      switcher.addEnvironment('test', {'key': 'value'});

      // Switch to the test environment.
      await switcher.switchTo('test');

      // Validate the current environment and its config.
      expect(switcher.currentEnv, 'test');
      expect(switcher.currentConfig['key'], 'value');
    });

    /// Tests if environments can be correctly exported to JSON format.
    test('exports to JSON', () {
      final switcher = EnvSwitcher();

      // Add a test environment.
      switcher.addEnvironment('test', {'key': 'value'});

      // Export the environments to JSON.
      final json = switcher.exportToJson();

      // Validate that the exported JSON contains the test environment.
      expect(json, contains('test'));
    });
  });
}
