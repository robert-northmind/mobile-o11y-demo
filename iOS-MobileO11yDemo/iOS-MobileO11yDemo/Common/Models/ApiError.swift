//
//  ApiError.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 16.05.24.
//

import Foundation

enum ApiError: Error {
    case invalidUrl, requestError, decodingError, statusNotOk, statusDidNotUpdate
}

