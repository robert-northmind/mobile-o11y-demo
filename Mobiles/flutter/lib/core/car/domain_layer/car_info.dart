import 'package:flutter_mobile_o11y_demo/core/car/domain_layer/car_color.dart';
import 'package:flutter_mobile_o11y_demo/core/car/domain_layer/car_model.dart';
import 'package:flutter_mobile_o11y_demo/core/car/domain_layer/car_software_version.dart';
import 'package:flutter_mobile_o11y_demo/core/utils/random_element.dart';

class CarInfo {
  CarInfo({
    required this.vin,
    required this.model,
    required this.color,
    required this.productionDate,
    required this.softwareVersion,
  });

  final String vin;
  final CarModel model;
  final CarColor color;
  final DateTime productionDate;
  final CarSoftwareVersion softwareVersion;
}

class CarInfoFactory {
  CarInfoFactory({
    required this.carSoftwareVersionFactory,
    required this.randomVinFactory,
  });

  CarSoftwareVersionFactory carSoftwareVersionFactory;
  RandomVinFactory randomVinFactory;

  CarInfo getRandomCarInfo() {
    return CarInfo(
      vin: randomVinFactory.getRandomVin(),
      model: CarModel.values.getRandomElement(),
      color: CarColor.values.getRandomElement(),
      productionDate: RandomElementDateTimeX.getRandomDate(),
      softwareVersion: carSoftwareVersionFactory.getRandomVersion(),
    );
  }
}
