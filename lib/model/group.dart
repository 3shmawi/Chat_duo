class GroupModel {
  final String? picture;
  final String? groupName;
  final String lastMessage;
  final String date;
  final List<String>? usersIds;

  GroupModel({
    this.picture,
    this.groupName,
    required this.lastMessage,
    required this.date,
    this.usersIds,
  });

  Map<String, dynamic> toJson() {
    if (groupName == null && picture == null && usersIds == null) {
      return {
        'lastMessage': lastMessage,
        'date': date,
      };
    }
    return {
      'picture': picture,
      'groupName': groupName,
      'lastMessage': lastMessage,
      'date': date,
      'usersIds': usersIds,
    };
  }

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      picture: json['picture'],
      groupName: json['groupName'],
      lastMessage: json['lastMessage'],
      date: json['date'],
      usersIds: List<String>.from(
          json['usersIds']), // Converts List<dynamic> to List<String>
    );
  }

  GroupModel copyWith({
    String? picture,
    String? groupName,
    String? lastMessage,
    String? date,
    List<String>? usersIds,
  }) {
    return GroupModel(
      picture: picture ?? this.picture,
      groupName: groupName ?? this.groupName,
      lastMessage: lastMessage ?? this.lastMessage,
      usersIds: usersIds ?? this.usersIds,
      date: date ?? this.date,
    );
  }
}
