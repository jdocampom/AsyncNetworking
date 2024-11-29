//
//  PostHTTPMethodTests.swift
//  Networking
//
//  Created by Juan Diego Ocampo on 11.28.2024.
//

import Foundation
import XCTest
@testable import AsyncNetworking

/// A test case class for testing the `PUT` HTTP method using the `NetworkManager`.
///
/// This test case class is a subclass of `AsyncNetworkManagerTestCase`, which provides the testing environment and instance of the `NetworkManager` with the `.testing` environment configuration. The `PostHTTPMethodTests` class focuses on testing the `PUT` HTTP method for specific endpoints using the `NetworkManager`.
///
/// **Testing the PUT HTTP Method:**
///
/// The `put` HTTP method is used to update data on the server by modifying some resources. In this test case class, we define test methods to ensure that the `NetworkManager` correctly handles `PUT` requests, performs the network communication, and decodes the server response into the expected model objects.
///
/// **Usage:**
///
/// To use this test case class, run the individual test methods or all test methods collectively to verify the correctness of the `PUT` HTTP method implementation in the `NetworkManager`. The test methods are automatically executed by the testing framework, and any failed assertions will be reported as test failures.
///
/// **Example:**
///
/// ```swift
/// class MyPutHTTPMethodTests: AsyncNetworkManagerTestCase {
///
///     // Test method for the PUT HTTP method with a specific endpoint.
///     func testUpdateUser() async throws {
///         // Create an Encodable object to hold the data that will be attached to the request as the httpBody.
///         let httpBody = UserProfileBody(name: "morpheus", job: "leader")
///         // Define the endpoint for creating a single user.
///         let endpoint = Endpoint(
///             decodeType: UserProfileResponse.self,
///             path: "/api/users/2",
///             httpMethod: .post,
///             headers: [:],
///             httpData: httpBody
///         )
///
///         // Perform the network request and fetch the user data.
///         let user = try await try await networkManager.sendData(for: endpoint)
///
///         // Assert the received user data's name and job.
///         XCTAssert(user.name == "morpheus", "The name for this user should be morpheus.")
///         XCTAssert(user.job == "zion resident", "The job for this user should be zion resident.")
///     }
///
/// }
/// ```
///
/// - Note: This test case class inherits the testing environment and `NetworkManager` instance from the `AsyncNetworkManagerTestCase` class. It is marked as `final`, meaning it cannot be subclassed further. However, you can create new test case classes based on this class and extend its functionality as needed.
final class PutHTTPMethodTests: AsyncNetworkManagerTestCase {
    
    /// Test method for handling the successful scenario of updating a user's profile.
    ///
    /// This private test method demonstrates the process of updating a user's profile on the server. It makes an HTTP PUT request with the provided endpoint details, where the endpoint path is set to "/api/users/2" to update the profile of the user with ID 2.
    ///
    /// The `Endpoint` struct is used to specify the endpoint details, such as the decoding type, path, HTTP method, headers, and the HTTP body containing the updated user profile information (`httpBody`).
    ///
    /// The `UserProfileBody` struct represents the HTTP body containing the user's profile update information, such as the new name and job.
    ///
    /// The test method sets the appropriate encoding and decoding strategies for the HTTP request and response, such as `.useDefaultKeys` for key encoding/decoding, `.iso8601` for date encoding/decoding, and `.base64` for data encoding/decoding. This ensures that the data is properly encoded and decoded for the server communication.
    ///
    /// The test method performs the HTTP PUT request and awaits the response. The server is expected to respond with the updated user profile, and the test method validates the response by checking the updated name and job.
    ///
    /// The test method uses `XCTAssert` statements to verify that the response contains the updated name ("morpheus") and job ("zion resident") as expected.
    ///
    /// The test method may throw an error if there's an issue with the network request or decoding the response. In such cases, the test fails, and the error's localized description is printed to the console for debugging purposes.
    ///
    /// - Throws: An error if there's an issue with the network request or decoding the response.
    ///
    /// - Note: The test method uses the `UserProfileResponse` struct to represent the updated user profile returned by the server.
    private func testUpdateUser() async throws {
        let httpBody = UserProfileBody(name: "morpheus", job: "zion resident")
        let endpoint = Endpoint(
            decodeType: UserProfileResponse.self,
            path: "/api/users/2",
            httpMethod: .put,
            headers: [:],
            httpData: httpBody
        )
        endpoint.encoder.keyEncodingStrategy = .useDefaultKeys
        endpoint.encoder.dateEncodingStrategy = .iso8601
        endpoint.encoder.dataEncodingStrategy = .base64
        endpoint.decoder.keyDecodingStrategy = .useDefaultKeys
        endpoint.decoder.dateDecodingStrategy = .iso8601
        endpoint.decoder.dataDecodingStrategy = .base64
        do {
            let user = try await networkManager.sendData(forEndpoint: endpoint)
            XCTAssert(user.name == "morpheus", "The name for this user should be morpheus.")
            XCTAssert(user.job == "zion resident", "The job for this user should be zion resident.")
        } catch let error {
            print(error.localizedDescription)
            XCTFail()
        }
    }
    
}
