class UpdateProfileRequest {
  final String firstName;
  final String lastName;

  UpdateProfileRequest({required this.firstName, required this.lastName});

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
      };
}
