// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

//
//  Package.swift
//  Networking
//
//  Created by Juan Diego Ocampo on 11.28.2024.
//

#if canImport(PackageDescription)

import PackageDescription

/// A `String` literal which indicates the name of the Swift package.
///
/// The package name is used to identify the package in the Swift Package Index,
/// and is used to generate the name of the package directory.
///
private let packageName = "Networking"

/// An array of `SupportedPlatform` values which defines the minimum
/// supported platforms for the `Networking` library.
///
/// The supported platforms are the operating systems on which the package can be used.
/// The package will not work on earlier versions of these platforms.
///
private let supportedPlatforms: [SupportedPlatform] = [
    .iOS(.v15),
    .macOS(.v12),
    .watchOS(.v8),
    .tvOS(.v15)
]

/// An array of `Product` objects which defines the products produced
/// by the `Networking` package, which are the executables or libraries
/// exposed to other packages that depend on yours.
///
/// Products define the executables and libraries a package produces,
/// making them visible to other packages.
///
private let products: [Product] = [
    .library(name: "Networking", targets: ["Networking"])
]

/// An array of `Package.Dependency` objects which defines the external
/// dependencies required by the `Networking` package.
///
/// Each `Package.Dependency` object specifies a package that the library
/// depends on, along with the minimum version required.
///
private let dependencies: [Package.Dependency] = []

/// An array of `Target` objects which defines the targets in the `Networking` library.
///
/// Targets are the basic building blocks of a package, defining a module or a test suite.
/// These can depend on other targets in this package and products from dependencies.
///
private let targets: [Target] = [
    .target(name:  "Networking"),
    .testTarget(name: "NetworkingTests", dependencies: ["Networking"])
]

/// The `Package` object that represents the main configuration for the `Networking` package manifest.
///
/// A package is a collection of Swift source files that are compiled together.
/// The manifest is a file that contains the metadata about the package.
///
let package = Package(
    name: packageName,
    platforms: supportedPlatforms,
    products: products,
    dependencies: dependencies,
    targets: targets
)

#endif
