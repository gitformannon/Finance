// lib/services/auth_service.dart
import 'dart:convert';
import 'api_service.dart';
import 'token_storage.dart';

class AuthService {
  /// ------------ регистрация ------------
  static Future<bool> register(String login, String email, String password) async {
    final r = await ApiService.post('/auth/register', {
      'username': login,
      'email'   : email,
      'password': password,
    });
    return r.statusCode == 200 || r.statusCode == 201;
  }

  /// ------------- логин ------------------
  static Future<bool> login(String login, String password) async {
    final r = await ApiService.post(
      '/auth/login',
      {
        'username': login,
        'password': password,
        'grant_type': 'password',
      },
      asForm: true,           // send as application/x-www-form-urlencoded
    );

    if (r.statusCode != 200) return false;

    final body = jsonDecode(r.body);
    final access = body['access_token'];
    final refresh = body['refresh_token'];
    if (access == null || refresh == null) return false;

    ApiService.setAccess(access);      // save "Bearer" type too
    await TokenStorage.saveRefresh(refresh);
    return true;
  }

  /// ------------ logout ------------------
  static Future<void> logout() async {
    // Retrieve refresh token and send it to backend for logout
    final refreshToken = await TokenStorage.readRefresh();
    await ApiService.post(
      '/auth/logout',
      {
        'refresh': refreshToken,
      },
    );
    await ApiService.logout();
  }

  /// ---------- сброс пароля по TOTP ----------
  static Future<bool> resetPassword(String email, String code, String newPassword) async {
    final r = await ApiService.post('/auth/password-reset', {
      'email': email,
      'code': code,
      'new_password': newPassword,
    });
    return r.statusCode == 204;
  }

  /// ------------- enable TOTP ------------------
  static Future<Map<String, dynamic>?> enableTOTP() async {
    final resp = await ApiService.post('/auth/enable-totp', {});
    if (resp.statusCode != 200) return null;
    final body = jsonDecode(resp.body);
    final uri = body['otpauth_uri'];
    final pngB64 = body['qr_png_base64'];
    if (uri == null || pngB64 == null) return null;
    return {
      'uri': uri,
      'image': base64Decode(pngB64),
    };
  }

  /// ------------- confirm TOTP ------------------
  static Future<bool> confirmTOTP(String code) async {
    final resp = await ApiService.post('/auth/confirm-totp', {'code': code});
    return resp.statusCode == 204;
  }

  /// ------------- disable TOTP ------------------
  static Future<bool> disableTOTP(String code) async {
    final resp = await ApiService.post('/auth/disable-totp', {'code': code});
    return resp.statusCode == 204;
  }

  /// ------------- get TOTP status ------------------
  static Future<bool?> getTOTPStatus() async {
    final resp = await ApiService.get('/auth/totp-status');
    if (resp.statusCode != 200) return null;
    final body = jsonDecode(resp.body);
    return body['is_enabled'] as bool?;
  }

  /// ------------- get current user info ------------------
  static Future<Map<String, dynamic>?> getProfile() async {
    final resp = await ApiService.get('/auth/me');
    if (resp.statusCode != 200) return null;
    return jsonDecode(resp.body) as Map<String, dynamic>;
  }
}