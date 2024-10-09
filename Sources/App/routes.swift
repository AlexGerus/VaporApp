import Vapor


func routes(_ app: Application) throws {
    struct Movies: Content {
        let name: String
        let releaseYear: String
    }

    try app.register(collection: UserController())

    let logger = Logger(label: "dev.logger.myAppLogs")
    let restaurants = app.grouped("restaurants")

//    app.get { req async in
//        "It works!"
//    }
    
//    app.get { req -> EventLoopFuture<View> in
//        return req.view.render("index", Movies(name: "Harry Potter and the Philosopher's Stone", releaseYear: "2001"))
//    }
    
    app.get("hello") { req -> EventLoopFuture<View> in
        return req.view.render("index", ["name": "Leaf"])
    }
    
//    app.get("hello") { req async -> String in
//        app.logger.info("App hello")
//        req.logger.info("Req Hello")
//        logger.info("Custom Hello")
//        return "Hello, world!"
//    }
    
    app.get("restaurants", ":location", "speciality", ":region") { req -> String in
        guard let location = req.parameters.get("location"), let region = req.parameters.get("region") else {
            throw Abort(.badRequest)
        }
        return "restaurants in \(location) with speciality \(region)"
    }
    
    app.get("routeany", "*", "endpoint") { req -> String in
        return "This is anything route"
    }
    
    app.get("routeany", "**") { req -> String in
        return "This is Catch All route"
    }
    
    app.get("search") { req -> String in
        guard let keyword = req.query["keyword"] as String?,
                let page = req.query["page"] as String? else {
            throw Abort(.badRequest)
        }
        return "Search for keyword \(keyword) on Page \(page)"
    }
    
    restaurants.get() { req -> String in
        return "restaurants base route"
    }
    
    restaurants.get("starRating", ":stars") { req -> String in
        guard let stars = req.parameters.get("stars") else {
            throw Abort(.badRequest)
        }
        return "restaurants/starRating/\(stars)"
    }
}
