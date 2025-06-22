class LogoutRequest {
  final String refresh;

  const LogoutRequest({required this.refresh});

  Map<String, dynamic> toJson() => {'refresh': refresh};
}
