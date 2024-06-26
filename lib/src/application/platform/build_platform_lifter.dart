import 'package:version_lifter/src/application/platform/lift_ios.dart';
import 'package:version_lifter/src/domain/constraints/project_platform.dart';

import '../../domain/typedefs.dart';

PlatformLifter buildPlatformLifter(ProjectPlatform platform) =>
    switch (platform) {
      ProjectPlatform.ios => liftIOS,
      _ => ({required currentVersion, required nextVersion}) async {},
    };
