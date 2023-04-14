//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 14.04.2023.
//

import Foundation
import PostgresBridge
import Vapor
import TelegramVaporBot

final class Chats: Table {
    
    @Column("id")
    var id: Int64
    @Column("created_at")
    public var createdAt: Date
    @Column("updated_at")
    public var updatedAt: Date
    
    @Column("chat_id")
    var chatId: Int64
    
    @Column("chat_type")
    var chatType: String
    
    @Column("title")
    var title: String?
    
    @Column("username")
    var username: String?
    
    /// See `Table`
    init() {}
    
    init(chatId: Int64, chatType: String, title: String?, username: String?, updatedAt: Date = Date()) {
        self.chatId = chatId
        self.chatType = chatType
        self.title = title
        self.username = username
        self.updatedAt = updatedAt
    }
}


////// MARK: Queries
extension Chats {
    
    @discardableResult
    static func updateOrCreate(chatId: Int64,
                               chatType: TGChatType,
                               title: String?,
                               username: String?
    ) async throws -> Chats {
        return try await app.postgres.transaction(to: .default) { conn in
            var object: Chats!
            object = try await SwifQL.select(
                \Chats.$id,
                 \Chats.$chatId,
                 \Chats.$chatType,
                 \Chats.$title,
                 \Chats.$username,
                 \Chats.$updatedAt,
                 \Chats.$createdAt
            ).from(Chats.table)
                .where(\Chats.$chatId == chatId
                )
                .execute(on: conn)
                .first(decoding: Chats.self)
            if object == nil {
                object = .init(chatId: chatId, chatType: chatType.rawValue, title: title, username: username)
                return try await object.insert(on: conn)
            } else {
                object.chatType = chatType.rawValue
                object.title = title
                object.username = username
                return try await object.upsert(conflictColumn: \Chats.$id, on: conn)
            }
        }
    }
    
    static func get(_ predicates: SwifQLable) async throws -> Chats? {
        return try await app.postgres.transaction(to: .default) { conn in
            var object: Chats?
            object = try await SwifQL.select(
                \Chats.$id,
                 \Chats.$chatId,
                 \Chats.$chatType,
                 \Chats.$title,
                 \Chats.$username,
                 \Chats.$updatedAt,
                 \Chats.$createdAt
            ).from(Chats.table)
                .where(predicates)
                .execute(on: conn)
                .first(decoding: Chats.self)
            
            return object
        }
    }
}
