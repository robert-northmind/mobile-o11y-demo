//
//  CarConnection.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import Foundation

class CarConnection {
    let carInfo: CarInfo
    var carDoorStatus: CarDoorStatus
    
    init() {
        self.carInfo = CarInfoFactory().getRandomCarInfo()
        self.carDoorStatus = CarDoorStatus(status: "locked")
    }
}
