mixin LocalDataSource {
  String getToken();

  String getRefreshToken();

  String getTokenType();

  Future<void> setUserToken(String token);

  Future<void> setRefreshToken(String token);

  Future<void> setTokenType(String tokenType);

  Future<void> setRole(String role);

  String getRole();

  String getLang();

  bool getVerified();

  Future<void> setVerified(bool value);

  String getUserId();

  Future<void> setUserId(String id);

  Future<void> setLang(String val);

  Future<void> setUserFullName(String fullName);

  String getFullName();

  Future<void> setFirstName(String firstName);

  String getFirstName();

  Future<void> setLastName(String lastName);

  String getLastName();

  Future<void> setProfileImagePath(String path);

  String getProfileImagePath();

  Future<void> setUsername(String username);

  String getUsername();

  Future<void> setEmail(String email);

  String getEmail();


  Future<void> setPhone(String phone);

  String getPhone();
}
