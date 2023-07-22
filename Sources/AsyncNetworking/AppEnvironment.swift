//
//  AppEnvironment.swift
//  AsyncNetworking
//
//  Created by Juan Diego Ocampo on 2023-07-22.
//

import Foundation

/// An object used to represent the environment in which the client app is running.
///
/// It contains information such as the name of the environment, the host URL, and the `URLSession` instance used to make network requests.
@objcMembers public final class AppEnvironment: NSObject {
    
    /// A `String` literal  that represents the name of the environment.
    ///
    /// This property is used to distinguish different environments, such as development, staging, and production.
    public private(set) var name: String
    
    /// A `String` literal that represents the base URL of the host for the environment.
    ///
    /// This property is used to make network requests to the correct server.
    public private(set) var host: String
    
    /// The `URLSession` instance that represents the HTTP scheme to be used when constructing or processing URLs.
    ///
    /// This property can be configured with custom settings such as caching, cookie storage, and timeout intervals.
    public private(set)var session: URLSession
    
    /// An `HTTPScheme` value that represents the base URL of the host for the environment.
    ///
    /// The default value for this property is set to `.https`. You can change the value of this property to use a different scheme based on your requirements.
    public var scheme: HTTPScheme = .https
    
    /// Creates a new `AppEnvironment` instance with the given parameters.
    /// - Parameters:
    ///   - name: A `String` literal  that represents the name of the environment.
    ///   - host: A `String` literal that represents the base URL of the host for the environment.
    ///   - session: The `URLSession` object that will be used to make network requests in the environment.
    public init(
        named name: String,
        usingHost host: String,
        andSession session: URLSession
    ) {
        self.name = name
        self.host = host
        self.session = session
    }
    
}
