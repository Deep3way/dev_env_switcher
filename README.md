# dev_env_switcher

A Flutter/Dart library to switch between development environments at runtime or build time.

## Features
- Define environments with custom configs (e.g., API URLs, flags).
- Switch environments dynamically or persist them.
- Flutter widget for toggling in debug mode.
- Export/import configs as JSON.

## Installation

Add this to your `pubspec.yaml` file:

```yaml
dependencies:
  dev_env_switcher: ^1.0.0
```


## Usage
```dart
import 'package:dev_env_switcher/dev_env_switcher.dart';

Future<void> main() async {
  
final switcher = EnvSwitcher();
switcher.addEnvironment('dev', {'apiUrl': 'https://dev.api.com'});
await switcher.switchTo('dev');
print(switcher.currentConfig['apiUrl']);

}
```

## Contribution

Feel free to fork the repository, create pull requests, and contribute to the library. Please ensure
all tests are passing before submitting any changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.