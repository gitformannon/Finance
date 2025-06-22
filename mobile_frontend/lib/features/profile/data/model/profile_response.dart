class ProfileResponse {
  final String id;
  final String username;
  ProfileResponse({required this.id, required this.username});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) => ProfileResponse(
        id: json['id']?.toString() ?? '',
        username: json['username'] as String? ?? '',
      );
}
