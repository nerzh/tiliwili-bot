//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 02.04.2023.
//

import Foundation
import PostgresBridge
import Vapor
import TelegramVaporBot

final class ChatsUsers: Table {
    
    @Column("id")
    var id: Int64
    @Column("created_at")
    public var createdAt: Date
    @Column("updated_at")
    public var updatedAt: Date
    
    @Column("users_id")
    var usersId: Int64
    
    @Column("chats_id")
    var chatsId: Int64
    
    @Column("approved")
    var approved: Bool
    
    @Column("banned")
    var banned: Bool
    
    /// See `Table`
    init() {}
    
    init(usersId: Int64, chatsId: Int64, approved: Bool, banned: Bool, updatedAt: Date = Date()) {
        self.usersId = usersId
        self.chatsId = chatsId
        self.approved = approved
        self.banned = banned
        self.updatedAt = updatedAt
    }
}


////// MARK: Queries
extension ChatsUsers {

    @discardableResult
    static func updateOrCreate(usersId: Int64,
                               chatsId: Int64,
                               approved: Bool,
                               banned: Bool
    ) async throws -> ChatsUsers {
        return try await app.postgres.transaction(to: .default) { conn in
            var object: ChatsUsers!
            object = try await SwifQL.select(
                 \ChatsUsers.$id,
                 \ChatsUsers.$usersId,
                 \ChatsUsers.$chatsId,
                 \ChatsUsers.$approved,
                 \ChatsUsers.$banned,
                 \ChatsUsers.$updatedAt,
                 \ChatsUsers.$createdAt
            ).from(ChatsUsers.table)
                .where(\ChatsUsers.$usersId == usersId &&
                        \ChatsUsers.$chatsId == chatsId
                )
                .execute(on: conn)
                .first(decoding: ChatsUsers.self)

            if object == nil {
                object = .init(usersId: usersId, chatsId: chatsId, approved: approved, banned: banned)
                return try await object.insert(on: conn)
            } else {
                object.approved = approved
                object.banned = banned
                return try await object.upsert(conflictColumn: \ChatsUsers.$id, on: conn)
            }
        }
    }
}
