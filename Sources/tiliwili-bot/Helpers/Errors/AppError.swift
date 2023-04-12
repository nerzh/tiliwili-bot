//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 14.06.2021.
//

import Foundation
import SwiftExtensionsPack

public struct AppError: ErrorCommon, Encodable {
    public var title: String = "AppError"
    public var reason: String = ""
    public init() {}
}
