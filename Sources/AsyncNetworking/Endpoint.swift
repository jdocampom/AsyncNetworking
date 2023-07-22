//
//  Endpoint.swift
//  AsyncNetworkKit
//
//  Created by Juan Diego Ocampo on 2023-07-22.
//

import Foundation

/// An object that  represents an API endpoint with customizable configurations for making network requests and handling responses. It contains information such as
/// the HTTP method, path, headers, and encoding strategies for encoding and decoding the response.
///
/// The `Endpoint` class is designed to encapsulate essential information about an API endpoint, including the request configurations and response handling.
/// This object is generic over a parameter named `T`, which represents the Swift type used for decoding the response from the network request. It must conform to
/// the `Decodable` protocol, enabling the received data to be decoded into a specific Swift model.
@objcMembers public final class Endpoint<T: Decodable>: NSObject {
    
    /// An instance of `JSONEncoder` used to encode instances of a data type as JSON objects.
    ///
    /// This property holds a `JSONEncoder` instance that is used to convert Swift data types into JSON representations. The encoder is responsible for
    /// converting Swift objects conforming to the `Encodable` protocol into JSON format for transmission over the network or storage. The encoding process
    /// allows data to be serialized and sent to a server as part of network requests or stored in a persistent format.
    public private(set) var encoder = JSONEncoder()
    
    /// An instance of `JSONDecoder` used to decode instances of a data type from JSON objects.
    ///
    /// This property holds a `JSONDecoder` instance that is used to convert JSON data received from the network or storage into Swift objects. The decoder
    /// is responsible for deserializing JSON data and converting it back into Swift objects conforming to the `Decodable` protocol. The decoding process
    /// allows data to be extracted and used in the application after it has been received from the server or read from a storage medium.
    public private(set) var decoder = JSONDecoder()
    
    /// A `T.Type` instance that represents the expected response type from the network request.
    ///
    /// This property is used to specify the expected response type of the data received from the network request. By providing a `T.Type` instance, you can
    /// ensure that the received data will be decoded into a specific Swift model conforming to the `Decodable` protocol.
    public private(set) var decodeType: T.Type
    
    /// A `String` literal that represents the endpoint path relative to the host URL.
    public private(set) var path: String
    
    /// An `HTTPMethod` value that represents the HTTP method to be used for the network request. The default value is `.get`.
    ///
    /// This property allows you to specify the HTTP method to be used for the network request, indicating the type of operation to perform on the requested resource.
    public private(set) var httpMethod: HTTPMethod = .get
    
    /// A `[String: String]`dictionary that represents the HTTP headers to be used for the network request. The default value is set to an empty dictionary.
    ///
    /// This property allows you to include additional HTTP headers in the network request. HTTP headers are used to convey metadata about the request, such as
    /// authentication tokens or content types.
    public private(set) var headerFields: [String: String] = [:]
    
    /// An optional `[String: String]` dictionary that represents the query items to use for the network request. The default value for this property is `nil`.
    ///
    /// This property allows you to specify key-value pairs as query parameters for network requests. These query parameters are appended to the URL as part of
    /// the request, typically used in `GET` requests to send additional information to the server.
    public private(set) var queryItems: [String: String]? = nil
    
    /// An optional  instance of any type that conforms to the `Encodable`protocol, which represents the data to be sent as the request body in the network request.
    /// The default value for this property is `nil`.
    ///
    /// This property allows you to specify the Swift type that data should be encoded into before sending it as the request body in the network request.
    public private(set) var httpData: Encodable? = nil
    
    /// A `TimeInterval` value that represents the timeout interval to use for the network request. It is measured in seconds, indicating the maximum time the
    /// request can wait for a response from the server before timing out. The default value is `60` seconds.
    ///
    /// This property sets the maximum duration for the network request to receive a response. If the server doesn't respond within the specified time, the request
    /// is considered timed out, and an error may be returned.
    public var timeoutInterval: TimeInterval = 60.0
    
    /// An optional `String` that represents the key path of the expected response from the network request. It is used when the API response contains nested
    /// JSON data that needs to be decoded into the corresponding Swift model. The default value for this property is `nil`.
    ///
    /// This property allows you to specify the key path that points to the data you want to decode from the JSON response. If the response contains nested JSON
    /// data, you can use the `keyPath` to navigate to the specific section of the JSON that corresponds to the desired Swift model.
    public var keyPath: String? = nil
    
    /// A `JSONEncoder.KeyEncodingStrategy` value that represents the strategy to use for automatically changing the value of keys before encoding.
    /// The default strategy is set to `.useDefaultKeys`.
    private var _keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys
    
    /// A `JSONEncoder.KeyEncodingStrategy` value that represents the strategy to use for automatically changing the value of keys before encoding.
    public var keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy {
        get {
            return _keyEncodingStrategy
        }
        set(newValue) {
            _keyEncodingStrategy = newValue
            encoder.keyEncodingStrategy = _keyEncodingStrategy
        }
    }
    
    /// A `JSONEncoder.DateEncodingStrategy` value that represents the strategy to use for encoding `Date` values.
    /// The default strategy is set to `.deferredToDate`.
    private var _dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .deferredToDate
    
    /// A `JSONEncoder.DateEncodingStrategy` value that represents the strategy to use for encoding `Date` values.
    public var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy {
        get {
            return _dateEncodingStrategy
        }
        set(newValue) {
            _dateEncodingStrategy = newValue
            encoder.dateEncodingStrategy = _dateEncodingStrategy
        }
    }
    
    /// A `JSONEncoder.DataEncodingStrategy` value that represents the strategy to use for encoding `Data` values.
    /// The default strategy is set to `.base64`.
    private var _dataEncodingStrategy: JSONEncoder.DataEncodingStrategy = .base64
    
    /// A `JSONEncoder.DataEncodingStrategy` value that represents the strategy to use for encoding `Data` values.
    public var dataEncodingStrategy: JSONEncoder.DataEncodingStrategy {
        get {
            return _dataEncodingStrategy
        }
        set(newValue) {
            _dataEncodingStrategy = newValue
            encoder.dataEncodingStrategy = _dataEncodingStrategy
        }
    }
    
    /// A `JSONDecoder.KeyDecodingStrategy` value that represents the strategy to use for automatically changing the value of keys before decoding.
    /// The default strategy is set to `.useDefaultKeys`.
    private var _keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    
    /// A `JSONDecoder.KeyDecodingStrategy` value that represents the strategy to use for automatically changing the value of keys before decoding.
    public var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy {
        get {
            return _keyDecodingStrategy
        }
        set(newValue) {
            _keyDecodingStrategy = newValue
            decoder.keyDecodingStrategy = _keyDecodingStrategy
        }
    }
    
    /// A `JSONDecoder.DateDecodingStrategy` value that represents the strategy to use for decoding `Date` values.
    /// The default strategy is set to `.deferredToDate`.
    private var _dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate
    
    /// A `JSONDecoder.DateDecodingStrategy` value that represents the strategy to use for decoding `Date` values.
    public var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        get {
            return _dateDecodingStrategy
        }
        set(newValue) {
            _dateDecodingStrategy = newValue
            decoder.dateDecodingStrategy = _dateDecodingStrategy
        }
    }
    
    /// A `JSONDecoder.DataDecodingStrategy` value that represents the strategy to use for decoding `Data` values.
    /// The default strategy is set to `.base64`.
    private var _dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .base64
    
    /// A `JSONDecoder.DataDecodingStrategy` value that represents the strategy to use for decoding `Data` values.
    public var dataDecodingStrategy: JSONDecoder.DataDecodingStrategy {
        get {
            return _dataDecodingStrategy
        }
        set(newValue) {
            _dataDecodingStrategy = newValue
            decoder.dataDecodingStrategy = _dataDecodingStrategy
        }
    }

    /// Creates an `Endpoint` instance with a single type for decoding the response.
    ///
    /// This initializer allows you to create an `Endpoint` instance with a single type for decoding the response. The response data received from the network
    /// request will be decoded into the specified Swift model type, enabling easy handling of the API's response data.
    ///
    /// - Parameters:
    ///   - type: A `T.Type` instance representing the type used for decoding the response from the network request.
    ///   - path: A `String` literal that represents the endpoint path relative to the host URL.
    ///   - httpMethod: An `HTTPMethod` value representing the HTTP method to be used for the network request.
    ///   - headers: A `[String: String]` dictionary representing the HTTP headers to be used for the network request.
    ///   - queryItems: An optional `[String: String]` dictionary representing the query items to use for the network request. The default value is `nil`.
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
        self.encoder.keyEncodingStrategy = _keyEncodingStrategy
        self.encoder.dateEncodingStrategy = _dateEncodingStrategy
        self.encoder.dataEncodingStrategy = _dataEncodingStrategy
        self.decoder.keyDecodingStrategy = _keyDecodingStrategy
        self.decoder.dateDecodingStrategy = _dateDecodingStrategy
        self.decoder.dataDecodingStrategy = _dataDecodingStrategy
    }
    
    /// Creates an `Endpoint` instance with separate types for decoding and encoding data.
    ///
    /// This initializer allows you to create an `Endpoint` instance with separate types for decoding and encoding data. The response data received from the
    /// network request will be decoded into the specified Swift model type, and any data sent as the request body will be encoded from the specified Swift model
    /// type.
    ///
    /// - Parameters:
    ///   - decodeType: A `T.Type` instance representing the type used for decoding the response from the network request.
    ///   - path: A `String` literal that represents the endpoint path relative to the host URL.
    ///   - httpMethod: An `HTTPMethod` value representing the HTTP method to be used for the network request.
    ///   - headers: A `[String: String]` dictionary representing the HTTP headers to be used for the network request.
    ///   - queryItems: An optional `[String: String]` dictionary representing the query items to use for the network request. The default value is `nil`.
    ///   - httpData: An  instance of a type that conforms to the `Encodable`protocol, which represents the data to be sent as the request body in the network request.
    public init(
        decodeType: T.Type,
        path: String,
        httpMethod: HTTPMethod,
        headers: [String : String],
        queryItems: [String : String]? = nil,
        httpData: Encodable
    ) {
        self.decodeType = decodeType
        self.path = path
        self.httpMethod = httpMethod
        self.headerFields = headers
        self.queryItems = queryItems
        self.httpData = httpData
        self.encoder.keyEncodingStrategy = _keyEncodingStrategy
        self.encoder.dateEncodingStrategy = _dateEncodingStrategy
        self.encoder.dataEncodingStrategy = _dataEncodingStrategy
        self.decoder.keyDecodingStrategy = _keyDecodingStrategy
        self.decoder.dateDecodingStrategy = _dateDecodingStrategy
        self.decoder.dataDecodingStrategy = _dataDecodingStrategy
    }
    
}

// MARK: - Static Properties and Methods

extension Endpoint {
    
    /// Constructs a valid `URL` for the specified API endpoint using the provided application environment.
    ///
    /// - Parameters:
    ///   - endpoint: An `Endpoint` instance representing the API endpoint for which the `URL` is to be constructed.
    ///   - environment: An `AppEnvironment` instance representing the application environment containing the base URL and other configuration details.
    ///
    /// - Returns: A valid `URL` object representing the constructed URL for the given API endpoint and application environment.
    ///
    /// - Throws: An `AsyncNetworkingError` if the constructed URL is invalid or any other error occurs during URL construction.
    ///
    /// This function constructs a valid URL for the specified API endpoint using the provided application environment. It begins by converting the `queryItems`
    /// dictionary of the `endpoint` parameter into an array of `URLQueryItem` objects. The `URLQueryItem` objects represent the key-value pairs
    /// to be used as query parameters in the URL, if applicable.
    ///
    /// Next, the function creates a `URLComponents` object to hold the various components of the URL, including the scheme (HTTP or HTTPS), host, path,
    /// and query parameters. The scheme and host are extracted from the `environment` parameter, while the path is taken from the `endpoint` parameter.
    /// If query parameters are available, they are added to the `URLComponents` object as well.
    ///
    /// Finally, the function checks whether a valid URL can be extracted from the `URLComponents` object. If successful, the valid `URL` is returned; otherwise, an `AsyncNetworkingError.invalidURL` error is thrown.
    ///
    /// Usage:
    /// ```swift
    /// let endpoint = Endpoint(path: "users", httpMethod: .get, headers: [:])
    /// let environment = AppEnvironment(named: "Example", host: "api.example.com", session: .shared)
    ///
    /// do {
    ///     let apiURL = try Endpoint.url(forEndpoint: endpoint, using: environment)
    ///     print("Constructed URL: \(apiURL.absoluteString)")
    /// } catch {
    ///     print("Error constructing URL: \(error.localizedDescription)")
    /// }
    /// ```
    static func url(
        forEndpoint endpoint: Endpoint,
        using environment: AppEnvironment
    ) throws -> URL {
        /// Create array of `URLQueryItem` objects from the `queryItems` dictionary of the `endpoint` parameter.
        var queryItems: [URLQueryItem]? = nil
        if let parameters = endpoint.queryItems {
            queryItems = parameters.map { key, value in
                return URLQueryItem(name: key, value: value)
            }
        }
        /// Create `URLComponents` object.
        var components = URLComponents()
        components.scheme = environment.scheme.stringValue
        components.host = environment.host
        components.path = endpoint.path
        components.queryItems = queryItems
        /// Check that a valid URL can be extracted from the `URLComponents` object.
        guard let url = components.url else {
            throw AsyncNetworkingError.invalidURL
        }
        return url
    }
    
    /// Constructs an `URLRequest` object for the specified API endpoint and URL.
    ///
    /// - Parameters:
    ///   - endpoint: An `Endpoint` instance representing the API endpoint for which the request is to be constructed.
    ///   - url: A valid `URL` object representing the complete URL for the network request.
    ///
    /// - Returns: An `URLRequest` object representing the constructed network request.
    ///
    /// This function creates an `URLRequest` object for the specified API endpoint and URL. It begins by initializing an empty `URLRequest` with the provided `url`.
    /// Then, it sets the HTTP method of the request based on the `httpMethod` property of the `endpoint` parameter. Next, the function assigns the HTTP
    /// header fields of the request using the `headerFields` property of the `endpoint` parameter. The header fields are used to convey additional
    /// information about the request, such as authentication tokens or content types.
    ///
    /// Subsequently, the function sets the timeout interval for the request using the `timeoutInterval` property of the `endpoint` parameter. The timeout
    /// interval represents the maximum time the request can wait for a response from the server before timing out.
    ///
    /// Additionally, the function allows cellular access and expensive network access for the request by setting `allowsCellularAccess` and
    /// `allowsExpensiveNetworkAccess` properties to `true`, respectively. Finally, the function returns the fully configured `URLRequest` object.
    ///
    /// Usage:
    /// ```swift
    /// let endpoint = Endpoint(path: "users", httpMethod: .get, headers: [:])
    /// let url = URL(string: "https://api.example.com")!
    /// let request = request(forEndpoint: endpoint, url: url)
    /// ```
    static func request(
        forEndpoint endpoint: Endpoint,
        url: URL
    ) -> URLRequest {
        /// Create `URLRequest` object.
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.stringValue
        request.allHTTPHeaderFields = endpoint.headerFields
        request.timeoutInterval = endpoint.timeoutInterval
        request.allowsCellularAccess = true
        request.allowsExpensiveNetworkAccess = true
        return request
    }
    
}
