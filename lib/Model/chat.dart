class Message {
  final String msgId;
  final String senderId;
  final String receiverId;
  final String message;
  final String sentAt;

  Message({
    required this.msgId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.sentAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      msgId: json['msg_id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      message: json['message'],
      sentAt: json['sent_at'],
    );
  }
}