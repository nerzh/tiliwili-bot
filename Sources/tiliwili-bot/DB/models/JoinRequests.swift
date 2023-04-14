//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 14.04.2023.
//

import Foundation
import PostgresBridge
import Vapor

final class JoinRequests: Table {
    
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
    
    @Column("element")
    var element: String
    
    /// See `Table`
    init() {}
    
    init(usersId: Int64, chatsId: Int64, element: String, updatedAt: Date = Date()) {
        self.usersId = usersId
        self.chatsId = chatsId
        self.element = element
        self.updatedAt = updatedAt
    }
}


////// MARK: Queries
extension JoinRequests {

    @discardableResult
    static func updateOrCreate(usersId: Int64,
                               chatsId: Int64,
                               element: String
    ) async throws -> JoinRequests {
        return try await app.postgres.transaction(to: .default) { conn in
            var object: JoinRequests!
            object = try await SwifQL.select(
                 \JoinRequests.$id,
                 \JoinRequests.$usersId,
                 \JoinRequests.$chatsId,
                 \JoinRequests.$element,
                 \JoinRequests.$updatedAt,
                 \JoinRequests.$createdAt
            ).from(JoinRequests.table)
                .where(\JoinRequests.$usersId == usersId &&
                        \JoinRequests.$chatsId == chatsId
                )
                .execute(on: conn)
                .first(decoding: JoinRequests.self)

            if object == nil {
                object = .init(usersId: usersId, chatsId: chatsId, element: element)
                return try await object.insert(on: conn)
            } else {
                object.element = element
                return try await object.upsert(conflictColumn: \JoinRequests.$id, on: conn)
            }
        }
    }
    
    static func checkElement(usersId: Int64,
                             chatsId: Int64,
                             element: String
    ) async throws -> Bool {
        return try await app.postgres.transaction(to: .default) { conn in
            var object: JoinRequests?
            object = try await SwifQL.select(
                 \JoinRequests.$id,
                 \JoinRequests.$usersId,
                 \JoinRequests.$chatsId,
                 \JoinRequests.$element,
                 \JoinRequests.$updatedAt,
                 \JoinRequests.$createdAt
            ).from(JoinRequests.table)
                .where(\JoinRequests.$usersId == usersId &&
                        \JoinRequests.$chatsId == chatsId
                )
                .execute(on: conn)
                .first(decoding: JoinRequests.self)

            return (object?.element ?? "") == element
        }
    }
    
    static func get(_ predicates: SwifQLable) async throws -> JoinRequests? {
        return try await app.postgres.transaction(to: .default) { conn in
            var object: JoinRequests?
            object = try await SwifQL.select(
                 \JoinRequests.$id,
                 \JoinRequests.$usersId,
                 \JoinRequests.$chatsId,
                 \JoinRequests.$element,
                 \JoinRequests.$updatedAt,
                 \JoinRequests.$createdAt
            ).from(JoinRequests.table)
                .where(predicates)
                .execute(on: conn)
                .first(decoding: JoinRequests.self)

            return object
        }
    }
}
