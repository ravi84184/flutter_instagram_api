# Instagram Login for Flutter 🚀

A Flutter package for easy **Instagram login** using OAuth authentication. Fetch user data seamlessly with just a few lines of code.


## Features 🌟

- **Secure OAuth-based login** with Instagram.
- **Fetch user details** (name, profile picture, followers, etc.).
- **Easy integration** with your Flutter app.
- **Supports Meta developer account credentials**.

## Getting Started 🏁

### Installation

Add this package to your project by running:

```sh
flutter pub add flutter_instagram_api
```
Or, manually add it to your pubspec.yaml file:

```bash
dependencies:
flutter_instagram_api: latest_version
```

## Usage  📌

Import the package:

```dart
import 'package:flutter_instagram_api/flutter_instagram_api.dart';
```

## How to Use
Use the following method to initiate the Instagram login process:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_instagram_api/flutter_instagram_api.dart';

class FlutterInstagramApiScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Instagram Login")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            FlutterInstagramApi.login(
              context,
              instaConfig: InstaConfig(
                instaUrl: 'The URL from your Meta Developer Account',
                clientId: 'your_client_id',
                clientSecret: 'your_client_secret',
              ),
              userData: (data) {
                print('User Data:');
                print('User ID: ${data.userId}');
                print('ID: ${data.id}');
                print('Name: ${data.name}');
                print('Username: ${data.username}');
                print('Account Type: ${data.accountType}');
                print('Followers Count: ${data.followersCount}');
                print('Follows Count: ${data.followsCount}');
                print('Media Count: ${data.mediaCount}');
                print('Profile Picture URL: ${data.profilePictureUrl}');
              },
            );
          },
          child: const Text("Login with Instagram"),
        ),
      ),
    );
  }
}
```


## Additional information ℹ️

For more details:

📖 Meta Developer Account: Ensure your app is registered with Meta for Developers to obtain your Instagram API credentials. Make sure your app type is Business and that you have added Instagram in the Products section.

📖 Configuration Details:

1. Click on Instagram in the Products section, then select Set up API with Instagram Login.
2. Here, you will find your Instagram App ID and App Secret, which correspond to your Client ID and Client Secret.
Next Steps:
✅ Click on Set up Instagram Business Login (3-step process).
✅ Go to Business Login Settings and add your OAuth Redirect URIs.
✅ Copy the Embed URL—this will be your instaUrl.


## License 📄
This package is licensed under the MIT License.