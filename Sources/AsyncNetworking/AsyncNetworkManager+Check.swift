//
//  AsyncNetworkManager+Check.swift
//  AsyncNetworking
//
//  Created by Juan Diego Ocampo on 2023-07-22.
//

import Foundation

// MARK: - Extension for handling any requests that don't require any value to be returned and don't provide any value to be attached to the request.

extension AsyncNetworkManager {
 
    /// Validates if the response from the specified API endpoint is succesful. This method does not return any data from the network request and does not attach any data to the request's body.
    ///
    /// - Parameters:
    ///   - endpoint: An `Endpoint` instance representing the API endpoint from which to fetch the data.
    ///
    /// - Returns: A `Bool` value indicating whether the request was succesful or not.
    /// - Throws: An `AsyncNetworkingError` if any error occurs during the network request process.
    ///
    /// This asynchronous function is used to perform network requests in a non-blocking manner. It takes an `Endpoint` instance as a parameter, which defines the API endpoint's details, such as URL, HTTP method, headers, and more.
    ///
    /// Next, the function constructs the `URL` and `URLRequest` objects required for the network request using the provided endpoint and current application environment. It then tries to execute the network request using the provided `URLSession` associated with the chosen environment, waiting for the response.
    ///
    /// Upon receiving the response, the function checks if the response can be converted into an `HTTPURLResponse` object. If not, it throws an `AsyncNetworkingError.invalidResponse` to indicate that the response is not in the expected format.
    ///
    /// Depending on the received HTTP status code, the function takes different actions:
    /// - For status codes in the range 200 to 300, it returns `true` because this means that the request was successful.
    /// - For any other status codes it returns `false` because this means that the request failed.
    ///
    /// Usage:
    /// ```swift
    /// let environment = AppEnvironment(named: "Test", host: "api.example.com", session: .shared)
    /// let endpoint = Endpoint(type: MyModel.self, path: "users", httpMethod: .get, headers: [:])
    /// do {
    ///     let data: MyModel = try await fetchData(for: endpoint)
    ///     // Process the fetched result.
    /// } catch {
    ///     // Handle errors.
    /// }
    /// ```
    public func checkRespose<T>(forEndpoint endpoint: Endpoint<T>) async throws -> Bool {
        /// Try to execute the network request. If there are any errors, propagate them upwards through the calling chain.
        do {
            /// Create `URL` object.
            let url = try Endpoint.url(forEndpoint: endpoint, using: environment)
            /// Create `URLRequest` object.
            let request = Endpoint.request(forEndpoint: endpoint, url: url)
            /// Try to execute the `URLRequest` using the provided `URLSession` for the chosen environment.
            let (_, response) = try await environment.session.data(for: request, delegate: delegate)
            /// Try to parse the `response` onject into a  `HTTPURLResponse` structure. If its not possible to do so, exit the function and throw an error.
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AsyncNetworkingError.invalidResponse
            }
            /// Take action on the received  `data` depending on the decoded  `httpResponse` structure.
            switch httpResponse.statusCode {
            case 200..<300:
                /// If the response code is in between the range of 200 to 300 it means that the request was successful, so we'll return `true`.
                return true
            default:
                /// If the response code is in outside the range of 200 to 300 it means that the request failed, so we'll return `false`.
                return false
            }
        } catch let error {
            throw AsyncNetworkingError.dataTaskError(error: error)
        }
    }
    
    /// Validates if the response from the specified API endpoint is succesful with a specified ammount of attempts. This method does not return any data from the network request and does not attach any data to the request's body.
    ///
    /// - Parameters:
    ///   - endpoint: An `Endpoint` instance representing the network request configuration.
    ///   - attempts: An integer value representing the number of retry attempts to fetch the data. If the initial request fails, the method will make additional
    ///   attempts up to the specified number before throwing an error.
    ///   - delay: An optional `UInt64` value representing the delay in seconds between each retry attempt. The default value is `1` second.
    /// - Returns: A `Bool` value indicating whether the request was succesful or not.
    /// - Throws: An error of type `AsyncNetworkingError` if the maximum number of retry attempts is reached and the data cannot be fetched successfully.
    /// - Important: The method uses asynchronous programming with the `async` keyword. When calling this method, use `try await` to handle errors and wait for the result.
    public func checkRespose<T>(
        forEndpoint endpoint: Endpoint<T>,
        attempts: Int,
        delay: UInt64 = 1
    ) async throws -> Bool {
        do {
            /// Attempt to fetch data for the provided endpoint.
            let response = try await checkRespose(forEndpoint: endpoint)
            return response
        } catch {
            /// If there's an error in fetching data, attempt retries based on the provided number of attempts. If the maximum number of attempts is reached, throw the error.
            guard attempts > 1 else {
                throw error
            }
            /// Wait for the specified delay before making the next retry attempt.
            try await Task.sleep(nanoseconds: NSEC_PER_SEC * delay)
            /// Make the next retry attempt by recursively calling the fetchData method with attempts reduced by 1./
            let response = try await checkRespose(
                forEndpoint: endpoint,
                attempts: attempts - 1,
                delay: delay
            )
            return response
        }
    }
    
}
