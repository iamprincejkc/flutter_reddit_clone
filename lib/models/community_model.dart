import 'dart:convert';

import 'package:flutter/foundation.dart';

class Community {
  final String id;
  final String name;
  final String banner;
  final String avatar;
  final List<String> members;
  final List<String> mods;

  Community(
    this.id,
    this.name,
    this.banner,
    this.avatar,
    this.members,
    this.mods,
  );

  Community copyWith({
    String? id,
    String? name,
    String? banner,
    String? avatar,
    List<String>? members,
    List<String>? mods,
  }) {
    return Community(
      id ?? this.id,
      name ?? this.name,
      banner ?? this.banner,
      avatar ?? this.avatar,
      members ?? this.members,
      mods ?? this.mods,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'banner': banner,
      'avatar': avatar,
      'members': members,
      'mods': mods,
    };
  }

  factory Community.fromMap(Map<String, dynamic> map) {
    return Community(
      map['id'] ?? '',
      map['name'] ?? '',
      map['banner'] ?? '',
      map['avatar'] ?? '',
      List<String>.from(map['members']),
      List<String>.from(map['mods']),
    );
  }
  
  @override
  String toString() {
    return 'Community(id: $id, name: $name, banner: $banner, avatar: $avatar, members: $members, mods: $mods)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Community &&
      other.id == id &&
      other.name == name &&
      other.banner == banner &&
      other.avatar == avatar &&
      listEquals(other.members, members) &&
      listEquals(other.mods, mods);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      banner.hashCode ^
      avatar.hashCode ^
      members.hashCode ^
      mods.hashCode;
  }
}
