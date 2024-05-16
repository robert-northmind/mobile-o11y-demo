//
//  ChangeDoorStatusRemoteAction.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 16.05.24.
//

import Foundation

protocol ChangeDoorStatusRemoteAction: Codable {
    var status: String { get }
}

struct UnlockDoorStatusRemoteAction: ChangeDoorStatusRemoteAction {
    var status = "unlocked"
}

struct LockDoorStatusRemoteAction: ChangeDoorStatusRemoteAction {
    var status = "locked"
}
