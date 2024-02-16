import 'package:flutter/material.dart';
import 'package:jobasheet/src/features/authentification/models/note_model.dart';
import 'package:jobasheet/src/features/core/screens/dashboard/innerdocuments/create_note.dart';
import 'package:jobasheet/src/features/core/screens/dashboard/widgets/note_card.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotespageState();
}

class _NotespageState extends State<NotesPage> {
  List<Note> notes = List.empty(growable: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Center(
          child: Text(
            "Project Notes",
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return NoteCard(
            note: notes[index],
            index: index,
            onNoteDeleted: onNoteDeleted,
          );
        },
      ),
      backgroundColor: Colors.grey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateNotes(
                onNewNoteCreated: onNewNoteCreated,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void onNewNoteCreated(Note note) {
    notes.add(note);
    setState(() {});
  }

  void onNoteDeleted(int index) {
    notes.removeAt(index);
    setState(() {});
  }
}
