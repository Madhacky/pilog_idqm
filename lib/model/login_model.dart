class LoginResponse {
  final String ssLocale;
  final String ssRegion;
  final String ssUserlocat;
  final String ssOrgname;
  final String ssOrgId;
  final String ssUsername;
  final String ssInstance;
  final String ssRole;

  LoginResponse({
    required this.ssLocale,
    required this.ssRegion,
    required this.ssUserlocat,
    required this.ssOrgname,
    required this.ssOrgId,
    required this.ssUsername,
    required this.ssInstance,
    required this.ssRole,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      ssLocale: json['ssLocale'],
      ssRegion: json['ssRegion'],
      ssUserlocat: json['ssUserlocat'],
      ssOrgname: json['ssOrgname'],
      ssOrgId: json['ssOrgId'],
      ssUsername: json['ssUsername'],
      ssInstance: json['ssInstance'],
      ssRole: json['ssRole'],
    );
  }
}
