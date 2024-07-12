import 'package:flutter_mobile_o11y_demo/core/utils/random_element.dart';

class CarSoftwareVersion {
  const CarSoftwareVersion({
    required this.major,
    required this.minor,
    required this.patch,
  });

  final int major;
  final int minor;
  final int patch;

  @override
  String toString() {
    return '(v$major.$minor.$patch)';
  }
}

class CarSoftwareVersionFactory {
  CarSoftwareVersion getRandomVersion() {
    const initialVersions = [
      CarSoftwareVersion(major: 1, minor: 0, patch: 0),
      CarSoftwareVersion(major: 1, minor: 2, patch: 0),
      CarSoftwareVersion(major: 2, minor: 0, patch: 1),
      CarSoftwareVersion(major: 2, minor: 1, patch: 2),
    ];
    return initialVersions.getRandomElement();
  }

  CarSoftwareVersion getRandomNextVersion({
    required CarSoftwareVersion currentVersion,
  }) {
    return CarSoftwareVersion(
      major: RandomElementIntX.getRandomInRange(
        currentVersion.major,
        currentVersion.major + 1,
      ),
      minor: RandomElementIntX.getRandomInRange(
        currentVersion.minor,
        currentVersion.minor + 1,
      ),
      patch: RandomElementIntX.getRandomInRange(
        currentVersion.patch,
        currentVersion.patch + 5,
      ),
    );
  }
}
