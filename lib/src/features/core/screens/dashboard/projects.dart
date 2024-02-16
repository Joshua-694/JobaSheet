import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:jobasheet/src/features/core/screens/dashboard/projects/current_projects.dart';
import 'package:jobasheet/src/features/core/screens/dashboard/projects/future_projects.dart';

class Projects extends StatefulWidget {
  const Projects({super.key});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  int index = 0;

  final screens = [
    CurrentProjects(),
    FutureProjects(),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: screens[index],
        backgroundColor: Colors.white,
        bottomNavigationBar: CurvedNavigationBar(
            index: index,
            onTap: (index) => setState(() => this.index = index),
            animationDuration: Duration(milliseconds: 300),
            color: Colors.black,
            backgroundColor: Colors.grey,
            items: [Icon(Icons.timelapse), Icon(Icons.opacity_sharp)]),
      ),
    );
  }
}
