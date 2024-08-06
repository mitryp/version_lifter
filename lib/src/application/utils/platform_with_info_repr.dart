import '../../domain/typedefs.dart';

extension PlatformWithInfoRepr on PlatformWithInfo {
  String get representation {
    final (platform, info) = this;
    final infoRepr = info == null ? '' : ' $info';

    return '${platform.name}$infoRepr';
  }
}
