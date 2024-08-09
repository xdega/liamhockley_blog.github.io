import 'package:args/args.dart';
import 'package:static_shock/static_shock.dart';

Future<void> main(List<String> arguments) async {
  var parser = ArgParser();

  // Add CLI command options.
  parser.addFlag('deploy', defaultsTo: false);
  parser.addFlag('preview', defaultsTo: false);

  // Parse the CLI command options.
  var options = parser.parse(arguments);

  // Configure the static website generator.
  final staticShock = StaticShock()
    // Here, you can directly hook into the StaticShock pipeline. For example,
    // you can copy an "images" directory from the source set to build set:
    ..pick(ExtensionPicker("html"))
    ..pick(ExtensionPicker("jpeg"))
    ..pick(DirectoryPicker.parse("images"))
    // All 3rd party behavior is added through plugins, even the behavior
    // shipped with Static Shock.
    ..plugin(const MarkdownPlugin())
    ..plugin(const JinjaPlugin())
    ..plugin(const PrettyUrlsPlugin())
    ..plugin(const RedirectsPlugin())
    ..plugin(const SassPlugin())
    ..plugin(
      DraftingPlugin(
        showDrafts: options['preview'],
      ),
    )
    ..plugin(
      TailwindPlugin(
        input: "source/styles/tailwind.css",
        output: "build/styles/tailwind.css",
        tailwindPath:
            options['deploy'] ? "./tailwindcss_deploy" : "./tailwindcss",
      ),
    );

  // Generate the static website.
  await staticShock.generateSite();
}
