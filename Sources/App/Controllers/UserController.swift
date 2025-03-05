//
//  File.swift
//  restaurant
//
//  Created by Shohjakhon Mamadaliev on 05/03/25.
//

import Vapor
import Fluent

struct UserController: RouteCollection {
    
    
    func boot(routes: any Vapor.RoutesBuilder) throws {
        let usersGroup = routes.grouped("users")
        usersGroup.post(use: createUserHandler)
        usersGroup.get(use: getAllUsersHandler)
        usersGroup.get(":id", use: getUserByIdHandler)
    }
    
    func createUserHandler(_ req: Request ) async throws -> User.Public {
        
        let user = try req.content.decode(User.self)
        user.password = try Bcrypt.hash(user.password)
        try await user.save(on: req.db)
        return user.convertToPublic()
    }
    
    func getAllUsersHandler(_ req: Request) async throws -> [User.Public] {
        let users = try await User.query(on: req.db).all()
        let publicUsers = users.map { user in
            user.convertToPublic()
        }
        return publicUsers
    }
    
    func getUserByIdHandler(_ req: Request) async throws -> User.Public {
        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return user.convertToPublic()
    }
    
}
