//
//  SelectedCarService.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 14.06.24.
//

import Foundation
import Combine
import OpenTelemetryApi

protocol SelectedCarServiceProtocol {
    var selectedCar: Car { get }
    var selectedCarPublisher: Published<Car>.Publisher { get }
    
    func updateSelectedCar(_ car: Car)
}

class SelectedCarService: SelectedCarServiceProtocol {
    @Published var selectedCar: Car = CarFactory().getRandomCar()
    var selectedCarPublisher: Published<Car>.Publisher { $selectedCar }
    
    func updateSelectedCar(_ car: Car) {
        selectedCar = car
    }
}

private struct SelectedCarServiceKey: InjectionKey {
    static var currentValue: SelectedCarServiceProtocol = SelectedCarService()
}

extension InjectedValues {
    var selectedCarService: SelectedCarServiceProtocol {
        get { Self[SelectedCarServiceKey.self] }
        set { Self[SelectedCarServiceKey.self] = newValue }
    }
}
