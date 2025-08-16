class SiteConfig {
  final String eventName;
  final String year;
  final String baseUrl;
  final String primaryColor;
  final String secondaryColor;

  SiteConfig({
    required this.eventName,
    required this.year,
    required this.baseUrl,
    required this.primaryColor,
    required this.secondaryColor,
  });

  factory SiteConfig.fromJson(Map<String, dynamic> json, {required String baseUrl, required String year}) {
    return SiteConfig(
      eventName: json['eventName'],
      year: year,
      baseUrl: baseUrl,
      primaryColor: json['primaryColor'],
      secondaryColor: json['secondaryColor'],
    );
  }
}
