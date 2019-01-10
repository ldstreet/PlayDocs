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
    internal enum ConvertCommandFlags: CommandFlags {
        
        case html
        case open
        
        var flag: CommandOption {
            switch self {
                
            case .html:
                return .flag(
                    name: "html",
                    short: "h",
                    help: ["Output as html"]
                )
            case .open:
                return .flag(
                    name: "open",
                    short: "o",
                    help: ["Open file after generating"]
                )
            }
        }
    }
    
    /// Describes options used to alter `convert` output
    internal enum ConvertCommandOptions: CommandOptions {
        
        case destination
        
        var option: CommandOption {
            switch self {
            case .destination:
                return .value(
                    name: "destination",
                    short: "d",
                    default: ".",
                    help: ["Path to output destination."]
                )
            }
        }
    }
    
    /// Describes arguments used to define `convert` output
    internal enum ConvertCommandArguments: CommandArguments {
        
        case source
        
        var argument: CommandArgument {
            switch self {
            case .source:
                return .argument(
                    name: "source",
                    help: ["Path to .swift or .playground file."]
                )
            }
        }
    }
    
    internal typealias Flags = ConvertCommandFlags
    internal typealias Options = ConvertCommandOptions
    internal typealias Arguments = ConvertCommandArguments
    
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
            print("No file or playground exists at \(sourcePath)")
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
            
            print("Converted successfully. You can find your markdown file at \(destinationURL.path)")
        } catch {
            print(error.localizedDescription)
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