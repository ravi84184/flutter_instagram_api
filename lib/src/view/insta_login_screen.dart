import 'package:flutter/material.dart';
import 'package:flutter_instagram_api/src/modal/user_data_model.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../api handler/api_handler.dart';

/// Screen for Instagram login
class InstaLoginView extends StatefulWidget {
  final Function(UserDataModel) userData;
  const InstaLoginView({super.key, required this.userData});

  @override
  State<InstaLoginView> createState() => _InstaLoginViewState();
}

class _InstaLoginViewState extends State<InstaLoginView> {
  /// WebView Controller
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            String url = request.url;
            if (url.contains('code=')) { // More flexible check
              _getData(url);
              return NavigationDecision.prevent; // Stops WebView from loading further
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(InstaApi.config.instaURL));
  }

  /// To fetch user data
  var _loading = false;

  Future<void> _getData(String url) async {
    setState(() {
      _loading = true;
    });

    Uri uri = Uri.parse(url);
    String? code = uri.queryParameters['code'];

    // Ensure we remove `#_` if present
    if (code != null) {
      code = code.split('#_').first;
    }
    print("code got $code");
    if (code != null && code.isNotEmpty) {
      try {
        String? token = await InstaApi.getAccessToken(code: code);
        if (token != null) {
          UserDataModel? data = await InstaApi.getUserData(accessToken: token);
          if (data != null) {
            widget.userData(data);
          }
        }
      } catch (e) {
        debugPrint("Error fetching user data: $e");
      }
    }

    Navigator.of(context).pop();
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Instagram Login',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Close the WebView
          },
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          WebViewWidget(controller: _webViewController),
          if (_loading)
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text(
                  'Please wait...',
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
        ],
      ),
    );
  }
}
