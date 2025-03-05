//
//  File.swift
//  restaurant
//
//  Created by Shohjakhon Mamadaliev on 05/03/25.
//

import Fluent
import Vapor

struct CreateUser: AsyncMigration {
    
    func prepare(on database: any FluentKit.Database) async throws {
        
        let schema = database.schema("users")
            .id()
            .field("name", .string, .required)
            .field("login", .string, .required)
            .field( "password", .string, .required)
            .field("role", .string, .required)
            .field("imagePic", .string)
            .unique(on: "login")
        try await  schema.create()
        
    }
    
    func revert(on database: any FluentKit.Database) async throws {
       try await database.schema("users").delete()
    }
}
