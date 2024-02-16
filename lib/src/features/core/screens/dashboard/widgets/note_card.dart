import 'package:flutter/material.dart';
import 'package:jobasheet/src/features/authentification/models/note_model.dart';
import 'package:jobasheet/src/features/core/screens/dashboard/widgets/note_view.dart';

class NoteCard extends StatelessWidget {
  const NoteCard(
      {super.key,
      required this.note,
      required this.index,
      required this.onNoteDeleted});
  final Note note;
  final int index;
  final Function(int) onNoteDeleted;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteView(
              note: note,
              index: index,
              onNoteDeleted: onNoteDeleted,
            ),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              Text(
                note.body,
                style: TextStyle(fontSize: 18),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
