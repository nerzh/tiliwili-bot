//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 22.10.2023.
//

import Foundation
@preconcurrency import SwiftTelegramSdk
import Vapor
import SwiftExtensionsPack
import Fluent
import FluentPostgresDriver

final class DeleteKoreanMessageDispatcher: TGDefaultDispatcher {
    
    override func handle() async throws {
        try await check()
    }
    
    func check() async throws {
        await add(TGMessageHandler({ update in
            if !update.message.isNil && !update.message!.text.isNil && update.message?.chat.id == -1001564736514 {
                let text = update.message!.text!
                if text[#"[\u3131-\uD79D]{3,}"#] {
                    try await app.botActor.bot.deleteMessage(params: TGDeleteMessageParams(chatId: .chat(update.message!.chat.id), messageId: update.message!.messageId))
                }
            }
        }))
    }
}

