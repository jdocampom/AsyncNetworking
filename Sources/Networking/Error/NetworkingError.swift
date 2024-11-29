//
//  NetworkingError.swift
//  Networking
//
//  Created by Juan Diego Ocampo on 11.28.2024.
//

#if canImport(Foundation)

import Foundation

/// Represents various errors that can occur when making HTTP network requests using a `NetworkManager` object.
///
/// This enum provides a set of error cases that can be thrown when interacting with the network manager.
///
@frozen public enum NetworkingError: Error, LocalizedError {
    
    /// Indicates that the provided HTTP method is invalid for the current API request.
    ///
    /// This error typically occurs when the HTTP method is not supported by the API endpoint.
    ///
    case invalidHTTPMethod
    
    /// Indicates that the endpoint URL provided to the network manager is invalid.
    ///
    /// This error typically occurs when the URL is malformed or missing required components.
    ///
    case invalidURL
    
    /// Indicates that the API failed to return a valid response.
    ///
    /// This error typically occurs when the response is missing or cannot be parsed.
    ///
    case invalidResponse
    
    /// Indicates that the API returned an invalid response code.
    ///
    /// - Parameters:
    ///   - responseCode: The invalid response code received from the API.
    ///
    case invalidResponseCode(_ responseCode: Int)
    
    /// Indicates that an error occurred during the creation of a data task.
    ///
    /// - Parameters:
    ///   - error: The underlying error that occurred.
    ///
    case dataTaskError(_ error: Error)
    
    /// Indicates that the data received from the API is corrupt or unreadable.
    ///
    /// This error typically occurs when the data cannot be properly decoded.
    ///
    case corruptData
    
    /// Indicates that an error occurred while encoding data for the API request.
    ///
    /// - Parameters:
    ///   - error: The underlying encoding error.
    ///
    case encodingError(_ error: Error)
    
    /// Indicates that an error occurred while decoding data from the API response.
    ///
    /// - Parameters:
    ///   - error: The underlying decoding error.
    ///
    case decodingError(_ error: Error)
    
    // MARK: - LocalizedError Conformance
    
    /// A localized message describing the error.
    ///
    /// This property provides a simple, concise description of the error.
    ///
    public var errorDescription: String? {
        switch self {
        case .invalidHTTPMethod:
            return "The provided HTTP method is invalid for this request."
        case .invalidURL:
            return "The endpoint URL is invalid."
        case .invalidResponse:
            return "The API returned an invalid response."
        case .invalidResponseCode(let responseCode):
            return "The API returned an invalid response code: \(responseCode)."
        case .dataTaskError(let error):
            if let networkError = error as? NetworkingError {
                return "A data task error occurred: \(networkError.errorDescription ?? networkError.localizedDescription)"
            } else {
                return "A data task error occurred: \(error.localizedDescription)"
            }
        case .corruptData:
            return "The data received from the API is corrupt or unreadable."
        case .encodingError(let error):
            return "An error occurred while encoding the data: \(error.localizedDescription)."
        case .decodingError(let error):
            return "An error occurred while decoding the data: \(error.localizedDescription)."
        }
    }
    
    /// A localized message describing the reason for the error.
    ///
    /// This property provides a more detailed explanation of the error, if available.
    ///
    public var failureReason: String? {
        switch self {
        case .invalidHTTPMethod:
            return "The specified HTTP method is not supported for this request."
        case .invalidURL:
            return "The constructed URL is malformed or incomplete."
        case .invalidResponse:
            return "The API response could not be interpreted."
        case .invalidResponseCode:
            return "The API returned an unexpected response code."
        case .dataTaskError:
            return "A network error occurred during the request."
        case .corruptData:
            return "The received data is corrupt or does not match the expected format."
        case .encodingError:
            return "The data could not be properly encoded for transmission."
        case .decodingError:
            return "The received data could not be properly decoded into the expected format."
        }
    }
    
    /// A localized message suggesting how to recover from the error, if possible.
    ///
    /// This property provides guidance on how to recover from the error or avoid similar errors in the future.
    ///
    public var recoverySuggestion: String? {
        switch self {
        case .invalidHTTPMethod:
            return "Ensure the HTTP method is appropriate for the API endpoint."
        case .invalidURL:
            return "Verify the endpoint URL and ensure it is properly constructed."
        case .invalidResponse:
            return "Check the API documentation and ensure the endpoint is valid."
        case .invalidResponseCode:
            return "Check the API documentation for the expected response codes."
        case .dataTaskError:
            return "Ensure the network connection is stable and try again."
        case .corruptData:
            return "Verify the API response format and ensure data integrity."
        case .encodingError:
            return "Ensure the data being sent conforms to the expected format."
        case .decodingError:
            return "Check the response format and update the decoding logic if necessary."
        }
    }
    
}

#endif
