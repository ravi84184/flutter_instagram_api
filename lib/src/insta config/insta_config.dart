/// For instagram configuration
class InstaConfig {
  final String instaUrl;
  final String clientId;
  final String clientSecret;

  /// Go to meta developer account and select your app. Under product section click on instagram.
  /// Click on API setup with Instagram business login. Here you can see Instagram app ID which is also called client ID and app secret.
  /// Then click on Set up Instagram business login. Here you can see Embed URL. You have to provide this URL in instaUrl field.

  InstaConfig(
      {required this.instaUrl,
      required this.clientId,
      required this.clientSecret});

  String get instaURL => instaUrl;
  String? get reDirectURL => _redirectUrl();
  String get instaID => clientId;
  String get instaSecret => clientSecret;

  String? _redirectUrl() {
    Uri uri = Uri.parse(instaUrl);
    var url = uri.queryParameters['redirect_uri'];
    return url;
  }
}
