import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
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
              Icon(Icons.macro_off),
              Icon(Icons.plumbing),
              Icon(Icons.stream),
              Icon(Icons.co2)
            ]),
      ),
    );
  }
}
