import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:version_lifter/src/application/info/gather_info.dart';
import 'package:version_lifter/src/application/info/print_info.dart';

class InfoCommand extends Command<void> {
  @override
  String get name => 'info';

  @override
  String get description => 'Display the current package, '
      'its version and platforms';

  @override
  Future<void> run() async {
    final dir = Directory.current;
    printPackageInfo(await gatherInfo(dir));
  }
}
