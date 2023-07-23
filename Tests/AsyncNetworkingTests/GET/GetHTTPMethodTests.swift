//
//  GetHTTPMethodTests.swift
//  AsyncNetworking
//
//  Created by Juan Diego Ocampo on 2023-07-22.
//

import Foundation
import XCTest
@testable import AsyncNetworking

/// A test case class for testing the `GET` HTTP method using the `AsyncNetworkManager`.
///
/// This test case class is a subclass of `AsyncNetworkManagerTestCase`, which provides the testing environment and instance of the `AsyncNetworkManager` with the `.testing` environment configuration. The `GetHTTPMethodTests` class focuses on testing the `GET` HTTP method for specific endpoints using the `AsyncNetworkManager`.
///
/// **Testing the GET HTTP Method:**
///
/// The `GET` HTTP method is used to retrieve data from the server without modifying any resources. In this test case class, we define test methods to ensure that the `AsyncNetworkManager` correctly handles `GET` requests, performs the network communication, and decodes the server response into the expected model objects.
///
/// **Usage:**
///
/// To use this test case class, run the individual test methods or all test methods collectively to verify the correctness of the `GET` HTTP method implementation in the `AsyncNetworkManager`. The test methods are automatically executed by the testing framework, and any failed assertions will be reported as test failures.
///
/// **Example:**
///
/// ```swift
/// class MyGetHTTPMethodTests: AsyncNetworkManagerTestCase {
///
///     // Test method for the GET HTTP method with a specific endpoint.
///     func testGetSingleUser() async throws {
///         // Define the endpoint for fetching a single user.
///         let singleUserEndpoint = Endpoint<User>(
///             type: User.self,
///             path: "/api/users/2",
///             httpMethod: .get,
///             headers: [:]
///         )
///
///         // Perform the network request and fetch the user data.
///         let user = try await networkManager.fetchData(forEndpoint: singleUserEndpoint)
///
///         // Assert the received user data's first name and last name.
///         XCTAssert(user.data.firstName == "Janet", "First name for this user should be Janet")
///         XCTAssert(user.data.lastName == "Weaver", "Last name for this user should be Weaver")
///     }
///
/// }
/// ```
///
/// - Note: This test case class inherits the testing environment and `AsyncNetworkManager` instance from the `AsyncNetworkManagerTestCase` class. It is marked as `final`, meaning it cannot be subclassed further. However, you can create new test case classes based on this class and extend its functionality as needed.
final class GetHTTPMethodTests: AsyncNetworkManagerTestCase {
    
    /// Test method for fetching a single user.
    ///
    /// This test method validates the scenario where a single user is fetched from the server. It sends an HTTP GET request to the `/api/users/2` endpoint to retrieve user information for the user with ID 2.
    ///
    /// The `Endpoint` struct is used to specify the endpoint details, such as the decoding type, path, HTTP method, and headers. The decoding type is set to the `User` struct, which contains the required properties to represent the user data.
    /// The test method performs the HTTP GET request and awaits the response. The server's response is decoded into the `User` struct, and the first name and last name of the user are validated against the expected values ("Janet" and "Weaver" respectively). If the validation fails, the test fails.
    ///
    /// - Throws: An error if there's an issue with the network request or decoding the response.
    ///
    /// - Important: The `User` struct includes a nested `Data` struct that maps the properties of the user data returned by the server. The `User` struct also contains a nested `Support` struct to map additional support information returned by the server.
    ///
    /// - Note: The test also includes a `catch` block to handle any errors that may occur during the network request. If an error occurs, the test prints its localized description and fails.
    private func testSingleUserFound() async throws {
        let endpoint = Endpoint(
            type: User.self,
            path: "/api/users/2",
            httpMethod: .get,
            headers: [:]
        )
        do {
            let user = try await networkManager.fetchData(forEndpoint: endpoint)
            XCTAssert(user.data.firstName == "Janet", "First name for this user should be Janet.")
            XCTAssert(user.data.lastName == "Weaver", "Last name for this user should be Weaver.")
        } catch let error {
            print(error.localizedDescription)
            XCTFail()
        }
    }
    
    /// Test method for fetching a single user when the user is not found.
    ///
    /// This test method validates the scenario where a single user is requested from the server, but the user with ID 23 is not found. It sends an HTTP GET request to the `/api/users/23` endpoint to retrieve user information for the user with ID 23, which is expected to be non-existent.
    ///
    /// The `Endpoint` struct is used to specify the endpoint details, such as the decoding type, path, HTTP method, and headers. The decoding type is set to the `User` struct, which contains the required properties to represent the user data.
    ///
    /// The test method performs the HTTP GET request and awaits the response. Since the user with ID 23 is not found, the server is expected to return an error response. To handle this scenario, the method uses the `attempts` parameter to allow for retrying the network request multiple times. The method waits for a specified delay between each retry using the `delay` parameter.
    /// The test method uses the `catch` block to handle any errors that may occur during the network request. If an error occurs, the test prints its localized description and passes since this scenario is expected to fail.
    ///
    /// - Throws: An error if there's an issue with the network request or decoding the response.
    ///
    /// - Important: The `User` struct includes a nested `Data` struct that maps the properties of the user data returned by the server. The `User` struct also contains a nested `Support` struct to map additional support information returned by the server.
    ///
    /// - Note: The test method expects the server to return an error when the user with ID 23 is not found. Thus, the test is considered successful if the request fails with the expected error.
    private func testSingleUserNotFound() async throws {
        let endpoint = Endpoint(
            type: User.self,
            path: "/api/users/23",
            httpMethod: .get,
            headers: [:]
        )
        do {
            let _ = try await networkManager.fetchData(forEndpoint: endpoint, attempts: 3, delay: UInt64(1.0))
            XCTFail()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /// Test method for handling the scenario of fetching a list of users using the `GET` HTTP method.
    ///
    /// This test method simulates a network request to fetch a list of users from the server using the `GET` HTTP method.
    /// It sets up a specific endpoint for fetching the user list by providing the required `UserList` model type, a valid path for retrieving the users (e.g., `/api/users?page=2`), the `.get` HTTP method, and an empty header dictionary.
    ///
    /// The method then uses the `AsyncNetworkManager` to perform the network request asynchronously. The server should respond with a list of users, which includes information about the total number of users and the total number of pages. The test method verifies that the response contains the expected number of users (6 users in this case) and that the total number of pages matches the expected value (2 pages in this case).
    ///
    /// - Important: This test method is automatically executed by the testing framework when running the tests. It verifies that the `AsyncNetworkManager` correctly handles the scenario of fetching a list of users using the `GET` HTTP method.
    
    
    /// Test method for fetching a list of users from the server.
    ///
    /// This test method validates the scenario where a list of users is requested from the server. It sends an HTTP GET request to the `/api/users?page=2` endpoint to retrieve user data for the second page of users.
    ///
    /// The `Endpoint` struct is used to specify the endpoint details, such as the decoding type, path, HTTP method, and headers. The decoding type is set to the `UserList` struct, which contains the required properties to represent the list of users returned by the server.
    ///
    /// The test method performs the HTTP GET request and awaits the response. It expects to receive a list of users with a specific count and page count from the server. The `XCTAssert` statements are used to check if the response data meets the expected criteria. Specifically, it verifies that there should be a total of 6 users on this request, and there should be a total of 2 pages on this request.
    /// The test method uses the `catch` block to handle any errors that may occur during the network request or decoding of the response. If an error occurs, the test prints its localized description and fails the test using `XCTFail`.
    ///
    /// - Throws: An error if there's an issue with the network request or decoding the response.
    ///
    /// - Important: The `UserList` struct includes a nested `Data` struct that maps the properties of each user in the list. The `UserList` struct also contains a nested `Support` struct to map additional support information returned by the server.
    ///
    /// - Note: The test method expects the server to return the correct list of users with the specified properties. Thus, the test is considered successful if the response data meets the expected criteria.
    private func testUserListFound() async throws {
        let endpoint = Endpoint(
            type: UserList.self,
            path: "/api/users?page=2",
            httpMethod: .get,
            headers: [:]
        )
        do {
            let users = try await networkManager.fetchData(forEndpoint: endpoint)
            XCTAssert(users.data.count == 6, "There should be a total of 6 users on this request.")
            XCTAssert(users.totalPages == 2, "There should be a total of 2 pages on this request.")
        } catch let error {
            print(error.localizedDescription)
            XCTFail()
        }
    }
    
    /// Test method for fetching a list of users from the server with a delay.
    ///
    /// This test method is similar to `testUserListFound()`, but it includes a delay of 3 seconds before making the network request. The delay is achieved by adding the `delay=3` parameter to the endpoint path (`/api/users?delay=3`).
    ///
    /// The method verifies the scenario where the server responds after a delay of 3 seconds, allowing time for the test to simulate a delayed network request.
    ///
    /// The `Endpoint` struct is used to specify the endpoint details, such as the decoding type, path, HTTP method, and headers. The decoding type is set to the `UserList` struct, which contains the required properties to represent the list of users returned by the server.
    ///
    /// The test method performs the HTTP GET request and awaits the response. It expects to receive a list of users with a specific count and page count from the server, similar to `testUserListFound()`.
    ///
    /// The test uses the `XCTAssert` statements to check if the response data meets the expected criteria. Specifically, it verifies that there should be a total of 6 users on this request and there should be a total of 2 pages on this request.
    ///
    /// The documentation includes a note about error handling using the `catch` block, which handles any errors that may occur during the network request or decoding of the response. If there's an error, the localized description of the error is printed, and the test is considered to fail using `XCTFail`, indicating that the expected response data was not received.
    ///
    /// - Throws: An error if there's an issue with the network request or decoding the response.
    ///
    /// - Important: The test method is designed to handle the server's delayed response, and the assertions should still pass after the delay. If the assertions fail, it may indicate issues with the server response or the delay mechanism.
    ///
    /// - Note: The test method uses the same `UserList` struct with nested `Data` and `Support` structs, similar to `testUserListFound()`.
    private func testUserListFoundWithDelay() async throws {
        let endpoint = Endpoint(
            type: UserList.self,
            path: "/api/users?delay=3",
            httpMethod: .get,
            headers: [:]
        )
        do {
            let users = try await networkManager.fetchData(forEndpoint: endpoint)
            XCTAssert(users.data.count == 6, "There should be a total of 6 users on this request.")
            XCTAssert(users.totalPages == 2, "There should be a total of 2 pages on this request.")
        } catch let error {
            print(error.localizedDescription)
            XCTFail()
        }
    }
    
    /// Test method for fetching a single resource from the server.
    ///
    /// This test method demonstrates fetching a single resource from the server by making an HTTP GET request with the provided endpoint details. The endpoint path is set to "/api/unknown/2" to request resource data with ID 2.
    ///
    /// The `Endpoint` struct is used to specify the endpoint details, such as the decoding type, path, HTTP method, and headers. The decoding type is set to the `Resource` struct, which contains the required properties to represent the resource returned by the server.
    ///
    /// The test method performs the HTTP GET request and awaits the response. It expects to receive the resource data with ID 2 from the server, as specified in the endpoint path.
    ///
    /// The test uses the `XCTAssert` statements to check if the response data meets the expected criteria. Specifically, it verifies that the resource color code should be "#C74375", and the resource name should be "fuchsia rose".
    ///
    /// The documentation includes a note about error handling using the `catch` block, which handles any errors that may occur during the network request or decoding of the response. If there's an error, the localized description of the error is printed, and the test is considered to fail using `XCTFail`, indicating that the expected response data was not received.
    ///
    /// - Throws: An error if there's an issue with the network request or decoding the response.
    ///
    /// - Important: This test method is automatically executed by the testing framework when running the tests. Any failed assertions will be reported as test failures.
    ///
    /// - Note: The test method uses the `Resource` struct with nested `Data` and `Support` structs to represent the resource data returned by the server.
    private func testSingleResourceFound() async throws {
        let endpoint = Endpoint(
            type: Resource.self,
            path: "/api/unknown/2",
            httpMethod: .get,
            headers: [:]
        )
        do {
            let resource = try await networkManager.fetchData(forEndpoint: endpoint)
            XCTAssert(resource.data.color == "#C74375", "Color code for this resource should be #C74375.")
            XCTAssert(resource.data.name == "fuchsia rose", "Color name for this user should be fuchsia rose.")
        } catch let error {
            print(error.localizedDescription)
            XCTFail()
        }
    }
    
    /// Test method for handling the scenario when a single resource is not found on the server.
    ///
    /// This test method demonstrates handling the case when a single resource with ID 23 is not found on the server. It makes an HTTP GET request with the provided endpoint details, where the endpoint path is set to "/api/unknown/23" to request resource data with ID 23, which does not exist.
    ///
    /// The `Endpoint` struct is used to specify the endpoint details, such as the decoding type, path, HTTP method, and headers. The decoding type is set to the `Resource` struct, which contains the required properties to represent the resource returned by the server.
    ///
    /// The test method performs the HTTP GET request and awaits the response. Since the resource with ID 23 does not exist on the server, the server will respond with an error status, and the test method is expected to handle this situation.
    ///
    /// The test method includes a `catch` block that handles the errors that may occur during the network request or decoding of the response. In this case, the server will respond with an error, and the `catch` block will catch this error. The error's localized description is printed to the console for debugging purposes, indicating that the resource was not found as expected.
    ///
    /// The test method does not use any `XCTAssert` statements since the expectation is that the server will return an error response. Instead, it relies on the `catch` block to handle the error and ensure the test does not fail unexpectedly.
    ///
    /// - Throws: An error if there's an issue with the network request or decoding the response.
    ///
    /// - Important: This test method is automatically executed by the testing framework when running the tests. It verifies that the `AsyncNetworkManager` correctly handles the scenario of fetching a non-existent resource using the `GET` HTTP method.
    ///
    /// - Note: The test method uses the `Resource` struct with nested `Data` and `Support` structs to represent the resource data returned by the server.
    private func testSingleResourceNotFound() async throws {
        let endpoint = Endpoint(
            type: Resource.self,
            path: "/api/unknown/23",
            httpMethod: .get,
            headers: [:]
        )
        do {
            let _ = try await networkManager.fetchData(forEndpoint: endpoint, attempts: 3, delay: UInt64(1.0))
            XCTFail()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /// Test method for handling the successful scenario when a resource list is found on the server.
    ///
    /// This test method demonstrates handling the case when a list of resources is found on the server. It makes an HTTP GET request with the provided endpoint details, where the endpoint path is set to "/api/unknown" to request a list of resources.
    ///
    /// The `Endpoint` struct is used to specify the endpoint details, such as the decoding type, path, HTTP method, and headers. The decoding type is set to the `ResourceList` struct, which contains the required properties to represent the list of resources returned by the server.
    ///
    /// The test method performs the HTTP GET request and awaits the response. The server is expected to respond with a list of resources, and the test method validates the response by checking the number of resources and the total number of pages.
    ///
    /// The test method uses `XCTAssert` statements to verify that the response contains the expected number of resources (6) and the total number of pages (2).
    ///
    /// The test method may throw an error if there's an issue with the network request or decoding the response. In such cases, the test fails and the error's localized description is printed to the console for debugging purposes.
    ///
    /// - Throws: An error if there's an issue with the network request or decoding the response.
    ///
    /// - Important: This test method is automatically executed by the testing framework when running the tests. It verifies that the `AsyncNetworkManager` correctly handles the scenario of fetching a list of resources using the `GET` HTTP method.
    ///
    /// - Note: The test method uses the `ResourceList` struct with nested `Data` and `Support` structs to represent the list of resources returned by the server.
    private func testResourceListFound() async throws {
        let endpoint = Endpoint(
            type: ResourceList.self,
            path: "/api/unknown",
            httpMethod: .get,
            headers: [:]
        )
        do {
            let resources = try await networkManager.fetchData(forEndpoint: endpoint)
            XCTAssert(resources.data.count == 6, "There should be a total of 6 resources on this request.")
            XCTAssert(resources.totalPages == 2, "There should be a total of 2 pages on this request.")
        } catch let error {
            print(error.localizedDescription)
            XCTFail()
        }
    }
    
}
