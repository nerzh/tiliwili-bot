//
//  File.swift
//
//
//  Created by Oleh Hudeichuk on 02.04.2023.
//

import Foundation
import Fluent
import FluentPostgresDriver

final class ChatsUsers: Model, @unchecked Sendable {
    
    static var schema: String { "Chats_Users".lowercased() }
    
    @ID(custom: "id", generatedBy: .database)
    var id: Int64?
    
    @Timestamp(key: "created_at", on: .create)
    public var createdAt: Date?
    @Timestamp(key: "updated_at", on: .update)
    public var updatedAt: Date?
    
    @Field(key: "users_id")
    var usersId: Int64
    
    @Field(key: "chats_id")
    var chatsId: Int64
    
    @Field(key: "approved")
    var approved: Bool
    
    @Field(key: "banned")
    var banned: Bool
    
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
    
    static func create(
        usersId: Int64,
        chatsId: Int64,
        approved: Bool,
        banned: Bool,
        db: any Database
    ) async throws {
        let object: ChatsUsers = .init(
            usersId: usersId,
            chatsId: chatsId,
            approved: approved,
            banned: banned
        )
        try await object.create(on: db)
    }
    
    @discardableResult
    static func updateOrCreate(
        usersId: Int64,
        chatsId: Int64,
        approved: Bool,
        banned: Bool,
        db: any Database
    ) async throws -> ChatsUsers {
        try await db.transaction { db in
            let object = try await db.query(ChatsUsers.self)
                .filter(\.$usersId == usersId)
                .filter(\.$chatsId == chatsId)
                .first()
            if object != nil {
                object!.usersId = usersId
                object!.chatsId = chatsId
                object!.approved = approved
                object!.banned = banned
                try await object!.save(on: db)
            } else {
                try await create(
                    usersId: usersId,
                    chatsId: chatsId,
                    approved: approved,
                    banned: banned,
                    db: db
                )
            }
            return try await get(\.$usersId == usersId, \.$chatsId == chatsId, db: db)!
        }
    }
    
    static func get(_ predicates: ModelValueFilter<ChatsUsers>..., db: any Database) async throws -> ChatsUsers? {
        var builder: QueryBuilder<ChatsUsers> = db.query(ChatsUsers.self)
        for predicate in predicates {
            builder = builder.filter(predicate)
        }
        return try await builder.first()
    }
}
