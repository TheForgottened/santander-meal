import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository {
  static const String _cardNumberKey = "cardNumber";
  static const String _cardSecretKey = "cardSecret";
  static const String _lastCardReferenceKey = "lastCardReference";
  static const String _lastNetBalanceKey = "lastNetBalance";
  static const String _lastGrossBalanceKey = "lastGrossBalance";

  SharedPreferencesRepository._();

  static Future<SharedPreferences> get sharedPrefs =>
      SharedPreferences.getInstance();

  static Future<String> getCardNumber() async =>
      (await sharedPrefs).getString(_cardNumberKey) ?? "";

  static Future setCardNumber(String cardNumber) async =>
      (await sharedPrefs).setString(_cardNumberKey, cardNumber);

  static Future<String> getCardSecret() async =>
      (await sharedPrefs).getString(_cardSecretKey) ?? "";

  static Future setCardSecret(String cardSecret) async =>
      (await sharedPrefs).setString(_cardSecretKey, cardSecret);

  static Future<String> getLastCardReference() async =>
      (await sharedPrefs).getString(_lastCardReferenceKey) ?? "";

  static Future setLastCardReference(String lastCardReference) async =>
      (await sharedPrefs).setString(_lastCardReferenceKey, lastCardReference);

  static Future<double> getLastNetBalance() async =>
      (await sharedPrefs).getDouble(_lastNetBalanceKey) ?? 0;

  static Future setLastNetBalance(double lastNetBalance) async =>
      (await sharedPrefs).setDouble(_lastNetBalanceKey, lastNetBalance);

  static Future<double> getLastGrossBalance() async =>
      (await sharedPrefs).getDouble(_lastGrossBalanceKey) ?? 0;

  static Future setLastGrossBalance(double lastGrossBalance) async =>
      (await sharedPrefs).setDouble(_lastGrossBalanceKey, lastGrossBalance);

  static Future clear() async => (await sharedPrefs).clear();
}
