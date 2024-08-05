import 'dart:async';
import 'dart:io';

import 'package:io/ansi.dart';
import 'package:path/path.dart' as path;
import 'package:version_lifter/src/application/platform/ios/ios_info.dart';
import 'package:version_lifter/src/application/utils/version_ext.dart';
import 'package:version_lifter/src/domain/abs/platform_lifter.dart';
import 'package:xcodeproj/xcodeproj.dart';

import '../../../domain/errors/version_lifter_error.dart';
import '../../../domain/typedefs.dart';

const _iosFolderName = 'ios';
const _projectDir = 'Runner.xcodeproj';
const _projectName = 'project.pbxproj';
const _marketingVersionKey = 'MARKETING_VERSION';
const _projectVersionKey = 'CURRENT_PROJECT_VERSION';

class IosPlatformLifter implements PlatformLifter<IosInfo> {
  const IosPlatformLifter();

  XCBuildConfiguration _getRunConf(Directory root) {
    final projectPath = root.uri.resolve(path.join(_iosFolderName, _projectDir)).path;
    final project = XCodeProj(projectPath);

    final runConf = project.buildConfigurations.where(
      (conf) =>
          conf.buildSettings.containsKey(_marketingVersionKey) &&
          conf.buildSettings.containsKey(_projectVersionKey),
    );

    return runConf.isNotEmpty ? runConf.first : (throw NoIosConfigurationError());
  }

  @override
  Future<IosInfo> gatherInfo(Directory root) async {
    final runConf = _getRunConf(root);

    final marketingVersion = runConf.buildSettings[_marketingVersionKey].toString();
    final projectVersion = runConf.buildSettings[_projectVersionKey] as int;

    return IosInfo(marketingVersion: marketingVersion, projectVersion: projectVersion);
  }

  @override
  Future<bool> lift(Directory root, MigrationDescription description) async {
    final target = description.target;
    final info = await gatherInfo(root);

    final xcodeprojFile = File(path.join(root.path, _iosFolderName, _projectDir, _projectName));

    print('Lifting versions at ${path.basename(xcodeprojFile.path)}');

    final originalLines = await xcodeprojFile.readAsLines();

    final modifiedLines = originalLines.map((line) {
      if (line.contains(_marketingVersionKey)) {
        return line.replaceFirst(info.marketingVersion, target.marketingVersion);
      }

      final buildStr = target.buildStr;
      if (buildStr != null && line.contains(_projectVersionKey)) {
        return line.replaceFirst('${info.projectVersion}', buildStr);
      }

      return line;
    });

    final newContent = modifiedLines.join('\n');
    await xcodeprojFile.writeAsString('$newContent\n');

    return true;
  }

  @override
  Future<void> onPostLift([String? command]) async {
    if (command == null) {
      print('iOS post-lift command is not specified');
      return;
    }

    print('Executing iOS post-lift command: $command');

    final [exec, ...args] = command.split(' ');

    try {
      await Process.run(exec, args);
    } on ProcessException catch (e) {
      print(
        wrapWith(
          'An exception occurred during the iOS post-run command execution: ${e.message}',
          [styleBold, red],
        ),
      );

      rethrow;
    }
  }
}
