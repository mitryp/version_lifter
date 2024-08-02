import 'dart:io';

import 'package:version_lifter/src/domain/abs/platform_info.dart';
import 'package:version_lifter/src/domain/abs/platform_lifter.dart';
import 'package:version_lifter/src/domain/constraints/project_platform.dart';

import '../../domain/typedefs.dart';

class PassingPlatformLifter implements PlatformLifter<PlatformInfo> {
  final ProjectPlatform targetPlatform;

  const PassingPlatformLifter(this.targetPlatform);

  @override
  Future<bool> lift(Directory root, MigrationDescription description) async {
    print('Platform ${targetPlatform.name} does not require additional lifting');
    return true;
  }

  @override
  Future<PlatformInfo?> gatherInfo(Directory root) async => null;

  @override
  Future<void> onPostLift([String? command]) async {
    print('Platform ${targetPlatform.name} does not require post-lift ');
  }
}
