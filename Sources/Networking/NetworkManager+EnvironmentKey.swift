//
//  NetworkManager+EnvironmentKey.swift
//  Networking
//
//  Created by Juan Diego Ocampo on 11.28.2024.
//

#if canImport(SwiftUI)

import SwiftUI

extension NetworkManager: EnvironmentKey {

    /// The default value for the `NetworkManager` when used as an environment key.
    ///
    /// This default value is initialized with a `.testing` environment, which can be useful
    /// for providing mock data or simulating network conditions during development or testing.
    ///
    /// #### Code Example:
    /// ```swift
    /// // Access the default `NetworkManager` value from an environment container
    /// let networkManager = Environment(\.networkManager).wrappedValue
    /// print("Default environment: \(networkManager.environment)")
    ///
    /// // Use the `NetworkManager` for a specific task
    /// let endpoint = Endpoint<User>(urlPath: "/users", httpMethod: .get)
    /// let user: User = try await networkManager.fetchData(for: endpoint)
    /// ```
    ///
    /// - Returns: A `NetworkManager` instance configured with the `.testing` environment.
    ///
    @MainActor public static var defaultValue: NetworkManager {
        .init(environment: .testing)
    }
    
}

#endif
