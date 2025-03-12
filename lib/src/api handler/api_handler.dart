import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../flutter_instagram_api.dart';
import '../modal/user_data_model.dart';

/// Handles Instagram API requests
class InstaApi {
  static late InstaConfig config;

  /// Step 1 & Step 2 Combined: Exchange Authorization Code → Get Long-Lived Token
  static Future<String?> getAccessToken({required String code}) async {
    try {
      var url = Uri.parse('https://api.instagram.com/oauth/access_token');
      var response = await http.post(url, body: {
        'client_id': config.instaID,
        'client_secret': config.instaSecret,
        'grant_type': 'authorization_code',
        'redirect_uri': config.reDirectURL.toString(),
        'code': code,
      });

      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        String shortLivedToken = data['access_token'];

        // Immediately convert short-lived token to long-lived token
        return await _getLongLivedToken(shortLivedToken);
      } else {
        print('Error fetching access token: ${data['error']}');
        return null;
      }
    } catch (e) {
      print('Exception in getAccessToken: $e');
      return null;
    }
  }

  /// Step 2: Convert Short-Lived Token to Long-Lived Token
  static Future<String?> _getLongLivedToken(String shortLivedToken) async {
    try {
      var url = Uri.parse(
        'https://graph.instagram.com/access_token?'
            'grant_type=ig_exchange_token&'
            'client_secret=${config.instaSecret}&'
            'access_token=$shortLivedToken',
      );

      var response = await http.get(url);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return data['access_token']; // Returning Long-Lived Token
      } else {
        print('Error converting to long-lived token: ${data['error']}');
        return null;
      }
    } catch (e) {
      print('Exception in _getLongLivedToken: $e');
      return null;
    }
  }

  /// Step 3: Fetch User Data
  static Future<UserDataModel?> getUserData({required String accessToken}) async {
    try {
      var url = Uri.parse(
        'https://graph.instagram.com/me?fields=id,username,account_type,media_count,profile_picture_url&access_token=$accessToken',
      );

      var response = await http.get(url);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return UserDataModel.fromJson(data, accessToken: accessToken);
      } else {
        print('Error fetching user data: ${data['error']}');
        return null;
      }
    } catch (e) {
      print('Exception in getUserData: $e');
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
      List<String> containerIds = [];

      // Step 4.1: Upload each image to an Instagram media container
      for (String imageUrl in imageUrls) {
        var uploadUrl = Uri.parse('https://graph.facebook.com/v19.0/$userId/media');
        var uploadResponse = await http.post(uploadUrl, body: {
          'image_url': imageUrl,
          'caption': caption,
          'access_token': accessToken,
        });

        var uploadData = jsonDecode(uploadResponse.body);
        if (uploadResponse.statusCode == 200) {
          containerIds.add(uploadData['id']);
        } else {
          print('Error uploading media: ${uploadData['error']}');
          return false;
        }
      }

      // If only one image, publish it directly
      if (containerIds.length == 1) {
        var publishUrl = Uri.parse('https://graph.facebook.com/v19.0/$userId/media_publish');
        var publishResponse = await http.post(publishUrl, body: {
          'creation_id': containerIds.first,
          'access_token': accessToken,
        });

        if (publishResponse.statusCode == 200) {
          return true; // Successfully posted single image
        } else {
          print('Error publishing single image: ${jsonDecode(publishResponse.body)['error']}');
          return false;
        }
      }

      // Step 4.2: Create a carousel container for multiple images
      var carouselUrl = Uri.parse('https://graph.facebook.com/v19.0/$userId/media');
      var carouselResponse = await http.post(carouselUrl, body: {
        'media_type': 'CAROUSEL',
        'children': containerIds.join(','), // Add all media container IDs
        'access_token': accessToken,
      });

      var carouselData = jsonDecode(carouselResponse.body);
      if (carouselResponse.statusCode != 200) {
        print('Error creating carousel: ${carouselData['error']}');
        return false;
      }

      String carouselId = carouselData['id'];

      // Step 4.3: Publish the carousel post
      var publishCarouselUrl = Uri.parse('https://graph.facebook.com/v19.0/$userId/media_publish');
      var publishCarouselResponse = await http.post(publishCarouselUrl, body: {
        'creation_id': carouselId,
        'access_token': accessToken,
      });

      if (publishCarouselResponse.statusCode == 200) {
        return true; // Successfully posted multiple images
      } else {
        print('Error publishing carousel: ${jsonDecode(publishCarouselResponse.body)['error']}');
        return false;
      }
    } catch (e) {
      print('Exception in uploadAndPublishPost: $e');
      return false;
    }
  }
}
