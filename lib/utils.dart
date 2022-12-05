import 'dart:io';

// Retrieves the current working directory
Directory getCurrentDirectory() => Directory.current;

// Checking whether 'pubspec.yaml' file exists in the working directory and
// importing flutter localization library in the file
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
      finalContent = newContent.replaceAll(
        RegExp(r'flutter:'),
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
generateLocalizationFiles() {
  print('🔃 Generating localization files...');
  ProcessResult processResult =
      Process.runSync('flutter', ['gen-l10n'], runInShell: true);
  if (processResult.exitCode == 0) {
    print('✅ Localization files have been created!\n'
        '========================================\n');
  } else {
    print('🔴 [ERROR]: ${processResult.stderr.toString()}\n'
        '❌ Program terminated!\n');
  }
}

int checkMainFile() {
  exitCode = 0;
  File mainFile = returnFile('lib/main.dart');
  if (mainFile.existsSync()) {
    final String content = mainFile.readAsStringSync();
    RegExp firstExp = RegExp(
        r'''return MaterialApp:((.|\r|\n)*)localizationsDelegates:((.|\r|\n)*),$''',
        multiLine: true);
    RegExp secondExp = RegExp(
        r'''return MaterialApp:((.|\r|\n)*)supportedLocales:((.|\r|\n)*),''',
        multiLine: true);
    RegExp thirdExp = RegExp(
        r'''return MaterialApp:((.|\r|\n)*)locale:((.|\r|\n)*),''',
        multiLine: true);
    String firstContent = content;
    if (!content.contains(firstExp)) {
      if (content.contains(RegExp(r'\r?\n\s*return MaterialApp:'))) {
        firstContent = content.replaceAll(
          RegExp(r'\s*return MaterialApp:'),
          '    return MaterialApp:\n        localizationsDelegates: S.localizationsDelegates,',
        );
        return exitCode;
      } else {
        print('❗ \'MaterialApp\' is not returned in the file.');
        exitCode = 1;
        return exitCode;
      }
    }
    String secondContent = firstContent;
    if (!firstContent.contains(secondExp)) {
      if (firstContent.contains(RegExp(r'\r?\n\s*return MaterialApp:'))) {
        secondContent = firstContent.replaceAll(
          RegExp(r'flutter:'),
          'flutter:\n  generate: true',
        );
      }
      return exitCode;
    }
    String finalContent = secondContent;
    if (!secondContent.contains(thirdExp)) {
      if (secondContent.contains(RegExp(r'\r?\n\s*return MaterialApp:'))) {
        finalContent = secondContent.replaceAll(
          RegExp(r'flutter:'),
          'flutter:\n  generate: true',
        );
      }
    }
    mainFile.writeAsStringSync(finalContent);
    return exitCode;
  } else {
    print('❗ There is no \'main.dart\' file in the path: \'lib/main.dart\'!\n');
    exitCode = 1;
    return exitCode;
  }
}

// Gets folder path from the user
String? getFolderPath() {
  stdout.write('Enter the path of the folder: ');
  String? folderPath = stdin.readLineSync();
  return folderPath;
}

// Function that returns String in lowerCamelCase for making keys of JSON file
String stringInCamelCase(String lowerCaseString) {
  try {
    lowerCaseString.trim();
    List<String> splittedStrings = lowerCaseString.split(' ');
    int length = splittedStrings.length;
    if (splittedStrings.length > 1) {
      for (int i = 1; i < length; i++) {
        String initial = splittedStrings[i].substring(0, 1);
        String initialInCapital = initial.toUpperCase();
        splittedStrings[i] =
            splittedStrings[i].replaceFirst(RegExp(initial), initialInCapital);
      }
    }
    String stringInCamelCase = splittedStrings.join();
    return stringInCamelCase;
  } catch (e) {
    print('Error while parsing [ $lowerCaseString ]: ${e.toString()}');
    return lowerCaseString;
  }
}

// Returns files in the working directory
File returnFile(String path) {
  Directory currentDirectory = getCurrentDirectory();
  final String currentDirPath = currentDirectory.path;
  final File file = File('$currentDirPath/$path');
  return file;
}
