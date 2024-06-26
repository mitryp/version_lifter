import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:io/ansi.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:version_lifter/src/application/info/gather_info.dart';
import 'package:version_lifter/src/application/info/print_info.dart';
import 'package:version_lifter/src/application/lift/next_version_by_type.dart';
import 'package:version_lifter/src/domain/constraints/version_type.dart';
import 'package:version_lifter/src/domain/errors/version_lifter_error.dart';

class LiftCommand extends Command<void> {
  static const dryRunFlagName = 'dry-run';
  static const keepBuildFlagName = 'keep-build';
  static const keepPrereleaseFlagName = 'keep-pre';
  static const buildVersionFlagName = 'build';
  static const preVersionFlagName = 'pre';

  LiftCommand() {
    argParser
      ..addFlag(dryRunFlagName, defaultsTo: false)
      ..addFlag(keepBuildFlagName, defaultsTo: false)
      ..addFlag(keepPrereleaseFlagName, defaultsTo: false)
      ..addOption(buildVersionFlagName,
          abbr: 'b', help: 'Set custom build version')
      ..addOption(preVersionFlagName, help: 'Set custom pre-release version');

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

  @override
  Future<void> run() async {
    final argResults = this.argResults!;
    final versionType = VersionType.values
        .where((type) => argResults.flag(type.name))
        .firstOrNull;

    if (versionType == null) {
      throw NoVersionTypeError();
    }

    final root = Directory.current;
    final info = await gatherInfo(root);

    printPackageInfo(info);
    print('');

    final buildVersion = argResults.option(buildVersionFlagName);
    final preVersion = argResults.option(preVersionFlagName);
    final keepBuild =
        buildVersion != null || argResults.flag(keepBuildFlagName);
    final keepPre =
        preVersion != null || argResults.flag(keepPrereleaseFlagName);

    final (:pubspec, :platforms) = info;
    final version = pubspec.version ?? Version.none;
    final nextVersion = version.nextByType(
      type: versionType,
      keepBuild: keepBuild,
      build: buildVersion,
      keepPre: keepPre,
      pre: preVersion,
    );

    print('Lifting ${versionType.name} version:');
    print(
      '${cyan.wrap('$version')} -> '
      '${wrapWith('$nextVersion', [styleBold, cyan])}',
    );

    if (argResults.flag(dryRunFlagName)) {
      return;
    }
  }
}
