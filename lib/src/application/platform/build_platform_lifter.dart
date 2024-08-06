import 'ios/ios_platform_lifter.dart';
import 'passing_platform_lifter.dart';
import '../../domain/constraints/project_platform.dart';

import '../../domain/abs/platform_lifter.dart';

extension PlatformLifterBuilder on ProjectPlatform {
  PlatformLifter buildLifter() => switch (this) {
        ProjectPlatform.ios => const IosPlatformLifter(),
        final platform => PassingPlatformLifter(platform),
      } as PlatformLifter;
}
