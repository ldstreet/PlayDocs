# PlayDocs 🏓
[![Build Status](https://travis-ci.org/ldstreet/PlayDocs.svg?branch=master)](https://travis-ci.org/ldstreet/PlayDocs)
![Swift Version](https://img.shields.io/badge/Swift-4.2-blue.svg)
[![SPM](https://img.shields.io/badge/spm-compatible-blue.svg)](https://swift.org/package-manager)
![Platforms](https://img.shields.io/badge/Platforms-macOS_Linux-blue.svg)
[![Git Version](https://img.shields.io/github/release/ldstreet/PlayDocs.svg)](https://github.com/ldstreet/PlayDocs/releases)
[![license](https://img.shields.io/github/license/ldstreet/PlayDocs.svg)](https://github.com/ldstreet/PlayDocs/blob/master/LICENSE)

PlayDocs is command line tool for converting Swift Playgrounds to Markdown and HTML. Playgrounds have supported rendering markdown from the beginning, so why not leverage that for generating documentation that can live both in your repository as executable code and on your wiki or blog as documention or a post?

## Usage

You can use PlayDocs both as a commandline tool or as a framework in your own code.

### Commandline Tool
Here is the basic command for generating a readme via a Playground:
```
playdocs convert ./MyPlayground.playground
```

And if you want it to output as html:
```
playdocs convert ./MyPlayground.playground --html
```

To open the converted file immediately have creation:
```
playdocs convert ./MyPlayground.playground --html --open
```

To specify a destination:
```
playdocs convert ./MyPlayground.playground --destination /path/to/file/MyFile.md --open
```

### Package
To make your conversions in swift, you can use `PlayDocsKit`

``` swift

// Convert swift source from a string to a markdown string
public func convertToMarkdown(text: String) -> String

// Convert swift source from a file to a markdown file
public func convertToMarkdown(from source: URL, to destination: URL) throws

// Convert swift source from a string to a html string
public func convertToHTML(text: String) throws -> String

// Convert swift source from a file to a html file
public func convertToHTML(from source: URL, to destination: URL) throws
```

## Installing

To install the commandline tool:


### [Mint](https://github.com/yonaskolb/mint)
```
$ mint install ldstreet/PlayDocs
```


### [Marathon](https://github.com/johnsundell/marathon)
Add to your Marathonfile:
```
marathon add https://github.com/ldstreet/PlayDocs.git
```
Or use the inline dependency syntax:

```swift
import Splash // https://github.com/ldstreet/PlayDocs.git
```


### Make

Run in terminal:
```
git clone https://github.com/ldstreet/PlayDocs.git && cd PlayDocs && make install
```


### [Swift Package Manager](https://swift.org/package-manager)
To use PlayDocsKit add the following to your `Package.swift` file.
```swift
// 🏓 A framework for converting Playgrounds and Swift files to markdown and html
.package(url: "https://github.com/ldstreet/PlayDocs.git", .branch("master")),

.target(name: "MyPackage", dependencies: ["PlayDocsKit"]),
```
