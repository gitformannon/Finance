class ProfileResponse {
  final String id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? profileImage;

  ProfileResponse({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.profileImage,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) => ProfileResponse(
        id: json['id']?.toString() ?? '',
        username: json['username'] as String? ?? '',
        email: json['email'] as String? ?? '',
        firstName: json['first_name'] as String? ?? 'User',
        lastName: json['last_name'] as String? ?? '',
        profileImage: json['profile_image'] as String?,
      );
}
