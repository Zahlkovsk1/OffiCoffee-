import Fluent
import Vapor

func routes(_ app: Application) throws {
 
    try app.register(collection: ProductController())
    try app.register(collection: UserController())
    app.routes.defaultMaxBodySize = "5Mb"
    
}
