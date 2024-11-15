class MessageModel {
  final String id;
  final String text;
  final String date;
  final String senderId;
  final String? receiverId;
  final String? senderPicture;
  final List<String> imagesUrl;
  final bool isEdited;

  MessageModel({
    required this.id,
    required this.text,
    required this.date,
    required this.senderId,
    required this.imagesUrl,
    required this.isEdited,
    this.receiverId,
    this.senderPicture,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'date': date,
      'senderId': senderId,
      'receiverId': receiverId,
      'isEdited': isEdited,
      'imagesUrl': imagesUrl,
      'senderPicture': senderPicture,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'],
      text: map['text'],
      date: map['date'],
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      imagesUrl: map['imagesUrl'].cast<String>(),
      isEdited: map['isEdited'],
      senderPicture: map['senderPicture'],
    );
  }

  MessageModel copyWith({
    String? text,
    bool? isEdited,
    List<String>? imagesUrl,
  }) {
    return MessageModel(
      id: id,
      text: text ?? this.text,
      date: date,
      senderId: senderId,
      receiverId: receiverId,
      isEdited: isEdited ?? this.isEdited,
      imagesUrl: imagesUrl ?? this.imagesUrl,
      senderPicture: senderPicture,
    );
  }
}
