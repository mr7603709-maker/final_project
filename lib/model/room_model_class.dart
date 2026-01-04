import 'dart:convert';
import 'package:flutter/foundation.dart';

class RoomModel {
  String? roomId;
  String? name;
  String? creatorId; // admin userId
  String? creatorName; // admin name
  bool? isPrivate;
  List<String>? members;

  RoomModel({
    this.roomId,
    this.name,
    this.creatorId,
    this.creatorName,
    this.isPrivate,
    this.members,
  });

  RoomModel copyWith({
    String? roomId,
    String? name,
    String? creatorId,
    String? creatorName,
    bool? isPrivate,
    List<String>? members,
  }) {
    return RoomModel(
      roomId: roomId ?? this.roomId,
      name: name ?? this.name,
      creatorId: creatorId ?? this.creatorId,
      creatorName: creatorName ?? this.creatorName,
      isPrivate: isPrivate ?? this.isPrivate,
      members: members ?? this.members,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'roomId': roomId,
      'name': name,
      'creatorId': creatorId,
      'creatorName': creatorName,
      'isPrivate': isPrivate,
      'members': members,
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      roomId: map['roomId'] != null ? map['roomId'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      creatorId: map['creatorId'] != null ? map['creatorId'] as String : null,
      creatorName: map['creatorName'] != null ? map['creatorName'] as String : null,
      isPrivate: map['isPrivate'] != null ? map['isPrivate'] as bool : null,
      members: map['members'] != null
          ? List<String>.from((map['members'] as List<dynamic>))
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory RoomModel.fromJson(String source) =>
      RoomModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RoomModel(roomId: $roomId, name: $name, creatorId: $creatorId, creatorName: $creatorName, isPrivate: $isPrivate, members: $members)';
  }

  @override
  bool operator ==(covariant RoomModel other) {
    if (identical(this, other)) return true;

    return other.roomId == roomId &&
        other.name == name &&
        other.creatorId == creatorId &&
        other.creatorName == creatorName &&
        other.isPrivate == isPrivate &&
        listEquals(other.members, members);
  }

  @override
  int get hashCode {
    return roomId.hashCode ^
        name.hashCode ^
        creatorId.hashCode ^
        creatorName.hashCode ^
        isPrivate.hashCode ^
        members.hashCode;
  }
}
