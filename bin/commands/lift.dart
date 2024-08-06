import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:io/ansi.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:version_lifter/src/application/common/build_platform_lifters.dart';
import 'package:version_lifter/src/application/info/gather_info.dart';
import 'package:version_lifter/src/application/info/print_info.dart';
import 'package:version_lifter/src/application/lift/lift_pubspec_version.dart';
import 'package:version_lifter/src/application/utils/next_version_by_type.dart';
import 'package:version_lifter/src/domain/constraints/project_platform.dart';
import 'package:version_lifter/src/domain/constraints/version_type.dart';
import 'package:version_lifter/src/domain/errors/version_lifter_error.dart';

class LiftCommand extends Command<void> {
  static const dryRunFlagName = 'dry-run';
  static const keepBuildFlagName = 'keep-build';
  static const keepPrereleaseFlagName = 'keep-pre';
  static const buildVersionFlagName = 'build';
  static const incrementBuildVersionFlagName = 'increment-build';
  static const preVersionFlagName = 'pre';
  static const iosPostLiftFlagName = 'post-ios';
  static const versionFlagName = 'version';

  LiftCommand() {
    argParser
      ..addFlag(dryRunFlagName, defaultsTo: false)
      ..addFlag(keepBuildFlagName, defaultsTo: true)
      ..addFlag(keepPrereleaseFlagName, defaultsTo: false)
      ..addFlag(incrementBuildVersionFlagName, defaultsTo: true)
      ..addOption(
        buildVersionFlagName,
        abbr: 'b',
        help: 'Set custom build version',
      )
      ..addOption(preVersionFlagName, help: 'Set custom pre-release version')
      ..addOption(
        versionFlagName,
        abbr: 'v',
        help: 'Set a specific version in a SemVer format. '
            'If provided, all other flags will be ignored',
      );

    for (final platform in ProjectPlatform.values) {
      final flag = platform.postLiftCommandFlag;
      final help = platform.postLiftCommandHelp;

      if (flag == null) {
        continue;
      }

      argParser.addOption(flag, help: help);
    }

    for (final type in VersionType.values) {
      argParser.addFlag(
        type.name,
        negatable: false,
      );
    }
  }

  @override
  String get name => 'lift';

  @override
  String get description => 'Lifts the version of the package';

  String? _getPostRunCommand(ProjectPlatform platform) {
    final argResults = this.argResults;
    late final flag = platform.postLiftCommandFlag;
    if (argResults == null || flag == null) {
      return null;
    }

    return argResults.option(flag);
  }

  @override
  Future<void> run() async {
    final argResults = this.argResults!;
    final versionStr = argResults.option(versionFlagName);
    final versionOverride =
        versionStr != null ? Version.parse(versionStr) : null;
    final versionType = VersionType.values
        .where((type) => argResults.flag(type.name))
        .firstOrNull;

    if (versionStr == null && versionType == null) {
      throw NoVersionTypeError();
    }

    final root = Directory.current;
    final lifters = await buildPlatformLifters(root);
    final info = await gatherInfo(root, lifters);

    printPackageInfo(info);
    print('');

    final buildVersion = argResults.option(buildVersionFlagName);
    final preVersion = argResults.option(preVersionFlagName);
    final keepBuild =
        buildVersion != null || argResults.flag(keepBuildFlagName);
    final keepPre =
        preVersion != null || argResults.flag(keepPrereleaseFlagName);
    final incrementBuild =
        buildVersion == null && argResults.flag(incrementBuildVersionFlagName);

    final (:pubspec, platforms: _) = info;
    final version = pubspec.version ?? Version.none;
    final nextVersion = versionOverride ??
        version.nextByType(
          type: versionType!,
          keepBuild: keepBuild,
          incrementBuild: incrementBuild,
          build: buildVersion,
          keepPre: keepPre,
          pre: preVersion,
        );

    if (versionType != null) {
      print('Lifting ${versionType.name} version:');
    } else if (versionOverride != null) {
      print('Lifting version to $versionOverride:');
    }
    print(
      '${cyan.wrap('$version')} -> '
      '${wrapWith('$nextVersion', [styleBold, cyan])}',
    );

    if (argResults.flag(dryRunFlagName)) {
      return;
    }

    await liftPubspecVersion(
      root: root,
      currentVersion: version,
      nextVersion: nextVersion,
    );

    final migration = (current: version, target: nextVersion);
    for (final MapEntry(key: platform, value: lifter) in lifters.entries) {
      final success = await lifter.lift(root, migration);

      if (!success) {
        print(
          wrapWith(
            'Could not lift the ${platform.name} version, skipping',
            [red, styleBold],
          ),
        );
        continue;
      }

      final command = _getPostRunCommand(platform);

      await lifter.onPostLift(command);
    }

    print(styleBold.wrap('\nSuccessfully lifted:'));

    printPackageInfo(await gatherInfo(root, lifters));
  }
}
