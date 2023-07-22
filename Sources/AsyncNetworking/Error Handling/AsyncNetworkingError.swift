//
//  AsyncNetworkingError.swift
//  AsyncNetworking
//
//  Created by Juan Diego Ocampo on 2023-07-22.
//

import Foundation

/// Represents different types of errors that can occur when using a `AsyncNetworkManager` object to make HTTP network requests.
public enum AsyncNetworkingError: Error, LocalizedError {
    
    /// Indicates that the endpoint URL provided to the network manager is invalid.
    case invalidURL
    
    /// Indicates that the API failed to issue a valid response.
    case invalidResponse
    
    /// Indicates that the API failed to issue a valid error code.
    case invalidErrorCode(errorCode: String)
    
    /// Indicates that the API failed to issue a valid response.
    case invalidResponseCode(errorCode: String)
    
    /// Indicates that the API failed to issue a valid response.
    case invalidStatusCode(statusCode: String, message: String)
    
    /// Indicates that the API failed to issue a valid response.
    case invalidResponseStatus
    
    ///  Indicates that an error occurred during the creation of a data task. The error is passed as an argument to this case.
    case dataTaskError(error: Error)
    
    /// Indicates that the data received from the API appears to be corrupt.
    case corruptData
    
    /// Indicates that an error occurred during the decoding of data received from the API. The error is passed as an argument to this case.
    case decodingError(error: Error)
    
    /// A `String` value that provides a localized description of the error.
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The endpoint URL is invalid."
        case .invalidResponseStatus:
            return "The API failed to issue a valid response."
        case .invalidErrorCode(let errorCode):
            return "Invalid error code: \(errorCode)."
        case .invalidResponseCode(let responseCode):
            return "Invalid response code: \(responseCode)."
        case .invalidStatusCode(let statusCode, let message):
            return "Invalid status code: \(statusCode) - \(message)."
        case .dataTaskError(let error):
            return "Data task error: \(error.localizedDescription)."
        case .corruptData:
            return "The data provided appears to be corrupt."
        case .invalidResponse:
            return "Invalid response."
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)."
        }
    }
    
    /// An optional `String` value that provides a localized message describing the reason for the failure.
    public var failureReason: String? {
        return nil
    }
    
    /// An optional `String` value that provides a localized message describing how one may recover from the failure.
    public var recoverySuggestion: String? {
        return nil
    }
    
}
