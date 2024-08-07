import 'package:equatable/equatable.dart';
import 'package:flutter_mobile_o11y_demo/core/domain_layer/car/car_color.dart';
import 'package:flutter_mobile_o11y_demo/core/domain_layer/car/car_model.dart';
import 'package:flutter_mobile_o11y_demo/core/domain_layer/car/car_software_version.dart';
import 'package:flutter_mobile_o11y_demo/core/utils/random_element.dart';

class CarInfo extends Equatable {
  const CarInfo({
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

  @override
  List<Object?> get props => [
        vin,
        model,
        color,
        productionDate,
        softwareVersion,
      ];
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
