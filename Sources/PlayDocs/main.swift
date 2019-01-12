import Console
import Command

let container =
    BasicContainer(
        config: .init(),
        environment: .init(name: "develop", isRelease: false),
        services: .init(),
        on: MultiThreadedEventLoopGroup(numberOfThreads: 1)
    )

var config = CommandConfig()
config.use(ConvertCommand(), as: "convert", isDefault: true)
config.use(NewCommand(), as: "new", isDefault: false)

let group = try config.resolve(for: container).group()
var input = CommandInput(arguments: CommandLine.arguments)

let terminal = Terminal()

_ = terminal.run(group, input: &input, on: container)

