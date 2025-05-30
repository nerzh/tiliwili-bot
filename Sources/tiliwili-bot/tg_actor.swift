//
//  tg_actor.swift
//  tiliwili-bot
//
//  Created by Oleh Hudeichuk on 29.05.2025.
//

import Foundation
import Vapor
import SwiftTelegramSdk

actor TGBotActor {
    private var _bot: TGBot!

    var bot: TGBot {
        self._bot
    }
    
    func setBot(_ bot: TGBot) {
        self._bot = bot
    }
}


extension Application {
    private struct TGServiceServiceKey: StorageKey {
        typealias Value = TGBotActor
    }

    var botActor: TGBotActor {
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
