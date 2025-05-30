//
//  File.swift
//
//
//  Created by Oleh Hudeichuk on 14.04.2023.
//

import Foundation
import Fluent
import FluentPostgresDriver

final class JoinRequests: Model, @unchecked Sendable {
    
    static var schema: String { "Join_Requests".lowercased() }
    
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
    
    @Field(key: "element")
    var element: String
    
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
    
    static func create(
        usersId: Int64,
        chatsId: Int64,
        element: String,
        db: any Database
    ) async throws {
        let object: JoinRequests = .init(
            usersId: usersId,
            chatsId: chatsId,
            element: element
        )
        try await object.create(on: db)
    }
    
    @discardableResult
    static func updateOrCreate(
        usersId: Int64,
        chatsId: Int64,
        element: String,
        db: any Database
    ) async throws -> JoinRequests {
        try await db.transaction { db in
            let object = try await db.query(JoinRequests.self)
                .filter(\.$usersId == usersId)
                .filter(\.$chatsId == chatsId)
                .first()
            if object != nil {
                object!.usersId = usersId
                object!.chatsId = chatsId
                object!.element = element
                try await object!.save(on: db)
            } else {
                try await create(
                    usersId: usersId,
                    chatsId: chatsId,
                    element: element,
                    db: db
                )
            }
            return try await get(\.$usersId == usersId, \.$chatsId == chatsId, db: db)!
        }
    }
    
    static func checkElement(
        usersId: Int64,
        chatsId: Int64,
        element: String,
        db: any Database
    ) async throws -> Bool {
        try await db.transaction { db in
            let object = try await db.query(JoinRequests.self)
                .filter(\.$usersId == usersId)
                .filter(\.$chatsId == chatsId)
                .first()
            
            return (object?.element ?? "") == element
        }
    }
    
    static func get(_ predicates: ModelValueFilter<JoinRequests>..., db: any Database) async throws -> JoinRequests? {
        var builder: QueryBuilder<JoinRequests> = db.query(JoinRequests.self)
        for predicate in predicates {
            builder = builder.filter(predicate)
        }
        return try await builder.first()
    }
}
