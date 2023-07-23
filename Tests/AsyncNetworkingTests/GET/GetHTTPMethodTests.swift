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
/// **Test Scenario:**
///
/// The `testSingleUserEndpoint()` method simulates a network request to fetch a single user's data from the server. It sets up a specific endpoint for fetching user data by providing the required `User` model type, the path for the user API, the `.get` HTTP method, and an empty header dictionary.
///
/// The method then uses the `AsyncNetworkManager` to perform the network request asynchronously, fetches the user data, and decodes the server response into a `User` model object. It asserts the received user data's first name and last name, ensuring that they match the expected values.
///
/// **Usage:**
///
/// To use this test case class, run the individual test methods or all test methods collectively to verify the correctness of the `GET` HTTP method implementation in the `AsyncNetworkManager`. The test methods are automatically executed by the testing framework, and any failed assertions will be reported as test failures.
///
/// **Example:**
///
/// ```swift
/// class GetHTTPMethodTests: GetHTTPMethodTests {
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
    
    /// Test method for testing the GET HTTP method with a specific endpoint.
    ///
    /// This method simulates a network request to fetch a single user's data from the server using the `GET` HTTP method.
    /// It sets up a specific endpoint for fetching user data by providing the required `User` model type, the path for the user API, the `.get` HTTP method, and an empty header dictionary.
    ///
    /// The method then uses the `AsyncNetworkManager` to perform the network request asynchronously, fetches the user data, and decodes the server response into a `User` model object. It asserts the received user data's first name and last name, ensuring that they match the expected values.
    ///
    /// - Important: This test method is automatically executed by the testing framework when running the tests. Any failed assertions will be reported as test failures.
    func testSingleUserFound() async throws {
        let endpoint = Endpoint(
            type: User.self,
            path: "/api/users/2",
            httpMethod: .get,
            headers: [:]
        )
        do {
            let user = try await networkManager.fetchData(forEndpoint: endpoint)
            XCTAssert(user.data.firstName == "Janet", "First name for this user should be Janet")
            XCTAssert(user.data.lastName == "Weaver", "Last name for this user should be Weaver")
        } catch let error {
            print(error.localizedDescription)
            XCTFail()
        }
    }
    
    /// Test method for handling the scenario of fetching a single user that does not exist (not found) using the `GET` HTTP method.
    ///
    /// This test method simulates a network request to fetch a single user's data from the server using the `GET` HTTP method.
    /// It sets up a specific endpoint for fetching user data by providing the required `User` model type, an invalid path for a non-existent user API (e.g., `/api/users/23`), the `.get` HTTP method, and an empty header dictionary.
    ///
    /// The method then uses the `AsyncNetworkManager` to perform the network request asynchronously. Since the provided endpoint does not correspond to any existing user, the request is expected to fail, and the server should respond with a `404 Not Found` status code. The test method catches the expected error and prints its localized description for debugging purposes.
    ///
    /// - Important: This test method is automatically executed by the testing framework when running the tests. It verifies that the `AsyncNetworkManager` correctly handles the scenario of fetching a non-existent user using the `GET` HTTP method.
    func testSingleUserNotFound() async throws {
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
    func testUserListFound() async throws {
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
    
    /// Test method for handling the scenario of fetching a list of users using the `GET` HTTP method with a time delay to simulate a bad network connection..
    ///
    /// This test method simulates a network request to fetch a list of users from the server using the `GET` HTTP method.
    /// It sets up a specific endpoint for fetching the user list by providing the required `UserList` model type, a valid path for retrieving the users (e.g., `/api/users?page=2`), the `.get` HTTP method, and an empty header dictionary.
    ///
    /// The method then uses the `AsyncNetworkManager` to perform the network request asynchronously. The server should respond with a list of users, which includes information about the total number of users and the total number of pages. The test method verifies that the response contains the expected number of users (6 users in this case) and that the total number of pages matches the expected value (2 pages in this case).
    ///
    /// - Important: This test method is automatically executed by the testing framework when running the tests. It verifies that the `AsyncNetworkManager` correctly handles the scenario of fetching a list of users using the `GET` HTTP method.
    func testUserListFoundWithDelay() async throws {
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
    
    /// Test method for testing the GET HTTP method with a specific endpoint.
    ///
    /// This method simulates a network request to fetch a single resource's data from the server using the `GET` HTTP method.
    /// It sets up a specific endpoint for fetching user data by providing the required `Resource` model type, the path for the user API, the `.get` HTTP method, and an empty header dictionary.
    ///
    /// The method then uses the `AsyncNetworkManager` to perform the network request asynchronously, fetches the user data, and decodes the server response into a `Resource` model object. It asserts the received user data's color and name, ensuring that they match the expected values.
    ///
    /// - Important: This test method is automatically executed by the testing framework when running the tests. Any failed assertions will be reported as test failures.
    func testSingleResourceFound() async throws {
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
    
    /// Test method for handling the scenario of fetching a single resource that does not exist (not found) using the `GET` HTTP method.
    ///
    /// This test method simulates a network request to fetch a single resource's data from the server using the `GET` HTTP method.
    ///  It sets up a specific endpoint for fetching user data by providing the required `Resource` model type, an invalid path for a non-existent resource API (e.g., `/api/unknown/23`), the `.get` HTTP method, and an empty header dictionary.
    ///
    /// The method then uses the `AsyncNetworkManager` to perform the network request asynchronously. Since the provided endpoint does not correspond to any existing resource, the request is expected to fail, and the server should respond with a `404 Not Found` status code. The test method catches the expected error and prints its localized description for debugging purposes.
    ///
    /// - Important: This test method is automatically executed by the testing framework when running the tests. It verifies that the `AsyncNetworkManager` correctly handles the scenario of fetching a non-existent resource using the `GET` HTTP method.
    func testSingleResourceNotFound() async throws {
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
    
    /// Test method for handling the scenario of fetching a list of resources using the `GET` HTTP method.
    ///
    /// This test method simulates a network request to fetch a list of resources from the server using the `GET` HTTP method.
    /// It sets up a specific endpoint for fetching the resource list by providing the required `Resource` model type, a valid path for retrieving the users (e.g., `/api/unknown`), the `.get` HTTP method, and an empty header dictionary.
    ///
    /// The method then uses the `AsyncNetworkManager` to perform the network request asynchronously. The server should respond with a list of resources, which includes information about the total number of resources and the total number of pages. The test method verifies that the response contains the expected number of resources (6 users in this case) and that the total number of pages matches the expected value (2 pages in this case).
    ///
    /// - Important: This test method is automatically executed by the testing framework when running the tests. It verifies that the `AsyncNetworkManager` correctly handles the scenario of fetching a list of resources using the `GET` HTTP method.
    func testResourceListFound() async throws {
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
