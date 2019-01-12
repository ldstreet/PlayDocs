//
//  ConvertCommand.swift
//  Async
//
//  Created by Luke Street on 12/24/18.
//

import Command
import PlayDocsKit

internal struct ConvertCommand: CommandProtocol {
    
    /// Describes flags used to alter `convert` output
    internal enum Flags: CommandFlags {
        
        case html
        case open
        
        var help: [String] {
            switch self {
            case .html: return ["Output as html"]
            case .open: return ["Open file after generating"]
            }
        }
    }
    
    /// Describes options used to alter `convert` output
    internal enum Options: CommandOptions {
        
        case destination
        
        var defaultValue: String? {
            switch self {
            case .destination:
                return "."
            }
        }
        
        var help: [String] {
            switch self {
            case .destination: return ["Path to output destination."]
            }
        }
    }
    
    /// Describes arguments used to define `convert` output
    internal enum Arguments: CommandArguments {
    
        case source
        
        var help: [String] {
            switch self {
            case .source:
                return ["Path to .swift or .playground file."]
            }
        }
    }
    
    /// Describes command
    internal var help: [String] {
        return [
            "Convert takes in a .swift or .playground files and will format and output that file as a .md or .html"
        ]
    }
    
    /// Runs the command against the supplied input.
    internal func run(using context: CommandContext) throws -> EventLoopFuture<Void> {
        let ext = context.flag(Flags.html) ? "html" : "md"
        let sourcePath = try context.argument(Arguments.source)
        let suppliedSourceURL = URL(fileURLWithPath: sourcePath)
        let sourceURL: URL
        
        guard FileManager.default.fileExists(atPath: suppliedSourceURL.path) else {
            context.console.output("No file or playground exists at \(sourcePath)", style: .error)
            exit(1)
        }
        if suppliedSourceURL.pathExtension == "playground" {
            sourceURL = suppliedSourceURL
                .appendingPathComponent("Contents")
                .appendingPathExtension("swift")
        } else {
            sourceURL = suppliedSourceURL
        }
        let destinationURL =
            suppliedSourceURL
                .deletingPathExtension()
                .appendingPathExtension(ext)
        do {
            if context.flag(Flags.html) {
                try convertToHTML(
                    from: sourceURL,
                    to: destinationURL
                )
            } else {
                try convertToMarkdown(
                    from: sourceURL,
                    to: destinationURL
                )
            }
            context.console.output("Converted successfully. You can find your markdown file at \(destinationURL.path)", style: .success)
        } catch {
            context.console.output(error.localizedDescription, style: .error)
            exit(1)
        }
        
        if context.flag(Flags.open) {
            let process = Process()
            process.launchPath = "/usr/bin/env"
            process.arguments = ["open", "\(destinationURL.path)"]
            process.launch()
            
        }
        
        return context.container.future()
    }
}
