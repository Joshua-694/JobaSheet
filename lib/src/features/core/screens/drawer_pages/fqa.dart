import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ'),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 20),
        children: <Widget>[
          Text('Q1: How to use this app?',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text('A1: Simply navigate through the app to find what you need.\n'),
          SizedBox(height: 15),
          Text('Q2: Who can I contact for support?',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
              'A2: You can contact our support team by going to the Settings & Support page and tapping on Contact Support.\n'),
          // Add more questions here
        ],
      ),
    );
  }
}
