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
/// This object is generic over two parameters:
/// - `T`: Represents the Swift type used for decoding the response from the network request. It must conform to the `Decodable` protocol, enabling the
/// received data to be decoded into a specific Swift model.
/// - `U`: An optional Swift type used for encoding data before sending it as the request body in the network request. It must conform to the `Encodable`
/// protocol, allowing data to be encoded into a specific format before sending it to the server. This parameter is optional, and if not provided, the request body will be
/// empty or not included in the request.
@objcMembers public final class Endpoint<T: Decodable, U: Encodable>: NSObject {
    
    /// A `T.Type` instance that represents the expected response type from the network request.
    ///
    /// This property is used to specify the expected response type of the data received from the network request. By providing a `T.Type` instance, you can
    /// ensure that the received data will be decoded into a specific Swift model conforming to the `Decodable` protocol.
    public private(set) var decodeType: T.Type
    
    /// An optional `U.Type` instance that represents the Swift type used for encoding data before sending it as the request body in the network request.
    /// The default value for this property is `nil`.
    ///
    /// This property allows you to specify the Swift type that data should be encoded into before sending it as the request body in the network request.
    /// By providing a `U.Type` instance, you indicate that the data to be sent in the request body should be encoded from the specified Swift type conforming
    /// to the `Encodable` protocol.
    public private(set) var encodeType: U.Type? = nil
    
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
    public private(set) var headers: [String: String] = [:]
    
    /// An optional `[String: String]` dictionary that represents the query items to use for the network request. The default value for this property is `nil`.
    ///
    /// This property allows you to specify key-value pairs as query parameters for network requests. These query parameters are appended to the URL as part of
    /// the request, typically used in `GET` requests to send additional information to the server.
    public private(set) var queryItems: [String: String]? = nil
    
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
    public var keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys
    
    /// A `JSONEncoder.DateEncodingStrategy` value that represents the strategy to use for encoding `Date` values.
    /// The default strategy is set to `.deferredToDate`.
    public var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .deferredToDate
    
    /// A `JSONEncoder.DataEncodingStrategy` value that represents the strategy to use for encoding `Data` values.
    /// The default strategy is set to `.base64`.
    public var dataEncodingStrategy: JSONEncoder.DataEncodingStrategy = .base64
    
    /// A `JSONDecoder.KeyDecodingStrategy` value that represents the strategy to use for automatically changing the value of keys before decoding.
    /// The default strategy is set to `.useDefaultKeys`.
    public var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    
    /// A `JSONDecoder.dateDecodingStrategy` value that represents he strategy to use for decoding `Date` values.
    /// The default strategy is set to `.deferredToDate`.
    public var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate
    
    /// A `JSONDecoder.dataDecodingStrategy` value that represents the strategy to use for decoding `Data` values.
    /// The default strategy is set to `.base64`.
    public var dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .base64

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
        self.encodeType = nil
        self.path = path
        self.httpMethod = httpMethod
        self.headers = headers
        self.queryItems = queryItems
    }
    
    /// Creates an `Endpoint` instance with separate types for decoding and encoding data.
    ///
    /// This initializer allows you to create an `Endpoint` instance with separate types for decoding and encoding data. The response data received from the
    /// network request will be decoded into the specified Swift model type, and any data sent as the request body will be encoded from the specified Swift model
    /// type. 
    ///
    /// - Parameters:
    ///   - decodeType: A `T.Type` instance representing the type used for decoding the response from the network request.
    ///   - encodeType: A `U.Type` instance representing the Swift type used for encoding data before sending it as the request body in the network request.
    ///   - path: A `String` literal that represents the endpoint path relative to the host URL.
    ///   - httpMethod: An `HTTPMethod` value representing the HTTP method to be used for the network request.
    ///   - headers: A `[String: String]` dictionary representing the HTTP headers to be used for the network request.
    ///   - queryItems: An optional `[String: String]` dictionary representing the query items to use for the network request. The default value is `nil`.
    public init(
        decodeType: T.Type,
        encodeType: U.Type,
        path: String,
        httpMethod: HTTPMethod,
        headers: [String : String],
        queryItems: [String : String]? = nil
    ) {
        self.decodeType = decodeType
        self.encodeType = encodeType
        self.path = path
        self.httpMethod = httpMethod
        self.headers = headers
        self.queryItems = queryItems
    }
    
}
