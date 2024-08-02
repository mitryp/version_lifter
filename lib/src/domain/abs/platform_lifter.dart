import 'dart:async';
import 'dart:io';

import 'package:version_lifter/src/domain/abs/platform_info.dart';
import 'package:version_lifter/src/domain/typedefs.dart';

abstract interface class PlatformLifter<TInfo extends PlatformInfo> {
  FutureOr<TInfo?> gatherInfo(Directory root);

  FutureOr<bool> lift(Directory root, MigrationDescription description);

  FutureOr<void> onPostLift([String? command]);
}
