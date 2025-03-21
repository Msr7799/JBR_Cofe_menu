import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminNotes extends StatefulWidget {
  @override
  _AdminNotesState createState() => _AdminNotesState();
}

class _AdminNotesState extends State<AdminNotes> {
  final _notes = <Note>[].obs;
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notesJson = prefs.getStringList('admin_notes') ?? [];
      _notes.value = notesJson.map((json) => Note.fromJson(json)).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    } catch (e) {
      print('خطأ في تحميل الملاحظات: $e');
    }
  }

  Future<void> _saveNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notesJson = _notes.map((note) => note.toJson()).toList();
      await prefs.setStringList('admin_notes', notesJson);
    } catch (e) {
      print('خطأ في حفظ الملاحظات: $e');
    }
  }

  void _addNote() {
    if (_formKey.currentState!.validate()) {
      final note = Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: _textController.text,
        date: DateTime.now(),
      );
      _notes.insert(0, note);
      _textController.clear();
      _saveNotes();
    }
  }

  void _deleteNote(String id) {
    _notes.removeWhere((note) => note.id == id);
    _saveNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الملاحظات'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildAddNoteForm(),
            SizedBox(height: 24),
            Expanded(
              child: _buildNotesList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddNoteForm() {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: -3,
        intensity: 0.8,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _textController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'أضف ملاحظة جديدة...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال نص الملاحظة';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              NeumorphicButton(
                onPressed: _addNote,
                style: NeumorphicStyle(
                  depth: 4,
                  intensity: 0.8,
                ),
                child: Text(
                  'إضافة',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotesList() {
    return Obx(() => ListView.builder(
          itemCount: _notes.length,
          itemBuilder: (context, index) {
            final note = _notes[index];
            return _buildNoteCard(note);
          },
        ));
  }

  Widget _buildNoteCard(Note note) {
    return Neumorphic(
      margin: EdgeInsets.only(bottom: 16),
      style: NeumorphicStyle(
        depth: 4,
        intensity: 0.8,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  note.formattedDate,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline),
                  onPressed: () => _deleteNote(note.id),
                  color: Colors.red,
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              note.text,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

class Note {
  final String id;
  final String text;
  final DateTime date;

  Note({
    required this.id,
    required this.text,
    required this.date,
  });

  String get formattedDate {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }

  factory Note.fromJson(String json) {
    final parts = json.split('|');
    return Note(
      id: parts[0],
      text: parts[1],
      date: DateTime.parse(parts[2]),
    );
  }

  String toJson() {
    return '$id|$text|${date.toIso8601String()}';
  }
}
