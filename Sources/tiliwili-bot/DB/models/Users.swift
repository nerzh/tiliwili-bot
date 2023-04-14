//
//  File.swift
//
//
//  Created by Oleh Hudeichuk on 06.06.2021.
//

import Foundation
import PostgresBridge
import Vapor
import TelegramVaporBot

final class Users: Table {

    @Column("id")
    var id: Int64
    @Column("created_at")
    public var createdAt: Date
    @Column("updated_at")
    public var updatedAt: Date

    @Column("chat_id")
    var chatId: Int64

    @Column("username")
    var username: String?

    @Column("first_name")
    var firstName: String

    @Column("last_name")
    var lastName: String?

    @Column("language_code")
    var languageCode: String?

    @Column("is_bot")
    var isBot: Bool

    /// See `Table`
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

    @discardableResult
    static func updateOrCreate(chatId: Int64,
                               username: String?,
                               firstName: String,
                               lastName: String?,
                               languageCode: String?,
                               isBot: Bool
    ) async throws -> Users {
        return try await app.postgres.transaction(to: .default) { conn in
            var object: Users!
            object = try await SwifQL.select(
                 \Users.$id,
                 \Users.$chatId,
                 \Users.$username,
                 \Users.$firstName,
                 \Users.$lastName,
                 \Users.$languageCode,
                 \Users.$isBot,
                 \Users.$updatedAt,
                 \Users.$createdAt
            ).from(Users.table)
                .where(\Users.$chatId == chatId
                )
                .execute(on: conn)
                .first(decoding: Users.self)

            if object == nil {
                object = .init(chatId: chatId, username: username, firstName: firstName, lastName: lastName, languageCode: languageCode, isBot: isBot)
                return try await object.insert(on: conn)
            } else {
                object.username = username
                object.firstName = firstName
                object.lastName = lastName
                object.languageCode = languageCode
                object.isBot = isBot
                return try await object.upsert(conflictColumn: \Users.$id, on: conn)
            }
        }
    }
    
    static func get(_ predicates: SwifQLable) async throws -> Users? {
        return try await app.postgres.transaction(to: .default) { conn in
            var object: Users?
            object = try await SwifQL.select(
                 \Users.$id,
                 \Users.$chatId,
                 \Users.$username,
                 \Users.$firstName,
                 \Users.$lastName,
                 \Users.$languageCode,
                 \Users.$isBot,
                 \Users.$updatedAt,
                 \Users.$createdAt
            ).from(Users.table)
                .where(predicates)
                .execute(on: conn)
                .first(decoding: Users.self)
            
            return object
        }
    }
}
