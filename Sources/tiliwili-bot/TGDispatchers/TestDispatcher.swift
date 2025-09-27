//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 25.09.2023.
//

import Foundation
import SwiftTelegramBot
import Vapor
import SwiftExtensionsPack
import Fluent
import FluentPostgresDriver

final class TestDispatcher: TGDefaultDispatcher, @unchecked Sendable {
    
    override
    func handle() async {
        await check()
    }
    
    func check() async {
        await add(TGCommandHandler(commands: ["check"], { update in
            if let userId = update.message?.chat.id {
                let params: TGSendMessageParams = .init(chatId: .chat(userId), text: "Status ✅")
                try await self.bot.sendMessage(params: params)
            }
        }))
    }
}
