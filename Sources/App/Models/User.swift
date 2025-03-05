//
//  File.swift
//  restaurant
//
//  Created by Shohjakhon Mamadaliev on 05/03/25.
//
import Fluent
import Vapor

final class User: Model, Content, @unchecked Sendable  {
    
    static let schema: String = "users"
    @ID var id: UUID?
    
    @Field(key: "name") var name: String
    @Field(key: "login") var login: String
    @Field(key: "password") var password: String
    @Field(key: "role") var role: String
    @Field(key: "imagePic") var imagePic: String?
    
    final class Public: Content {
        var name: String
        var id: UUID?
        var login: String
        var role: String
        var imagePic: String?
        
        init(name : String, id: UUID? = nil, login: String, role: String, imagePic: String? = nil) {
            self.id = id
            self.login = login
            self.role = role
            self.imagePic = imagePic
            self.name = name
        }
    }
}

extension User {
    func convertToPublic() -> User.Public {
        let publicUser = User.Public(name: self.name,
                                     id: self.id,
                                     login: self.login,
                                     role: self.role)
        return publicUser
    }
}

enum UserRole: String, CaseIterable {
    case waiter = "waiter"
    case manager = "manager"
}
