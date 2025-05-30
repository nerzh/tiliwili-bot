//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 02.04.2023.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct Сreate_Users_1: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.transaction { database in
            try await database.schema(Users.schema)
                .field(.id, .int64, .identifier(auto: true))
                .field(.string("chat_id"), .int64, .required)
                .field(.string("username"), .string)
                .field(.string("first_name"), .string, .sql(.default("")))
                .field(.string("last_name"), .string)
                .field(.string("language_code"), .string)
                .field(.string("is_bot"), .bool, .sql(.default(false)))
                
                .field(.string("updated_at"), .datetime)
                .field(.string("created_at"), .datetime)
                .create()
        }
    }
    
    func revert(on database: Database) async throws {
        try await database.transaction { database in
            try await database.schema(Users.schema).delete()
        }
    }
}
