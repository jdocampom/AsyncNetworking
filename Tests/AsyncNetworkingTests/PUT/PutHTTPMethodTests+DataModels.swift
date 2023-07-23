//
//  PutHTTPMethodTests+DataModels.swift
//  AsyncNetworking
//
//  Created by Juan Diego Ocampo on 2023-07-22.
//

import Foundation

/// This extension defines custom data models used for testing the `PUT` HTTP method in the `AsyncNetworkManager` class.
/// The models represent the structure of the data returned from the `REQRES.io` server for specific endpoints.
/// Each data model conforms to the `Codable` protocol, enabling easy encoding and decoding of JSON data.
///
///
/// - Note: These data models are specific to the test cases in the `PutHTTPMethodTests` class and are used to simulate responses from the server. They serve the purpose of validating the `AsyncNetworkManager`'s handling of data encoding and decoding for `PUT` HTTP requests.

extension PutHTTPMethodTests {
    
    /// Data model representing a single user profile sent to the server.
    struct UserProfileBody: Codable {
        
        /// The name of the user.
        let name: String
        
        /// The job title of the user.
        let job: String
        
    }
    
    /// Data model representing a single user profile received from the server.
    struct UserProfileResponse: Codable {
        
        /// The name of the user.
        let name: String
        
        /// The job title of the user.
        let job: String
        
        /// The date when the user's profile was updated.
        let updatedAt: Date
        
    }
    
}
