////
////  File.swift
////  
////
////  Created by Oleh Hudeichuk on 09.06.2021.
////
//
//import Foundation
//import PostgresBridge
//import Vapor
//import TelegramVaporBot
//
//enum CallbackModules: String, CustomStringConvertible {
//    case langSelect = "#lang:select "
//
//    var description: String { self.rawValue }
//}
//
//func callbackData(_ name: CallbackModules, _ value: String) -> String {
//    "\(name.description)\(value)"
//}
//
//func callbackDataValue(_ name: CallbackModules, _ data: String?) -> String? {
//    guard let data = data else { return nil }
//    let matches: [Int: String] = data.regexp("\(name.description)([\\s\\S]+)")
//    if let value = matches[1] { return value }
//    return nil
//}
//
//extension TGUpdate {
//
//    func from<T>(_ callback: (TGUser) -> T?) -> T? {
//        if let message = self.message, let from = message.from {
//            return callback(from)
//        } else if let message = self.editedMessage, let from = message.from {
//            return callback(from)
//        } else if let message = self.callbackQuery {
//            return callback(message.from)
//        }
//
//        return nil
//    }
//
//    func from() -> TGUser? {
//        if let message = self.message, let from = message.from {
//            return from
//        } else if let message = self.editedMessage, let from = message.from {
//            return from
//        } else if let message = self.callbackQuery {
//            return message.from
//        }
//
//        return nil
//    }
//}
//
//func unwrapResult<T>(_ value: Result<T, Error>) -> T? {
//    switch value {
//    case let .success(result):
//        return result
//    case let .failure(error):
//        TGBot.log.error(error.logMessage)
//        return nil
//    }
//}
//
//func throwingLogWrapper<T>(_ callback: () throws -> T) -> T? {
//    do {
//        return try callback()
//    } catch {
//        TGBot.log.error(error.logMessage)
//        return nil
//    }
//}
//
//func throwingLogWrapper(_ callback: () throws -> Void) {
//    do {
//        try callback()
//    } catch {
//        TGBot.log.error(error.logMessage)
//    }
//}
//
