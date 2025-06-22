/// Data required for logging in using OAuth2 password flow.
class LoginUserRequest {
  final String username;
  final String password;

  const LoginUserRequest({
    required this.username,
    required this.password,
  });

  /// Returns data encoded for an `application/x-www-form-urlencoded` request.
  Map<String, dynamic> toMap() => {
        'username': username,
        'password': password,
        'grant_type': 'password',
      };
}
