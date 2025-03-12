library flutter_instagram_api;

import 'package:flutter/material.dart';
import 'package:flutter_instagram_api/src/modal/user_data_model.dart';
import 'src/api handler/api_handler.dart';
import 'src/insta config/insta_config.dart';
import 'src/view/insta_login_screen.dart';

export 'src/insta config/insta_config.dart';

/// for instagram login
class FlutterInstagramApi {
  static void login(
    BuildContext context, {
    required InstaConfig instaConfig,
    required Function(UserDataModel) userData,
  }) {
    InstaApi.config = instaConfig;
    if (instaConfig.instaUrl.isEmpty) {
      throw 'Please provide the correct URL which you got from your Meta developer account.';
    } else if (instaConfig.clientId.isEmpty) {
      throw 'Please provide clientID.';
    } else if (instaConfig.clientSecret.isEmpty) {
      throw 'Please provide client secret.';
    } else {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => InstaLoginView(
          userData: userData,
        ),
      ));
    }
  }
  /// Upload and publish a post (single or multiple images)
  static Future<bool> uploadPost({
    required List<String> imageUrls, // Can be 1 or more images
    required String caption,
    required String accessToken,
    required String userId,
  }) async {
    if (accessToken.isEmpty || userId.isEmpty) {
      throw 'User is not authenticated. Please log in first.';
    }

    return await InstaApi.uploadAndPublishPost(
      imageUrls: imageUrls,
      caption: caption,
      accessToken: accessToken,
      userId: userId,
    );
  }
}
