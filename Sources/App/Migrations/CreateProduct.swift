//
//  File.swift
//  restaurant
//
//  Created by Shohjakhon Mamadaliev on 04/03/25.
//

import Foundation
import Fluent
import Vapor


struct CreateProduct: Migration {
    
    func prepare(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema ("products")
            .id()
            .field("title", .string, .required)
            .field("description", .string, .required)
            .field( "price", .int, .required)
            .field("category", .string, .required)
            .field("image", .string, .required)
            .create()
    }
func revert(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
    database.schema("products").delete()
  }
}
