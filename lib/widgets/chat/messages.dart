import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator.adaptive());
        }

        final chatDocs = snapshot.data?.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs!.length,
          itemBuilder: (ctx, index) => MessageBubble(
              chatDocs[index]['text'],
              chatDocs[index]['username'],
              chatDocs[index]['userImage'],
              chatDocs[index]['userId'] ==
                  FirebaseAuth.instance.currentUser!.uid,
              key: ValueKey(chatDocs[index].reference.id)),
        );
      },
    );
    // return FutureBuilder(
    //   future: Future.value(FirebaseAuth.instance.currentUser),
    //   builder: (ctx, futureSnapshot) {
    //     if (futureSnapshot.connectionState == ConnectionState.waiting) {
    //       return Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     }
    //     return StreamBuilder(
    //         stream: FirebaseFirestore.instance
    //             .collection('chat')
    //             .orderBy(
    //               'createdAt',
    //               descending: true,
    //             )
    //             .snapshots(),
    //         builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
    //           if (chatSnapshot.connectionState == ConnectionState.waiting) {
    //             return Center(
    //               child: CircularProgressIndicator(),
    //             );
    //           }
    //           final chatDocs = chatSnapshot.data!.docs;
    //           return ListView.builder(
    //             reverse: true,
    //             itemCount: chatDocs.length,
    //             itemBuilder: (ctx, index) => MessageBubble(
    //                 chatDocs[index]['text'],
    //                 chatDocs[index]['username'],
    //                 chatDocs[index]['userImage'],
    //                 chatDocs[index]['userId'] == futureSnapshot.data!.uid,
    //                 key: ValueKey(chatDocs[index].reference.id)),
    //           );
    //         });
    //   },
    // );
  }
}
