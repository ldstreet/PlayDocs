//
//  World.swift
//  Async
//
//  Created by Luke Street on 1/9/19.
//

import SwiftMarkdown
import Splash

/// The current world. Only allow to be modified if in debug.
#if DEBUG
internal var Current = World()
#else
internal let Current = World()
#endif

/// Defines all dependencies needed in this project
internal struct World {
    
    /// Takes in Markdown String and converts to HTML String
    internal var convertToHTML: (MarkdownSource) -> HTMLSource? = { source in return try? markdownToHTML(source) }
    
    /// Takes in Swift source String and converts to HTML String with highlighting tags
    internal var convertToHighlightedHTML: (SwiftSource) -> HTMLSource = SyntaxHighlighter.highlight(SyntaxHighlighter(format: HTMLOutputFormat()))
}
