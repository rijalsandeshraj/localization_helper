import 'dart:io';

// Retrieves the current working directory
Directory getCurrentDirectory() => Directory.current;

// Gets folder path from the user
String? getFolderPath() {
  stdout.write(
      'Enter the path of the folder from where JSON file was extracted (using JSON_CREATOR): ');
  String? folderPath = stdin.readLineSync();
  return folderPath;
}

// Checking whether 'pubspec.yaml' file exists in the working directory and
// importing flutter localization library in the file
checkPubspecFile(File file) {
  final String content = file.readAsStringSync();
  RegExp firstExp = RegExp(
      r'''dependencies:((.|\r|\n)*)flutter_localizations:''',
      multiLine: true);
  RegExp secondExp =
      RegExp(r'''(\r?\nflutter:((.|\r|\n)*)generate: true)''', multiLine: true);
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
    if (newContent.contains(RegExp(r'''\r?\nflutter:'''))) {
      finalContent = newContent.replaceAll(
        RegExp(r'(?<!.*)flutter:'),
        'flutter:\n  generate: true',
      );
    } else {
      finalContent = '$finalContent\nflutter:\n  generate: true';
    }
  }
  outputFile.writeAsStringSync(finalContent);
  print('✅ Flutter localization library has been imported...');
}

// Content for localization configuration file
String getLocalizationConfig(String templateArbFileName) {
  return "arb-dir: lib/l10n/arb\n"
      "output-dir: lib/l10n/generated\n"
      "template-arb-file: $templateArbFileName\n"
      "output-localization-file: l10n.dart\n"
      "output-class: S\n"
      "synthetic-package: false\n"
      "nullable-getter: false\n"
      "untranslated-messages-file: l10n_errors.txt\n";
}

// Creates config or settings file for localization in the working directory
int createLocalizationConfigFile() {
  print("✳️  Create localization configuration file...\n"
      "🔰 The following configuration will be added to 'l10n.yaml' file:\n"
      "========================================\n"
      "${getLocalizationConfig('[your_arb_file_name]')}"
      "========================================\n");
  stdout.write(
      '➡️  Enter the name of your template arb file [with extension, eg \'app_en.arb\']: ');
  String? templateArbFileName = stdin.readLineSync();
  if (templateArbFileName != null && templateArbFileName.isNotEmpty) {
    File templateArbFile = returnFile('lib/l10n/arb/$templateArbFileName');
    if (templateArbFile.existsSync() && templateArbFile.path.endsWith('.arb')) {
      print("🔃 Creating localization configuration file...");
      File configFile = returnFile('l10n.yaml');
      configFile.writeAsStringSync(getLocalizationConfig(templateArbFileName));
      print('✅ Localization config file has been created!');
      exitCode = 0;
      return exitCode;
    } else if (!templateArbFile.path.endsWith('.arb')) {
      print('❗ [$templateArbFileName] is invalid arb file!');
      exitCode = 1;
      return exitCode;
    } else {
      print(
          "❗ There's no arb file named [$templateArbFileName] in the path: lib/l10n/arb/\n"
          "  Add at least two translation files in the given path.\n");
      exitCode = 1;
      return exitCode;
    }
  } else {
    print('❌ Program terminated!\n');
    exitCode = 1;
    return exitCode;
  }
}

// Runs command for generating localization files
int generateLocalizationFiles() {
  print('🔃 Generating localization files...');
  ProcessResult processResult =
      Process.runSync('flutter', ['gen-l10n'], runInShell: true);
  if (processResult.exitCode == 0) {
    print(
        '✅ Localization files have been created in the path: lib/l10n/generated!\n'
        '========================================\n');
    exitCode = 0;
    return exitCode;
  } else {
    print('🔴 [ERROR]: ${processResult.stderr.toString()}\n'
        '❌ Program terminated!\n');
    exitCode = 1;
    return exitCode;
  }
}

// Checks 'main.dart' file in lib directory and adds localizationsDelegates and
// supportedLocales in MaterialApp
int checkMainFile() {
  exitCode = 0;
  print('🔃 Checking \'main.dart\' file...');
  File mainFile = returnFile('lib/main.dart');
  if (mainFile.existsSync()) {
    final String content = mainFile.readAsStringSync();
    RegExp importExp = RegExp(r'''import \'package:.+\r?\n''');
    RegExp firstExp = RegExp(
        r'''MaterialApp\(((.|\r|\n)*)localizationsDelegates:((.|\r|\n)*),$''',
        multiLine: true);
    RegExp secondExp = RegExp(
        r'''MaterialApp\(((.|\r|\n)*)supportedLocales:((.|\r|\n)*),''',
        multiLine: true);
    RegExp thirdExp = RegExp(
        r'''MaterialApp\(((.|\r|\n)*)locale:((.|\r|\n)*),''',
        multiLine: true);
    String firstContent = content;
    if (!content.contains(firstExp)) {
      if (content.contains(RegExp(r'return MaterialApp\('))) {
        firstContent = content.replaceAll(
          RegExp(r'MaterialApp\('),
          'MaterialApp(\n        localizationsDelegates: S.localizationsDelegates,',
        );
        Iterable<Match> importMatches = importExp.allMatches(firstContent);
        if (importMatches.isNotEmpty) {
          String lastMatch = importMatches.last[0]!;
          firstContent = firstContent.replaceAll(
              lastMatch,
              "$lastMatch"
              "import 'package:localization_helper/l10n/generated/l10n.dart';\n");
        }
      } else {
        print('❗ \'MaterialApp\' is not returned in the file.');
        exitCode = 1;
        return exitCode;
      }
    }
    String secondContent = firstContent;
    if (!firstContent.contains(secondExp)) {
      print('second');
      if (firstContent.contains(RegExp(r'\r?\n\s*return MaterialApp\('))) {
        secondContent = firstContent.replaceAll(
          RegExp(r'MaterialApp\('),
          'MaterialApp(\n        supportedLocales: S.supportedLocales,',
        );
      }
    }
    String finalContent = secondContent;
    if (!secondContent.contains(thirdExp)) {
      print('third');
      if (secondContent.contains(RegExp(r'\r?\n\s*return MaterialApp\('))) {
        finalContent = secondContent.replaceAll(
          RegExp(r'MaterialApp\('),
          'MaterialApp(\n        locale: S.supportedLocales.first,',
        );
      }
    }
    mainFile.writeAsStringSync(finalContent);
    print('✅ Localization file has been imported in \'main.dart\' file!\n'
        '========================================\n');
    return exitCode;
  } else {
    print('❗ There is no \'main.dart\' file in the path: \'lib/main.dart\'!\n');
    exitCode = 1;
    return exitCode;
  }
}

// Function that returns String in lowerCamelCase for making keys of callers in localization
String stringInCamelCase(String lowerCaseString) {
  try {
    List<String> splittedStrings = lowerCaseString.split(RegExp(r'\s+'));
    int length = splittedStrings.length;
    if (length > 1) {
      for (int i = 1; i < length; i++) {
        String initial = splittedStrings[i].substring(0, 1);
        String initialInCapital = initial.toUpperCase();
        splittedStrings[i] =
            splittedStrings[i].replaceFirst(RegExp(initial), initialInCapital);
      }
      if (lowerCaseString.startsWith(RegExp(r'[0-9]'))) {
        String stringInCamelCase = splittedStrings.join();
        return 'n$stringInCamelCase';
      }
    } else if (lowerCaseString.startsWith(RegExp(r'[0-9]'))) {
      return 'n$lowerCaseString';
    }
    String stringInCamelCase = splittedStrings.join();
    return stringInCamelCase;
  } catch (e) {
    print('Error while parsing [ $lowerCaseString ]: ${e.toString()}');
    String outputString = lowerCaseString.replaceAll(' ', '');
    return outputString;
  }
}

// Replaces Text widget values with localization callers in every Dart files
// located inside the path given by the user
replaceTextValuesWithCallers() {
  String? jsonCreationPath = getFolderPath();
  if (jsonCreationPath != null && jsonCreationPath.isNotEmpty) {
    Directory dir = Directory(jsonCreationPath);
    bool dirStatus = dir.existsSync();
    // Checking whether the directory exists
    if (dirStatus) {
      List<FileSystemEntity> contents = dir
          .listSync(
            recursive: true,
            followLinks: false,
          )
          .where((e) => e.path.endsWith('.dart'))
          .toList();
      if (contents.isNotEmpty) {
        for (FileSystemEntity file in contents) {
          if (file is File) {
            String content = file.readAsStringSync();
            RegExp importExp = RegExp(r'''import \'.+\r?\n''');
            RegExp exp = RegExp(
                r'''(Text(Widget)?|msg)[(:]\r?\n?\s*['"]+[!"#%&'*/\\,-.;<>=@\[\]^_`~\w\s\r\n]+[?]?['"]+''',
                multiLine: true);
            RegExp replaceExp = RegExp(r'''(Text(Widget)?|msg)[(:]\r?\n?\s*''',
                multiLine: true);
            Iterable<Match> matches = exp.allMatches(content);
            if (matches.isNotEmpty) {
              for (final Match m in matches) {
                String actualMatch = m[0]!.replaceAll(replaceExp, '');
                String matchInLowerCase = actualMatch
                    .toLowerCase()
                    .replaceAll(RegExp(r'''[^\w\s]'''), ' ')
                    .trim();
                String matchInCamelCase = stringInCamelCase(matchInLowerCase);
                content = content.replaceAll(
                    actualMatch, 'S.of(context).$matchInCamelCase');
              }
              Iterable<Match> importMatches = importExp.allMatches(content);
              if (importMatches.isNotEmpty) {
                String lastMatch = importMatches.last[0]!;
                content = content.replaceAll(
                    lastMatch,
                    "$lastMatch"
                    "import 'package:localization_helper/l10n/generated/l10n.dart';\n");
              }
              file.writeAsStringSync(content);
              print('✅ ${matches.length} MATCHES replaced in: 🔰 ${file.path}');
            }
          }
        }
      } else {
        print('❗ Directory has no contents!\n');
      }
    } else {
      print('❗ Directory does not exist!\n');
    }
  } else {
    print('❗ You didn\'t enter the path!\n');
  }
}

// Returns files in the working directory
File returnFile(String path) {
  Directory currentDirectory = getCurrentDirectory();
  final String currentDirPath = currentDirectory.path;
  final File file = File('$currentDirPath/$path');
  return file;
}
