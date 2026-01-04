import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class FriendModel {
  String? friendname;
  String? friendId;
  String? userId;
  String? fdId;

  FriendModel({
    this.friendname,
    this.friendId,
    this.userId,
    this.fdId,
  });

  FriendModel copyWith({
    String? friendname,
    String? friendId,
    String? userId,
    String? fdId,
  }) {
    return FriendModel(
      friendname: friendname ?? this.friendname,
      friendId: friendId ?? this.friendId,
      userId: userId ?? this.userId,
      fdId: fdId ?? this.fdId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'friendname': friendname,
      'friendId': friendId,
      'userId': userId,
      'fdId': fdId,
    };
  }

  factory FriendModel.fromMap(Map<String, dynamic> map) {
    return FriendModel(
      friendname: map['friendname'] != null ? map['friendname'] as String : null,
      friendId: map['friendId'] != null ? map['friendId'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      fdId: map['fdId'] != null ? map['fdId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FriendModel.fromJson(String source) =>
      FriendModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FriendModel(friendname: $friendname, friendId: $friendId, userId: $userId, fdId: $fdId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FriendModel &&
        other.friendname == friendname &&
        other.friendId == friendId &&
        other.userId == userId &&
        other.fdId == fdId;
  }

  @override
  int get hashCode =>
      friendname.hashCode ^
      friendId.hashCode ^
      userId.hashCode ^
      fdId.hashCode;
}
