import 'package:intl/intl.dart';

extension DateTimePrettifier on DateTime {
  String get slashedDate {
    final twoFormatter = NumberFormat("00");
    final fourFormatter = NumberFormat("0000");

    final day = twoFormatter.format(this.day);
    final month = twoFormatter.format(this.month);
    final year = fourFormatter.format(this.year);

    return "$day/$month/$year";
  }
}
