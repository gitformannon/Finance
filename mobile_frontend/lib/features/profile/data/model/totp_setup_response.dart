class TotpSetupResponse {
  final String otpauthUri;
  final String qrPngBase64;

  TotpSetupResponse({required this.otpauthUri, required this.qrPngBase64});

  factory TotpSetupResponse.fromJson(Map<String, dynamic> json) => TotpSetupResponse(
        otpauthUri: json['otpauth_uri'] as String? ?? '',
        qrPngBase64: json['qr_png_base64'] as String? ?? '',
      );
}
