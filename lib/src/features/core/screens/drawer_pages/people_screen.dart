import 'package:flutter/material.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.all(30),
          onPressed: () {},
          icon: Icon(Icons.group_add_rounded),
          tooltip: "Team Leads",
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            padding: EdgeInsets.all(30),
            onPressed: () {},
            icon: Icon(Icons.safety_check_rounded),
            tooltip: "safety Meetings",
          ),
        ],
      ),
    );
  }
}
