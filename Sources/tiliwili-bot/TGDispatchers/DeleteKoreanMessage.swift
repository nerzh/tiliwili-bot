//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 22.10.2023.
//

import Foundation
import TelegramVaporBot
import Vapor
import SwiftExtensionsPack

final class DeleteKoreanMessageDispatcher: TGDefaultDispatcher {
    
    override func handle() async throws {
        try await check()
    }
    
    func check() async throws {
        await add(TGMessageHandler({ update, bot in 
            if !update.message.isNil && !update.message!.text.isNil && update.message?.chat.id == -1001564736514 {
                let text = update.message!.text!
                if text[#"[\u3131-\uD79D]{3,}"#] {
                    TGBot.log.debug("delete message: \(text)")
                    try await bot.deleteMessage(params: TGDeleteMessageParams(chatId: .chat(update.message!.chat.id), messageId: update.message!.messageId))
                }
            }
        }))
    }
}

