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
}
