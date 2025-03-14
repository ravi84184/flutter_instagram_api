import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../flutter_instagram_api.dart';
import '../modal/user_data_model.dart';

/// Handles Instagram API requests
class InstaApi {
  static late InstaConfig config;

  /// Step 1 & Step 2 Combined: Exchange Authorization Code → Get Long-Lived Token
  static Future<String?> getAccessToken({required String code}) async {
    try {
      log("🔵 Step 1: Requesting short-lived access token...");
      var url = Uri.parse('https://api.instagram.com/oauth/access_token');
      log("Request URL: $url");

      var response = await http.post(url, body: {
        'client_id': config.instaID,
        'client_secret': config.instaSecret,
        'grant_type': 'authorization_code',
        'redirect_uri': config.reDirectURL.toString(),
        'code': code,
      });

      var data = jsonDecode(response.body);
      log("Response: ${response.body}");

      if (response.statusCode == 200) {
        String shortLivedToken = data['access_token'];
        log("✅ Received short-lived token: $shortLivedToken");

        // Immediately convert short-lived token to long-lived token
        return await _getLongLivedToken(shortLivedToken);
      } else {
        log('❌ Error fetching access token: ${data['error']}');
        return null;
      }
    } catch (e) {
      log('⚠️ Exception in getAccessToken: $e');
      return null;
    }
  }

  /// Step 2: Convert Short-Lived Token to Long-Lived Token
  static Future<String?> _getLongLivedToken(String shortLivedToken) async {
    try {
      log("🔵 Step 2: Converting short-lived token to long-lived token...");
      var url = Uri.parse(
        'https://graph.instagram.com/access_token'
            '?grant_type=ig_exchange_token'
            '&client_secret=${config.instaSecret}'
            '&access_token=$shortLivedToken',
      );
      log("Request URL: $url");

      var response = await http.get(url); // Using GET request
      var data = jsonDecode(response.body);
      log("Response: ${response.body}");

      if (response.statusCode == 200) {
        log("✅ Received long-lived token: ${data['access_token']}");
        return data['access_token'];
      } else {
        log('❌ Error converting to long-lived token: ${data['error']}');
        return null;
      }
    } catch (e) {
      log('⚠️ Exception in _getLongLivedToken: $e');
      return null;
    }
  }

  /// Step 3: Fetch User Data
  static Future<UserDataModel?> getUserData({required String accessToken}) async {
    try {
      log("🔵 Step 3: Fetching user data...");
      var url = Uri.parse(
        'https://graph.instagram.com/me?fields=id,username,account_type,media_count,profile_picture_url&access_token=$accessToken',
      );
      log("Request URL: $url");

      var response = await http.get(url);
      var data = jsonDecode(response.body);
      log("Response: ${response.body}");

      if (response.statusCode == 200) {
        log("✅ Successfully fetched user data.");
        return UserDataModel.fromJson(data, accessToken: accessToken);
      } else {
        log('❌ Error fetching user data: ${data['error']}');
        return null;
      }
    } catch (e) {
      log('⚠️ Exception in getUserData: $e');
      return null;
    }
  }

  /// Step 4: Upload and Publish **Single or Multiple Images** to Instagram
  static Future<bool> uploadAndPublishPost({
    required List<String> imageUrls, // List of image URLs
    required String caption,
    required String accessToken,
    required String userId,
  }) async {
    try {
      log("🔵 Step 4: Uploading images and publishing post...");
      List<String> containerIds = [];

      // Step 4.1: Upload each image to an Instagram media container
      for (String imageUrl in imageUrls) {
        log("🟢 Uploading image: $imageUrl");
        var uploadUrl = Uri.parse('https://graph.instagram.com/v22.0/$userId/media');
        log("Request URL: $uploadUrl");

        var uploadResponse = await http.post(uploadUrl, body: {
          'image_url': imageUrl,
          'caption': caption,
          'access_token': accessToken,
        });

        var uploadData = jsonDecode(uploadResponse.body);
        log("Response: ${uploadResponse.body}");

        if (uploadResponse.statusCode == 200) {
          containerIds.add(uploadData['id']);
          log("✅ Successfully uploaded media. ID: ${uploadData['id']}");
        } else {
          log('❌ Error uploading media: ${uploadData['error']}');
          return false;
        }
      }

      // If only one image, publish it directly
      if (containerIds.length == 1) {
        log("🔵 Publishing single image...");
        var publishUrl = Uri.parse('https://graph.instagram.com/v22.0/$userId/media_publish');
        log("Request URL: $publishUrl");

        var publishResponse = await http.post(publishUrl, body: {
          'creation_id': containerIds.first,
          'access_token': accessToken,
        });

        log("Response: ${publishResponse.body}");

        if (publishResponse.statusCode == 200) {
          log("✅ Successfully posted single image.");
          return true;
        } else {
          log('❌ Error publishing single image: ${jsonDecode(publishResponse.body)['error']}');
          return false;
        }
      }

      return false;
    } catch (e) {
      log('⚠️ Exception in uploadAndPublishPost: $e');
      return false;
    }
  }
}
