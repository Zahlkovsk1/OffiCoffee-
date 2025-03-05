//
//  File.swift
//  restaurant
//
//  Created by Shohjakhon Mamadaliev on 04/03/25.
//

import Fluent
import Vapor

final class Product: Model, Content, @unchecked Sendable {
    static let schema: String = "products"
    
    @ID var id: UUID?
    @Field(key: "title") var title: String
    @Field(key: "description") var description: String
    @Field(key: "price") var price: Int
    @Field(key: "category") var category: String
    @Field(key: "image") var image: String
    
    init(){}
    
    init(id: UUID? = nil, title: String, description: String, price: Int, category: String, image: String) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        self.category = category
        self.image = image
    }
}
