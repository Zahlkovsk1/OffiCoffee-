//
//  File.swift
//  restaurant
//
//  Created by Shohjakhon Mamadaliev on 04/03/25.
//

import Foundation
import Fluent
import Vapor

struct ProductController: RouteCollection {
    func boot(routes: any Vapor.RoutesBuilder) throws {
        let productGroup = routes.grouped("products")
        productGroup.post(use: createProductHandler)
        productGroup.get(use: getAllProductHandler)
        productGroup.get( ":productID",use: getProductHandler)
    }
    
    func createProductHandler(_ req: Request) async throws -> Product {
        guard let product = try? req.content.decode(Product.self) else {
            throw Abort(.custom(code: 499, reasonPhrase: "Not decoded into Product model"))
        }
        
        try await product.save(on: req.db)
        return product
    }
    
    
    func getAllProductHandler(_ req: Request) async throws -> [Product] {
        let proucts = try await Product.query(on: req.db).all()
        return proucts
    }
    
    func getProductHandler(_ req: Request) async throws -> Product {
        guard let product = try await Product.find(req.parameters.get("productID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return product
    }
}
