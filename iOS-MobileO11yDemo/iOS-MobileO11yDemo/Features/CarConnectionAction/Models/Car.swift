//
//  Car.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import Foundation

class Car {
    let info: CarInfo
    var carDoorStatus: CarDoorStatus
    
    init() {
        self.info = CarInfoFactory().getRandomCarInfo()
        self.carDoorStatus = CarDoorStatus(status: "locked")
    }
}
