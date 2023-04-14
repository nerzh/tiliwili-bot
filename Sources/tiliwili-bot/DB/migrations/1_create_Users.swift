//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 02.04.2023.
//

import Foundation
import Bridges

struct Сreate_Users_1: TableMigration {
    typealias Table = Users

    static func prepare(on conn: BridgeConnection) async throws {
        let builder: CreateTableBuilder<Table> = createBuilder
        _ = builder.column("id", .bigserial, .primaryKey, .notNull)
        _ = builder.column("chat_id", .bigint, .notNull)
        _ = builder.column("username", .text)
        _ = builder.column("first_name", .text, .default(""), .notNull)
        _ = builder.column("last_name", .text)
        _ = builder.column("language_code", .text)
        _ = builder.column("is_bot", .bool, .default(false), .notNull)
        
        _ = builder.column("created_at", .timestamptz, .default(Fn.now()), .notNull)
        _ = builder.column("updated_at", .timestamptz, .default(Fn.now()), .notNull)

        try await builder.execute(on: conn)
    }

    static func revert(on conn: BridgeConnection) async throws {
        let builder: DropTableBuilder<Table> = dropBuilder
        try await builder.execute(on: conn)
    }
}
