import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class Documents extends StatefulWidget {
  const Documents({super.key});

  @override
  State<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Text("Messages"),
        ),
        backgroundColor: Colors.white,
        bottomNavigationBar: CurvedNavigationBar(
          onTap: (Index) {
            setState(() {});
          },
          animationDuration: Duration(milliseconds: 300),
          color: Colors.black87,
          backgroundColor: Colors.white,
          items: [
            Icon(Icons.file_copy_outlined),
            Icon(Icons.note_add),
            Icon(
              Icons.email_outlined,
            )
          ],
        ),
      ),
    );
  }
}
