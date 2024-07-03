//
//  Car.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import Foundation

struct Car {
    let info: CarInfo
    let carDoorStatus: CarDoorStatus
}

class CarFactory {
    func getRandomCar() -> Car {
        return Car(
            info: CarInfoFactory().getRandomCarInfo(),
            carDoorStatus: CarDoorStatus(status: "locked")
        )
    }
}
