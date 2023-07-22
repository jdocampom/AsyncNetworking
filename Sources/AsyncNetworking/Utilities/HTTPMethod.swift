//
//  File.swift
//  
//
//  Created by Juan Diego Ocampo on 2023-07-21.
//

import Foundation

@objc public enum HTTPMethod: Int {
    
    case get
    
    case delete
    
    case post
    
    case patch
    
    case put
    
    var stringValue: String {
        switch self {
        case .get:
            return "GET"
        case .delete:
            return "DELETE"
        case .post:
            return "POST"
        case .patch:
            return "PATCH"
        case .put:
            return "PUT"
        }
    }
    
}
