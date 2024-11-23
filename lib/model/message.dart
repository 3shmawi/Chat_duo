class MessageModel {
  final String id;
  final String message;
  final String createdAt;
  final String updatedAt;
  final String senderId;
  final String? receiverId;
  final String? senderName;
  final String? senderAvatar;
  final List<String> imgUrl;

  MessageModel({
    required this.id,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    required this.senderId,
    required this.receiverId,
    required this.senderName,
    required this.senderAvatar,
    required this.imgUrl,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      message: json['message'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      senderId: json['sender_id'] as String,
      receiverId: json['receiver_id'] as String?,
      senderName: json['sender_name'] as String?,
      senderAvatar: json['sender_avatar'] as String?,
      imgUrl: List<String>.from(json['img_url'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'sender_name': senderName,
      'sender_avatar': senderAvatar,
      'img_url': imgUrl,
    };
  }
}
