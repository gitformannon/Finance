mixin SharedRepository {
  String getToken();

  Future<void> setToken(String token);
}
