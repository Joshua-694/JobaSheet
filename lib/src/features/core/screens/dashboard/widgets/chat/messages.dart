import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobasheet/src/features/core/screens/dashboard/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future(() => FirebaseAuth.instance.currentUser!),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("chat")
                .orderBy(
                  'createdAt',
                  descending: true,
                )
                .snapshots(),
            builder: (context, chatSnapshot) {
              final chatDocs = chatSnapshot.data?.docs;
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                reverse: true,
                itemCount: chatDocs?.length,
                itemBuilder: ((context, index) => MessageBubble(
                      chatDocs?[index]["text"],
                      chatDocs?[index]["userId"] == futureSnapshot.data?.uid,
                      chatDocs?[index]["username"],
                      key: ValueKey(chatDocs?[index].reference),
                    )),
              );
            });
      },
    );
  }
}
