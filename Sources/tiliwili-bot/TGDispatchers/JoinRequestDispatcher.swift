//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 13.04.2023.
//

import Foundation
import SwiftTelegramBot
import Vapor
import SwiftRegularExpression
import SwiftExtensionsPack
import Fluent
import FluentPostgresDriver

final class JoinRequestDispatcher: TGDefaultDispatcher, @unchecked Sendable {
    
    override
    func handle() async {
        await addWhenJoinUser()
        await addWhenClickButton()
    }
    
    private func addWhenClickButton() async {
        await add(TGCallbackQueryHandler(pattern: "JoinRequestButton:") { update in
            guard let callbackQuery = update.callbackQuery else { return }
            guard let data = callbackQuery.data else { throw AppError("callbackQuery data not found") }
            let matches: [Int: String] = data.regexp(#"JoinRequestButton: (.+) (.+)"#)
            guard let element = matches[1] else { throw AppError("callbackQuery element not found") }
            guard
                let chatIdString = matches[2],
                let chatId: Int64 = Int64(chatIdString)
            else {
                throw AppError("callbackQuery chatId not found")
            }
            let userId: Int64 = callbackQuery.from.id
            let approve: Bool = try await self.checkResponse(userId: userId, chatId: chatId, element: element)
            if approve {
                try await self.bot.approveChatJoinRequest(params: .init(chatId: .chat(chatId), userId: userId))
                try await self.updateDBIfApprove(userId: userId, chatId: chatId)
                if let message = callbackQuery.message {
                    try await self.bot.deleteMessage(params: TGDeleteMessageParams(chatId: .chat(message.chat.id), messageId: message.messageId))
                    /// bot can't initiate conversation with a user
                    /// try await bot.sendMessage(params: TGSendMessageParams(chatId: .chat(message.chat.id), text: "Your response has been approved."))
                }
            } else {
                try await Self.updateDBIfDecline(userId: userId, chatId: chatId)
                try await self.bot.declineChatJoinRequest(params: .init(chatId: .chat(chatId), userId: userId))
                if let message = callbackQuery.message {
                    try await self.bot.deleteMessage(params: TGDeleteMessageParams(chatId: .chat(message.chat.id), messageId: message.messageId))
                    /// bot can't initiate conversation with a user
                    /// try await bot.sendMessage(params: TGSendMessageParams(chatId: .chat(message.chat.id), text: "Your response has been rejected."))
                }
            }
        })
    }
    
    private func addWhenJoinUser() async {
        await add(TGBaseHandler() { update in
            guard let chatJoinRequest = update.chatJoinRequest else { return }
            let userId: Int64 = chatJoinRequest.from.id
            let tgChat: TGChat = update.chatJoinRequest!.chat
            let buttons: [[TGInlineKeyboardButton]] = [
                [
                    .init(text: "🍌", callbackData: "JoinRequestButton: banana \(tgChat.id)"),
                    .init(text: "🍭", callbackData: "JoinRequestButton: candy \(tgChat.id)"),
                    .init(text: "🍏", callbackData: "JoinRequestButton: apple \(tgChat.id)"),
                    .init(text: "🍋", callbackData: "JoinRequestButton: lemon \(tgChat.id)"),
                ].shuffled(),
                [
                    .init(text: "🚗", callbackData: "JoinRequestButton: car \(tgChat.id)"),
                    .init(text: "🔑", callbackData: "JoinRequestButton: key \(tgChat.id)"),
                    .init(text: "🚁", callbackData: "JoinRequestButton: helicopter \(tgChat.id)"),
                    .init(text: "📱", callbackData: "JoinRequestButton: iPhone \(tgChat.id)"),
                ].shuffled()
            ]
            let forSelect: [String] = ["banana", "candy", "apple", "lemon", "car", "key", "helicopter", "iPhone"]
            let element: String = forSelect.randomElement()!
            try await self.workWithDB(update: update, element: element)
            let text: String = """
            \(element)
            
            Checking the entrance to the chat:
            
            title: \(tgChat.title ?? "no title")
            username: \(tgChat.username ?? "no username")
            
            To enter, please click on the: \(element)
            """
            let keyboard: TGInlineKeyboardMarkup = .init(inlineKeyboard: buttons)
            let params: TGSendMessageParams = .init(chatId: .chat(userId),
                                                    text: text,
                                                    replyMarkup: .inlineKeyboardMarkup(keyboard))
            try await self.bot.sendMessage(params: params)
        })
    }
    
    private func workWithDB(update: TGUpdate, element: String) async throws {
        do {
            let tgUser: TGUser = update.chatJoinRequest!.from
            let tgChat: TGChat = update.chatJoinRequest!.chat
            let user: Users = try await Users.updateOrCreate(chatId: tgUser.id,
                                                             username: tgUser.username,
                                                             firstName: tgUser.firstName,
                                                             lastName: tgUser.lastName,
                                                             languageCode: tgUser.languageCode,
                                                             isBot: tgUser.isBot,
                                                             db: app.db)
            
            let chat: Chats = try await Chats.updateOrCreate(chatId: tgChat.id,
                                                             chatType: tgChat.type,
                                                             title: tgChat.title,
                                                             username: tgChat.username,
                                                             db: app.db)
            
            try await ChatsUsers.updateOrCreate(usersId: user.id!,
                                                chatsId: chat.id!,
                                                approved: false,
                                                banned: false,
                                                db: app.db)
            
            try await JoinRequests.updateOrCreate(usersId: user.id!, chatsId: chat.id!, element: element, db: app.db)
        } catch {
            throw AppError(error, errorLevel: .debug)
        }
    }
    
    private func checkResponse(userId: Int64, chatId: Int64, element: String) async throws -> Bool {
        guard let user: Users = try await Users.get(\Users.$chatId == userId, db: app.db) else { throw AppError("User not found") }
        guard let chat: Chats = try await Chats.get(\Chats.$chatId == chatId, db: app.db) else { throw AppError("Chat not found") }
        let approve: Bool = try await JoinRequests.checkElement(usersId: user.id!, chatsId: chat.id!, element: element, db: app.db)
        return approve
    }
    
    private func updateDBIfApprove(userId: Int64, chatId: Int64) async throws {
        guard let user: Users = try await Users.get(\Users.$chatId == userId, db: app.db) else { throw AppError("User not found") }
        guard let chat: Chats = try await Chats.get(\Chats.$chatId == chatId, db: app.db) else { throw AppError("Chat not found") }
        guard
            let request: JoinRequests = try await JoinRequests.get(
                \.$usersId == user.id!,
                 \.$chatsId == chat.id!,
                 db: app.db
        ) else {
            throw AppError("JoinRequests not found")
        }
        try await request.delete(on: app.db)
        try await ChatsUsers.updateOrCreate(usersId: user.id!, chatsId: chat.id!, approved: true, banned: false, db: app.db)
    }
    
    class func updateDBIfDecline(userId: Int64, chatId: Int64) async throws {
        guard let user: Users = try await Users.get(\.$chatId == userId, db: app.db) else { throw AppError("User not found") }
        guard let chat: Chats = try await Chats.get(\.$chatId == chatId, db: app.db) else { throw AppError("Chat not found") }
        guard
            let request: JoinRequests = try await JoinRequests.get(\JoinRequests.$usersId == user.id!, \JoinRequests.$chatsId == chat.id!, db: app.db
        ) else {
            throw AppError("JoinRequests not found")
        }
        try await request.delete(on: app.db)
        try await ChatsUsers.updateOrCreate(usersId: chat.id!, chatsId: user.id!, approved: false, banned: false, db: app.db)
    }
}
