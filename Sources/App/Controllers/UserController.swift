//
//  File.swift
//  restaurant
//
//  Created by Shohjakhon Mamadaliev on 05/03/25.
//

import Vapor
import Fluent

struct UserController: RouteCollection, Sendable {
    
    
    func boot(routes: any Vapor.RoutesBuilder) throws {
        let usersGroup = routes.grouped("users")
        usersGroup.post(use: createUserHandler)
        usersGroup.get(use: getAllUsersHandler)
        usersGroup.get(":id", use: getUserByIdHandler)
        usersGroup.post("auth", use:authUserHandler)
    }
    
    //MARK: CRUD - post
    @Sendable
    func createUserHandler(_ req: Request ) async throws -> User.Public {
        
        let user = try req.content.decode(User.self)
        user.password = try Bcrypt.hash(user.password)
        try await user.save(on: req.db)
        return user.convertToPublic()
    }
    
    //MARK: CRUD - get all
    @Sendable
    func getAllUsersHandler(_ req: Request) async throws -> [User.Public] {
        let users = try await User.query(on: req.db).all()
        let publicUsers = users.map { user in
            user.convertToPublic()
        }
        return publicUsers
    }
    
    //MARK: CRUD - get
    @Sendable
    func getUserByIdHandler(_ req: Request) async throws -> User.Public {
        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return user.convertToPublic()
    }
    
    @Sendable
    func authUserHandler(_ req: Request) async throws -> User.Public {
        let userDTO = try req.content.decode(AuthUserDTO.self)
        guard let user = try await User
            .query(on: req.db)
            .filter("login", .equal, userDTO.login)
            .first() else {throw Abort(.notFound)}
        let isPassEqual = try Bcrypt.verify(userDTO.password, created: user.password)
        guard isPassEqual else {throw Abort(.unauthorized)}
        return user.convertToPublic()
        
    }
 
}


struct AuthUserDTO: Content {
    let login : String
    var password : String
}
