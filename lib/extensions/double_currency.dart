import 'package:intl/intl.dart';

extension DoubleCurrency on double {
  String get euro {
    final formatter = NumberFormat.currency(locale: "en_US", symbol: "€");

    return "$_leadingSign${formatter.format(this)}";
  }

  String get _leadingSign => this > 0 ? "+" : "";
}
