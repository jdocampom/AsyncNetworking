//
//  HTTPMethod.swift
//  Networking
//
//  Created by Juan Diego Ocampo on 11.28.2024.
//

#if canImport(Foundation)

import Foundation

/// Represents the HTTP methods used in RESTful web services that are supported by the `AsyncNetworking` framework.
///
/// This enum provides cases for commonly used HTTP methods, along with a computed property (`stringValue`)
/// to retrieve the method name as a `String` literal. It conforms to `CaseIterable` for easy iteration
/// over all possible cases and is marked as `@frozen` to guarantee its memory layout remains consistent
/// across module versions.
///
/// #### Code Example:
/// ```swift
/// // Access a specific HTTP method
/// let method: HTTPMethod = .get
/// print("HTTP Method: \(method.stringValue)") // Prints: "HTTP Method: GET"
///
/// // Iterate through all supported HTTP methods
/// for method in HTTPMethod.allCases {
///     print("Supported method: \(method.stringValue)")
/// }
/// ```
///
@frozen public enum HTTPMethod: CaseIterable, CustomStringConvertible, Sendable {
    
    /// Represents the `GET` HTTP method.
    ///
    /// Typically used for retrieving data from a server without modifying the server state.
    ///
    case get
    
    /// Represents the `POST` HTTP method.
    ///
    /// Typically used for submitting data to a server, such as creating a new resource.
    ///
    case post
    
    /// Represents the `DELETE` HTTP method.
    ///
    /// Typically used for removing a resource from a server.
    ///
    case delete
    
    /// Represents the `PATCH` HTTP method.
    ///
    /// Typically used for partially updating an existing resource on a server.
    ///
    case patch
    
    /// Represents the `PUT` HTTP method.
    ///
    /// Typically used for replacing or creating a resource on a server.
    ///
    case put
    
    /// A `String` representation of the HTTP method.
    ///
    /// Returns the string equivalent of the method name, such as `"GET"` for `.get` or `"POST"` for `.post`.
    ///
    /// #### Code Example:
    /// ```swift
    /// let method: HTTPMethod = .put
    /// print("Method as string: \(method.description)") // Prints: "Method as string: PUT"
    /// ```
    ///
    public var description: String {
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

#endif
