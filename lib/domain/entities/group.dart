class Group {
  String name;
  String chatId;
  List<GroupMember> member;
  String profilePhotoUrl;
  String? lastMessage;
  String? lastMessageTimeStamp;
  List<String>? activeMember;
  Group(
      {required this.name,
      required this.member,
      required this.chatId,
      required this.profilePhotoUrl,
      this.lastMessage = "",
      this.lastMessageTimeStamp = ""});

  Map<String, dynamic> toJson() => {
        'name': name,
        'chatId': chatId,
        'member': member.map((e) => e.toJson()).toList(),
        'profilePhotoUrl': profilePhotoUrl,
        'lastMessageTimeStamp': lastMessageTimeStamp,
        'lastMessage': lastMessage,
        'activeMember': member.map((e) => e.memberId).toList()
      };

  factory Group.fromJson(Map<String, dynamic> data) {
    return Group(
        name: data['name'] as String? ?? '',
        chatId: data['chatId'] as String? ?? '',
        member: (data["member"] as List<dynamic>)
            .map((e) => GroupMember.fromJson(e))
            .toList(),
        profilePhotoUrl: data['profilePhotoUrl'] as String? ?? '',
        lastMessage: data['lastMessage'],
        lastMessageTimeStamp: data['lastMessageTimeStamp']);
  }
}

class GroupMember {
  String? memberId;
  bool? isAdmin;

  GroupMember({required this.memberId, required this.isAdmin});

  Map<String, dynamic> toJson() => {'memberId': memberId, 'isAdmin': isAdmin};

  GroupMember.fromJson(Map<String, dynamic> data) {
    memberId = data['memberId'] ?? '';
    isAdmin = data['isAdmin'] ?? false;
  }
}
