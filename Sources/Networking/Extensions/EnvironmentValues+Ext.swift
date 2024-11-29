//
//  EnvironmentValues+Ext.swift
//  Networking
//
//  Created by Juan Diego Ocampo on 11.28.2024.
//

#if canImport(SwiftUI)

import SwiftUI

extension EnvironmentValues {

    /// A computed property for accessing and setting the `NetworkManager` in the environment.
    ///
    /// This property provides a convenient way to retrieve or update the `NetworkManager` instance
    /// associated with a specific environment key. It leverages the `NetworkManager`'s conformance
    /// to `EnvironmentKey` to manage the default value.
    ///
    /// #### Code Example:
    /// ```swift
    /// // Access the current `NetworkManager`
    /// let networkManager = environment.networkManager
    /// print("Current environment: \(networkManager.environment)")
    ///
    /// // Update the `NetworkManager` to use a new environment
    /// environment.networkManager = NetworkManager(environment: .production)
    ///
    /// // Use the updated network manager
    /// let endpoint = Endpoint<User>(urlPath: "/users", httpMethod: .get)
    /// let user: User = try await environment.networkManager.fetchData(forEndpoint: endpoint)
    /// print("User data: \(user)")
    /// ```
    @MainActor public var networkManager: NetworkManager {
        get { self[NetworkManager.self] }
        set { self[NetworkManager.self] = newValue }
    }
    
}

#endif
