import 'package:hive/hive.dart';

import '../constants/local_storage_keys.dart';
import 'local_data_source.dart';

class LocalDataSourceImpl implements LocalDataSource {
  @override
  String getToken() {
    final box = Hive.box(LocalStorageKeys.box);
    return box.get(LocalStorageKeys.token, defaultValue: "");
  }

  @override
  String getRefreshToken() {
    final box = Hive.box(LocalStorageKeys.box);
    return box.get(LocalStorageKeys.refreshToken, defaultValue: "");
  }

  @override
  String getTokenType() {
    final box = Hive.box(LocalStorageKeys.box);
    return box.get(LocalStorageKeys.tokenType, defaultValue: "Bearer");
  }

  @override
  Future<void> setUserToken(String token) async {
    final box = Hive.box(LocalStorageKeys.box);
    return box.put(LocalStorageKeys.token, token);
  }

  @override
  Future<void> setRefreshToken(String token) async {
    final box = Hive.box(LocalStorageKeys.box);
    await box.put(LocalStorageKeys.refreshToken, token);
  }

  @override
  Future<void> setTokenType(String tokenType) async {
    final box = Hive.box(LocalStorageKeys.box);
    await box.put(LocalStorageKeys.tokenType, tokenType);
  }

  @override
  String getRole() {
    final box = Hive.box(LocalStorageKeys.box);
    return box.get(LocalStorageKeys.role, defaultValue: "");
  }

  @override
  Future<void> setRole(String role) async {
    final box = Hive.box(LocalStorageKeys.box);
    await box.put(LocalStorageKeys.role, role);
  }

  @override
  String getLang() {
    final box = Hive.box(LocalStorageKeys.box);
    return box.get(LocalStorageKeys.language, defaultValue: "en");
  }

  @override
  Future<void> setLang(String val) async {
    final box = Hive.box(LocalStorageKeys.box);
    await box.put(LocalStorageKeys.language, val);
  }

  @override
  bool getVerified() {
    final box = Hive.box(LocalStorageKeys.box);
    return box.get(LocalStorageKeys.verified, defaultValue: false);
  }

  @override
  Future<void> setVerified(bool value) async {
    final box = Hive.box(LocalStorageKeys.box);
    await box.put(LocalStorageKeys.verified, value);
  }

  @override
  Future<void> setUserFullName(String fullName) async {
    final box = Hive.box(LocalStorageKeys.box);
    await box.put(LocalStorageKeys.fullName, fullName);
  }

  @override
  String getFullName() {
    final box = Hive.box(LocalStorageKeys.box);
    return box.get(LocalStorageKeys.fullName, defaultValue: "");
  }

  @override
  Future<void> setFirstName(String firstName) async {
    final box = Hive.box(LocalStorageKeys.box);
    await box.put(LocalStorageKeys.firstName, firstName);
  }

  @override
  String getFirstName() {
    final box = Hive.box(LocalStorageKeys.box);
    return box.get(LocalStorageKeys.firstName, defaultValue: "User");
  }

  @override
  Future<void> setLastName(String lastName) async {
    final box = Hive.box(LocalStorageKeys.box);
    await box.put(LocalStorageKeys.lastName, lastName);
  }

  @override
  String getLastName() {
    final box = Hive.box(LocalStorageKeys.box);
    return box.get(LocalStorageKeys.lastName, defaultValue: "");
  }

  @override
  Future<void> setProfileImagePath(String path) async {
    final box = Hive.box(LocalStorageKeys.box);
    await box.put(LocalStorageKeys.profileImage, path);
  }

  @override
  String getProfileImagePath() {
    final box = Hive.box(LocalStorageKeys.box);
    return box.get(LocalStorageKeys.profileImage, defaultValue: "");
  }

  @override
  Future<void> setUsername(String username) async {
    final box = Hive.box(LocalStorageKeys.box);
    await box.put(LocalStorageKeys.username, username);
  }

  @override
  String getUsername() {
    final box = Hive.box(LocalStorageKeys.box);
    return box.get(LocalStorageKeys.username, defaultValue: "");
  }

  @override
  Future<void> setEmail(String email) async {
    final box = Hive.box(LocalStorageKeys.box);
    await box.put(LocalStorageKeys.email, email);
  }

  @override
  String getEmail() {
    final box = Hive.box(LocalStorageKeys.box);
    return box.get(LocalStorageKeys.email, defaultValue: "");
  }

  @override
  String getUserId() {
    final box = Hive.box(LocalStorageKeys.box);
    return box.get(LocalStorageKeys.userId, defaultValue: "");
  }

  @override
  Future<void> setUserId(String id) async {
    final box = Hive.box(LocalStorageKeys.box);
    await box.put(LocalStorageKeys.userId, id);
  }

  @override
  String getPhone() {
    final box = Hive.box(LocalStorageKeys.box);
    return box.get(LocalStorageKeys.phone, defaultValue: "");
  }

  @override
  Future<void> setPhone(String phone) async {
    final box = Hive.box(LocalStorageKeys.box);
    await box.put(LocalStorageKeys.phone, phone);
  }
}
