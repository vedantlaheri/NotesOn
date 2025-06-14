import 'package:flutter/material.dart';
import 'package:noteson/notes_db.dart';
import 'package:noteson/screens/notes_card.dart';
import 'package:noteson/screens/notes_dialog.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchNotes() async {
    final fetchedNotes = await NotesDb.instance.getNotes();

    setState(() {
      notes = fetchedNotes;
    });
  }

  final List<Color> noteColors = [
    const Color(0xFFF3E5F5), // Light Purple
    const Color(0xFFFFF3E0), // Light Orange
    const Color(0xFFE3F2FD), // Light Blue
    const Color(0xFFE8F5E9), // Light Green
    const Color(0xFFFFEBEE), // Light Red
    const Color(0xFFFFFDE7), // Light Yellow
    const Color(0xFFFBE9E7), // Peach
    const Color(0xFFF1F8E9), // Pale Green
    const Color(0xFFEDE7F6), // Lavender
    const Color(0xFFFFF8E1), // Soft Amber
    // More pastel tones
    const Color(0xFFE0F7FA), // Cyan Tint
    const Color(0xFFE1F5FE), // Powder Blue
    const Color(0xFFFFE0B2), // Apricot
    const Color(0xFFDCEDC8), // Lime Tint
    const Color(0xFFFFCDD2), // Rose
    const Color(0xFFD1C4E9), // Soft Violet
    const Color(0xFFFFF9C4), // Lemon Tint
    const Color(0xFFB2DFDB), // Teal Tint
    const Color(0xFFCFD8DC), // Cool Gray
    // More vibrant options
    const Color(0xFF81D4FA), // Sky Blue
    const Color(0xFF4DB6AC), // Aqua
    const Color(0xFFFF8A65), // Coral
    const Color(0xFFBA68C8), // Orchid
    const Color(0xFFAED581), // Light Lime
    const Color(0xFFFFD54F), // Golden Yellow
    // Muted neutrals
    const Color(0xFFFAFAFA), // Almost White
    const Color(0xFFF5F5F5), // Very Light Gray
    const Color(0xFFE0E0E0), // Light Gray
    const Color(0xFFBDBDBD), // Gray
  ];

  void showNoteDialog({
    int? id,
    String? title,
    String? content,
    int colorIndex = 0,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return NotesDialog(
          colorIndex: colorIndex,
          noteColors: noteColors,
          noteId: id,
          title: title,
          content: content,
          onNotesSaved: (
            newtTitle,
            newDescription,
            currentDate,
            selectedColorIndex,
          ) async {
            if (id == null) {
              await NotesDb.instance.addNote(
                newtTitle,
                newDescription,
                selectedColorIndex,
                currentDate,
              );
            } else {
              await NotesDb.instance.updateNote(
                id,
                newtTitle,
                newDescription,
                selectedColorIndex,
                currentDate,
              );
            }
            fetchNotes();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'NotesOn',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showNoteDialog();
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black87),
      ),
      body:
          notes.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notes_outlined, size: 80, color: Colors.grey),
                    const SizedBox(height: 20),

                    Text(
                      'No Notes Found',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return NotesCard(
                      note: note,
                      onDelete: () async {
                        await NotesDb.instance.deleteNote(note['id']);
                        fetchNotes();
                      },
                      onTap: () {
                        showNoteDialog(
                          id: note['id'],
                          title: note['title'],
                          content: note['description'],
                          colorIndex: note['color'],
                        );
                      },
                      noteColors: noteColors,
                    );
                  },
                ),
              ),
    );
  }
}
