import 'package:flutter/material.dart';
import 'package:flutter_instagram_api/flutter_instagram_api.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Instagram login',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.pink.shade300,
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              FlutterInstagramApi.login(
                context,
                instaConfig: InstaConfig(
                    instaUrl: 'The URL that you will get from Meta Account',
                    clientId: 'your client id',
                    clientSecret: 'your client secret'),
                userData: (data) {
                  print(
                      'user data == ${data.userId}  ${data.id}  ${data.name}  ${data.username}  ${data.accountType}  ${data.followersCount}  ${data.followsCount}  ${data.mediaCount}  ${data.profilePictureUrl}');
                },
              );
            },
            child: const Text('Login')),
      ),
    );
  }
}
