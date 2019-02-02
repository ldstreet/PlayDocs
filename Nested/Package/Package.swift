// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PlayDocs",
    products: [
        .executable(name: "playdocs", targets: ["PlayDocs"]),
        .library(name: "PlayDocsKit", targets: ["PlayDocsKit"])
    ],
    dependencies: [
        /// 💻 APIs for creating interactive CLI tools.
        .package(url: "https://github.com/vapor/console.git", from: "3.0.0"),
        
        .package(url: "https://github.com/vapor-community/markdown.git", from: "0.4.0"),
        
        .package(url: "https://github.com/JohnSundell/Splash", from: "0.1.4"),
        
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "1.7.4"),
        
        .package(url: "https://github.com/pointfreeco/swift-overture.git", from: "0.3.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "PlayDocs",
            dependencies: ["Console", "Command", "PlayDocsKit", "Overture"]
        ),
        .target(
            name: "PlayDocsKit",
            dependencies: ["Splash", "SwiftSoup", "SwiftMarkdown"]
        ),
        .testTarget(
            name: "PlayDocsKitTests",
            dependencies: ["PlayDocsKit"]
        ),
    ]
)
