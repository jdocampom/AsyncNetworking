//
//  NetworkManager+Send.swift
//  Networking
//
//  Created by Juan Diego Ocampo on 11.28.2024.
//

#if canImport(Foundation)

import Foundation

// MARK: - Extension for handling POST, PATCH, PUT and DELETE HTTP requests.

extension NetworkManager {

    /// Sends data to a specified endpoint using the provided HTTP method
    /// and decodes the response.
    ///
    /// This function validates the HTTP method, constructs a URL request,
    /// and sends data asynchronously using the configured environment.
    ///
    /// It handles responses and decodes the response data into a generic type `T`.
    ///
    /// #### Code Example:
    /// ```swift
    /// let endpoint = Endpoint<User>(urlPath: "/users", httpMethod: .post, httpData: user)
    /// let response: User = try await networkManager.sendData(for: endpoint)
    /// print("User received: \(response)")
    /// ```
    ///
    /// - Parameters:
    ///   - endpoint: An `Endpoint` instance that contains information about the URL,
    ///               HTTP method, and data to be sent.
    ///
    /// - Returns: The decoded response of type `T`.
    ///
    /// - Throws:
    ///   - `NetworkingError.invalidHTTPMethod` if the HTTP method is not one of `.post`, `.delete`,
    ///     `.patch`, or `.put`.
    ///   - `NetworkingError.encodingError` if encoding the request body fails.
    ///   - `NetworkingError.invalidResponse` if the response cannot be cast to `HTTPURLResponse`.
    ///   - `NetworkingError.invalidResponseCode` for unexpected HTTP status codes.
    ///   - `NetworkingError.decodingError` if decoding the response data fails.
    ///   - `NetworkingError.dataTaskError` for network-related errors.
    ///
    public func sendData<T>(for endpoint: Endpoint<T>) async throws -> T {
        // Validate the HTTP method to ensure it is one of the allowed methods.
        switch endpoint.httpMethod {
        case .post, .delete, .patch, .put:
            // Continue with the request.
            break
        default:
            // If the HTTP method is not allowed, throw an error.
            throw NetworkingError.invalidHTTPMethod
        }
        // Try to execute the network request.
        do {
            // Create `URL` object.
            let url = try Endpoint.url(for: endpoint, using: environment)
            // Create `URLRequest` object.
            let request = Endpoint.request(forEndpoint: endpoint, url: url)
            // Try to execute the `URLRequest` using the provided `URLSession` for the chosen environment.
            let (data, response) = try await environment.session.data(
                for: request,
                delegate: delegate
            )
            // Try to parse the `response` object into a  `HTTPURLResponse` structure.
            guard let httpResponse = response as? HTTPURLResponse else {
                // If its not possible to do so, exit the function and throw an error.
                throw NetworkingError.invalidResponse
            }
            // Take action on the received  `data` depending on the decoded  `httpResponse` structure.
            switch httpResponse.statusCode {
            case 100..<200:
                throw NetworkingError.invalidResponseCode(httpResponse.statusCode)
            case 200..<300:
                // Validate if the `keyPath` property of the provided `endpoint` has any content.
                // If it does it means that the user does not want to decode the entire JSON object
                // but only a specific piece. To do this, try to convert the received `data`into an
                //`NSDictionary` and use the `keyPath`property to access the desired value.
                var dataToDecode = data
                if let keyPath = endpoint.keyPath {
                    if let rootObject = try JSONSerialization.jsonObject(with: data) as? NSDictionary {
                        if let nestedObject = rootObject.value(forKeyPath: keyPath) {
                            dataToDecode = try JSONSerialization.data(
                                withJSONObject: nestedObject,
                                options: .fragmentsAllowed
                            )
                        }
                    }
                }
                // Try to decode the `dataToDecode` using the manager's `decoder` property.
                do {
                    // Attempt to decode the data using the provided `decoder`.
                    let decodedData = try endpoint.decoder.decode(T.self, from: dataToDecode)
                    // If decoding is successful, return the decoded data.
                    return decodedData
                } catch let decodingError {
                    // If something goes wrong, exit the function and throw an error.
                    throw NetworkingError.decodingError(decodingError)
                }
            case 300..<400:
                throw NetworkingError.invalidResponseCode(httpResponse.statusCode)
            case 400..<500:
                throw NetworkingError.invalidResponseCode(httpResponse.statusCode)
            case 500..<600:
                throw NetworkingError.invalidResponseCode(httpResponse.statusCode)
            default:
                throw NetworkingError.invalidResponseCode(httpResponse.statusCode)
            }
        } catch let error {
            throw NetworkingError.dataTaskError(error)
        }
    }

    /// Sends data to a specified endpoint with retry logic for failed requests.
    ///
    /// This function attempts to send data up to a specified number of retries,
    /// waiting for a delay between attempts.
    ///
    /// #### Code Example:
    /// ```swift
    /// let endpoint = Endpoint<User>(urlPath: "/users", httpMethod: .post, httpData: user)
    /// let response: User = try await networkManager.sendData(forEndpoint: endpoint, attempts: 3)
    /// print("User received: \(response)")
    /// ```
    ///
    /// - Parameters:
    ///   - endpoint: An `Endpoint` instance that contains information about the URL,
    ///               HTTP method, and data to be sent.
    ///   - attempts: The number of retry attempts before throwing the error.
    ///   - delay: The delay between retry attempts, in seconds (default is 1 second).
    ///
    /// - Returns: The decoded response of type `T`.
    ///
    /// - Throws: Any error thrown by the `sendData(for:)` method if all attempts fail.
    ///
    public func sendData<T>(
        forEndpoint endpoint: Endpoint<T>,
        attempts: Int,
        delay: UInt64 = 1
    ) async throws -> T {
        do {
            // Attempt to fetch data for the provided endpoint.
            let response = try await sendData(for: endpoint)
            // Return the response if successful.
            return response
        } catch {
            // Make sure there are more than 1 attempts left
            guard attempts > 1 else {
                // If there are no more attempts left, propagate the error upwards.
                throw error
            }
            // Wait for the specified delay before making the next retry attempt.
            try await Task.sleep(nanoseconds: NSEC_PER_SEC * delay)
            // Make the next retry attempt by recursively calling the fetchData method
            // with attempts reduced by 1.
            let response = try await sendData(
                forEndpoint: endpoint,
                attempts: attempts - 1,
                delay: delay
            )
            // Return the response if successful.
            return response
        }
    }
    
    /// Sends data to a specified endpoint with retry logic and a default value fallback.
    ///
    /// This function attempts to send data up to a specified number of retries.
    /// If all retries fail, it returns the provided default value.
    ///
    /// #### Code Example:
    /// ```swift
    /// let endpoint = Endpoint<User>(urlPath: "/users", httpMethod: .post, httpData: user)
    /// let response: User = await networkManager.sendData(
    ///     forEndpoint: endpoint,
    ///     attempts: 3,
    ///     defaultValue: User.placeholder
    /// )
    /// print("User received: \(response)")
    /// ```
    ///
    /// - Parameters:
    ///   - endpoint: An `Endpoint` instance that contains information about the URL,
    ///               HTTP method, and data to be sent.
    ///   - attempts: The number of retry attempts before returning the default value.
    ///   - delay: The delay between retry attempts, in seconds (default is 1 second).
    ///   - defaultValue: The value to return if all retry attempts fail.
    ///
    /// - Returns: The decoded response of type `T`, or the default value if all attempts fail.
    ///
    public func sendData<T>(
        forEndpoint endpoint: Endpoint<T>,
        attempts: Int,
        delay: UInt64 = 1,
        defaultValue: T
    ) async -> T {
        do {
            // Attempt to fetch data for the provided endpoint.
            let response = try await sendData(
                forEndpoint: endpoint,
                attempts: attempts,
                delay: delay
            )
            // Return the response if successful.
            return response
        } catch {
            // Return the default value if all attempts fail.
            return defaultValue
        }
    }
    
}

#endif
