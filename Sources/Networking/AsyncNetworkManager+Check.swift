//
//  NetworkManager+Check.swift
//  Networking
//
//  Created by Juan Diego Ocampo on 11.28.2024.
//

#if canImport(Foundation)

import Foundation

extension NetworkManager {
 
    /// Checks the response of a network request for a given endpoint to determine success.
    ///
    /// This function sends a network request to the specified endpoint and evaluates the HTTP status code
    /// in the response. If the status code is within the range of 200 to 299, the response is considered
    /// successful, and the function returns `true`. Otherwise, it returns `false`.
    ///
    /// ### Example:
    /// ```swift
    /// let endpoint = Endpoint<Void>(urlPath: "/health-check", httpMethod: .get)
    /// let isSuccessful = try await networkManager.checkResponse(for: endpoint)
    /// print("Response success: \(isSuccessful)")
    /// ```
    ///
    /// - Parameters:
    ///     - endpoint: An `Endpoint` instance containing the URL and request details.
    ///
    /// - Returns: A `Bool` indicating whether the response status code indicates success.
    ///
    /// - Throws:
    ///   - `NetworkingError.invalidResponse` if the response cannot be parsed as an `HTTPURLResponse`.
    ///   - `NetworkingError.dataTaskError` for errors during the request execution.
    ///
    public func checkResponse<T>(for endpoint: Endpoint<T>) async throws -> Bool {
        // Try to execute the network request.
        do {
            // Create `URL` object.
            let url = try Endpoint.url(for: endpoint, using: environment)
            // Create `URLRequest` object.
            let request = Endpoint.request(forEndpoint: endpoint, url: url)
            // Try to execute the `URLRequest` using the provided `URLSession` for the chosen environment.
            let (_, response) = try await environment.session.data(for: request, delegate: delegate)
            // Try to parse the `response` object into a  `HTTPURLResponse` structure.
            guard let httpResponse = response as? HTTPURLResponse else {
                // If its not possible to do so, exit the function and throw an error.
                throw NetworkingError.invalidResponse
            }
            // Take action on the received  `data` depending on the decoded  `httpResponse` structure.
            switch httpResponse.statusCode {
            case 200..<300:
                // If the response code is in between the range of 200 to 300
                // it means that the request was successful, so we'll return `true`.
                return true
            default:
                // If the response code is in outside the range of 200 to 300
                // it means that the request failed, so we'll return `false`.
                return false
            }
        } catch let error {
            throw NetworkingError.dataTaskError(error)
        }
    }

    /// Checks the response of a network request for a given endpoint with retry logic.
    ///
    /// This function attempts to check the response of a network request up to a specified number
    /// of retries. Between retries, it waits for a specified delay. If all attempts fail, the error
    /// is propagated to the caller.
    ///
    /// #### Code Example:
    /// ```swift
    /// let endpoint = Endpoint<Void>(urlPath: "/health-check", httpMethod: .get)
    /// do {
    ///     let isSuccessful = try await networkManager.checkResponse(for: endpoint, attempts: 3)
    ///     print("Response success after retries: \(isSuccessful)")
    /// } catch {
    ///     print("Failed to check response: \(error)")
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - endpoint: An `Endpoint` instance containing the URL and request details.
    ///   - attempts: The number of retry attempts before throwing the error.
    ///   - delay: The delay between retry attempts, in seconds (default is 1 second).
    ///
    /// - Returns: A Boolean indicating whether the response status code indicates success.
    ///
    /// - Throws: Any error thrown by the `checkResponse(for:)` method if all attempts fail.
    ///
    public func checkResponse<T>(
        for endpoint: Endpoint<T>,
        attempts: Int,
        delay: UInt64 = 1
    ) async throws -> Bool {
        do {
            // Attempt to fetch data for the provided endpoint.
            let response = try await checkResponse(for: endpoint)
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
            let response = try await checkResponse(
                for: endpoint,
                attempts: attempts - 1,
                delay: delay
            )
            // Return the response if successful.
            return response
        }
    }
    
}

#endif
