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
config.use(GenerateCommand(), as: "generate", isDefault: true)

let group = try config.resolve(for: container).group()
var input = CommandInput(arguments: CommandLine.arguments)

let terminal = Terminal()

_ = terminal.run(group, input: &input, on: container)

