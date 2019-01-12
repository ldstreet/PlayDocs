//
//  NewCommand.swift
//  Async
//
//  Created by Luke Street on 1/11/19.
//

import Command
import Logging

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
    
    var help: [String] {
        return ["Creates a new playground."]
    }
    
    func run(using context: CommandContext) throws -> EventLoopFuture<Void> {
        
        let name = try context.argument(Arguments.name)
        let macOS = context.flag(Flags.macos)
        let empty = context.flag(Flags.empty)
        
        let url =
            URL(fileURLWithPath: context.option(Options.destination) ?? ".")
                .appendingPathComponent(name)
                .appendingPathExtension("playground")
        
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
        
        let contents = empty ? "" : """
        /*:
        # Welcome to PlayDocs
        
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
        
        if context.flag(Flags.open) {
            let process = Process()
            process.launchPath = "/usr/bin/env"
            process.arguments = ["open", "\(url.path)"]
            process.launch()
        }
        
        context.console.output("Playground successfully created at \(url.path).", style: .success)
        
        
        return context.container.future()
    }
    

}
