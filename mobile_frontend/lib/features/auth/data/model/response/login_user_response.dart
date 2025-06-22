/// Response returned by the OAuth2 login endpoint.
class LoginUserResponse {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final String userId;

  const LoginUserResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.userId,
  });

  factory LoginUserResponse.fromJson(Map<String, dynamic> json) =>
      LoginUserResponse(
        accessToken: json['access_token'] as String? ?? '',
        refreshToken: json['refresh_token'] as String? ?? '',
        tokenType: json['token_type'] as String? ?? '',
        userId: json['user_id']?.toString() ?? '',
      );
}
