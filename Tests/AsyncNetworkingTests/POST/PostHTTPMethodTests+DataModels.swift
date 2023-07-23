//
//  PostHTTPMethodTests+DataModels.swift
//  AsyncNetworking
//
//  Created by Juan Diego Ocampo on 2023-07-22.
//

import Foundation

/// This extension defines custom data models used for testing the `POST` HTTP method in the `AsyncNetworkManager` class.
/// The models represent the structure of the data returned from the `REQRES.io` server for specific endpoints.
/// Each data model conforms to the `Codable` protocol, enabling easy encoding and decoding of JSON data.
///
///
/// - Note: These data models are specific to the test cases in the `PostHTTPMethodTests` class and are used to simulate responses from the server. They serve the purpose of validating the `AsyncNetworkManager`'s handling of data encoding and decoding for `POST` HTTP requests.

extension PostHTTPMethodTests {
    
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
        
        /// The ID of the user's profile.
        let id: String
        
        /// The date when the user's profile was created.
        let createdAt: Date
        
    }
    
    /// Data model representing a single user's credentials sent to the server on a success scenario.
    struct UserRegistrationSuccessBody: Codable {
        
        /// The email of the user's profile.
        let email: String
        
        /// The password of the user's profile.
        let password: String
        
    }
    
    /// Data model representing a single user's credentials received from the server on a success scenario.
    struct UserRegistrationSuccessResponse: Codable {
        
        /// The ID of the user's profile.
        let id: Int
        
        /// The token of the user's current session.
        let token: String
        
    }
    
    
    /// Data model representing a single user's credentials sent to the server on a failure scenario.
    struct UserRegistrationFailedBody: Codable {
        
        /// The email of the user's profile.
        let email: String
        
    }
    
    /// Data model representing a single user's credentials received from the server on a failure scenario.
    struct UserRegistrationFailedResponse: Codable {
        
        /// The reason for the failure.
        let error: String
        
    }
    
    /// Data model representing a single user's login credentials sent to the server on a success scenario.
    struct LoginSuccessBody: Codable {

        /// The email of the user's profile.
        let email: String
        
        /// The password of the user's profile.
        let password: String
        
    }
    
    
    /// Data model representing a single user's login credentials received from the server on a success scenario.
    struct LoginSuccessResponse: Codable {
        
        /// The token of the user's current session.
        let token: String
        
    }
    
    
    /// Data model representing a single user's login credentials sent to the server on a failure scenario.
    struct LoginFailedBody: Codable {
        
        /// The email of the user's profile.
        let email: String
        
    }
    
    /// Data model representing a single user's login credentials received from the server on a failure scenario.
    struct LoginFailedResponse: Codable {
        
        /// The reason for the failure.
        let error: String
        
    }

}
