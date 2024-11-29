//
//  GetHTTPMethodTests+DataModels.swift
//  Networking
//
//  Created by Juan Diego Ocampo on 11.28.2024.
//

import Foundation

/// This extension defines custom data models used for testing the `GET` HTTP method in the `NetworkManager` class.
/// The models represent the structure of the data returned from the `REQRES.io` server for specific endpoints.
/// Each data model conforms to the `Codable` protocol, enabling easy encoding and decoding of JSON data.
///
///
/// - Note: These data models are specific to the test cases in the `GetHTTPMethodTests` class and are used to simulate responses from the server. They serve the purpose of validating the `NetworkManager`'s handling of data decoding for `GET` HTTP requests.

extension GetHTTPMethodTests {
    
    /// Data model representing a single user entity received from the server.
    struct User: Codable {
        
        /// User data containing information such as ID, email, first name, last name, and avatar URL.
        let data: Data
        
        /// Support data containing the support URL and text.
        let support: Support
        
        /// Nested data model representing user-specific information.
        struct Data: Codable {
            
            let id: Int
            let email: String
            let firstName: String
            let lastName: String
            let avatar: URL
            
            private enum CodingKeys: String, CodingKey {
                case id
                case email
                case firstName = "first_name"
                case lastName = "last_name"
                case avatar
            }
            
        }
        
        /// Nested data model representing support information.
        struct Support: Codable {
            let url: URL
            let text: String
        }
        
    }
    
    /// Data model representing a list of users received from the server.
    struct UserList: Codable {
        
        /// The current page number.
        let page: Int
        
        /// The number of users per page.
        let perPage: Int
        
        /// The total count of users.
        let total: Int
        
        /// The total number of pages.
        let totalPages: Int
        
        /// An array containing user-specific data.
        let data: [Data]
        
        /// Support data containing the support URL and text.
        let support: Support
        
        private enum CodingKeys: String, CodingKey {
            case page
            case perPage = "per_page"
            case total
            case totalPages = "total_pages"
            case data
            case support
        }
        
        /// Nested data model representing user-specific information.
        struct Data: Codable {
            let id: Int
            let name: String
            let year: Int
            let color: String
            let pantoneValue: String
            
            private enum CodingKeys: String, CodingKey {
                case id
                case name
                case year
                case color
                case pantoneValue = "pantone_value"
            }
            
        }
        
        /// Nested data model representing support information.
        struct Support: Codable {
            let url: URL
            let text: String
        }
        
    }
    
    /// Data model structure representing a single resource retrieved from the server.
    struct Resource: Codable {
        
        /// The resource data.
        let data: Data
        
        /// The support information.
        let support: Support
        
        /// Nested data model representing resource-specific information.
        struct Data: Codable {
            
            let id: Int
            let name: String
            let year: Int
            let color: String
            let pantoneValue: String
            
            private enum CodingKeys: String, CodingKey {
                case id
                case name
                case year
                case color
                case pantoneValue = "pantone_value"
            }
            
        }
        
        /// Nested data model representing support information.
        struct Support: Codable {
            let url: URL
            let text: String
        }
    
    }
    
    
    /// Codable structure representing a list of resources retrieved from the server.
    ///
    /// This struct defines the data structure for a list of resources fetched from the server. It conforms to the `Codable` protocol, allowing it to be encoded and decoded to/from JSON. The `ResourceList` struct consists of two nested structs, `Data` and `Support`, representing the resource data and support information, respectively. The `CodingKeys` enum is used to map the JSON keys to the corresponding struct properties during decoding.
    struct ResourceList: Codable {
        
        /// The current page number.
        let page: Int
        
        /// The number of resources per page.
        let perPage: Int
        
        /// The total number of resources.
        let total: Int
        
        /// The total number of pages.
        let totalPages: Int
        
        /// The list of resource data.
        let data: [Data]
        
        /// The support information.
        let support: Support
        
        private enum CodingKeys: String, CodingKey {
            case page
            case perPage = "per_page"
            case total
            case totalPages = "total_pages"
            case data
            case support
        }
        
        /// Nested data model representing resource-specific information.
        struct Data: Codable {
            
            let id: Int
            let name: String
            let year: Int
            let color: String
            let pantoneValue: String
            
            private enum CodingKeys: String, CodingKey {
                case id
                case name
                case year
                case color
                case pantoneValue = "pantone_value"
            }
            
        }
        
        /// Nested data model representing support information.
        struct Support: Codable {
            let url: URL
            let text: String
        }
        
    }
    
}
