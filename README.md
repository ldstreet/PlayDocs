[![Build Status](https://travis-ci.org/ldstreet/PlayDocs.svg?branch=master)](https://travis-ci.org/ldstreet/PlayDocs)

# PlayDocs
Command line tool for converting Swift Playgrounds to Markdown and HTML.

## Install

To install the commandline tool:
```
git clone https://github.com/ldstreet/PlayDocs.git`
cd PlayDocs
make install
```

To use PlayDocsKit add the following to your `Package.swift` file.
```swift
// 🏓 A framework for converting Playgrounds and Swift files to markdown and html
.package(url: "https://github.com/ldstreet/PlayDocs.git", .branch("master")),

.target(name: "MyPackage", dependencies: ["PlayDocsKit"]),
```



