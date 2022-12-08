# LOCALIZATION_HELPER for Flutter Apps Localization

This is command line Dart application that helps in implementing localization in Flutter apps.

[**NOTE**]: You may find ['json_creator'](https://pub.dev/packages/json_creator) and
['json_translator'](https://pub.dev/packages/json_translator) packages on [pub.dev](https://pub.dev) helpful
if you are doing localization of prebuilt Flutter apps.<br>
https://pub.dev/packages/json_creator<br>
https://pub.dev/packages/json_translator

This package intends to help Flutter developers who have already developed a Flutter app and
are looking for localizing the project. This package includes two modes for implementing
localization in Flutter apps: Basic Mode and Full Mode.

(A) Basic Mode includes:

1. Import of necessary localization library in 'pubspec.yaml' file
2. Creation of localization configuration file
3. Running command for generation of localization files
4. Addition of localization delegates in MaterialApp of 'main.dart' file

(B) Full Mode includes all features of Basic Mode in addition with:<br>
=> Import of localization file in every Dart files containing values of<br>
generated keys of \*.arb file and replacement of Text values with translated keys

## Usage

This program is published to pub.dev so you can use this package:

1. As an executable by running the following commands:

```ps
dart pub global activate localization_helper
```

If path warning is shown, you need to add the highlighted directory to your system's "Path"
environment variable for allowing the executable to run. Run the following command after adding
the directory to path. This command runs the program in Basic Mode:

```ps
localization_helper
```

For running the program in Full Mode, execute the following command:

```ps
localization_helper -i full
```

<img src="https://github.com/rijalsandeshraj/localization_helper/raw/main/screenshots/confirm.png" />

## Steps involved while running the program

1. Run the program in the project directory where localization needs to be implemented
2. Enter 'y' for allowing the program to run
3. The program detects whether the 'pubspec.yaml' file exists and imports necessary localization
   library
4. Enter the name of your template \*.arb file located at the specified path
5. The program creates a localization configuration file named 'l10n.yaml' in the working directory
   and also adds localization delegates in 'main.dart' file
6. When executed in Full Mode, the user needs to provide the path of the directory for replacing
   Text values with localization callers in every Dart files from where JSON file was created
   (using JSON_CREATOR)

## Output

Output is shown in console where every executions are shown with details.

<img src="https://github.com/rijalsandeshraj/localization_helper/raw/main/screenshots/output.png" />

## Additional Information

When used in Full Mode, this program replaces all matched const Text widgets with normal Text widgets with non
constant values. You can use this regex in the search field for all files to remove const keyword for widgets wrapping
matched Text widget:

```console
(const )(\w*[([]((\r?\n?).*){0,5}S.of\(context\))
```

by replacing with this expression: '$2' in VS Code.

<img src="https://github.com/rijalsandeshraj/localization_helper/raw/main/screenshots/const_replacer1.png" />

It's advisable to perform replacing operations one by one so that unexpected errors can be minimized.

<img src="https://github.com/rijalsandeshraj/localization_helper/raw/main/screenshots/const_replacer2.png" />

There's an interesting article that can be helpful when working with arb files for localization. You
can check this out:
https://yapb.dev/tips-and-tricks-13-tips-when-working-with-arb-files-for-localization

Use the package and feedback is welcome! :blush::sparkling_heart:
