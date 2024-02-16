import 'package:flutter/material.dart';

class PendingInspections extends StatelessWidget {
  const PendingInspections({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Pending Inspections"),
      ),
      backgroundColor: Colors.grey,
    );
  }
}
