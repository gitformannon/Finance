mixin LocalDataSource {
  String getToken();

  Future<void> setUserToken(String token);

  Future<void> setRole(String role);

  String getRole();

  String getLang();

  bool getVerified();

  Future<void> setVerified(bool value);

  int getUserId();

  Future<void> setUserId(int id);

  Future<void> setLang(String val);

  Future<void> setUserFullName(String fullName);

  String getFullName();


  Future<void> setPhone(String phone);

  String getPhone();
}
