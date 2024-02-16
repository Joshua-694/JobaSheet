import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:jobasheet/src/features/core/screens/dashboard/team_leads/chart_screen.dart';
import 'package:jobasheet/src/features/core/screens/dashboard/team_leads/schedule_meeting.dart';

class TeamLeads extends StatefulWidget {
  const TeamLeads({super.key});

  @override
  State<TeamLeads> createState() => _TeamLeadsState();
}

class _TeamLeadsState extends State<TeamLeads> {
  int index = 0;
  final screen = [
    ChartScreen(),
    ScheduleMeeting(),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: screen[index],
        backgroundColor: Colors.white,
        bottomNavigationBar: CurvedNavigationBar(
          index: index,
          onTap: (index) => setState(() => this.index = index),
          animationDuration: Duration(milliseconds: 300),
          color: Colors.black,
          backgroundColor: Colors.grey,
          items: [
            Icon(Icons.chat_rounded),
            Icon(Icons.meeting_room),
          ],
        ),
      ),
    );
  }
}
