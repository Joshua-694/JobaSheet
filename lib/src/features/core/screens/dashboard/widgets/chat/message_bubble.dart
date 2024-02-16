import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MessageBubble extends StatelessWidget {
  MessageBubble(this.message, this.isMe, this.userName, {required this.key});
  final String userName;
  final Key key;
  final String message;
  bool isMe;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                bottomRight: !isMe ? Radius.circular(0) : Radius.circular(12)),
            color: isMe ? Colors.white : Colors.grey[300],
          ),
          width: 140,
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          margin: EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isMe ? Colors.black : Colors.black38),
              ),
              Text(
                message,
                style: TextStyle(color: isMe ? Colors.black : Colors.black38),
                textAlign: isMe ? TextAlign.end : TextAlign.start,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
