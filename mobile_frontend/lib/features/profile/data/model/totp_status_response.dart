class TotpStatusResponse {
  final bool isEnabled;

  TotpStatusResponse({required this.isEnabled});

  factory TotpStatusResponse.fromJson(Map<String, dynamic> json) =>
      TotpStatusResponse(isEnabled: json['is_enabled'] as bool? ?? false);
}
