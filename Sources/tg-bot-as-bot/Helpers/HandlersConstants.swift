////
////  File.swift
////  
////
////  Created by Oleh Hudeichuk on 09.06.2021.
////
//
//import Foundation
//import CNIOHTTPParser
//
//class HandlersConstants {
//    private static var commandsQueue: DispatchQueue = .init(label: "com.tg-game-bot.commandsQueue")
//    private static var _usedCommands: [String] = []
//    static var usedCommands: [String] {
//        get {
//            var result: [String] = []
//            commandsQueue.sync(flags: .barrier) {
//                result = _usedCommands
//            }
//            return result
//        }
//        set {
//            commandsQueue.sync(flags: .barrier) {
//                _usedCommands = newValue
//            }
//        }
//    }
//}
