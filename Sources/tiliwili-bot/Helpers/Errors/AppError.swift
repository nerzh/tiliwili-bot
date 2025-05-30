//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 14.06.2021.
//

//import Foundation
//import SwiftExtensionsPack
//
//public struct AppError: ErrorCommon, Encodable {
//    public var title: String = "AppError"
//    public var reason: String = ""
//    public init() {}
//}


import Foundation
import SwiftExtensionsPack

public struct AppError: ErrorCommon, Encodable {
    public var reason: String = ""
    public init() {}
    public init(_ reason: String, file: String = #file, function: String = #function, line: Int = #line) {
        self.init()
        self.reason = "[ERROR] \(file), \(function), line \(line):\n\(reason)"
    }
}
