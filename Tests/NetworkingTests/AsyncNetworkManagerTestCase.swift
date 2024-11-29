//
//  AsyncNetworkManagerTestCase.swift
//  Networking
//
//  Created by Juan Diego Ocampo on 11.28.2024.
//

import Foundation
import XCTest
@testable import AsyncNetworking

/// A test case class for testing the functionality of the `NetworkManager` class.
///
/// This test case class inherits from `XCTestCase`, which is the base class for all test cases. It is used to test the behavior and functionality of the `NetworkManager` class, which is responsible for managing asynchronous network requests and responses in the application.
///
/// The `AsyncNetworkManagerTestCase` class sets up an instance of the `NetworkManager` with a specific environment for testing. It also conforms to the `URLSessionTaskDelegate` protocol, allowing it to receive delegate callbacks from `URLSession` tasks and enabling customized handling of tasks in the testing environment.
///
/// **Testing the NetworkManager:**
///
/// The `NetworkManager` is a critical component of the application that handles network requests and responses asynchronously. Asynchronous behavior can be challenging to test using traditional unit testing approaches. However, the `AsyncNetworkManagerTestCase` class provides an appropriate testing environment for the `NetworkManager` by leveraging the `URLSessionTaskDelegate` protocol to handle tasks in a controlled manner.
///
/// **Setting Up the Testing Environment:**
///
/// The `AsyncNetworkManagerTestCase` class sets up a test environment using the `.testing` environment configuration. This configuration is designed specifically for testing purposes and typically uses a mock server or predefined responses to simulate network behavior. By initializing the `NetworkManager` with the testing environment, the test cases can run in isolation and without affecting the production environment or actual network resources.
///
/// **Customized Task Handling:**
///
/// Conforming to the `URLSessionTaskDelegate` protocol allows the `AsyncNetworkManagerTestCase` class to receive delegate callbacks for `URLSession` tasks. This capability is beneficial in a testing environment, where we can customize task behaviors, mock responses, and test edge cases. By implementing the delegate methods, the class can intercept tasks and respond with predefined data, which makes testing various scenarios easier and more efficient.
///
/// **Usage:**
///
/// To use this test case class, subclass it as needed and write test methods to verify the functionality of the `NetworkManager`. You can use the `networkManager` property within your test methods to interact with the `NetworkManager` and assert the expected results for different network requests.
///
/// **Example:**
///
/// ```swift
/// class MyNetworkManagerTestCase: AsyncNetworkManagerTestCase {
///
///     // Test method for fetching data from the server.
///     func testFetchData() async throws {
///         // Define an endpoint for testing.
///         let endpoint = Endpoint<MyModel>(path: "/api/data", httpMethod: .get, headers: [:])
///
///         // Perform the network request and receive the response.
///         let responseData: MyModel = try await networkManager.fetchData(for: endpoint)
///
///         // Assert the received data or perform additional tests.
///         XCTAssertNotNil(responseData)
///     }
///
///     // Other test methods can be added here.
///
/// }
/// ```
///
/// - Important: The test case class is marked as `final`, which means it cannot be subclassed further. However, you can create new test case classes based on this class and extend its functionality as needed.
class AsyncNetworkManagerTestCase: XCTestCase {
    
    /// The `NetworkManager` instance used for testing network requests and responses.
    ///
    /// This property creates an instance of the `NetworkManager` with the `.testing` environment configuration and a custom delegate (conforming to `URLSessionTaskDelegate`). Note that this property provides an isolated testing environment for the `NetworkManager`, allowing you to perform network requests without affecting the production environment or actual network resources.
    ///
    /// - Note: The lazy initialization ensures that the `networkManager` instance is created only when it is first accessed, reducing resource consumption during the test setup.
    lazy var networkManager: AsyncNetworkManager = {
        let manager = AsyncNetworkManager(
            environment: .testing,
            delegate: nil
        )
        return manager
    }()
    
}
