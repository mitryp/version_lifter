import 'dart:io';

import 'package:path/path.dart' as path;

enum ProjectPlatform {
  android,
  ios,
  web,
  windows,
  linux;

  static final Map<String, ProjectPlatform> namesToPlatforms = Map.fromEntries(
    values.map((platform) => MapEntry(platform.name, platform)),
  );
}
