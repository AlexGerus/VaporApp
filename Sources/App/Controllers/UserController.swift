//
//  UserController.swift
//  
//
//  Created by Alexander Gerus on 26.08.2023.
//

import Foundation
import Vapor

struct Address : Content {
    let street: String
    let state: String
    let zip: String
}

struct User : Content {
    let name: String
    let age: Int
    let address: Address
}

//enum CustomErrorMessage {
//    case userNotLoggedIn
//    case invalidEmail(String)
//}
//
//extension CustomUserError: AbortError {
//    var reason: String {
//        switch self {
//        case .userNotLoggedIn:
//            return "User is not logged in"
//        case .invalidEmail(let email):
//            return "Email address is not valid: \(email)"
//        }
//    }
//
//    var status: HTTPStatus {
//            switch self {
//            case .userNotLoggedIn:
//                return .unauthorized
//            case .invalidEmail:
//                return .badRequest
//    }
//}

//struct CustomUserError: DebuggableError {
//    enum Value {
//        case userNotLoggedIn
//        case invalidEmail(String)
//    }
//    var identifier: String {
//        switch self.value {
//        case .userNotLoggedIn:
//            return "userNotLoggedIn"
//        case .invalidEmail:
//            return "invalidEmail"
//        }
//
//        var reason: String {
//            switch self.value {
//            case .userNotLoggedIn:
//                return "User not logged in."
//            case .invalidEmail(let email):
//                return "Email address not valid: \(email)."
//            }
//        }
//        var value: Value
//        var source: ErrorSource?
//
//        init(
//            _ value: Value,
//            file: String = #file,
//            function: String = #function,
//            line: UInt = #line,
//            column: UInt = #column
//        ){
//            self.value = value self.source = .init(
//                file: file,
//                function: function,
//                line: line,
//                column: column
//            )
//        } }
//
//}

struct CustomUserError: DebuggableError {
    var identifier: String
    var reason: String
    var stackTrace: StackTrace?
    init(
        identifier: String,
        reason: String,
        stackTrace: StackTrace? = .capture()
){
    self.identifier = identifier
    self.reason = reason
    self.stackTrace = stackTrace
} }

struct UserController : RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")

        users.get(use: getAllUsers)
        
        users.post(use: createUser)

        users.group(":userId") { user in
            user.get(use: show)
        }
    }
    
//    func getAllUsers(request: Request) throws -> String {
//        return "All users"
//    }
//    func getAllUsers(request: Request) throws -> Response {
//        let users = [["name": "User1", "age": 32], ["name": "User2", "age": 12]]
//
//        let data = try JSONSerialization.data(withJSONObject: users, options: .prettyPrinted)
//        return Response(status: .ok, body: Response.Body(data: data))
//    }
    func getAllUsers(request: Request) throws -> [User] {
        let address = Address(street: "Road 8 Rohini sec 8", state: "Delhi", zip: "110085")
        let users = [User(name: "User1", age: 32, address: address), User(name: "User2", age: 12, address: address)]
        
        return users
    }
    
    func show(request: Request) throws -> String {
        guard let userId = request.parameters.get("userId") as String? else {
            throw Abort(.badRequest)
        }
        
        return "Show user for user id = \(userId)"
    }
    
    func createUser(request: Request) throws -> HTTPStatus {
        let user = try request.content.decode(User.self)
        print(user)
        
        return .created
    }
}
