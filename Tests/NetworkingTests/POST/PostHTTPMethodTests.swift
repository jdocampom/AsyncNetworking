//
//  PostHTTPMethodTests.swift
//  Networking
//
//  Created by Juan Diego Ocampo on 11.28.2024.
//

import Foundation
import XCTest
@testable import AsyncNetworking

/// A test case class for testing the `POST` HTTP method using the `NetworkManager`.
///
/// This test case class is a subclass of `AsyncNetworkManagerTestCase`, which provides the testing environment and instance of the `NetworkManager` with the `.testing` environment configuration. The `PostHTTPMethodTests` class focuses on testing the `POST` HTTP method for specific endpoints using the `NetworkManager`.
///
/// **Testing the POST HTTP Method:**
///
/// The `post` HTTP method is used to retrieve data from the server while modifying some resources. In this test case class, we define test methods to ensure that the `NetworkManager` correctly handles `POST` requests, performs the network communication, and decodes the server response into the expected model objects.
///
/// **Usage:**
///
/// To use this test case class, run the individual test methods or all test methods collectively to verify the correctness of the `POST` HTTP method implementation in the `NetworkManager`. The test methods are automatically executed by the testing framework, and any failed assertions will be reported as test failures.
///
/// **Example:**
///
/// ```swift
/// class MyPostHTTPMethodTests: AsyncNetworkManagerTestCase {
///
///     // Test method for the POST HTTP method with a specific endpoint.
///     func testCreateUser() async throws {
///         // Create an Encodable object to hold the data that will be attached to the request as the httpBody.
///         let httpBody = UserProfileBody(name: "morpheus", job: "leader")
///         // Define the endpoint for creating a single user.
///         let endpoint = Endpoint(
///             decodeType: UserProfileResponse.self,
///             path: "/api/users",
///             httpMethod: .post,
///             headers: [:],
///             httpData: httpBody
///         )
///
///         // Perform the network request and fetch the user data.
///         let user = try await try await networkManager.sendData(for: endpoint)
///
///         // Assert the received user data's name and ID.
///         XCTAssert(user.name == "morpheus", "The name for this user should be morpheus.")
///         XCTAssert(user.id == "949", "The ID for this user should be 949.")
///     }
///
/// }
/// ```
///
/// - Note: This test case class inherits the testing environment and `NetworkManager` instance from the `AsyncNetworkManagerTestCase` class. It is marked as `final`, meaning it cannot be subclassed further. However, you can create new test case classes based on this class and extend its functionality as needed.
final class PostHTTPMethodTests: AsyncNetworkManagerTestCase {
    
    /// Test method for creating a new user.
    ///
    /// This test method validates the successful creation of a new user by sending an HTTP POST request to the `/api/users` endpoint with the specified `httpBody`. The `UserProfileBody` struct is used to define the data that will be sent in the request body. The `Endpoint` struct is used to specify the endpoint details, such as the decoding type, path, HTTP method, headers, and the provided `httpData`.
    /// After sending the HTTP POST request and receiving the response, the test method performs assertions to verify the correctness of the user's name and ID in the `UserProfileResponse`. If the test fails, an error is thrown, and the test case will fail.
    ///
    /// - Throws: An error if the test fails or if there's an issue with the network request.
    ///
    /// - Important: The decoding strategy for the response is also configured within this method. The `UserProfileResponse` struct is used as the `decodeType` to ensure that the server's response is correctly mapped to this structure during the decoding process. The `UserProfileResponse` struct contains information about the newly created user, such as the user's name, ID, job, and creation date.
    ///
    /// - Note: The decoding strategies for the keys, dates, and data are also set to `.useDefaultKeys`, `.iso8601`, and `.base64`, respectively. These decoding strategies ensure that the server's response is accurately mapped to the corresponding properties within the `UserProfileResponse` struct.
    private func testCreateUser() async throws {
        let httpBody = UserProfileBody(name: "morpheus", job: "leader")
        let endpoint = Endpoint(
            decodeType: UserProfileResponse.self,
            path: "/api/users",
            httpMethod: .post,
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
            XCTAssert(user.id == "949", "The ID for this user should be 949.")
        } catch let error {
            print(error.localizedDescription)
            XCTFail()
        }
    }
    
    /// Test method for successful user registration.
    ///
    /// This test method validates the successful registration of a user by sending an HTTP POST request to the `/api/register` endpoint with the specified `httpBody`. The `UserRegistrationSuccessBody` struct is used to define the user's email and password, which are included in the request body.
    ///
    /// The `Endpoint` struct is used to specify the endpoint details, such as the decoding type, path, HTTP method, headers, and the provided `httpData`.
    /// After sending the HTTP POST request and receiving the response, the test method performs assertions to verify the correctness of the user's ID and token in the `UserRegistrationSuccessResponse`. If the test fails, an error is thrown, and the test case will fail.
    ///
    /// - Throws: An error if the test fails or if there's an issue with the network request.
    ///
    /// - Important: The decoding strategy for the response is also configured within this method. The `UserRegistrationSuccessResponse` struct is used as the `decodeType` to ensure that the server's response is correctly mapped to this structure during the decoding process. The `UserRegistrationSuccessResponse` struct contains the user's ID and registration token upon successful registration.
    ///
    /// - Note: The decoding strategies for the keys, dates, and data are set to `.useDefaultKeys`, `.iso8601`, and `.base64`, respectively. These decoding strategies ensure that the server's response is accurately mapped to the corresponding properties within the `UserRegistrationSuccessResponse` struct.
    private func testSuccessfulUserRegistration() async throws {
        let httpBody = UserRegistrationSuccessBody(email: "eve.holt@reqres.in", password: "pistol")
        let endpoint = Endpoint(
            decodeType: UserRegistrationSuccessResponse.self,
            path: "/api/register",
            httpMethod: .post,
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
            XCTAssert(user.id == 4, "The ID for this user should be 4.")
            XCTAssert(user.token == "949", "The token for this user should be QpwL5tke4Pnpja7X4.")
        } catch let error {
            print(error.localizedDescription)
            XCTFail()
        }
    }
    
    /// Test method for failed user registration.
    ///
    /// This test method validates the handling of a failed user registration by sending an HTTP POST request to the `/api/register` endpoint with the provided `httpBody`. The `UserRegistrationFailedBody` struct is used to define the user's email, which is included in the request body.
    ///
    /// The `Endpoint` struct is used to specify the endpoint details, such as the decoding type, path, HTTP method, headers, and the provided `httpData`.
    /// The test method performs the HTTP POST request and awaits the response. Since the registration is expected to fail, the test method uses the `attempts` parameter to retry the request multiple times with a delay between each retry (`delay`). In this case, the test method sets `attempts` to 3 and `delay` to 1 second.
    ///
    /// - Throws: An error if the test case fails or if there's an issue with the network request.
    ///
    /// - Important: The decoding strategy for the response is also configured within this method. The `UserRegistrationFailedResponse` struct is used as the `decodeType` to ensure that the server's error response is correctly mapped to this structure during the decoding process. The `UserRegistrationFailedResponse` struct contains the error message returned by the server upon a failed registration attempt.
    ///
    /// - Note: The decoding strategies for the keys, dates, and data are set to `.useDefaultKeys`, `.iso8601`, and `.base64`, respectively. These decoding strategies ensure that the server's error response is accurately mapped to the corresponding properties within the `UserRegistrationFailedResponse` struct.
    private func testFailedUserRegistration() async throws {
        let httpBody = UserRegistrationFailedBody(email: "sydney@fife")
        let endpoint = Endpoint(
            decodeType: UserRegistrationFailedResponse.self,
            path: "/api/register",
            httpMethod: .post,
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
            let _ = try await networkManager.sendData(forEndpoint: endpoint, attempts: 3, delay: UInt64(1.0))
            XCTFail()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /// Test method for successful user login.
    ///
    /// This test method validates the successful login scenario by sending an HTTP POST request to the `/api/login` endpoint with the provided `httpBody`. The `LoginSuccessBody` struct is used to define the user's email and password, which are included in the request body.
    ///
    /// The `Endpoint` struct is used to specify the endpoint details, such as the decoding type, path, HTTP method, headers, and the provided `httpData`.
    /// The test method performs the HTTP POST request and awaits the response. If the login is successful, the user's authentication token is verified against the expected value ("QpwL5tke4Pnpja7X4"). If the assertion fails, the test will also fail.
    ///
    /// - Throws: An error if the test case fails or if there's an issue with the network request.
    ///
    /// - Important: The decoding strategy for the response is also configured within this method. The `LoginSuccessResponse` struct is used as the `decodeType` to ensure that the server's response is correctly mapped to this structure during the decoding process. The `LoginSuccessResponse` struct contains the user's authentication token returned by the server upon successful login.
    ///
    /// - Note: The decoding strategies for the keys, dates, and data are set to `.useDefaultKeys`, `.iso8601`, and `.base64`, respectively. These decoding strategies ensure that the server's response is accurately mapped to the corresponding properties within the `LoginSuccessResponse` struct.
    private func testSuccessfulLogin() async throws {
        let httpBody = LoginSuccessBody(email: "eve.holt@reqres.in", password: "cityslicka")
        let endpoint = Endpoint(
            decodeType: LoginSuccessResponse.self,
            path: "/api/login",
            httpMethod: .post,
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
            XCTAssert(user.token == "QpwL5tke4Pnpja7X4", "The token for this user should be QpwL5tke4Pnpja7X4.")
        } catch let error {
            print(error.localizedDescription)
            XCTFail()
        }
    }
    
    /// Test method for failed user login.
    ///
    /// This test method validates the scenario where the user login attempt fails due to incorrect credentials. It sends an HTTP POST request to the `/api/register` endpoint with the provided `httpBody`, which contains an invalid email. The `LoginFailedBody` struct is used to define the user's email for the login attempt.
    ///
    /// The `Endpoint` struct is used to specify the endpoint details, such as the decoding type, path, HTTP method, headers, and the provided `httpData`.
    /// The test method performs the HTTP POST request and awaits the response. Since the login attempt is expected to fail, the test catches the error and prints its localized description. The test passes if the error is caught without triggering a failure.
    ///
    /// - Throws: An error if there's an issue with the network request.
    ///
    /// - Important: The decoding strategy for the response is also configured within this method. The `LoginFailedResponse` struct is used as the `decodeType` to ensure that the server's response is correctly mapped to this structure during the decoding process. The `LoginFailedResponse` struct contains an error message returned by the server indicating the login failure.
    ///
    /// - Note: The decoding strategies for the keys, dates, and data are set to `.useDefaultKeys`, `.iso8601`, and `.base64`, respectively. These decoding strategies ensure that the server's response is accurately mapped to the corresponding properties within the `LoginFailedResponse` struct.
    private func testFailedLogin() async throws {
        let httpBody = LoginFailedBody(email: "peter@klaven")
        let endpoint = Endpoint(
            decodeType: LoginFailedResponse.self,
            path: "/api/register",
            httpMethod: .post,
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
            let _ = try await networkManager.sendData(forEndpoint: endpoint, attempts: 3, delay: UInt64(1.0))
            XCTFail()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
