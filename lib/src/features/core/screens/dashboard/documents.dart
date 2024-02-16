import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:jobasheet/src/features/core/screens/dashboard/innerdocuments/email.dart';
import 'package:jobasheet/src/features/core/screens/dashboard/innerdocuments/file_photos.dart';
import 'package:jobasheet/src/features/core/screens/dashboard/innerdocuments/notes_page.dart';

class Documents extends StatefulWidget {
  const Documents({super.key});

  @override
  State<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  int index = 0;

  final screens = [
    NotesPage(),
    FilesPage(),
    EmailPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: screens[index],
        bottomNavigationBar: CurvedNavigationBar(
          index: index,
          onTap: (index) => setState(() => this.index = index),
          animationDuration: Duration(milliseconds: 300),
          color: Colors.black87,
          backgroundColor: Colors.grey,
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
