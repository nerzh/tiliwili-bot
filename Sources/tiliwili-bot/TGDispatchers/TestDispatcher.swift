//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 25.09.2023.
//

import Foundation
@preconcurrency import SwiftTelegramSdk
import Vapor
import SwiftExtensionsPack
import Fluent
import FluentPostgresDriver

final class TestDispatcher: TGDefaultDispatcher {
    
    override func handle() async throws {
        try await check()
    }
    
    func check() async throws {
        await add(TGCommandHandler(commands: ["check"], { update in
            if let userId = update.message?.chat.id {
                let params: TGSendMessageParams = .init(chatId: .chat(userId), text: "Status ✅")
                try await app.botActor.bot.sendMessage(params: params)
            }
        }))
    }
}
