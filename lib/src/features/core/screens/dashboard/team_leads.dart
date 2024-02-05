import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class TeamLeads extends StatefulWidget {
  const TeamLeads({super.key});

  @override
  State<TeamLeads> createState() => _TeamLeadsState();
}

class _TeamLeadsState extends State<TeamLeads> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: CurvedNavigationBar(
          animationDuration: Duration(milliseconds: 300),
          color: Colors.black,
          backgroundColor: Colors.white,
          items: [
            Icon(Icons.chat_rounded),
            Icon(Icons.meeting_room),
          ],
        ),
      ),
    );
  }
}
