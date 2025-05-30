//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 14.04.2023.
//

import Foundation
import SwiftExtensionsPack
@preconcurrency import SwiftTelegramSdk
import Fluent
import FluentPostgresDriver

final class TelegramWatcher {
    
    class func start(checkEverySec: UInt32, timeoutSec: Int64) {
        Thread {
            while true {
                Task.detached {
                    try await app.db.transaction { db in
                        let objects: [JoinRequests] = try await db.query(JoinRequests.self).all()
                        
                        for object in objects {
                            pe("\(Date().toSeconds()) - \(object.updatedAt!.toSeconds())", (Date().toSeconds() - object.updatedAt!.toSeconds()) >= timeoutSec)
                            
                            if (Date().toSeconds() - object.updatedAt!.toSeconds()) >= timeoutSec {
                                guard
                                    let user: Users = try await Users.get(\Users.$id == object.usersId, db: db)
                                else {
                                    throw makeError(AppError("User not found"))
                                }
                                guard
                                    let chat: Chats = try await Chats.get(\Chats.$id == object.chatsId, db: db)
                                else {
                                    throw makeError(AppError("Chat not found"))
                                }
                                try? await JoinRequestDispatcher.updateDBIfDecline(userId: user.chatId, chatId: chat.chatId)
                                try await app.botActor.bot.declineChatJoinRequest(params: .init(chatId: .chat(chat.chatId), userId: user.chatId))
                            }
                        }
                    }
                }
                sleep(checkEverySec)
            }
        }.start()
    }
}
