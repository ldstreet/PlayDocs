//
//  World.swift
//  Async
//
//  Created by Luke Street on 1/9/19.
//

import PerfectMarkdown
import Splash

/// The current world. Only allow to be modified if in debug.
#if debug
internal var current = World()
#else
internal let current = World()
#endif

/// Defines all dependencies needed in this project
internal struct World {
    
    /// Takes in Markdown String and converts to HTML String
    internal let convertToHTML: (MarkdownSource) -> HTMLSource? = get(\.markdownToHTML)
    
    /// Takes in Swift source String and converts to HTML String with highlighting tags
    internal let convertToHighlightedHTML: (SwiftSource) -> HTMLSource = SyntaxHighlighter.highlight(SyntaxHighlighter(format: HTMLOutputFormat()))
}
