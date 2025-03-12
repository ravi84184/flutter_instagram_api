class UserDataModel {
  final String? userId;
  final String? id;
  final String? username;
  final String? name;
  final String? accountType;
  final String? profilePictureUrl;
  final int? followersCount;
  final int? followsCount;
  final int? mediaCount;
  final String? accessToken;
  UserDataModel(
      {this.userId,
      this.username,
      this.name,
      this.accountType,
      this.profilePictureUrl,
      this.followersCount,
      this.followsCount,
      this.mediaCount,
      this.id,
      this.accessToken});

  factory UserDataModel.fromJson(Map<String, dynamic> json, {String? accessToken}) => UserDataModel(
      userId: json["user_id"],
      username: json["username"],
      name: json["name"],
      accountType: json["account_type"],
      profilePictureUrl: json["profile_picture_url"],
      followersCount: json["followers_count"],
      followsCount: json["follows_count"],
      mediaCount: json["media_count"],
      id: json['id'],
      accessToken: accessToken);

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "username": username,
        "name": name,
        "account_type": accountType,
        "profile_picture_url": profilePictureUrl,
        "followers_count": followersCount,
        "follows_count": followsCount,
        "media_count": mediaCount,

      };
}
