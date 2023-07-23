# AsyncNetworkKit

> `AsyncNetworkKit` is a Swift framework that provides a powerful and easy-to-use networking abstraction for making asynchronous network requests with async/await support. It simplifies the process of fetching data from RESTful APIs and handling responses using modern Swift features.

[![Swift 5.8][swift-image]][swift-url]
[![License][license-image]][license-url]

The framework comes with the following features:

- Asynchronous networking: Make asynchronous network requests using async/await and Combine.
- HTTP methods: Supports common HTTP methods, such as GET, POST, PUT, DELETE, etc.
- Codable support: Easily decode and encode JSON data using Codable.
- Retry mechanism: Implement a retry mechanism for failed network requests with configurable attempts and delay.
- Environment-based configuration: Configure different network environments (e.g., production, testing, staging) using the EnvironmentValues SwiftUI struct.

## Installation

To integrate AsyncNetworkManager into your Xcode project, you can use Swift Package Manager. Simply add the package dependency to your project's Package.swift file:

```swift
dependencies: [
    .package(url: "https://github.com/example/AsyncNetworkKit.git", from: "1.0.0")
]
```

## Basic Usage

- 1: Import the framework:

```swift
import AsyncNetworkKit

```

- 2:  Create an instance of `AsyncNetworkManager`:

```swift
let environment = AsyncNetworkManager(named: "Testing", usingHost: "reqres.io", session: .shared)
let networkManager = AsyncNetworkManager(environment: environment, delegate: nil)

```

- 3:  Define an `Endpoint` instance for your API endpoint:

```swift
let endpoint = Endpoint(type: YourCodableSwiftModel.self,path: "/api/unknown", httpMethod: .get, headers: [:])
```

- 4:  Perform the network request:

```swift
do {
    let response = try await networkManager.fetchData(forEndpoint: endpoint)
    // Do something with the received data...
} catch let error {
    // Handle errors..
    print(error.localizedDescription)
}
```

## Advanced Usage

### Retry Mechanism

`AsyncNetworkKit` provides a built-in retry mechanism for failed network requests. You can specify the number of retry attempts and the delay between attempts. Here's an example of making a network request with retries:

```swift
do {
    let response = try await networkManager.fetchData(forEndpoint: endpoint, attempts: 3, delay: UInt64(1.0))
    // Do something with the received data...
} catch let error {
    // Handle errors..
    print(error.localizedDescription)
}
```

### Environment Configuration

`AsyncNetworkKit` supports different network environments (e.g., production, testing, staging) using the `EnvironmentValues` SwiftUI struct. You can configure different environments for your app and pass them along down the SwiftUI view hierarchy using the `asyncNetworkManager` `@Environment" key. Here's how you can set up and share an environment:

```swift

// Main App struct
@main
struct YourApp: App {

    let environment = AsyncNetworkManager(named: "Testing", usingHost: "reqres.io", session: .shared)
    @StateObject var networkManager = AsyncNetworkManager(environment: environment, delegate: nil)

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.asyncNetworkManager, networkManager)
        }
    }
    
}

// Content View 

struct ContentView: View {

    @Environment(\.asyncNetworkManager) var networkManager
    
    var body: some View {
        Text("Hello, world!")
    }

}
```

### Environment Configuration

You can customize the encoding and decoding strategies for the HTTP request and response using the `encoder` and `decoder `properties of the `Endpoint` class. For example:

```swift
let httpBody = UserProfileBody(name: "morpheus", job: "leader") // The Encodable Swift model to be sent as the request's httpBody property.
let endpoint = Endpoint(decodeType: YourCodableSwiftModel.self, path: "/api/users", httpMethod: .post, headers: [:], httpData: httpBody)
endpoint.encoder.keyEncodingStrategy = .useDefaultKeys
endpoint.encoder.dateEncodingStrategy = .iso8601
endpoint.encoder.dataEncodingStrategy = .base64
endpoint.decoder.keyDecodingStrategy = .useDefaultKeys
endpoint.decoder.dateDecodingStrategy = .iso8601
endpoint.decoder.dataDecodingStrategy = .base64
```

## Requirements

- Swift 5.5+
- iOS 15.0+ / macOS 12.0+ / tvOS 15.0+ / watchOS 8.0+

## Release History

* 1.0
    * Intial release.
* 1.1
    * Added unit test cases.
* 1.2
    * Added documentation.
* 1.3
    * Added README and LICENSE.
* 1.4
    * Added methods to check if the response code for a request is valid without expecting a response from the server.
    * Added test case for the DELETE HTTP method type.
* 1.5
    * Updated README.
* 1.6
    * Work in progress.

## License

The `AsyncNetworkKit` framework is available under the MIT license. See the LICENSE file for more info.

## Contributing

Pull requests and bug reports are welcome! If you'd like to contribute to AsyncNetworkManager, please open an issue or submit a pull request with your changes.

## Acknowledgments

This framework was inspired by the need for a modern and easy to use networking library that supports async/await out of the box in Swift.

## Contact

If you have any questions or suggestions, feel free to contact me at gummy_pond0v@icloud.com or at my Twitter account [@jdocampom_0117](https://twitter.com/jdocampom_0117).

[swift-image]:https://img.shields.io/badge/swift-5.8-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
