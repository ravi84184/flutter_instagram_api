# Instagram Login & Media Upload for Flutter 🚀

A Flutter package for **secure Instagram login** using OAuth authentication. It allows fetching user details and supports **image uploads (single & carousel)** to Instagram via the Graph API.

## Features 🌟

- **OAuth-based login** with Instagram.
- **Fetch user profile details** (ID, username, account type, profile picture, media count).
- **Upload and publish Instagram posts** (single images & carousels).
- **Easy integration** with your Flutter app.
- **Requires a Meta Developer account & Instagram App setup.**

---

## Getting Started 🏁

### Installation

Run this command to install the package:

```sh
flutter pub add flutter_instagram_api
```  

Or, manually add it to your **pubspec.yaml**:

```yaml
dependencies:
  flutter_instagram_api: latest_version
```  

---

## Usage 📌

### Import the package

```dart
import 'package:flutter_instagram_api/flutter_instagram_api.dart';
```  

---

### 1️⃣ **Login & Fetch User Data**

Use the following method to initiate Instagram login and fetch user details:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_instagram_api/flutter_instagram_api.dart';

class InstagramLoginScreen extends StatelessWidget {
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
                instaUrl: 'https://your-meta-developer-url.com',
                clientId: 'your_client_id',
                clientSecret: 'your_client_secret',
              ),
              userData: (UserDataModel data) {
                print('✅ User Data Retrieved:');
                print('📌 User ID: ${data.userId}');
                print('👤 Username: ${data.username}');
                print('📷 Profile Picture: ${data.profilePictureUrl}');
                print('📊 Account Type: ${data.accountType}');
                print('🎥 Media Count: ${data.mediaCount}');
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

---

### 2️⃣ **Upload & Publish Posts (Single or Multiple Images)**

```dart
void uploadPost() async {
  bool success = await FlutterInstagramApi.uploadPost(
    imageUrls: [
      'https://example.com/image1.jpg',
      'https://example.com/image2.jpg'
    ], // Supports single or multiple images
    caption: "My Instagram Post via API 🚀",
    accessToken: "your_access_token",
    userId: "your_instagram_user_id",
  );

  if (success) {
    print("🎉 Post uploaded successfully!");
  } else {
    print("❌ Failed to upload post.");
  }
}
```  

---

## **Instagram API Setup (Meta Developer Account) 🛠️**

To use this package, you need to set up an **Instagram App** in the **Meta Developer Portal**:

### **1️⃣ Register Your App**
- Go to the [Meta Developer Portal](https://developers.facebook.com/).
- Create a new **Business App**.
- Add **Instagram** as a product & set up **Instagram Graph API**.

### **2️⃣ Configure OAuth & Permissions**
- Navigate to **Instagram Basic Display API** settings.
- Add your **OAuth Redirect URL** (e.g., `https://your-app.com/auth`).
- Set permissions:
    - `user_profile` (Fetch user ID, username, and profile picture)
    - `user_media` (Retrieve user media for posting)

### **3️⃣ Obtain API Credentials**
- Get **Client ID** & **Client Secret** from your Instagram App settings.
- Ensure your app is **Live** or in **Development Mode** for testing.

---

## **Troubleshooting & Notes** 🛠️

⚠️ **Permissions Issues?**
- Ensure you’ve enabled **Instagram Graph API** in your Meta Developer settings.
- Use a verified **Instagram Business or Creator account**.

⚠️ **Login Not Working?**
- Verify that your **Redirect URI** matches what you set in the Meta Developer Console.
- Ensure your **Client ID & Client Secret** are correct.

⚠️ **Post Upload Failing?**
- The **image URLs must be publicly accessible**.
- The Instagram Business account must have **permissions to publish posts**.

---

## **License 📝**

This package is **open-source** and licensed under the **MIT License**.

---

### **📩 Need Help?**
For issues, feature requests, or contributions, check out the [GitHub Repository](https://github.com/KaranParmarkp/flutter_instagram_api).

🚀 **Happy Coding!**  
