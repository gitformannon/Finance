class TotpCodeRequest {
  final String code;
  TotpCodeRequest({required this.code});

  Map<String, dynamic> toJson() => {'code': code};
}
