import XCTest
@testable import AsyncNetworking

final class AsyncNetworkingTests: XCTestCase {
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
    }
}

// MARK: - Static Properties and Methods

extension AppEnvironment {
    
    /// A demo `AppEnvironment` value used for testing purposes.
    internal static let testing = AppEnvironment(
        named: "AsyncNetworkingTests",
        usingHost: "reqres.in",
        andSession: {
            let configuration = URLSessionConfiguration.ephemeral
            configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            return URLSession(configuration: configuration)
        }()
    )
    
}
