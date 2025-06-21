import 'dart:convert';

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
  Future<void> setUserToken(String token) async {
    final box = Hive.box(LocalStorageKeys.box);
    return box.put(LocalStorageKeys.token, token);
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
  int getUserId() {
    final box = Hive.box(LocalStorageKeys.box);
    return box.get(LocalStorageKeys.userId, defaultValue: 0);
  }

  @override
  Future<void> setUserId(int id) async {
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
