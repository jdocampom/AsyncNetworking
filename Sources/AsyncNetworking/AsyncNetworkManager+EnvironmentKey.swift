//
//  AsyncNetworkManager+EnvironmentKey.swift
//  AsyncNetworking
//
//  Created by Juan Diego Ocampo on 2023-07-22.
//

import SwiftUI

/// An extension of `AsyncNetworkManager`, conforming to the `EnvironmentKey` protocol.
/// This extension sets the default value for the `AsyncNetworkManager` instance when it is used as an environment key.

extension AsyncNetworkManager: EnvironmentKey {

    /// Returns an object of type `AsyncNetworkManager`, representing the default value of the `.asyncNetworkManager` environment key.
    ///
    /// When the `AsyncNetworkManager` instance is used as an environment key and there's no associated value in the environment,
    /// this default value is returned.
    public static var defaultValue: AsyncNetworkManager {
        return .init(environment: .testing)
    }
    
}
