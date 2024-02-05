import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class Inspections extends StatefulWidget {
  const Inspections({super.key});

  @override
  State<Inspections> createState() => _InspectionsState();
}

class _InspectionsState extends State<Inspections> {
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
            Icon(Icons.track_changes_outlined),
            Icon(Icons.approval_rounded),
          ],
        ),
      ),
    );
  }
}
