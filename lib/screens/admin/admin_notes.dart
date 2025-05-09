import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gpr_coffee_shop/constants/theme.dart'; // إضافة استيراد الثيم

class AdminNotes extends StatefulWidget {
  const AdminNotes({super.key});

  @override
  _AdminNotesState createState() => _AdminNotesState();
}

class _AdminNotesState extends State<AdminNotes> {
  final _notes = <Note>[].obs;
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  // متغيرات للتعديل
  String? _editingNoteId;
  bool _isEditing = false;

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

  // دالة جديدة لتحديث ملاحظة موجودة
  void _updateNote() {
    if (_formKey.currentState!.validate() && _editingNoteId != null) {
      final index = _notes.indexWhere((note) => note.id == _editingNoteId);
      if (index != -1) {
        // إنشاء نسخة جديدة من الملاحظة مع النص المحدث
        final updatedNote = Note(
          id: _editingNoteId!,
          text: _textController.text,
          date: DateTime.now(), // تحديث التاريخ عند التعديل
        );
        
        _notes[index] = updatedNote;
        _notes.sort((a, b) => b.date.compareTo(a.date)); // إعادة ترتيب القائمة
        
        // إعادة تعيين حالة التحرير
        _exitEditingMode();
        _saveNotes();
      }
    }
  }

  // دالة لبدء تحرير ملاحظة
  void _startEditing(Note note) {
    _isEditing = true;
    _editingNoteId = note.id;
    _textController.text = note.text;
  }

  // دالة للخروج من وضع التحرير
  void _exitEditingMode() {
    _isEditing = false;
    _editingNoteId = null;
    _textController.clear();
  }

  void _deleteNote(String id) {
    // إذا كان المستخدم يحرر الملاحظة التي يريد حذفها، نخرج من وضع التحرير أولاً
    if (_editingNoteId == id) {
      _exitEditingMode();
    }
    _notes.removeWhere((note) => note.id == id);
    _saveNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الملاحظات'),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor, // استخدام لون الثيم
        foregroundColor: Colors.white, // تغيير لون النص والأيقونات
        // إضافة زر للخروج من وضع التحرير إذا كنا في وضع التحرير
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _exitEditingMode,
              tooltip: 'إلغاء التعديل',
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildAddNoteForm(),
            const SizedBox(height: 24),
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
        color: Colors.white, // تحديد لون خلفية النيومورفيك
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _textController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: _isEditing ? 'تعديل الملاحظة...' : 'أضف ملاحظة جديدة...',
                  border: const OutlineInputBorder(),
                  // إضافة رمز يدل على وضع التحرير
                  prefixIcon: _isEditing 
                    ? Icon(Icons.edit, color: AppTheme.primaryColor) 
                    : null,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال نص الملاحظة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // زر الإضافة أو التحديث
                  Expanded(
                    child: NeumorphicButton(
                      onPressed: _isEditing ? _updateNote : _addNote,
                      style: NeumorphicStyle(
                        depth: 4,
                        intensity: 0.8,
                        color: _isEditing ? AppTheme.primaryColor.withOpacity(0.1) : AppTheme.primaryColor,
                      ),
                      child: Text(
                        _isEditing ? 'تحديث' : 'إضافة',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                          color: _isEditing ? AppTheme.primaryColor : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // زر إلغاء التحرير إذا كنا في وضع التحرير
                  if (_isEditing) ...[
                    const SizedBox(width: 16),
                    Expanded(
                      child: NeumorphicButton(
                        onPressed: _exitEditingMode,
                        style: NeumorphicStyle(
                          depth: 4,
                          intensity: 0.8,
                          color: Colors.grey.shade200,
                        ),
                        child: const Text(
                          'إلغاء',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotesList() {
    return Obx(() => _notes.isEmpty
        ? _buildEmptyNotesMessage()
        : ListView.builder(
            itemCount: _notes.length,
            itemBuilder: (context, index) {
              final note = _notes[index];
              return _buildNoteCard(note);
            },
          ));
  }

  // إضافة رسالة عندما لا توجد ملاحظات
  Widget _buildEmptyNotesMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_add,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد ملاحظات حالياً',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'أضف ملاحظة جديدة باستخدام النموذج أعلاه',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(Note note) {
    // تحديد ما إذا كانت هذه الملاحظة قيد التحرير
    final bool isCurrentlyEditing = _editingNoteId == note.id;
    
    return Neumorphic(
      margin: const EdgeInsets.only(bottom: 16),
      style: NeumorphicStyle(
        depth: 4,
        intensity: 0.8,
        color: isCurrentlyEditing ? AppTheme.primaryColor.withOpacity(0.1) : Colors.white,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                Row(
                  children: [
                    // زر التعديل
                    IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        color: isCurrentlyEditing ? AppTheme.primaryColor : Colors.grey[600],
                      ),
                      onPressed: () {
                        // منع بدء تحرير جديد إذا كان هناك تحرير قائم لملاحظة أخرى
                        if (_isEditing && _editingNoteId != note.id) {
                          Get.snackbar(
                            'تنبيه',
                            'الرجاء إنهاء تحرير الملاحظة الحالية أولاً',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.amber,
                            colorText: Colors.white,
                          );
                          return;
                        }
                        
                        // بدء أو إلغاء التحرير
                        if (!isCurrentlyEditing) {
                          _startEditing(note);
                        } else {
                          _exitEditingMode();
                        }
                      },
                      tooltip: isCurrentlyEditing ? 'إلغاء التعديل' : 'تعديل',
                    ),
                    // زر الحذف
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _showDeleteConfirmDialog(note),
                      tooltip: 'حذف',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              note.text,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Cairo',
                // تمييز الملاحظة قيد التحرير
                fontWeight: isCurrentlyEditing ? FontWeight.bold : FontWeight.normal,
                color: Colors.black87, // تغيير لون النص
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // إضافة مربع حوار لتأكيد الحذف
  void _showDeleteConfirmDialog(Note note) {
    Get.dialog(
      AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من رغبتك في حذف هذه الملاحظة؟'),
        actions: [
          TextButton(
            child: const Text('إلغاء'),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: Text('حذف', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Get.back();
              _deleteNote(note.id);
            },
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
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
    // تنسيق الوقت ليعرض الدقائق بشكل صحيح (مع صفر في البداية إذا كان أقل من 10)
    String minutes = date.minute < 10 ? '0${date.minute}' : '${date.minute}';
    return '${date.day}/${date.month}/${date.year} ${date.hour}:$minutes';
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