class ProfileResponse {
  final String id;
  final String username;
  final String email;

  ProfileResponse({
    required this.id,
    required this.username,
    required this.email,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) => ProfileResponse(
        id: json['id']?.toString() ?? '',
        username: json['username'] as String? ?? '',
        email: json['email'] as String? ?? '',
      );
}
