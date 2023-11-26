import 'package:flutter/material.dart';

extension ContextStyles on BuildContext {
  StyleValues get styles => StyleValues._(context: this);
}

class StyleValues {
  final BuildContext _context;

  StyleValues._({required BuildContext context}) : _context = context;

  TextStyleValues get text => TextStyleValues._(context: _context);
  ColorStyleValues get color => ColorStyleValues._(context: _context);
}

class TextStyleValues {
  final BuildContext _context;

  TextStyleValues._({required BuildContext context}) : _context = context;

  TextStyle get displayLarge => Theme.of(_context).textTheme.displayLarge!;
  TextStyle get displayMedium => Theme.of(_context).textTheme.displayMedium!;
  TextStyle get displaySmall => Theme.of(_context).textTheme.displaySmall!;
  TextStyle get headlineMedium => Theme.of(_context).textTheme.headlineMedium!;
  TextStyle get headlineSmall => Theme.of(_context).textTheme.headlineSmall!;
  TextStyle get titleLarge => Theme.of(_context).textTheme.titleLarge!;
  TextStyle get titleMedium => Theme.of(_context).textTheme.titleMedium!;
  TextStyle get titleSmall => Theme.of(_context).textTheme.titleSmall!;
  TextStyle get bodyLarge => Theme.of(_context).textTheme.bodyLarge!;
  TextStyle get bodyMedium => Theme.of(_context).textTheme.bodyMedium!;
  TextStyle get labelLarge => Theme.of(_context).textTheme.labelLarge!;
  TextStyle get bodySmall => Theme.of(_context).textTheme.bodySmall!;
  TextStyle get labelSmall => Theme.of(_context).textTheme.labelSmall!;
}

class ColorStyleValues {
  final BuildContext _context;

  ColorStyleValues._({required BuildContext context}) : _context = context;

  Color get background => Theme.of(_context).colorScheme.background;
  Color get primaryContainer => Theme.of(_context).colorScheme.primaryContainer;
  Color get outline => Theme.of(_context).colorScheme.outline;
  Color get error => Theme.of(_context).colorScheme.error;
  Color get onPrimary => Theme.of(_context).colorScheme.onPrimary;
  Color get onSecondary => Theme.of(_context).colorScheme.onSecondary;
  Color get onTertiary => Theme.of(_context).colorScheme.onTertiary;
}
