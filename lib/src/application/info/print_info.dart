import 'package:io/ansi.dart';
import '../utils/platform_with_info_repr.dart';
import '../../domain/typedefs.dart';

void printPackageInfo(PackageInfo info) {
  print('In project ${styleBold.wrap(info.pubspec.name)}:');
  print(
    'Project version: '
    '${wrapWith('${info.pubspec.version}', [cyan, styleBold])}',
  );
  if (info.platforms.isNotEmpty) {
    print(
      'Platforms: '
      '${cyan.wrap(info.platforms.map((e) => e.representation).join(', '))}',
    );
  } else {
    print(yellow.wrap('No platform code found'));
  }
}
