//
//  File.swift
//
//
//  Created by Oleh Hudeichuk on 14.04.2023.
//

import Foundation
import Fluent
import FluentPostgresDriver
@preconcurrency import SwiftTelegramSdk


final class Chats: Model, @unchecked Sendable {
    
    static var schema: String { "Chats".lowercased() }
    
    @ID(custom: "id", generatedBy: .database)
    var id: Int64?
    
    @Timestamp(key: "created_at", on: .create)
    public var createdAt: Date?
    @Timestamp(key: "updated_at", on: .update)
    public var updatedAt: Date?
    
    @Field(key: "chat_id")
    var chatId: Int64
    
    @Field(key: "chat_type")
    var chatType: String
    
    @Field(key: "title")
    var title: String?
    
    @Field(key: "username")
    var username: String?
    
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
    
    static func create(
        chatId: Int64,
        chatType: TGChatType,
        title: String?,
        username: String?,
        db: any Database
    ) async throws {
        let object: Chats = .init(
            chatId: chatId,
            chatType: chatType.rawValue,
            title: title,
            username: username
        )
        try await object.create(on: db)
    }
    
    @discardableResult
    static func updateOrCreate(
        chatId: Int64,
        chatType: TGChatType,
        title: String?,
        username: String?,
        db: any Database
    ) async throws -> Chats {
        try await db.transaction { db in
            let object = try await db.query(Chats.self)
                .filter(\.$chatId == chatId)
                .first()
            if object != nil {
                object!.chatId = chatId
                object!.chatType = chatType.rawValue
                object!.title = title
                object!.username = username
                try await object!.save(on: db)
            } else {
                try await create(
                    chatId: chatId,
                    chatType: chatType,
                    title: title,
                    username: username,
                    db: db
                )
            }
            return try await get(\.$chatId == chatId, db: db)!
        }
    }
    
    static func get(_ predicates: ModelValueFilter<Chats>..., db: any Database) async throws -> Chats? {
        var builder: QueryBuilder<Chats> = db.query(Chats.self)
        for predicate in predicates {
            builder = builder.filter(predicate)
        }
        return try await builder.first()
    }
}
