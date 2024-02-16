import 'package:flutter/material.dart';
import 'package:jobasheet/src/features/authentification/models/note_model.dart';

class NoteView extends StatelessWidget {
  const NoteView(
      {super.key,
      required this.note,
      required this.index,
      required this.onNoteDeleted});

  final Note note;
  final int index;
  final Function(int) onNoteDeleted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Note"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Delete This?"),
                    content: Text('Note ${note.title} will be deleted!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onNoteDeleted(index);
                          Navigator.of(context).pop();
                        },
                        child: Text("DELETE"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("CANCEL"),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              note.title,
              style: TextStyle(fontSize: 26),
            ),
            SizedBox(height: 10),
            Text(
              note.body,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
