//
//  File.swift
//
//
//  Created by Oleh Hudeichuk on 06.06.2021.
//

import Foundation
import Fluent
import FluentPostgresDriver

final class Users: Model, @unchecked Sendable {
    
    static var schema: String { "Users".lowercased() }
    
    @ID(custom: "id", generatedBy: .database)
    var id: Int64?
    @Timestamp(key: "created_at", on: .create)
    public var createdAt: Date?
    @Timestamp(key: "updated_at", on: .update)
    public var updatedAt: Date?
    
    @Field(key: "chat_id")
    var chatId: Int64
    
    @Field(key: "username")
    var username: String?
    
    @Field(key: "first_name")
    var firstName: String
    
    @Field(key: "last_name")
    var lastName: String?
    
    @Field(key: "language_code")
    var languageCode: String?
    
    @Field(key: "is_bot")
    var isBot: Bool
    
    init() {}
    
    init(
        chatId: Int64,
        username: String?,
        firstName: String,
        lastName: String?,
        languageCode: String?,
        isBot: Bool,
        updatedAt: Date = Date()
    ) {
        self.chatId = chatId
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.languageCode = languageCode
        self.isBot = isBot
        self.updatedAt = updatedAt
    }
}

////// MARK: Queries
extension Users {
    
    static func create(
        chatId: Int64,
        username: String?,
        firstName: String,
        lastName: String?,
        languageCode: String?,
        isBot: Bool,
        db: any Database
    ) async throws {
        let object: Users = .init(
            chatId: chatId,
            username: username,
            firstName: firstName,
            lastName: lastName,
            languageCode: languageCode,
            isBot: isBot
        )
        try await object.create(on: db)
    }
    
    static func updateOrCreate(
        chatId: Int64,
        username: String?,
        firstName: String,
        lastName: String?,
        languageCode: String?,
        isBot: Bool,
        db: any Database
    ) async throws -> Users {
        try await db.transaction { db in
            let object = try await db.query(Users.self)
                .filter(\.$chatId == chatId)
                .all().first
            if object != nil {
                object!.username = username
                object!.firstName = firstName
                object!.lastName = lastName
                object!.languageCode = languageCode
                object!.isBot = isBot
                try await object!.save(on: db)
            } else {
                try await create(
                    chatId: chatId,
                    username: username,
                    firstName: firstName,
                    lastName: lastName,
                    languageCode: languageCode,
                    isBot: isBot,
                    db: db
                )
            }
            return try await get(\.$chatId == chatId, db: db)!
        }
    }
    
    static func get(_ predicates: ModelValueFilter<Users>..., db: any Database) async throws -> Users? {
        var builder: QueryBuilder<Users> = db.query(Users.self)
        for predicate in predicates {
            builder = builder.filter(predicate)
        }
        return try await builder.first()
    }
}
