/// This is command line Dart application that helps in implementing localization in Flutter apps.
///
/// This package intends to help Flutter developers who have already developed
/// a Flutter app and are looking for localizing the project. This package includes two
/// modes for implementing localization in Flutter apps: Basic Mode and Full Mode.
///
/// (A) Basic Mode includes:
///   [1] Import of necessary localization library in 'pubspec.yaml' file
///   [2] Creation of localization configuration file
///   [3] Running command for generation of localization files
///   [4] Addition of localization delegates in MaterialApp of 'main.dart' file
///
/// (B) Full Mode includes all features of Basic Mode in addition with:
///   => Import of localization file in every Dart files containing values of
///      generated keys of *.arb file and replacement of Text values with translated keys
///
/// Run this command in the terminal for starting the program:
/// > dart run      OR,
/// > localization_helper       --- For running the program in Basic Mode       OR,
/// > localization_helper -i full       --- For running the program in Full Mode
///
/// Steps involved while running the program:
// 1. Run the program in the project directory where localization needs to be implemented
// 2. Enter 'y' for allowing the program to run
// 3. The program detects whether the 'pubspec.yaml' file exists and imports necessary localization
//    library
// 4. Enter the name of your template *.arb file located at the specified path
// 5. The program creates a localization configuration file named 'l10n.yaml' in the working directory
//    and also adds localization delegates in 'main.dart' file
// 6. When executed in Full Mode, the user needs to provide the path of the directory for replacing
//    Text values with localization callers in every Dart files from where JSON file was created
//    (using JSON_CREATOR)

library localization_helper;

export '../lib/src/localization_helper.dart';
