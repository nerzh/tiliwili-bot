//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 11.03.2023.
//

import Foundation
import Vapor

var Domain: String = "https://bytehub.io"
var VAPOR_PORT: Int!
var VAPOR_IP: String!

let TGWebHookName: String = "telegramWebHook"

var PG_HOST: String = ""
var PG_PORT: Int = 0
var PG_USER: String = ""
var PG_PSWD: String = ""
var PG_DB_NAME: String = ""
var PG_DB_CONNECTIONS: Int = Int(Double(80) / Double(System.coreCount))

var TG_BOT_ID: String!
var TG_WEBHOOK_DOMAIN: String!

func getAllEnvConstants() throws {
    let env = try Environment.detect()
    if env.name == "production" {
        guard let variable_15 = Environment.get("telegramm_webhook_domain") else { fatalError("Set TG_WEBHOOK_DOMAIN to .env.\(env)") }
        TG_WEBHOOK_DOMAIN = variable_15
    } else {
        Domain = "http://127.0.0.1:8181"
    }
    app.logger.warning("\(env)")
    guard let vaporStringPort = Environment.get("vapor_port"), let variable_1 = Int(vaporStringPort) else {
        fatalError("Set vapor_port to .env.\(env)")
    }
    VAPOR_PORT = variable_1
    
    guard let variable_2 = Environment.get("vapor_ip") else { fatalError("Set vapor_ip to .env.\(env)") }
    VAPOR_IP = variable_2
    
    guard let variable_10 = Environment.get("PG_HOST") else { fatalError("Set PG_HOST to .env.\(env)") }
    PG_HOST = variable_10
    
    guard
            let dbPortString = Environment.get("PG_PORT"),
            let variable_11 = Int(dbPortString)
    else { fatalError("Set PG_PORT to \((try? Environment.detect().name) ?? ".env.\(env)")") }
    PG_PORT = variable_11
    
    guard let variable_12 = Environment.get("PG_USER") else { fatalError("Set PG_USER to .env.\(env)") }
    PG_USER = variable_12
    
    guard let variable_13 = Environment.get("PG_PSWD") else { fatalError("Set PG_PSWD to .env.\(env)") }
    PG_PSWD = variable_13
    
    guard let variable_14 = Environment.get("PG_DB_NAME") else { fatalError("Set PG_DB_NAME to .env.\(env)") }
    PG_DB_NAME = variable_14
    
    guard let variable_16 = Environment.get("TG_BOT_ID") else { fatalError("Set TG_BOT_ID to .env.\(env)") }
    TG_BOT_ID = variable_16
}
