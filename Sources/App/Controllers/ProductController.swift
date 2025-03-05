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
        productGroup.get(use: getAllProductHandler)
        productGroup.get( ":productID",use: getProductHandler)
        
        let basicMW = User.authenticator()
        let guardMW = User.guardMiddleware()
        let protected = productGroup.grouped(basicMW, guardMW)
        protected.post(use: createProductHandler)
        protected.delete(":productID",use: deleteProductHandler)
        protected.put(":productID", use: updateProductHandler)
    }
    
    //MARK: CRUD - post
    func createProductHandler(_ req: Request) async throws -> Product {
        
        guard let productData = try? req.content.decode(ProductDTO.self) else {
            throw Abort(.custom(code: 499, reasonPhrase: "Not decoded into ProductDTO model"))
        }
        let productID = UUID()
        let product = Product(id: productID,
                              title:productData.title,
                              description: productData.description,
                              price: productData.price,
                              category: productData.category,
                              image: "")
        
        let imagePath = req.application.directory.workingDirectory + "Storage/Products" + "/\(product.id!).jpg"
        
        try await req.fileio.writeFile(.init(data: productData.image), at: imagePath)
        product.image = imagePath
        try await product.save(on: req.db)
        return product
    }
    
    //MARK: CRUD - Retrieve all
    func getAllProductHandler(_ req: Request) async throws -> [Product] {
        let proucts = try await Product.query(on: req.db).all()
        return proucts
    }
    
    //MARK: CRUD - Retrieve
    func getProductHandler(_ req: Request) async throws -> Product {
        guard let product = try await Product.find(req.parameters.get("productID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return product
    }
    
    //MARK: CRUD - Update
    func updateProductHandler(_ req: Request) async throws -> Product {
        guard let product = try await Product.find(req.parameters.get("productID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updatedProduct = try req.content.decode(Product.self)
        
        product.title = updatedProduct.title
        product.price = updatedProduct.price
        product.category = updatedProduct.category
        product.image = updatedProduct.image
        product.description = updatedProduct.description
        try await product.save(on: req.db)
        
        return product
    }
    
    
    //MARK: CRUD - delete
    func deleteProductHandler (_ req: Request) async throws -> Response {
        guard let product = try await Product.find(req.parameters.get("productID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await   product.delete(on: req.db)
        return Response.init(status: .ok, version: .init(major: 1, minor: 1), headersNoUpdate: [:], body: .init(stringLiteral: String("Deleted")))
    }
}


struct ProductDTO: Content {

     var title: String
     var description: String
     var price: Int
     var category: String
     var image: Data
}
