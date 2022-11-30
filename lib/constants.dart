String modeAdditionalContent =
    "This mode includes: [1] Import of necessary localization library in 'pubspec.yaml' file\n"
    "                    [2] Creation of localization configuration file\n"
    "                    [3] Running command for generation of localization files\n"
    "                    [4] Addition of localization delegates in MaterialApp of 'main.dart' file\n";

String basicModeAdditionalContent =
    "For running program in Full Mode, run following command after terminating this program:\n"
    "> dart bin/localization_helper.dart -i full\n"
    "Full Mode includes all features of Basic Mode in addition with:\n"
    "   => Import of localization file in every Dart files containing values of\n"
    "      generated keys of *.arb file and replacement of Text values with translated keys\n";

String fullModeAdditionalContent =
    "                    [5] Import of localization file in every Dart files containing values of\n"
    "                       generated keys of *.arb file and replacement of Text values with translated keys\n";
