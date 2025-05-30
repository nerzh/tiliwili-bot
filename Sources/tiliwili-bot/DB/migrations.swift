//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 02.04.2023.
//

import Foundation
import Fluent
import FluentPostgresDriver
import Vapor

func migrations(_ app: Application) async throws {
    do {
        let dbIdentifier: String = "default"
        app.migrations.add(Сreate_Users_1(), to: .init(string: dbIdentifier))
        app.migrations.add(Сreate_ChatsUsers_2(), to: .init(string: dbIdentifier))
        app.migrations.add(Сreate_JoinRequests_3(), to: .init(string: dbIdentifier))
        app.migrations.add(Сreate_Chats_4(), to: .init(string: dbIdentifier))
        
        try await app.autoMigrate()
    } catch {
        print(String(reflecting: error))
        throw AppError(error, logLevel: .error)
    }
}
