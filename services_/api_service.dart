// lib/services/api_service.dart
import 'dart:convert';
import 'package:frontend/services/token_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = 'http://localhost:8000';
  static String? _access;                     // в ОЗУ!

static void setAccess(String? v) => _access = v;
  /* ------------- общий метод ------------------ */
  static Future<http.Response> _send(
      Future<http.Response> Function(Map<String,String>) req,
      {int retry = 0}) async {

    final headers = {'Content-Type':'application/json'};
    if (_access != null) headers['Authorization'] = 'Bearer $_access';

    final resp = await req(headers);

    if (resp.statusCode == 401 && retry == 0) {
      final ok = await _refresh();          // попробуем обновить
      if (ok) return _send(req, retry: 1);  // повторяем исходный запрос
    }
    return resp;
  }

  static Future<http.Response> get(String ep) =>
      _send((h)=>http.get(Uri.parse('$baseUrl$ep'), headers: h));

  static Future<http.Response> post(String ep, dynamic data,
      {bool asForm = false}) =>
      _send((h)=>http.post(Uri.parse('$baseUrl$ep'),
          headers: asForm ? {...h, 'Content-Type': 'application/x-www-form-urlencoded'}
              : h,
          body: asForm
              ? (data is Map
                  ? data.entries
                      .map((e) =>
                          '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent('${e.value}')}')
                      .join('&')
                  : data)
              : jsonEncode(data),
      ));

  /* ------------- refresh ------------------ */
  static Future<bool> _refresh() async {
    final refresh = await TokenStorage.readRefresh();
    if (refresh == null) return false;

    final resp = await http.post(
      Uri.parse('$baseUrl/auth/refresh'),
      headers: {'Content-Type':'application/json'},
      body: jsonEncode({'refresh_token': refresh}),
    );

    if (resp.statusCode == 200) {
      final json = jsonDecode(resp.body);
      _access = json['access_token'];
      await TokenStorage.saveRefresh(json['refresh_token']);
      return true;
    }
    await logout();                      // refresh некорректен
    return false;
  }

  static Future<void> logout() async {
    _access = null;
    await TokenStorage.clear();
  }
}
