//
//  File.swift
//  restaurant
//
//  Created by Shohjakhon Mamadaliev on 04/03/25.
//

import Foundation
import Fluent
import Vapor


struct CreateProduct: AsyncMigration {
    
    func prepare(on database: FluentKit.Database) async throws {
        
        let schema = database.schema("products")
        
            .id()
            .field("title", .string, .required)
            .field("description", .string, .required)
            .field( "price", .int, .required)
            .field("category", .string, .required)
            .field("image", .string, .required)
        try await  schema.create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
       try await database.schema("products").delete()
    }
}
