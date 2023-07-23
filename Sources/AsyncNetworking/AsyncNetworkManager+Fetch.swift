//
//  AsyncNetworkManager+Fetch.swift
//  AsyncNetworking
//
//  Created by Juan Diego Ocampo on 2023-07-22.
//

import Foundation

// MARK: - Extension for handling GET requests.

extension AsyncNetworkManager {
    
    /// Fetches data from the specified API endpoint and decodes it into a generic object of type `T`.
    ///
    /// - Parameters:
    ///   - endpoint: An `Endpoint` instance representing the API endpoint from which to fetch the data.
    ///
    /// - Returns: A generic object of type `T`, representing the decoded data from the API response.
    /// - Throws: An `AsyncNetworkingError` if any error occurs during the network request or data decoding process.
    ///
    /// This asynchronous function is used to perform network requests and data decoding in a non-blocking manner. It takes an `Endpoint` instance as a parameter, which defines the API endpoint's details, such as URL, HTTP method, headers, and more.
    ///
    /// The function first checks if the HTTP method of the endpoint is supported for fetching data. If the method is not a valid option for data retrieval (e.g., POST, DELETE, PATCH, PUT), the function throws an `AsyncNetworkingError.invalidHTTPMethod` to indicate the issue.
    ///
    /// Next, the function constructs the `URL` and `URLRequest` objects required for the network request using the provided endpoint and current application environment. It then tries to execute the network request using the provided `URLSession` associated with the chosen environment, waiting for the response.
    ///
    /// Upon receiving the response, the function checks if the response can be converted into an `HTTPURLResponse` object. If not, it throws an `AsyncNetworkingError.invalidResponse` to indicate that the response is not in the expected format.
    ///
    /// Depending on the received HTTP status code, the function takes different actions:
    /// - For status codes in the range 100. to 200, it throws an `AsyncNetworkingError.invalidResponseCode` with an "informationalResponse" error code.
    /// - For status codes in the range 200 to 300, it decodes the data into a generic object of the specified type `T`.
    /// - For status codes in the range 300 to 600, it throws an `AsyncNetworkingError.invalidResponseCode` with a corresponding "redirectionResponse",
    ///   "clientErrorResponse", or "serverErrorResponse" error code, respectively.
    /// - For any other status codes, it throws an `AsyncNetworkingError.invalidResponseCode` with an "invalidResponseCode" error code.
    ///
    /// If the `keyPath` property of the provided `endpoint` contains content, it indicates that the user wants to decode only a specific piece of the JSON object. In this case, the function attempts to convert the received `data` into an `NSDictionary` and uses the `keyPath` property to access the desired value.
    ///
    /// After successfully decoding the data, the function returns the generic object of type `T`. If any error occurs during the decoding process, it throws an `AsyncNetworkingError.decodingError` to indicate the issue.
    ///
    /// Usage:
    /// ```swift
    /// let environment = AppEnvironment(named: "Test", host: "api.example.com", session: .shared)
    /// let endpoint = Endpoint(type: MyModel.self, path: "users", httpMethod: .get, headers: [:])
    /// do {
    ///     let data: MyModel = try await fetchData(for: endpoint)
    ///     // Process the fetched data.
    /// } catch {
    ///     // Handle errors.
    /// }
    /// ```
    public func fetchData<T>(forEndpoint endpoint: Endpoint<T>) async throws -> T {
        /// Validate that the `httpBody` property of the provided `endpoint` parameters matches one of the accepted cases for this method.
        switch endpoint.httpMethod {
        case .post, .delete, .patch, .put:
            throw AsyncNetworkingError.invalidHTTPMethod
        default:
            break
        }
        /// Try to execute the network request. If there are any errors, propagate them upwards through the calling chain.
        do {
            /// Create `URL` object.
            let url = try Endpoint.url(forEndpoint: endpoint, using: environment)
            /// Create `URLRequest` object.
            let request = Endpoint.request(forEndpoint: endpoint, url: url)
            /// Try to execute the `URLRequest` using the provided `URLSession` for the chosen environment.
            let (data, response) = try await environment.session.data(for: request, delegate: delegate)
            /// Try to parse the `response` onject into a  `HTTPURLResponse` structure. If its not possible to do so, exit the function and throw an error.
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AsyncNetworkingError.invalidResponse
            }
            /// Take action on the received  `data` depending on the decoded  `httpResponse` structure.
            switch httpResponse.statusCode {
                /// Invalid status code received. Exit the function and throw an error.
            case 100..<200:
                let errorMessage = "\("informationalResponse"): \(httpResponse.statusCode)."
                throw AsyncNetworkingError.invalidResponseCode(errorCode: errorMessage)
                /// The status code received is valid. Try to decode the data into a generic object of type `U`.
            case 200..<300:
                /// Validate if the `keyPath` property of the provided `endpoint` has any content. If it does it means that the user does not want to decode
                /// the entire JSON object but only a specific piece. To do this, try to convert the received `data`into an `NSDictionary` and use the
                /// `keyPath`property to access the desired value.
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
                /// Try to decode the `dataToDecode` using the decoder created above. If something goes wrong, exit the function and throw an error.
                do {
                    let decodedData = try endpoint.decoder.decode(T.self, from: dataToDecode)
                    return decodedData
                } catch let decodingError {
                    throw AsyncNetworkingError.decodingError(error: decodingError)
                }
                /// Invalid status code received. Exit the function and throw an error.
            case 300..<400:
                let errorMessage = "\("redirectionResponse"): \(httpResponse.statusCode)."
                throw AsyncNetworkingError.invalidResponseCode(errorCode: errorMessage)
                /// Invalid status code received. Exit the function and throw an error.
            case 400..<500:
                let errorMessage = "\("clientErrorResponse"): \(httpResponse.statusCode)."
                throw AsyncNetworkingError.invalidResponseCode(errorCode: errorMessage)
                /// Invalid status code received. Exit the function and throw an error.
            case 500..<600:
                let errorMessage = "\("serverErrorResponse"): \(httpResponse.statusCode)."
                throw AsyncNetworkingError.invalidResponseCode(errorCode: errorMessage)
                /// Invalid status code received. Exit the function and throw an error.
            default:
                let errorMessage = "\("invalidResponseCode"): \(httpResponse.statusCode)."
                throw AsyncNetworkingError.invalidResponseCode(errorCode: errorMessage)
            }
        } catch let error {
            throw AsyncNetworkingError.dataTaskError(error: error)
        }
    }
    
    /// Fetches data from the specified API endpoint and decodes it into a generic object of type `T` with a specified ammount of attempts.
    ///
    /// This method is used to perform a network request for the given `Endpoint` instance and fetches data of type `T` from the server. In case of a failure, it provides a retry mechanism that allows you to make multiple attempts to fetch the data before throwing an error.
    ///
    /// - Parameters:
    ///   - endpoint: An `Endpoint` instance representing the network request configuration.
    ///   - attempts: An integer value representing the number of retry attempts to fetch the data. If the initial request fails, the method will make additional
    ///   attempts up to the specified number before throwing an error.
    ///   - delay: An optional `UInt64` value representing the delay in seconds between each retry attempt. The default value is `1` second.
    /// - Returns: The fetched data of type `T`.
    /// - Throws: An error of type `AsyncNetworkingError` if the maximum number of retry attempts is reached and the data cannot be fetched successfully.
    /// - Important: The method uses asynchronous programming with the `async` keyword. When calling this method, use `try await` to handle errors and wait for the result.
    public func fetchData<T>(
        forEndpoint endpoint: Endpoint<T>,
        attempts: Int,
        delay: UInt64 = 1
    ) async throws -> T {
        do {
            /// Attempt to fetch data for the provided endpoint.
            let response = try await fetchData(forEndpoint: endpoint)
            return response
        } catch {
            /// If there's an error in fetching data, attempt retries based on the provided number of attempts. If the maximum number of attempts is reached, throw the error.
            guard attempts > 1 else {
                throw error
            }
            /// Wait for the specified delay before making the next retry attempt.
            try await Task.sleep(nanoseconds: NSEC_PER_SEC * delay)
            /// Make the next retry attempt by recursively calling the fetchData method with attempts reduced by 1./
            let response = try await fetchData(
                forEndpoint: endpoint,
                attempts: attempts - 1,
                delay: delay
            )
            return response
        }
    }
    
    /// Fetches data from the specified API endpoint and decodes it into a generic object of type `T` with a specified ammount of attempts and a default value to return in the event that an error occurs.
    ///
    /// This method is used to perform a network request for the given `Endpoint` instance and fetches data of type `T` from the server. It provides a retry mechanism that allows you to make multiple attempts to fetch the data before returning a default value in case of failure.
    ///
    /// - Parameters:
    ///   - endpoint: An `Endpoint` instance representing the network request configuration.
    ///   - attempts: An integer value representing the number of retry attempts to fetch the data. If the initial request fails, the method will make additional attempts up to the specified number.
    ///   - delay: An optional `UInt64` value representing the delay in seconds between each retry attempt. The default value is `1` second.
    ///   - defaultValue: A default value of type `T` to be returned if the maximum number of retry attempts is reached and the data cannot be fetched successfully.
    /// - Returns: The fetched data of type `T` if successful, otherwise returns the specified `defaultValue`.
    /// - Important: The method uses asynchronous programming with the `async` keyword. When calling this method, use `await` to get the result.
    public func fetchData<T>(
        forEndpoint endpoint: Endpoint<T>,
        attempts: Int,
        delay: UInt64 = 1,
        defaultValue: T
    ) async -> T {
        do {
            let response = try await fetchData(
                forEndpoint: endpoint,
                attempts: attempts,
                delay: delay
            )
            return response
        } catch {
            return defaultValue
        }
    }
    
}
