import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  const ChatBubble(
      {super.key, required this.message, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isCurrentUser
          ? const EdgeInsets.only(left: 100)
          : const EdgeInsets.only(right: 100),
      child: Container(
        decoration: BoxDecoration(
            color: isCurrentUser
                ? Color.fromARGB(255, 133, 55, 228)
                : Color(0xFFBB86FC),
            borderRadius: isCurrentUser
                ? BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12))
                : BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12))),
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        child: Text(
          message,
          style: GoogleFonts.ubuntu(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}
