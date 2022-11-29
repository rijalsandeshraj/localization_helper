import 'dart:io';

import 'package:args/args.dart';
import 'package:localization_helper/utils.dart';

const String initialize = 'init-localization';

void main(List<String> arguments) {
  exitCode = 0; // presume success
  final parser = ArgParser()..addFlag(initialize, negatable: false, abbr: 'i');

  ArgResults argResults = parser.parse(arguments);
  final confirmations = argResults.rest;

  confirm(confirmations);
}

checkPubspecFile(File file) {
  final String content = file.readAsStringSync();
  RegExp firstExp = RegExp(
      r'''[\n](dependencies:.*flutter_localizations:.*sdk: flutter)''',
      multiLine: true);
  RegExp secondExp = RegExp(r'''(flutter:.*generate: true)''', multiLine: true);
  Iterable<Match> firstMatches = firstExp.allMatches(content);
  Iterable<Match> secondMatches = secondExp.allMatches(content);
  String newContent = content;
  if (firstMatches.isEmpty || secondMatches.isEmpty) {
    newContent = content
        .replaceAll(
          RegExp(r'dependencies:'),
          'dependencies:\n  flutter_localizations:\n    sdk: flutter',
        )
        .replaceAll(
          RegExp(r'flutter:'),
          'flutter:\n  generate: true',
        );
  }
  File outputFile = returnFile();
  outputFile.writeAsStringSync(newContent);
  print('Flutter localization library has been imported...');
}

Future<void> confirm(List<String> confirmations) async {
  stdout.write('Initialize the program [y/n]: ');
  String? confirmation = stdin.readLineSync();
  if (confirmation == 'y') {
    Directory currentDirectory = getCurrentDirectory();
    File file = File('${currentDirectory.path}/pubspec.yaml');
    if (file.existsSync()) {
      print('Program is running...');
      checkPubspecFile(file);
    } else {
      print('There is no \'pubspec.yaml\' file in this directory!');
    }
  } else {
    print('Program is terminating!');
  }
  // await stdin.pipe(stdout);
}
