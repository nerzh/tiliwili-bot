//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 14.04.2023.
//

import Foundation
import SwiftExtensionsPack
import PostgresBridge
import TelegramVaporBot

final class TelegramWatcher {
    
    class func start(checkEverySec: UInt32, timeoutSec: Int64) {
        Thread {
            while true {
                Task.detached {
                    try await app.postgres.transaction(to: .default) { conn in
                        let objects: [JoinRequests] = try await SwifQL.select(
                             \JoinRequests.$id,
                             \JoinRequests.$usersId,
                             \JoinRequests.$chatsId,
                             \JoinRequests.$element,
                             \JoinRequests.$updatedAt,
                             \JoinRequests.$createdAt
                        ).from(JoinRequests.table)
                            .execute(on: conn)
                            .all(decoding: JoinRequests.self)
                        
                        for object in objects {
                            pe("\(Date().toSeconds()) - \(object.updatedAt.toSeconds())", (Date().toSeconds() - object.updatedAt.toSeconds()) >= timeoutSec)
                            if (Date().toSeconds() - object.updatedAt.toSeconds()) >= timeoutSec {
                                let bot = await TGBOT.connection.bot
                                guard let user: Users = try await Users.get(\Users.$id == object.usersId)
                                else { throw makeError(AppError("User not found")) }
                                guard let chat: Chats = try await Chats.get(\Chats.$id == object.chatsId)
                                else { throw makeError(AppError("Chat not found")) }
                                try? await JoinRequestDispatcher.updateDBIfDecline(userId: user.chatId, chatId: chat.chatId)
                                try await bot.declineChatJoinRequest(params: .init(chatId: .chat(chat.chatId), userId: user.chatId))
                            }
                        }
                    }
                }
                sleep(checkEverySec)
            }
        }.start()
    }
}
