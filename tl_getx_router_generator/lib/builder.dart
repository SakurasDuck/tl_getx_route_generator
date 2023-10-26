

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/generators/router_config_generator.dart';
import 'src/generators/router_generator.dart';

/// A builder that generates a json file for one or more routes.
Builder tlgetXRouterBuilder(BuilderOptions options) {
  return LibraryBuilder(
    const TLGetXRouterGenerator(),
    formatOutput: (generated) => generated.replaceAll(RegExp(r'//.*|\s'), ''),
    generatedExtension: '.get_x_router.json',
  );
}


Builder tlgetXRouterArgumentsBuilder(BuilderOptions options) {
  return LibraryBuilder(TLGetXRouterArgumentsGenerator(),
      generatedExtension: '.router_arguments.dart');
}



/// A builder that generates the navigator class.
Builder tlgetXRouterConfigBuilder(BuilderOptions options) {
  return LibraryBuilder(TLGetXRouterConfigGenerator(),
      generatedExtension: '.get_x_router_config.dart');
}

