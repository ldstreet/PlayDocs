//
//  NewCommand.swift
//  Async
//
//  Created by Luke Street on 1/11/19.
//

import Command
import Logging

import Overture
extension Process {
    private convenience init(command: String) {
        self.init()
        self.launchPath = "/usr/bin/env"
        self.arguments = command.split(separator: " ").map(String.init)
    }
    
    public static func run(_ command: String) {
        let process = Process(command: command)
        process.launch()
        process.waitUntilExit()
    }
    
    public static func run(_ commands: String...) {
        commands.forEach(run)
    }
}

internal struct NewCommand: CommandProtocol {
    
    enum Arguments: CommandArguments {
        case name
        
        var help: [String] {
            switch self {
            case .name: return ["Name of the playground to be created."]
            }
        }
    }
    
    enum Options: CommandOptions {
        
        case destination
        
        var help: [String] {
            switch self {
            case .destination: return ["Destination of the playground to be created."]
            }
        }
        
        var defaultValue: String? {
            switch self {
            case .destination:
                return "."
            }
        }
    }
    
    enum Flags: CommandFlags {
        case open
        case macos
        case empty
        
        var help: [String] {
            switch self {
            case .open: return ["Open playground after creation."]
            case .macos: return ["Configure playground to run for MacOS"]
            case .empty: return ["Created playground will have no starting content."]
            }
        }
    }
    
    internal enum MultipleOptions: CommandMultipleOptions {
        case packages
        
        var help: [String] {
            switch self {
            case .packages: return [
                "Any swift packages to link within this Playground.",
                "E.g. --packages ldstreet/Playdocs"
                ]
            }
        }
    }
    
    var help: [String] {
        return ["Creates a new playground."]
    }
    
    static func buildSPMPackage(fromGithub path: String, destination: URL) throws {
        let splitPath = path.split(separator: "/")
        let urlPath: String
        if splitPath.count == 2 {
            urlPath = path
        } else if splitPath.count > 2 {
            urlPath = "\(splitPath[0])/\(splitPath[1])"
        } else {
            print("Need to handle this")
            exit(1)
        }
        guard let packageName = urlPath.split(separator: "/").last.map(String.init) else {
            print("Need to handle this")
            exit(1)
        }
        guard let targetName = splitPath.last.map(String.init) else {
            print("Need to handle this")
            exit(1)
        }
        _ = Process.run(
            "git clone https://github.com/\(urlPath).git \(destination.path)/\(packageName)",
            "swift package update --package-path \(destination.path)/\(packageName)",
            "swift build -c release -Xswiftc -static-stdlib --package-path \(destination.path)/\(packageName) --build-path \(destination.path)/\(packageName)/.build",
            "cp  \(destination.path)/\(packageName)/.build/Release/\(packageName).framework \(destination.path)/\(targetName).framework",
            "rm -rf \(destination.path)/\(packageName)"
        )
    }
    
    func run(using context: CommandContext) throws -> EventLoopFuture<Void> {
        
        let name = try context.arg(Arguments.name)
        let macOS = context[Flags.macos]
        let empty = context[Flags.empty]
        
        let url =
                context[Options.destination]
                    .map(URL.init(fileURLWithPath:))
                    ??
                    URL(fileURLWithPath: ".")
                        .appendingPathComponent(name)
                        .appendingPathExtension("playground")
        
        
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
        
        let contents = empty ? "" : """
        /*:
        # Welcome to PlayDocs 🏓
        
        ### Cheat Sheet:
        *To render markdown:* `Editor -> Show Rendered Markup`
        
        *For raw markup:*  `Editor -> Show Raw Markup`
        
        *Convert to markdown file:*  `playdocs convert \(name) --open`
        
        *Convert to HTML file:*  `playdocs convert \(name) --html --open`
        */
        \(macOS ? "import Foundation" : "import UIKit")
        
        var str = "Hello, PlayDocs!"

        """
        
        let contentsURL = url.appendingPathComponent("Contents").appendingPathExtension("swift")
        try contents.write(to: contentsURL, atomically: true, encoding: .utf8)
        
        let xcplayground = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <playground version='5.0' target-platform='\(macOS ? "macos" : "ios")' display-mode='\(empty ? "raw" : "rendered")' executeOnSourceChanges='false'>
            <timeline fileName='timeline.xctimeline'/>
        </playground>
        """
        
        let xcplaygroundURL = url.appendingPathComponent("Contents").appendingPathExtension("xcplayground")
        try xcplayground.write(to: xcplaygroundURL, atomically: true, encoding: .utf8)
        
        if context[Flags.open] {
            Process.run("open \(url.path)")
        }
        
        context.console.output("Playground successfully created at \(url.path).", style: .success)
        
        
        return .done(on: context.container)
    }
    

}
