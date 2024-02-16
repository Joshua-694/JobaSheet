import 'package:flutter/material.dart';
import 'package:jobasheet/src/features/authentification/models/note_model.dart';

class CreateNotes extends StatefulWidget {
  const CreateNotes({super.key, required this.onNewNoteCreated});

  final Function(Note) onNewNoteCreated;

  @override
  State<CreateNotes> createState() => _CreateNotesState();
}

class _CreateNotesState extends State<CreateNotes> {
  List users = [];
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              style: TextStyle(
                fontSize: 28,
              ),
              decoration: InputDecoration(
                hintText: "Title",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: bodyController,
              decoration: InputDecoration(
                hintText: "Body",
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (titleController.text.isEmpty) {
            return;
          }
          if (bodyController.text.isEmpty) {
            return;
          }

          final note =
              Note(body: bodyController.text, title: titleController.text);

          widget.onNewNoteCreated(note);
          Navigator.pop(context);
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
