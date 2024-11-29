//
//  Environment.swift
//  Networking
//
//  Created by Juan Diego Ocampo on 11.28.2024.
//

#if canImport(Foundation)

import Foundation

/// A structure representing a network environment configuration.
///
/// The `Environment` struct defines the properties and methods for managing
/// network configurations such as the base host URL, the associated URL session,
/// and the URL scheme. It is particularly useful for managing different environments
/// (e.g., development, testing, production) in a networking layer of an application.
///
/// ### Example Usage
/// ```swift
/// // Create a custom environment
/// let productionEnvironment = Environment(
///     named: "Production",
///     usingHost: "api.example.com",
///     andSession: URLSession(configuration: .default)
/// )
///
/// print(productionEnvironment.name) // "Production"
/// print(productionEnvironment.host) // "api.example.com"
///
/// ```
///
@frozen public struct Environment: Sendable {
    
    /// The name of the environment.
    ///
    /// This is a descriptive name for the environment, typically used for
    /// identification purposes (e.g., "Development", "Production").
    public let name: String
    
    /// The base host URL for the environment.
    ///
    /// The host represents the main endpoint for API requests
    /// (e.g., "api.example.com").
    public let host: String
    
    /// The `URLSession` instance used for network requests in this environment.
    ///
    /// Each environment can have a unique session configuration (e.g., ephemeral,
    /// default) to suit its specific requirements.
    public let session: URLSession
    
    /// The URL scheme (e.g., `http` or `https`) used for constructing API requests.
    ///
    /// Defaults to `.https`.
    public var scheme: HTTPScheme = .https
    
    /// Initializes a new `Environment` instance with the given name, host, and session.
    ///
    /// - Parameters:
    ///   - name: A descriptive name for the environment.
    ///   - host: The base host URL for the environment.
    ///   - session: The `URLSession` instance to be used for network requests.
    public init(
        named name: String,
        host: String,
        session: URLSession
    ) {
        self.name = name
        self.host = host
        self.session = session
    }
}

// MARK: - Static Properties and Methods

public extension Environment {
    
    /// A predefined static environment configuration for testing purposes.
    ///
    /// - **Name**: "ReqRes".
    /// - **Host**: "reqres.in".
    /// - **Session**: Configured as follows:
    ///   - `ephemeral` session type: Does not persist cache or cookies.
    ///   - Cache policy: `reloadIgnoringLocalAndRemoteCacheData` (always fetches fresh data).
    ///
    /// Use this environment for making test network requests to the `reqres.in` API or similar services.
    ///
    static let testing = Environment(
        named: "ReqRes",
        host: "reqres.in",
        session: {
            let configuration = URLSessionConfiguration.ephemeral
            configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            return URLSession(configuration: configuration)
        }()
    )
    
}

#endif
