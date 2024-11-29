//
//  NetworkManager.swift
//  Networking
//
//  Created by Juan Diego Ocampo on 11.28.2024.
//

#if canImport(Foundation)

import Foundation

/// A structure responsible for managing network-related tasks, such as configuring
/// the environment and handling URL session task delegation.
///
/// `NetworkManager` is a frozen struct, ensuring its memory layout is fixed across
/// all future versions of the module.
///
/// ### Usage Example:
/// ```swift
/// // Define an application environment
/// let appEnvironment = Environment(baseURL: "https://api.example.com")
///
/// // Initialize the network manager with an environment and an optional delegate
/// let networkManager = NetworkManager(environment: appEnvironment)
///
/// // Use `networkManager` for performing network-related tasks
/// print("Environment base URL: \(networkManager.environment.baseURL)")
/// ```
///
@frozen public struct NetworkManager: Sendable {
    
    /// The application environment used for configuring network requests.
    ///
    /// This property defines the environment settings such as base URLs,
    /// API keys, or other configuration details required for networking.
    ///
    /// ### Example:
    /// ```swift
    /// let environment = Environment(baseURL: "https://api.example.com")
    /// let networkManager = NetworkManager(environment: environment)
    /// print("Base URL: \(networkManager.environment.baseURL)")
    /// ```
    ///
    public let environment: Environment
    
    /// A weak reference to the delegate for handling URL session task events.
    ///
    /// This delegate can be used to monitor task progress or handle authentication
    /// challenges for the URL session tasks initiated by this network manager.
    /// - Note: This property is optional and defaults to `nil`.
    ///
    /// ### Example:
    /// ```swift
    /// class CustomDelegate: NSObject, URLSessionTaskDelegate {
    ///     // Implement delegate methods here
    /// }
    ///
    /// let delegate = CustomDelegate()
    /// let networkManager = NetworkManager(environment: environment, delegate: delegate)
    /// ```
    ///
    public weak var delegate: URLSessionTaskDelegate? = nil
    
    /// Initializes a new instance of the `NetworkManager`.
    ///
    /// - Parameters:
    ///   - environment: The application environment used for configuring the network requests.
    ///   - delegate: An optional delegate for handling URL session task events.
    ///     Defaults to `nil`.
    /// - Returns: A fully initialized instance of `NetworkManager`.
    ///
    /// ### Example:
    /// ```swift
    /// let appEnvironment = Environment(baseURL: "https://api.example.com")
    /// let networkManager = NetworkManager(environment: appEnvironment)
    /// ```
    ///
    public init(
        environment: Environment,
        delegate: URLSessionTaskDelegate? = nil
    ) {
        self.environment = environment
        self.delegate = delegate
    }
}

#endif
