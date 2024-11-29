//
//  HTTPScheme.swift
//  Networking
//
//  Created by Juan Diego Ocampo on 11.28.2024.
//

#if canImport(Foundation)

import Foundation

/// Represents the HTTP schemes used in RESTful web services that are supported by the framework.
///
/// This enum defines the supported URL schemes (`http` and `https`) commonly used in web requests.
/// It includes a computed property (`stringValue`) to retrieve the scheme as a `String` literal.
///
/// The enum conforms to `CaseIterable` for iterating through all cases and is marked as `@frozen`
/// to ensure its memory layout remains consistent across module versions.
///
/// #### Code Example:
/// ```swift
/// // Access a specific HTTP scheme
/// let scheme: HTTPScheme = .https
/// print("HTTP Scheme: \(scheme.stringValue)") // Prints: "HTTP Scheme: https"
///
/// // Iterate through all supported HTTP schemes
/// for scheme in HTTPScheme.allCases {
///     print("Supported scheme: \(scheme.stringValue)")
/// }
/// ```
///
@frozen public enum HTTPScheme: CaseIterable, CustomStringConvertible, Sendable {
    
    /// Represents the `http` scheme in URLs.
    ///
    /// Typically used for unencrypted HTTP requests.
    ///
    case http
    
    /// Represents the `https` scheme in URLs.
    ///
    /// Typically used for encrypted HTTP requests, providing secure communication over the web.
    ///
    case https
    
    /// A `String` representation of the HTTP scheme.
    ///
    /// Returns the string equivalent of the scheme, such as `"http"` for `.http` or `"https"` for `.https`.
    ///
    /// #### Code Example:
    /// ```swift
    /// let scheme: HTTPScheme = .http
    /// print("Scheme as string: \(scheme.description)") // Prints: "Scheme as string: http"
    /// ```
    ///
    public var description: String {
        switch self {
        case .http:
            return "http"
        case .https:
            return "https"
        }
    }
}

#endif
