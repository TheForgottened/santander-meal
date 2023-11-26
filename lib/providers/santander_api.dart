import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path/path.dart';
import 'package:santander_meal/shared/constants.dart';
import 'package:santander_meal/shared/shared_preferences_repository.dart';

class SantanderApi {
  final String _baseUrl;
  final Dio _dio = Dio();
  final CookieJar _cookieJar = CookieJar();

  late String _token;
  late Map<String, String> _session;
  late String _cookie;

  SantanderApi._(this._baseUrl) {
    _dio.interceptors.add(CookieManager(_cookieJar));
  }

  factory SantanderApi() {
    return SantanderApi._(Constants.baseSantanderUrl);
  }

  Future login() async {
    const String endpoint = "bepp/sanpt/usuarios/loginrefeicao/";
    final String url = join(_baseUrl, endpoint);

    final username = await SharedPreferencesRepository.getCardNumber();
    final password = await SharedPreferencesRepository.getCardSecret() +
        await SharedPreferencesRepository.getCardSecret();

    _token = await _getOgcToken();
    _session = await _getSessionState();

    late final Response response;

    response = await _dio.post(
      url,
      data: {
        "accion": 3,
        _session["username"] ?? "": username,
        _session["password"] ?? "": password,
        "OGC_TOKEN": _token
      },
      options: Options(
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      ),
    );

    final contentType =
        response.headers["content-type"]?.first.split(";").first;

    if (response.statusCode == HttpStatus.ok && contentType == "text/html") {
      _cookie = response.headers["set-cookie"]?.first ?? "";
    }
  }

  Future<Map<String, dynamic>> getAccountDetails() async {
    const String endpoint =
        "bepp/sanpt/tarjetas/listadomovimientostarjetarefeicao/0,,,0.shtml";
    final String url = join(_baseUrl, endpoint);

    final response = await _dio.get(
      url,
      options: Options(
        headers: {
          "OGC_TOKEN": _token,
        },
      ),
    );

    final contentType =
        response.headers["content-type"]?.first.split(";").first;

    if (response.statusCode != HttpStatus.ok || contentType != "text/html") {
      return {};
    }

    final String html = response.data;

    // <section>
    int index = html.indexOf('<div class="balance-container">');
    final sectionStart = html.substring(index);
    index = sectionStart.indexOf("</section>");
    final section = sectionStart.substring(0, index);

    // <card_ref>
    String pattern = '<p class="balance-value">';
    index = section.indexOf(pattern) + pattern.length;
    final cardRefStart = section.substring(index);
    index = cardRefStart.indexOf("</p>");
    final cardRef = cardRefStart.substring(0, index);

    // <gross_balance>
    pattern = '<p class="balance-value">';
    index = cardRefStart.indexOf(pattern, index) + pattern.length;
    final grossBalanceStart = cardRefStart.substring(index);
    index = grossBalanceStart.indexOf("</p>");
    final grossBalanceUnparsed = grossBalanceStart.substring(0, index);
    final grossBalance = double.parse(
        grossBalanceUnparsed.replaceAll(" EUR", "").replaceAll(",", "."));

    // <net_balance>
    pattern = '<p class="balance-value text-green">';
    index = grossBalanceStart.indexOf(pattern, index) + pattern.length;
    final netBalanceStart = grossBalanceStart.substring(index);
    index = netBalanceStart.indexOf("</p>");
    final netBalanceUnparsed = netBalanceStart.substring(0, index);
    final netBalance = double.parse(
        netBalanceUnparsed.replaceAll(" EUR", "").replaceAll(",", "."));

    return {
      "cardRef": cardRef,
      "grossBalance": grossBalance,
      "netBalance": netBalance
    };
  }

  Future<Map<String, String>> _getSessionState() async {
    const String endpoint = "bepp/sanpt/usuarios/loginrefeicao/0,,,0.shtml";
    final String url = join(_baseUrl, endpoint);

    final response = await _dio.get(url);

    final contentType =
        response.headers["content-type"]?.first.split(";").first;

    if (response.statusCode != HttpStatus.ok || contentType != "text/html") {
      return {};
    }

    final String html = response.data;

    // <section>
    int index = html.indexOf('<section class="form-container">');
    final sectionStart = html.substring(index);
    index = sectionStart.indexOf("</section>") + 10;
    final section = sectionStart.substring(0, index);

    // <input username>
    index = section.indexOf('<input type="text"');
    final usernameDivStart = section.substring(index);
    index = usernameDivStart.indexOf(">") + 1;
    final usernameDiv = usernameDivStart.substring(0, index);

    index = usernameDiv.indexOf("id=") + 4;
    final usernameIdStart = usernameDiv.substring(index);
    index = usernameIdStart.indexOf('"');
    final usernameId = usernameIdStart.substring(0, index);

    // <input password>
    index = section.indexOf('<input type="password"');
    final passwordDivStart = section.substring(index);
    index = passwordDivStart.indexOf(">") + 1;
    final passwordDiv = passwordDivStart.substring(0, index);

    index = passwordDiv.indexOf("id=") + 4;
    final passwordIdStart = passwordDiv.substring(index);
    index = passwordIdStart.indexOf('"');
    final passwordId = passwordIdStart.substring(0, index);

    return {
      "username": usernameId,
      "password": passwordId,
    };
  }

  Future<String> _getOgcToken() async {
    const String endpoint = "nbp_guard";
    final String url = join(Constants.baseSantanderUrl, endpoint);

    final response = await _dio.post(
      url,
      options: Options(
        headers: {"FETCH-CSRF-TOKEN": "1"},
      ),
    );

    final contentType =
        response.headers["content-type"]?.first.split(";").first;

    if (response.statusCode != HttpStatus.ok || contentType != "text/plain") {
      return "";
    }

    final String text = response.data;

    if (text.indexOf("OGC_TOKEN:") != 0) {
      return "";
    }

    return text.substring(10);
  }
}
