import 'dart:io';

import 'package:args/args.dart';
import 'package:localization_helper/utils.dart';

void main(List<String> arguments) {
  exitCode = 0; // presume success
  final parser = ArgParser()
    ..addFlag('init-localization', negatable: false, abbr: 'l')
    ..addOption('initializer',
        abbr: 'i',
        help: 'Initializes the program',
        defaultsTo: 'basic',
        allowed: ['basic', 'full']);

  ArgResults argResults = parser.parse(arguments);
  final confirmations = argResults.rest;
  if (argResults.wasParsed('initializer')) {
    print(parser.usage);
  }
  print(argResults.arguments);

  confirm(confirmations);
}

checkPubspecFile(File file) {
  final String content = file.readAsStringSync();
  RegExp firstExp = RegExp(
      r'''dependencies:((.|\r|\n)*)flutter_localizations:''',
      multiLine: true);
  RegExp secondExp =
      RegExp(r'''(flutter:((.|\r|\n)*)generate: true)''', multiLine: true);
  String newContent = content;
  File outputFile = returnFile('pubspec.yaml');
  if (!content.contains(firstExp)) {
    if (content.contains(RegExp(r'(?<!dev\_)dependencies:'))) {
      newContent = content.replaceAll(
        RegExp(r'(?<!dev\_)dependencies:'),
        'dependencies:\n  flutter_localizations:\n    sdk: flutter',
      );
    } else {
      newContent =
          '$content\ndependencies:\n  flutter_localizations:\n    sdk: flutter';
    }
  }
  String finalContent = newContent;
  if (!newContent.contains(secondExp)) {
    if (newContent.contains('\nflutter:')) {
      print('if');
      finalContent = newContent.replaceAll(
        RegExp(r'flutter:'),
        'flutter:\n  generate: true',
      );
    } else {
      finalContent = '$finalContent\nflutter:\n  generate: true';
    }
  }
  outputFile.writeAsStringSync(finalContent);
  print('Flutter localization library has been imported...');
}

createLocalizationSettingsFile() {
  File outputFile = returnFile('l10n.yaml');
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
