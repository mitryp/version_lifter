import 'package:io/ansi.dart';
import 'package:version_lifter/src/domain/typedefs.dart';

void printPackageInfo(PackageInfo info) {
  print('In project ${styleBold.wrap(info.pubspec.name)}:');
  print(
    'Project version: '
    '${wrapWith('${info.pubspec.version}', [cyan, styleBold])}',
  );
  if (info.platforms.isNotEmpty) {
    print(
      'Platforms: '
      '${cyan.wrap(info.platforms.map((e) => e.name).join(', '))}',
    );
  } else {
    print(yellow.wrap('No platform code found'));
  }
}
