enum CarModel {
  turboWombat,
  vortexVelociraptor,
  giggleMobile,
  pandaProwler,
  blizzardBison,
  rocketRaccoon,
}

extension CarModelX on CarModel {
  String get description {
    switch (this) {
      case CarModel.turboWombat:
        return 'Turbo Wombat';
      case CarModel.vortexVelociraptor:
        return 'Vortex Velociraptor';
      case CarModel.giggleMobile:
        return 'Giggle Mobile';
      case CarModel.pandaProwler:
        return 'Panda Prowler';
      case CarModel.blizzardBison:
        return 'Blizzard Bison';
      case CarModel.rocketRaccoon:
        return 'Rocket Raccoon';
    }
  }

  String get imageAssetPath {
    switch (this) {
      case CarModel.turboWombat:
        return 'assets/images/turboWombat.webp';
      case CarModel.vortexVelociraptor:
        return 'assets/images/vortexVelociraptor.webp';
      case CarModel.giggleMobile:
        return 'assets/images/giggleMobile.webp';
      case CarModel.pandaProwler:
        return 'assets/images/pandaProwler.webp';
      case CarModel.blizzardBison:
        return 'assets/images/blizzardBison.webp';
      case CarModel.rocketRaccoon:
        return 'assets/images/rocketRaccoon.webp';
    }
  }
}
