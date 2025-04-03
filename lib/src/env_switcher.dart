import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages development environments and switching between them.
class EnvSwitcher {
  final Map<String, Environment> _environments = {};
  String _currentEnv = 'default';
  static const _prefKey = 'current_env';

  /// Initializes the environment switcher and loads the last saved environment.
  EnvSwitcher() {
    _loadCurrentEnv();
  }

  /// Adds an environment with a [name] and [config].
  ///
  /// Example:
  /// ```dart
  /// switcher.addEnvironment('staging', {'api_url': 'https://staging.example.com'});
  /// ```
  void addEnvironment(String name, Map<String, dynamic> config) {
    _environments[name] = Environment(name, config);
  }

  /// Switches to the environment with the given [name].
  ///
  /// Persists the selected environment using `SharedPreferences`.
  /// Throws an exception if the environment does not exist.
  ///
  /// Example:
  /// ```dart
  /// await switcher.switchTo('production');
  /// ```
  Future<void> switchTo(String name) async {
    if (!_environments.containsKey(name)) throw Exception('Env not found');
    _currentEnv = name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, name);
  }

  /// Returns the current environment's configuration.
  ///
  /// Example:
  /// ```dart
  /// var config = switcher.currentConfig;
  /// print(config['api_url']);
  /// ```
  Map<String, dynamic> get currentConfig =>
      _environments[_currentEnv]?.config ?? {};

  /// Returns the name of the current environment.
  String get currentEnv => _currentEnv;

  /// Exports all environments to a JSON string.
  ///
  /// Example:
  /// ```dart
  /// String jsonStr = switcher.exportToJson();
  /// print(jsonStr);
  /// ```
  String exportToJson() {
    final data = _environments.map((key, env) => MapEntry(key, env.toJson()));
    return jsonEncode(data);
  }

  /// Imports environments from a JSON string.
  ///
  /// Example:
  /// ```dart
  /// switcher.importFromJson(jsonString);
  /// ```
  void importFromJson(String jsonStr) {
    final Map<String, dynamic> data = jsonDecode(jsonStr);
    _environments.clear();
    data.forEach((key, value) {
      _environments[key] = Environment.fromJson(key, value);
    });
  }

  /// Loads the last selected environment from persistent storage.
  Future<void> _loadCurrentEnv() async {
    final prefs = await SharedPreferences.getInstance();
    _currentEnv = prefs.getString(_prefKey) ?? 'default';
  }
}

/// Represents a single environment configuration.
class Environment {
  /// The name of the environment (e.g., "production", "staging").
  final String name;

  /// The configuration settings for this environment.
  final Map<String, dynamic> config;

  /// Creates an environment with the given [name] and [config].
  Environment(this.name, this.config);

  /// Converts the environment to a JSON-compatible map.
  Map<String, dynamic> toJson() => {'name': name, 'config': config};

  /// Creates an environment instance from JSON data.
  factory Environment.fromJson(String name, Map<String, dynamic> json) {
    return Environment(name, json['config']);
  }
}

/// A Flutter widget to toggle environments in debug mode.
class EnvSwitcherWidget extends StatefulWidget {
  /// The environment switcher instance managing the environments.
  final EnvSwitcher switcher;

  /// Creates an environment switcher dropdown widget.
  const EnvSwitcherWidget({required this.switcher, super.key});

  @override
  State<EnvSwitcherWidget> createState() => _EnvSwitcherWidgetState();
}

class _EnvSwitcherWidgetState extends State<EnvSwitcherWidget> {
  @override
  Widget build(BuildContext context) {
    // Only show the dropdown in debug mode.
    if (!const bool.fromEnvironment('dart.vm.product', defaultValue: false)) {
      return DropdownButton<String>(
        value: widget.switcher.currentEnv,
        items: widget.switcher._environments.keys
            .map((env) => DropdownMenuItem(value: env, child: Text(env)))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            widget.switcher.switchTo(value);
            setState(() {}); // Update the UI after switching environments.
          }
        },
      );
    }
    return const SizedBox.shrink(); // Hidden in release mode.
  }
}
