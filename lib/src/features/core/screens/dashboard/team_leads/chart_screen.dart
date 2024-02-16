import 'package:flutter/material.dart';
import 'package:jobasheet/src/features/core/screens/dashboard/widgets/chat/messages.dart';
import 'package:jobasheet/src/features/core/screens/dashboard/widgets/chat/new_message.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text(
          "PublicChat",
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: Messages()),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
