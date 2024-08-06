import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:pub_semver/pub_semver.dart';
import 'package:version_lifter/src/domain/constraints/project_platform.dart';

/// A default Dart package version is 0.1.0.
final initialProjectVersion = Version(0, 1, 0);

/// Executes the given callback [fn] in context of a new Flutter project created with the given
/// [platforms].
Future<T> withTestEnvironment<T>(
  FutureOr<T> Function(Directory projectDir) fn, {
  required Set<ProjectPlatform> platforms,
  String name = 'version_lister_test_env',
  String command = 'flutter',
  String tempFolderPath = 'temp',
}) async {
  final path = '$tempFolderPath-${Random().nextDouble()}';
  final dir = await createTestDir(path);
  await createFlutterProject(
    workingDir: dir,
    platforms: platforms,
    name: name,
    command: command,
  );

  final projectDir = Directory.fromUri(dir.uri.resolve(name));

  try {
    return await fn(projectDir);
  } finally {
    await dir.delete(recursive: true);
  }
}

Future<Directory> createTestDir(
  String tempFolderPath, {
  bool recursive = true,
}) async {
  final dir = Directory(tempFolderPath);

  if (!await dir.exists()) {
    await dir.create(recursive: recursive);
  }

  return dir;
}

Future<void> createFlutterProject({
  required Directory workingDir,
  required String name,
  required Set<ProjectPlatform> platforms,
  required String command,
}) async {
  final args = [
    'create',
    name,
    if (platforms.isNotEmpty)
      for (final platform in platforms) ...[
        '--platforms',
        platform.name,
      ],
    '--empty',
  ];

  await Process.run(command, args, workingDirectory: workingDir.path);
}
