//
//  DeleteHTTPMethodTests.swift
//  AsyncNetworking
//
//  Created by Juan Diego Ocampo on 2023-07-22.
//

import Foundation
import XCTest
@testable import AsyncNetworking

/// A test case class for testing the `DELETE` HTTP method using the `AsyncNetworkManager`.
///
/// This test case class is a subclass of `AsyncNetworkManagerTestCase`, which provides the testing environment and instance of the `AsyncNetworkManager` with the `.testing` environment configuration. The `DeleteHTTPMethodTests` class focuses on testing the `DELETE` HTTP method for specific endpoints using the `AsyncNetworkManager`.
///
/// **Testing the GET HTTP Method:**
///
/// The `DELETE` HTTP method is used to delete data from the server. In this test case class, we define test methods to ensure that the `AsyncNetworkManager` correctly handles `DELETE` requests, performs the network communication, and decodes the server response into the expected model objects, if required.
///
/// **Usage:**
///
/// To use this test case class, run the individual test methods or all test methods collectively to verify the correctness of the `DELETE` HTTP method implementation in the `AsyncNetworkManager`. The test methods are automatically executed by the testing framework, and any failed assertions will be reported as test failures.
///
/// **Example:**
///
/// ```swift
/// class MyDeleteHTTPMethodTests: AsyncNetworkManagerTestCase {
///
///     // Test method for the DELETE HTTP method with a specific endpoint.
///     func testDeleteUser() async throws {
///         let endpoint = Endpoint(
///             type: Bool.self,
///                 path: "/api/users/2",
///                 httpMethod: .delete,
///                 headers: [:]
///                 )
///         do {
///             let result = try await networkManager.checkRespose(forEndpoint: endpoint, attempts: 3, delay: UInt64(1.0))
///                 XCTAssertTrue(result, "The result should have been true if the request was succesful.")
///         } catch let error {
///             print(error.localizedDescription)
///             XCTFail()
///         }
///     }
///
/// }
/// ```
/// - Note: This test case class inherits the testing environment and `AsyncNetworkManager` instance from the `AsyncNetworkManagerTestCase` class. It is marked as `final`, meaning it cannot be subclassed further. However, you can create new test case classes based on this class and extend its functionality as needed.
final class DeleteHTTPMethodTests: AsyncNetworkManagerTestCase {
    
    /// Test method for deleting a single user.
    ///
    /// This test method validates the scenario where a single user is deleted from the server. It sends an HTTP GET request to the `/api/users/2` endpoint to request the deletion of all information for the user with ID 2.
    ///
    /// The `Endpoint` struct is used to specify the endpoint details, such as the decoding type, path, HTTP method, and headers. The decoding type is set to the `User` struct, which contains the required properties to represent the user data.
    /// The test method performs the HTTP DELETE request and awaits the response, which contains a `Bool` indicating whether the received response code is valid or not.
    ///
    /// - Throws: An error if there's an issue with the network request.
    ///
    /// - Note: The test also includes a `catch` block to handle any errors that may occur during the network request. If an error occurs, the test prints its localized description and fails.
    private func testDeleteUser() async throws {
        let endpoint = Endpoint(
            type: Bool.self,
            path: "/api/users/2",
            httpMethod: .delete,
            headers: [:]
        )
        do {
            let result = try await networkManager.checkRespose(forEndpoint: endpoint, attempts: 3, delay: UInt64(1.0))
            XCTAssertTrue(result, "The result should have been true if the request was succesful.")
        } catch let error {
            print(error.localizedDescription)
            XCTFail()
        }
    }
    
}
