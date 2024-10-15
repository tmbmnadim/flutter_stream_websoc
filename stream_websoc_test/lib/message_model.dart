class MessageModel {
  final String sender;
  final String message;
  final DateTime timestamp;

  MessageModel({
    required this.sender,
    required this.message,
    required this.timestamp,
  });

  // Convert CustomModel to a JSON map
  Map<String, dynamic> toJson() => {
        'sender': sender,
        'message': message,
        'timestamp': timestamp.toIso8601String(),
      };

  // Create CustomModel from a JSON map
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      sender: json['sender'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
