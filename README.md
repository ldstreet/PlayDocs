#  PlayDocs 🏓
[![Build Status](https://travis-ci.org/ldstreet/PlayDocs.svg?branch=master)](https://travis-ci.org/ldstreet/PlayDocs)
![Swift Version](https://img.shields.io/badge/Swift-4.2-blue.svg)
[![SPM](https://img.shields.io/badge/spm-compatible-blue.svg)](https://swift.org/package-manager)
![Platforms](https://img.shields.io/badge/Platforms-macOS_Linux-blue.svg)
[![Git Version](https://img.shields.io/github/release/ldstreet/PlayDocs.svg)](https://github.com/ldstreet/PlayDocs/releases)
[![license](https://img.shields.io/github/license/ldstreet/PlayDocs.svg)](https://github.com/ldstreet/PlayDocs/blob/master/LICENSE)
[![Twitter](https://img.shields.io/badge/Twitter-@street_luke-blue.svg)](https://twitter.com/street_luke)

## 💡 Overview 

PlayDocs is command line tool for converting Swift Playgrounds to Markdown and HTML. Playgrounds have supported rendering markdown from the beginning, so why not leverage that for generating documentation that can live both in your repository as executable code and on your wiki or blog as documention or a post?

## ⚙️ Usage

You can use PlayDocs both as a commandline tool or as a framework in your own code.

### As a commandline tool...

####  Convert
Here is the basic command for generating a markdown file via a Playground:
```
playdocs convert ./MyPlayground.playground --open
```

And if you want it to output as html:
```
playdocs convert ./MyPlayground.playground --html --open
```

To specify a destination:
```
playdocs convert ./MyPlayground.playground --destination /path/to/file/MyFile.md --open
```

#### New
PlayDocs can also help you easily create new Playground files so you can get your doc started fast:
```
playdocs new HelloPlayDocs --open
```

If you want the Playground to target MacOS:
```
playdocs new HelloPlayDocs --macos --open
```
And if you don't want any boilerplate in your Playground:
```
playdocs new HelloPlayDocs --macos --empty --open
```

### As a package...
To make your conversions in swift, you can use `PlayDocsKit`

``` swift

// Convert swift source from a swift source string to a markdown string
public func convertToMarkdown(from source: SwiftSource) -> MarkdownSource

// Convert swift source from a file to a markdown file
public func convertToMarkdown(from source: URL, to destination: URL) throws

// Convert swift source from a string to an html string
public func convertToHTML(from source: SwiftSource) throws -> HTMLSource

// Convert swift source from a file to a html file
public func convertToHTML(from source: URL, to destination: URL) throws

// Custom conversion allowing caller to convert each Chunk as seen fit
public func convert(from source: SwiftSource, prepending header: String = "", appending footer: String = "", conversion convert: (Chunk) -> String) -> String
```

## 🖍 Syntax Highlighting
Syntax highlighting for all Swift code is applied via John Sundell's [Splash](https://github.com/JohnSundell/Splash)

Note: For now, the theme for syntax highlighting is hardcoded, but in the future this project should make the theme configurable.

## ⬇️ Installing 

To install the commandline tool:


### 🌱 [Mint](https://github.com/yonaskolb/mint) 
```
$ mint install ldstreet/PlayDocs
```

### 🔧 Make 

Run in terminal:
```
git clone https://github.com/ldstreet/PlayDocs.git && cd PlayDocs && make install
```

### 🏃‍♂️ [Marathon](https://github.com/johnsundell/marathon) 
Add to your Marathonfile:
```
marathon add https://github.com/ldstreet/PlayDocs.git
```
Or use the inline dependency syntax:

```swift
import PlayDocsKit // https://github.com/ldstreet/PlayDocs.git
```

### 🎁 [Swift Package Manager](https://swift.org/package-manager) 
To use PlayDocsKit add the following to your `Package.swift` file.
```swift
// 🏓 A framework for converting Playgrounds and Swift files to markdown and html
.package(url: "https://github.com/ldstreet/PlayDocs.git", .branch("master")),

.target(name: "MyPackage", dependencies: ["PlayDocsKit"]),
```
