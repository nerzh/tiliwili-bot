//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 25.09.2023.
//

import Foundation
import TelegramVaporBot
import Vapor
import SwiftExtensionsPack

final class TestDispatcher: TGDefaultDispatcher {
    
    override func handle() async throws {
        try await check()
    }
    
    func check() async throws {
        await add(TGCommandHandler(commands: ["check"], { update, bot in
            if let userId = update.message?.chat.id {
                let params: TGSendMessageParams = .init(chatId: .chat(userId), text: "Status ✅")
                try await bot.sendMessage(params: params)
            }
        }))
    }
}
