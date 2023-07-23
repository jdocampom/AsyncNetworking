//
//  AsyncNetworkManager.swift
//  AsyncNetworking
//
//  Created by Juan Diego Ocampo on 2023-07-22.
//

import Foundation

/// An object that provides a centralised point for managing and coordinating asynchronous network requests within your application.serves as a manager for handling
/// asynchronous network operations in your application.
///
/// This class is `final`, meaning it cannot be subclassed, ensuring a concrete implementation that cannot be further extended or modified. It also conforms to the
/// `ObservableObject` protocol, making it compatible with SwiftUI's reactive programming paradigm, allowing SwiftUI views to observe changes in the state
/// of the network manager and automatically update when the state changes.
@objcMembers public final class AsyncNetworkManager: NSObject, ObservableObject {
    
    /// An `AppEnvironment` instance representing the current environment/configuration of the application.
    ///
    /// This property holds an `AppEnvironment` instance that encapsulates various settings and configurations for the behavior of the `AsyncNetworkManager`.
    /// The application environment includes information such as the base URL, authentication credentials, caching policies, and other configuration details
    /// required to manage network requests effectively based on the application's deployment environment.
    public private(set) var environment: AppEnvironment
    
    /// A reference to an object that conforms to the `URLSessionTaskDelegate` representing a delegate for `URLSession` tasks.
    ///
    /// This property holds a weak reference to an object conforming to the `URLSessionTaskDelegate` protocol. It allows you to set a delegate for URLSession
    /// tasks managed by the `AsyncNetworkManager`. The delegate can receive various events and notifications related to the URLSession tasks, such as task
    /// completion, progress updates, and authentication challenges.
    ///
    /// The property is marked as weak to prevent strong reference cycles. The delegate object will be automatically deallocated when its strong references
    /// are released, ensuring proper memory management.
    public private(set) weak var delegate: URLSessionTaskDelegate? = nil
    
    /// Creates an `AsyncNetworkManager` instance with the specified application environment and optional URLSession task delegate.
    ///
    /// - Parameters:
    ///   - environment: An `AppEnvironment` instance representing the current environment/configuration of the application.
    ///   - delegate: A reference to an object that conforms to the `URLSessionTaskDelegate` representing a delegate for `URLSession` tasks.
    ///
    /// This initializer allows you to create an `AsyncNetworkManager` instance with a specific application environment and an optional delegate for `URLSession` tasks.
    /// The application environment encapsulates various settings and configurations for the network manager's behavior, such as the base URL, authentication credentials,
    /// or caching policies.
    ///
    /// The delegate, if provided, allows you to set an object that conforms to the `URLSessionTaskDelegate` protocol. The delegate can receive various events and
    /// notifications related to URLSession tasks managed by the `AsyncNetworkManager`. For example, it can handle task completion, progress updates, and authentication challenges.
    ///
    /// Usage:
    /// ```swift
    /// let environment = AppEnvironment(named: "Test", host: "api.example.com", session: .shared)
    /// let delegate = MyURLSessionTaskDelegate()
    ///
    /// // Implementing a URLSessionTaskDelegate observer.
    /// let networkManager = AsyncNetworkManager(environment: environment, delegate: delegate)
    ///
    /// // Ommiting a URLSessionTaskDelegate observer.
    /// let networkManager = AsyncNetworkManager(environment: environment, delegate: nil)
    /// ```
    public init(
        environment: AppEnvironment,
        delegate: URLSessionTaskDelegate? = nil
    ) {
        self.environment = environment
        self.delegate = delegate
    }
    
}
