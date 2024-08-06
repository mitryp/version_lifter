import 'dart:async';
import 'dart:io';

import 'platform_info.dart';
import '../typedefs.dart';

abstract interface class PlatformLifter<TInfo extends PlatformInfo> {
  FutureOr<TInfo?> gatherInfo(Directory root);

  FutureOr<bool> lift(Directory root, MigrationDescription description);

  FutureOr<void> onPostLift([String? command]);
}
