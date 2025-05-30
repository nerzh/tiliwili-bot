//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 11.03.2023.
//

import Foundation
import Vapor

nonisolated(unsafe) var Domain: String = ""
nonisolated(unsafe) var VAPOR_PORT: Int!
nonisolated(unsafe) var VAPOR_IP: String!

let TGWebHookName: String = "telegramWebHook"

nonisolated(unsafe) var PG_HOST: String = ""
nonisolated(unsafe) var PG_PORT: Int = 0
nonisolated(unsafe) var PG_USER: String = ""
nonisolated(unsafe) var PG_PSWD: String = ""
nonisolated(unsafe) var PG_DB_NAME: String = ""
nonisolated(unsafe) var PG_DB_CONNECTIONS: Int = 5


nonisolated(unsafe) var TG_BOT_ID: String!
nonisolated(unsafe) var TG_WEBHOOK_DOMAIN: String!

func getAllEnvConstants() throws {
    let projectPath = app.directory.workingDirectory
    print("Project working directory: \(projectPath)")
    
    let env = try Environment.detect()
    if env.name == "production" {
        guard let variable_15 = Environment.get("TG_WEBHOOK_DOMAIN") else { fatalError("Set TG_WEBHOOK_DOMAIN to .env.\(env.name)") }
        TG_WEBHOOK_DOMAIN = variable_15
    } else {
        Domain = "http://127.0.0.1:8181"
    }
    
    guard let vaporStringPort = Environment.get("vapor_port"), let variable_1 = Int(vaporStringPort) else {
        fatalError("Set vapor_port to .env.\(env.name)")
    }
    VAPOR_PORT = variable_1
    
    guard let variable_2 = Environment.get("vapor_ip") else { fatalError("Set vapor_ip to .env.\(env.name)") }
    VAPOR_IP = variable_2
    
    guard let variable_10 = Environment.get("PG_HOST") else { fatalError("Set PG_HOST to .env.\(env.name)") }
    PG_HOST = variable_10
    
    guard
            let dbPortString = Environment.get("PG_PORT"),
            let variable_11 = Int(dbPortString)
    else { fatalError("Set PG_PORT to \((try? Environment.detect().name) ?? ".env.\(env.name)")") }
    PG_PORT = variable_11
    
    guard let variable_12 = Environment.get("PG_USER") else { fatalError("Set PG_USER to .env.\(env.name)") }
    PG_USER = variable_12
    
    guard let variable_13 = Environment.get("PG_PSWD") else { fatalError("Set PG_PSWD to .env.\(env.name)") }
    PG_PSWD = variable_13
    
    guard let variable_14 = Environment.get("PG_DB_NAME") else { fatalError("Set PG_DB_NAME to .env.\(env.name)") }
    PG_DB_NAME = variable_14
    
    guard let variable_16 = Environment.get("TG_BOT_ID") else { fatalError("Set TG_BOT_ID to .env.\(env.name)") }
    TG_BOT_ID = variable_16
}
