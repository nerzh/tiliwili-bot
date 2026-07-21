//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 14.04.2023.
//

import Foundation
import SwiftTelegramBot
import Fluent
import FluentPostgresDriver

final class TelegramWatcher {
    
    class func start(checkEverySec: UInt32, timeoutSec: Int64) {
        Task.detached {
            while !Task.isCancelled {
                do {
                    let requests: [JoinRequests] = try await app.db.query(JoinRequests.self).all()
                    let expirationDate = Date().addingTimeInterval(-TimeInterval(timeoutSec))

                    for request in requests {
                        guard let updatedAt = request.updatedAt else {
                            app.logger.error("Join request \(request.id?.description ?? "unknown") has no updated_at value")
                            continue
                        }
                        guard updatedAt <= expirationDate else { continue }

                        do {
                            guard
                                let user: Users = try await Users.get(\Users.$id == request.usersId, db: app.db)
                            else {
                                throw AppError("User not found for join request \(request.id?.description ?? "unknown")")
                            }
                            guard
                                let chat: Chats = try await Chats.get(\Chats.$id == request.chatsId, db: app.db)
                            else {
                                throw AppError("Chat not found for join request \(request.id?.description ?? "unknown")")
                            }

                            try await app.bot.declineChatJoinRequest(
                                params: .init(chatId: .chat(chat.chatId), userId: user.chatId)
                            )
                            try await JoinRequestDispatcher.updateDBIfDecline(
                                userId: user.chatId,
                                chatId: chat.chatId
                            )
                            app.logger.info("Expired join request declined: user_id=\(user.chatId), chat_id=\(chat.chatId)")
                        } catch {
                            app.logger.error(
                                "Failed to decline expired join request \(request.id?.description ?? "unknown"): \(String(reflecting: error))"
                            )
                        }
                    }
                } catch {
                    app.logger.error("Failed to load join requests: \(String(reflecting: error))")
                }

                do {
                    try await Task.sleep(for: .seconds(checkEverySec))
                } catch {
                    break
                }
            }
        }
    }
}
