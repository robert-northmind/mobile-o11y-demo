//
//  CarInfo.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import Foundation

struct CarInfo {
    let vin: String
    let model: CarModel
    let color: CarColor
    let productionDate: Date
    let softwareVersion: CarSoftwareVersion
}

class CarInfoFactory {
    func getRandomCarInfo() -> CarInfo {
        return CarInfo(
            vin: UUID().uuidString,
            model: CarModel.allCases.randomElement() ?? .turboWombat,
            color: CarColor.allCases.randomElement() ?? .cosmicBlue,
            productionDate: ProductionDateFactory().getRandomDate(),
            softwareVersion: CarSoftwareVersionFactory().getRandomVersion()
        )
    }
}

class ProductionDateFactory {
    func getRandomDate() -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = Int.random(in: 2011...2023)
        dateComponents.month = Int.random(in: 1...12)
        dateComponents.day = Int.random(in: 1...28)

        let calendar = Calendar.current
        return calendar.date(from: dateComponents)!
    }
}
