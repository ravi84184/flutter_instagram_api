import 'package:flutter/material.dart';
import 'package:flutter_instagram_api/src/modal/user_data_model.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../api handler/api_handler.dart';

/// screen for instagram login
class InstaLoginView extends StatefulWidget {
  final Function(UserDataModel) userData;
  const InstaLoginView({super.key, required this.userData});

  @override
  State<InstaLoginView> createState() => _InstaLoginViewState();
}

class _InstaLoginViewState extends State<InstaLoginView> {
  /// For showing instagram login page in web
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: (change) async {
            var url = change.url;
            if (url!.startsWith('${InstaApi.config.reDirectURL}?code=')) {
              _getData(url);
            }
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
    var code = uri.queryParameters['code'];
    await InstaApi.getAccessToken(code: code.toString()).then(
      (token) async {
        if (token != null) {
          await InstaApi.getUserData(accessToken: token).then(
            (data) {
              if (data != null) {
                widget.userData(data);
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pop();
              }
            },
          );
        } else {
          Navigator.of(context).pop();
        }
      },
    );
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Instagram login',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          WebViewWidget(controller: _webViewController),
          _loading
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Please wait...',
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
