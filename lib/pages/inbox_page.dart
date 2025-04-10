import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workify/pages/chat/chat_page.dart';
import 'package:workify/services/chat/chat_services.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  final _authService = FirebaseAuth.instance;
  final _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inbox"),
        centerTitle: true,
      ),
      body: _buildChatList(),
    );
  }

  Widget _buildChatList() {
    String senderID = _authService.currentUser!.uid;
    return StreamBuilder(
        stream: _chatService.getChatrooms(senderID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading...");
          }

          return ListView(
            children:
                snapshot.data!.docs.map((doc) => _buildChatItem(doc)).toList(),
          );
        });
  }

  Widget _buildChatItem(DocumentSnapshot doc) {
    List<dynamic> ids = doc['userList'];
    String recieverID = '';
    for (String i in ids) {
      if (i != _authService.currentUser!.uid) {
        recieverID = i;
      }
    }

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .doc(recieverID)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        var recieverDoc = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatPage(
                          receiverEmail: recieverDoc['email'],
                          receiverID: recieverID)));
            },
            child: Container(
              height: 60,
              width: 100,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Icon(Icons.person_2_outlined),
                    SizedBox(
                      width: 50,
                    ),
                    Text(
                      "${recieverDoc['firstName']} ${recieverDoc['lastName']}",
                      style: GoogleFonts.ubuntu(
                          fontSize: 19, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
