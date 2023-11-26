extension StringCardInfo on String {
  bool get isValidCardNumber => length == 16;
  bool get isValidCardSecret => [3, 4].contains(length);

  bool get isInvalidCardNumber => !isValidCardNumber;
  bool get isInvalidCardSecret => !isValidCardSecret;
}
