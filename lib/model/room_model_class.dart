import 'dart:convert';
import 'package:flutter/foundation.dart';

class RoomModel {
  final String roomId;
  final String name;
  final String creatorId;      // admin userId
  final String creatorName;    // admin name
  final bool isPrivate;
  final List<String> members;

  const RoomModel({
    required this.roomId,
    required this.name,
    required this.creatorId,
    required this.creatorName,
    required this.isPrivate,
    required this.members,
  });

  /// copyWith
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

  /// Firestore / Map
  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'name': name,
      'creatorId': creatorId,
      'creatorName': creatorName,
      'isPrivate': isPrivate,
      'members': members,
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map, String docId) {
    return RoomModel(
      roomId: docId, // 🔥 Firestore doc.id
      name: map['roomName'] ?? '',
      creatorId: map['adminId'] ?? '',
      creatorName: map['adminName'] ?? '',
      isPrivate: map['private'] ?? false,
      members: map['members'] != null
          ? List<String>.from(map['members'])
          : <String>[],
    );
  }

  String toJson() => json.encode(toMap());

  factory RoomModel.fromJson(String source) =>
      RoomModel.fromMap(json.decode(source), '');

  @override
  String toString() {
    return 'RoomModel(roomId: $roomId, name: $name, creatorId: $creatorId, creatorName: $creatorName, isPrivate: $isPrivate, members: $members)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RoomModel &&
        other.roomId == roomId &&
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