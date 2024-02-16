import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:jobasheet/src/features/core/screens/dashboard/inspections/approved_inspections.dart';
import 'package:jobasheet/src/features/core/screens/dashboard/inspections/pending_inspections.dart';

class Inspections extends StatefulWidget {
  const Inspections({super.key});

  @override
  State<Inspections> createState() => _InspectionsState();
}

class _InspectionsState extends State<Inspections> {
  int index = 0;

  final screens = [
    PendingInspections(),
    ApprovedInspections(),
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
          items: [
            Icon(Icons.track_changes_outlined),
            Icon(Icons.approval_rounded),
          ],
        ),
      ),
    );
  }
}
