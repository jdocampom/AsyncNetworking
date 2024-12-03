//
//  Endpoint.swift
//  Networking
//
//  Created by Juan Diego Ocampo on 11.28.2024.
//

#if canImport(Foundation)

import Foundation

/// A generic structure representing an API endpoint.
///
/// The `Endpoint` structure provides a highly configurable way to define API
/// endpoints, including HTTP methods, headers, query parameters, and request/response
/// data encoding and decoding strategies. This enables flexible handling of diverse
/// API requests and responses.
///
/// #### Type Parameter:
///   - `T`: The type of the response data, conforming to `Decodable`.
///
/// #### Key Features:
/// - Configure headers, query items, and HTTP methods.
/// - Support for custom JSON encoding and decoding strategies.
/// - Ability to handle nested response structures using a key path.
///
/// #### Code Example:
/// ```swift
/// // Define a model conforming to Decodable
/// struct User: Decodable {
///     let id: Int
///     let name: String
/// }
///
/// // Create an endpoint to fetch user data
/// let userEndpoint = Endpoint<User>(
///     type: User.self,
///     path: "/users/1",
///     httpMethod: .get,
///     headers: ["Authorization": "Bearer token"]
/// )
///
/// print(userEndpoint.path)           // "/users/1"
/// print(userEndpoint.httpMethod)     // GET
/// print(userEndpoint.headerFields)   // ["Authorization": "Bearer token"]
/// ```
@frozen
public struct Endpoint<T: Decodable>: Sendable {
    
    // MARK: - Properties
    
    /// The `JSONDecoder` instance used for decoding response data.
    ///
    /// Use this to specify the type of data to be decoded from the response.
    ///
    public let decoder: JSONDecoder
    
    /// The type of the expected decoded response data.
    ///
    /// Use this to specify the type of data to be decoded from the response.
    ///
    public let decodeType: T.Type
    
    /// The API path for the endpoint (relative to the base URL).
    ///
    /// Use this to specify the resource path for the request.
    ///
    public let path: String
    
    /// The HTTP method used for the request.
    ///
    /// Use this to specify the type of request (e.g., GET, POST).
    ///
    public let httpMethod: HTTPMethod
    
    /// The HTTP headers to include in the request.
    ///
    /// Use this to pass additional information to the server.
    ///
    public let headerFields: [String: String]
    
    /// The query parameters to include in the request URL.
    ///
    /// Use this to pass additional information to the server.
    ///
    public let queryItems: [String: String]?
    
    /// The HTTP body data to include in the request, if applicable.
    ///
    /// This should conform to `Encodable` for proper encoding.
    ///
    public let httpData: Data?
    
    /// The timeout interval for the request, in seconds.
    ///
    /// The default value is `60.0` seconds.
    ///
    public var timeoutInterval: TimeInterval = 60.0
    
    /// The key path used to extract nested response data.
    ///
    /// Use this if the desired data is located within a specific key of the response JSON.
    ///
    public var keyPath: String? = nil
    
    // MARK: - Decoding Strategies
    
    /// The key decoding strategy for the `JSONDecoder`.
    ///
    /// The default value is `.useDefaultKeys`.
    ///
    private var _keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    
    /// The key decoding strategy for the `JSONDecoder`.
    ///
    /// The default value is `.useDefaultKeys`.
    ///
    public var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy {
        get {
            _keyDecodingStrategy
        }
        set {
            _keyDecodingStrategy = newValue
            decoder.keyDecodingStrategy = _keyDecodingStrategy
        }
    }
    
    /// The date decoding strategy for the `JSONDecoder`.
    ///
    /// The default value is `.deferredToDate`.
    ///
    private var _dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate
    
    /// The date decoding strategy for the `JSONDecoder`.
    ///
    /// The default value is `.deferredToDate`.
    ///
    public var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        get {
            _dateDecodingStrategy
        }
        set {
            _dateDecodingStrategy = newValue
            decoder.dateDecodingStrategy = _dateDecodingStrategy
        }
    }
    
    /// The data decoding strategy for the `JSONDecoder`.
    ///
    /// The default value is `.base64`.
    ///
    private var _dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .base64
    
    /// The data decoding strategy for the `JSONDecoder`.
    ///
    /// The default value is `.base64`.
    ///
    public var dataDecodingStrategy: JSONDecoder.DataDecodingStrategy {
        get {
            _dataDecodingStrategy
        }
        set {
            _dataDecodingStrategy = newValue
            decoder.dataDecodingStrategy = _dataDecodingStrategy
        }
    }
    
    // MARK: - Initializers
    
    /// Initializes a new `Endpoint` for making requests.
    ///
    /// Use this initializer when the request does not require a body payload.
    ///
    /// #### Code Example:
    /// ```swift
    /// let endpoint = Endpoint<User>(
    ///     type: User.self,
    ///     path: "/users",
    ///     httpMethod: .get,
    ///     headers: ["Authorization": "Bearer token"]
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - type: The type of the decoded response data.
    ///   - path: The API path for the endpoint.
    ///   - httpMethod: The HTTP method to use for the request (e.g., GET, POST).
    ///   - headers: The HTTP headers to include in the request.
    ///   - queryItems: The query parameters for the request URL, if any. Defaults to `nil`.
    ///
    public init(
        type: T.Type,
        path: String,
        httpMethod: HTTPMethod,
        headers: [String: String],
        queryItems: [String: String]? = nil
    ) {
        self.decodeType = type
        self.path = path
        self.httpMethod = httpMethod
        self.headerFields = headers
        self.queryItems = queryItems
        self.httpData = nil
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = _keyDecodingStrategy
        self.decoder.dateDecodingStrategy = _dateDecodingStrategy
        self.decoder.dataDecodingStrategy = _dataDecodingStrategy
    }
    
    /// Initializes a new `Endpoint` with request body data.
    ///
    /// Use this initializer when the request requires a body payload.
    ///
    /// - Parameters:
    ///   - decodeType: The type of the decoded response data.
    ///   - path: The API path for the endpoint.
    ///   - httpMethod: The HTTP method to use for the request.
    ///   - headers: The HTTP headers to include in the request.
    ///   - queryItems: The query parameters for the request URL, if any. Defaults to `nil`.
    ///   - httpData: The HTTP body data to include in the request.
    ///
    /// - Note: The `httpData` parameter should conform to `Encodable`.
    ///
    public init(
        decodeType: T.Type,
        path: String,
        httpMethod: HTTPMethod,
        headers: [String: String],
        queryItems: [String: String]? = nil,
        httpData: Data
    ) {
        self.decodeType = decodeType
        self.path = path
        self.httpMethod = httpMethod
        self.headerFields = headers
        self.queryItems = queryItems
        self.httpData = httpData
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = _keyDecodingStrategy
        self.decoder.dateDecodingStrategy = _dateDecodingStrategy
        self.decoder.dataDecodingStrategy = _dataDecodingStrategy
    }
    
}

// MARK: - Static Properties and Methods

extension Endpoint {
    
    /// Creates a `URL` object for a given `Endpoint` using a specified `Environment`.
    ///
    /// This function constructs a URL by combining the base URL from the `Environment`
    /// and the relative path, query parameters, and other components from the `Endpoint`.
    ///
    /// #### Code Example:
    /// ```swift
    /// let environment = Environment(
    ///     named: "Production",
    ///     host: "api.example.com",
    ///     session: URLSession.shared
    /// )
    /// let endpoint = Endpoint<User>(
    ///     type: User.self,
    ///     path: "/users",
    ///     httpMethod: .get,
    ///     headers: ["Authorization": "Bearer token"],
    ///     queryItems: ["page": "1"]
    /// )
    ///
    /// do {
    ///     let url = try Endpoint.url(for: endpoint, using: environment)
    ///     print(url) // Outputs: https://api.example.com/users?page=1
    /// } catch {
    ///     print("Failed to create URL: \(error)")
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - endpoint: The `Endpoint` containing the path and query parameters.
    ///   - environment: The `Environment` providing the base URL configuration.
    ///
    /// - Returns: A `URL` object representing the full URL for the request.
    ///
    /// - Throws: `NetworkingError.invalidURL` if the URL cannot be constructed.
    ///
    static func url(
        for endpoint: Endpoint,
        using environment: Environment
    ) throws -> URL {
        // Create array of `URLQueryItem` objects from the `queryItems`
        // dictionary of the `endpoint` parameter.
        var queryItems: [URLQueryItem]? = nil
        if let parameters = endpoint.queryItems {
            queryItems = parameters.map { key, value in
                return URLQueryItem(name: key, value: value)
            }
        }
        // Create `URLComponents` object.
        var components = URLComponents()
        // Configure `URLComponents` object.
        components.scheme = environment.scheme.description
        components.host = environment.host
        components.path = endpoint.path
        components.queryItems = queryItems
        // Check that a valid URL can be extracted from the `URLComponents` object.
        guard let url = components.url else {
            // If not, throw an error.
            throw NetworkingError.invalidURL
        }
        // Return the constructed `URL` object.
        return url
    }
    
    
    /// Creates a `URLRequest` object for a given `Endpoint` and `URL`.
    ///
    /// This function initializes a `URLRequest` with the provided URL and configures
    /// it using the HTTP method, headers, and timeout from the `Endpoint`.
    ///
    /// #### Code Example:
    /// ```swift
    /// let environment = Environment(
    ///     named: "Production",
    ///     host: "api.example.com",
    ///     session: URLSession.shared
    /// )
    /// let endpoint = Endpoint<User>(
    ///     type: User.self,
    ///     path: "/users",
    ///     httpMethod: .get,
    ///     headers: ["Authorization": "Bearer token"]
    /// )
    ///
    /// do {
    ///     let url = try Endpoint.url(for: endpoint, using: environment)
    ///     let request = Endpoint.request(forEndpoint: endpoint, url: url)
    ///     print(request.httpMethod) // Outputs: GET
    ///     print(request.allHTTPHeaderFields) // Outputs: ["Authorization": "Bearer token"]
    /// } catch {
    ///     print("Failed to create URLRequest: \(error)")
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - endpoint: The `Endpoint` containing the request configuration.
    ///   - url: The `URL` for the request, typically generated using `url(for:using:)`.
    ///
    /// - Returns: A `URLRequest` object configured for the endpoint.
    ///
    static func request(
        forEndpoint endpoint: Endpoint,
        url: URL
    ) -> URLRequest {
        // Create `URLRequest` object.
        var request = URLRequest(url: url)
        // Configure `URLRequest` object.
        request.httpMethod = endpoint.httpMethod.description
        request.allHTTPHeaderFields = endpoint.headerFields
        request.timeoutInterval = endpoint.timeoutInterval
        request.allowsCellularAccess = true
        request.allowsExpensiveNetworkAccess = true
        // If the request has body data, add it to the `URLRequest` object.
        if let data = endpoint.httpData {
            request.httpBody = data
        }
        // Return the configured `URLRequest` object.
        return request
    }
    
}

#endif
