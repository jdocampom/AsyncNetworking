//
//  EnvironmentValues+Ext.swift
//  AsyncNetworking
//
//  Created by Juan Diego Ocampo on 2023-07-22.
//

import SwiftUI

/// An extension on `EnvironmentValues`, which allows storing and accessing the `AsyncNetworkManager` instance using the key `.asyncNetworkManager`.

extension EnvironmentValues {
    
    /// An object of type `AsyncNetworkManager`, which provides an interface to access and modify the `AsyncNetworkManager` instance
    /// associated with the environment using the key `asyncNetworkManager`.
    ///
    /// When accessed, this property retrieves the value of `AsyncNetworkManager` from the `EnvironmentValues` dictionary.
    /// When set, it updates the `AsyncNetworkManager` instance in the `EnvironmentValues` dictionary with the provided new value.
    public var asyncNetworkManager: AsyncNetworkManager {
        get {
            self[AsyncNetworkManager.self]
        }
        set {
            self[AsyncNetworkManager.self] = newValue
        }
    }
    
}
