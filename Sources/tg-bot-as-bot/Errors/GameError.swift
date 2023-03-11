//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 14.06.2021.
//

import Foundation

struct GameError: Error, CustomStringConvertible {

    enum Types {
        case error
    }

    private let title: String = "GameError"

    var type:        Types
    var reason:      String
    var description: String { "[\(title)] \(type) \(reason)" }

    init (_ type: Types = .error, reason: String = "") {
        self.type = type
        self.reason = reason
    }

    init (_ reason: String) {
        self.type = .error
        self.reason = reason
    }
}
