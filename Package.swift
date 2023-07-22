// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

//
//  Package.swift
//  AsyncNetworking
//
//  Created by Juan Diego Ocampo on 2023-07-22.
//

import PackageDescription

/// A `String` literal which indicates the name of the Swift package.
private let packageName = "AsyncNetworking"

/// An array of `SupportedPlatform` values which defines the minimum supported platforms for the `AsyncNetworking` library.
private let supportedPlatforms: [SupportedPlatform] = [
    .iOS(.v15),
    .macOS(.v12),
    .watchOS(.v8),
    .tvOS(.v15)
]

/// An array of `Product` objects which defines the products produced by the `AsyncNetworking` package, which are the executables or libraries exposed to other packages that depend on yours.
///
/// Products define the executables and libraries a package produces, making them visible to other packages.
private let products: [Product] = [
    .library(name: "AsyncNetworking", targets: ["AsyncNetworking"])
]

/// An array of `Package.Dependency` objects which defines the external dependencies required by the `AsyncNetworking` package.
///
/// Each `Package.Dependency` object specifies a package that the library depends on, along with the minimum version required.
private let dependencies: [Package.Dependency] = []

/// An array of `Target` objects which defines the targets in the `AsyncNetworking` library.
///
/// Targets are the basic building blocks of a package, defining a module or a test suite. These can depend on other targets in this package and products from dependencies.
private let targets: [Target] = [
    .target(name:  "AsyncNetworking"),
    .testTarget(name: "AsyncNetworkingTests", dependencies: ["AsyncNetworking"])
]

/// The `Package` object that represents the main configuration for the `AsyncNetworking` Swift package manifest.
let package = Package(
    name: packageName,
    platforms: supportedPlatforms,
    products: products,
    dependencies: dependencies,
    targets: targets
)
