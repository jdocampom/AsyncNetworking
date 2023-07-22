//
//  HTTPScheme.swift
//  AsyncNetworking
//
//  Created by Juan Diego Ocampo on 2023-07-22.
//

import Foundation

/// Represents the  HTTP schemes used in RESTful web services that are supported by the `AsyncNetworking` framework.
@objc public enum HTTPScheme: Int, CaseIterable {
    
    /// Represents the `http` scheme in URLs.
    case http
    
    /// Represents the `https` scheme in URLs.
    case https
    
    /// A `String` literal that matches the method name associated with the given `HTTPScheme` case.
    public var stringValue: String {
        switch self {
        case .http:
            return "http"
        case .https:
            return "https"
        }
        
    }
    
}
