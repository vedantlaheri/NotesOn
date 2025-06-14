import 'package:flutter/material.dart';
import 'package:noteson/screens/notes_screen.dart';

void main() {
  runApp(NoteOn());
}

class NoteOn extends StatelessWidget {
  const NoteOn({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NotesOn',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const NotesScreen(),
    );
  }
}
