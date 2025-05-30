//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 14.04.2023.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct Сreate_Chats_4: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.transaction { database in
            try await database.schema(Chats.schema)
                .field(.id, .int64, .identifier(auto: true))
                .field(.string("chat_id"), .int64, .required)
                .field(.string("chat_type"), .string, .required)
                .field(.string("title"), .string)
                .field(.string("username"), .string)
                
                .field(.string("updated_at"), .datetime)
                .field(.string("created_at"), .datetime)
                .create()
        }
    }
    
    func revert(on database: Database) async throws {
        try await database.transaction { database in
            try await database.schema(Chats.schema).delete()
        }
    }
}
