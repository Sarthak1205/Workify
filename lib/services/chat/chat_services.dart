import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workify/models/message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();

        return user;
      }).toList();
    });
  }

  Future<void> sendMessage(String receiverId, message) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp);

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomID = ids.join('_');

    await _firestore
        .collection("ChatRooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());

    await _firestore
        .collection("ChatRooms")
        .doc(chatRoomID)
        .set({'userList': ids}, SetOptions(merge: true));
  }

  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("ChatRooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getChatrooms(String userID) {
    return _firestore
        .collection("ChatRooms")
        .where('userList', arrayContains: userID)
        .snapshots();
  }
}
