//
//  HTTPMethod.swift
//  AsyncNetworking
//
//  Created by Juan Diego Ocampo on 2023-07-22.
//

import Foundation

/// Represents the  HTTP methods used in RESTful web services that are supported by the `AsyncNetworking` framework.
@objc public enum HTTPMethod: Int, CaseIterable {
    
    /// Represents the `GET` HTTP method.
    case get
    
    /// Represents the `POST` HTTP method.
    case post
    
    /// Represents the `DELETE` HTTP method.
    case delete
    
    /// Represents the `PATCH` HTTP method.
    case patch
    
    /// Represents the `PUT` HTTP method.
    case put
    
    /// A `String` literal that matches the method name associated with the given `HTTPMethod` case.
    public var stringValue: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        case .patch:
            return "PATCH"
        case .put:
            return "PUT"
        }
        
    }
    
}
