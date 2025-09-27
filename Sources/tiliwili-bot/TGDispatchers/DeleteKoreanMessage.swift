//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 22.10.2023.
//

import Foundation
import SwiftTelegramBot
import Vapor
import SwiftExtensionsPack
import Fluent
import FluentPostgresDriver

final class DeleteKoreanMessageDispatcher: TGDefaultDispatcher, @unchecked Sendable {
    
    override
    func handle() async {
        await check()
    }
    
    func check() async {
        await add(TGMessageHandler({ update in
            if !update.message.isNil && !update.message!.text.isNil && update.message?.chat.id == -1001564736514 {
                let text = update.message!.text!
                if text[#"[\u3131-\uD79D]{3,}"#] {
                    try await self.bot.deleteMessage(params: TGDeleteMessageParams(chatId: .chat(update.message!.chat.id), messageId: update.message!.messageId))
                }
            }
        }))
    }
}

