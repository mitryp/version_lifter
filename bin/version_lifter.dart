import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:io/ansi.dart';
import 'package:version_lifter/src/domain/constants.dart';
import 'package:version_lifter/src/domain/errors/version_lifter_error.dart';

import 'commands/info.dart';
import 'commands/lift.dart';

CommandRunner buildRunner() {
  final commands = [
    InfoCommand(),
    LiftCommand(),
  ];

  final runner = CommandRunner(packageName, packageDescription);

  for (final command in commands) {
    runner.addCommand(command);
  }

  runner.argParser.addFlag(
    'version',
    negatable: false,
    help: 'Print the tool version.',
  );

  return runner;
}

void printUsage(ArgParser argParser) {
  print('Usage: dart version_lifter <flags> [arguments]');
  print(argParser.usage);
}

Future<void> main(List<String> args) async {
  final runner = buildRunner();

  try {
    final ArgResults results = runner.parse(args);

    if (results.wasParsed('version')) {
      print('version_lifter version: $packageVersion');
      return;
    }

    print('');
    await runner.run(args);
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(runner.argParser);
  } on VersionLifterError catch (e) {
    print(wrapWith(e.message, [red, styleBold]));
  }
}
