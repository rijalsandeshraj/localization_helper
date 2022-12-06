import 'dart:io';

import 'package:args/args.dart';

import 'constants.dart';
import 'utils.dart';

void main(List<String> arguments) {
  exitCode = 0;
  final parser = ArgParser()
    ..addOption(
      'init',
      abbr: 'i',
      help:
          'Initializes the program for localization with options as: basic or full',
      defaultsTo: 'basic',
      allowed: ['basic', 'full'],
      allowedHelp: {
        'basic':
            'Executes basic implementation of localization to your Flutter apps',
        'full':
            'Executes full implementation of localization to your Flutter apps',
      },
    )
    ..addSeparator(flutterLocalizationHelper);
  try {
    ArgResults argResults = parser.parse(arguments);
    String initValue = argResults['init'];
    String modeContent =
        "🔰 You have chosen ${initValue.toUpperCase()} Localization Mode...\n"
        "$modeAdditionalContent";
    if (initValue == 'basic') {
      print("$modeContent\n"
          "$basicModeAdditionalContent");
    } else if (initValue == 'full') {
      print("$modeContent"
          "$fullModeAdditionalContent");
    }
    confirm(initValue);
  } catch (e) {
    print(e.toString());
    print(
        '❌ There was an error while parsing the arguments. Program terminated!');
    print('${parser.usage}\n');
  }
}

// Looks for confirmation from the user and checks whether 'pubspec.yaml' file exists
void confirm(String localizationMode) {
  stdout.write('$flutterLocalizationHelper\n❔ Initialize the program? [y/n]: ');
  String? confirmation = stdin.readLineSync();
  if (confirmation == 'y') {
    Directory currentDirectory = getCurrentDirectory();
    File file = File('${currentDirectory.path}/pubspec.yaml');
    if (file.existsSync()) {
      print('🔃 Program is running...');
      print(
          '🔃 Importing necessary localization library in \'pubspec.yaml\' file...');
      checkPubspecFile(file);
      int exitCode = createLocalizationConfigFile();
      if (exitCode == 0) {
        int exitCode = generateLocalizationFiles();
        if (exitCode == 0) {
          int exitCode = checkMainFile();
          if (exitCode == 0 && localizationMode == 'full') {
            replaceTextValuesWithCallers();
          }
        }
      }
    } else {
      print('❗ There is no \'pubspec.yaml\' file in this directory!\n');
    }
  } else {
    print('❌ Program terminated!\n');
  }
}
