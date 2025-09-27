//
//  tg_actor.swift
//  tiliwili-bot
//
//  Created by Oleh Hudeichuk on 29.05.2025.
//

import Foundation
import Vapor
import SwiftTelegramBot

extension Application {
    private struct TGServiceServiceKey: StorageKey {
        typealias Value = TGBot
    }

    var bot: TGBot {
        get {
            guard let service = storage[TGServiceServiceKey.self] else {
                fatalError("TGBot not configured. Use app.bot = ...")
            }
            return service
        }
        set {
            storage[TGServiceServiceKey.self] = newValue
        }
    }
}
