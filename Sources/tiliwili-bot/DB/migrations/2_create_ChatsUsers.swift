//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 14.04.2023.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct Сreate_ChatsUsers_2: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.transaction { database in
            try await database.schema(ChatsUsers.schema)
                .field(.id, .int64, .identifier(auto: true))
                .field(.string("users_id"), .int64, .required)
                .field(.string("chats_id"), .int64, .required)
                .field(.string("approved"), .bool, .sql(.default(false)))
                .field(.string("banned"), .bool, .sql(.default(false)))
                
                .field(.string("updated_at"), .datetime)
                .field(.string("created_at"), .datetime)
                .create()
        }
    }
    
    func revert(on database: Database) async throws {
        try await database.transaction { database in
            try await database.schema(ChatsUsers.schema).delete()
        }
    }
}
