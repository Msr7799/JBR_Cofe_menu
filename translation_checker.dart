import 'dart:io';

const translationFile = 'lib/utils/app_translations.dart';
final screensDir = Directory('lib/screens');

// استخراج النصوص من ملف Dart
final regex = RegExp(r'Text\s*\(\s*"([^"]+)"\s*\)|title:\s*"([^"]+)"');

void main() async {
  final existingKeys = await extractExistingTranslations();
  final foundTexts = <String>{};

  for (final file in screensDir.listSync(recursive: true)) {
    if (file is File && file.path.endsWith('.dart')) {
      final content = await file.readAsString();
      final matches = regex.allMatches(content);
      for (final match in matches) {
        final text = match.group(1) ?? match.group(2);
        if (text != null && text.trim().isNotEmpty) {
          foundTexts.add(text.trim());
        }
      }
    }
  }

  print('🔍 تم استخراج النصوص من ملفات الشاشات:\n');
  final missing = <String>{};

  for (final text in foundTexts) {
    final key = generateKey(text);
    if (!existingKeys.contains(key)) {
      missing.add(text);
      print('❌ "$text" غير موجود في ملف الترجمة.');
    }
  }

  if (missing.isEmpty) {
    print('\n✅ جميع النصوص موجودة في ملف الترجمة.');
  } else {
    print('\n📝 يمكنك إضافة التالي إلى ملف الترجمة:\n');
    for (final text in missing) {
      final key = generateKey(text);
      print("  '$key': '$text', // ar");
      print("  '$key': '${translateToEnglish(text)}', // en");
    }
  }
}

String generateKey(String text) {
  return text.toLowerCase().replaceAll(' ', '_').replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '');
}

Future<Set<String>> extractExistingTranslations() async {
  final content = await File(translationFile).readAsString();
  final regex = RegExp(r"'([a-zA-Z0-9_]+)'\s*:");
  return regex.allMatches(content).map((m) => m.group(1)!).toSet();
}

String translateToEnglish(String arabic) {
  // ترجمة بسيطة لبعض الكلمات الشائعة (يمكنك التوسيع لاحقاً)
  const map = {
    'تسجيل الدخول': 'Login',
    'أهلاً وسهلاً': 'Welcome',
    'الرئيسية': 'Home',
    'إعدادات': 'Settings',
    'حسابي': 'My Account',
    'خروج': 'Logout',
  };
  return map[arabic] ?? arabic;
}
