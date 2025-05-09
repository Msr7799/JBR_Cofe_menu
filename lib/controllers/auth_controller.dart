import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gpr_coffee_shop/models/user_credentials.dart';
import 'package:flutter/material.dart';
import 'package:gpr_coffee_shop/utils/logger_util.dart';
import 'dart:convert'; // لاستخدام json
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class AuthResult {
  final bool success;
  final String? errorMessage;
  final bool isAdmin;

  AuthResult({required this.success, this.errorMessage, this.isAdmin = false});
}

class User {
  final String email;
  final String password;
  final bool isAdmin;
  final String name;
  final String? photoUrl;

  User({
    required this.email,
    required this.password,
    this.isAdmin = false,
    required this.name,
    this.photoUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'isAdmin': isAdmin,
      'name': name,
      'photoUrl': photoUrl,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      password: json['password'],
      isAdmin: json['isAdmin'] ?? false,
      name: json['name'] ?? '',
      photoUrl: json['photoUrl'],
    );
  }
}

class AuthController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final RxBool isAdmin = false.obs;
  final RxString currentUserEmail = ''.obs;
  final RxString currentUserName = ''.obs;
  final RxString currentUserPhotoUrl = ''.obs;

  // المستخدمون المسموح لهم بتسجيل الدخول كمسؤولين
  final Map<String, String> _allowedAdmins = {
    'jbr': 'jbr',
    'admin': 'admin',
  };

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('current_user_email');

    if (savedEmail != null) {
      // التحقق مما إذا كان المستخدم مسؤولاً أو مستخدماً عادياً
      if (_allowedAdmins.containsKey(savedEmail)) {
        // المستخدم هو مسؤول من القائمة المحددة
        isLoggedIn.value = true;
        isAdmin.value = true;
        currentUserEmail.value = savedEmail;
        currentUserName.value = savedEmail; // يمكن تعديلها لاحقاً لعرض اسم حقيقي
      } else {
        // التحقق من قائمة المستخدمين المسجلين
        final userJson = prefs.getString('user_$savedEmail');
        if (userJson != null) {
          try {
            final user = User.fromJson(jsonDecode(userJson));
            isLoggedIn.value = true;
            isAdmin.value = user.isAdmin;
            currentUserEmail.value = user.email;
            currentUserName.value = user.name;
            currentUserPhotoUrl.value = user.photoUrl ?? '';
          } catch (e) {
            LoggerUtil.logger.e('خطأ في قراءة بيانات المستخدم: $e');
            isLoggedIn.value = false;
            isAdmin.value = false;
          }
        } else {
          isLoggedIn.value = false;
          isAdmin.value = false;
        }
      }
    } else {
      isLoggedIn.value = false;
      isAdmin.value = false;
    }
  }

  // دالة للتحقق مما إذا كان البريد الإلكتروني مسجلاً بالفعل
  Future<bool> isEmailRegistered(String email) async {
    final prefs = await SharedPreferences.getInstance();
    
    // التحقق من قائمة المسؤولين
    if (_allowedAdmins.containsKey(email)) {
      return true;
    }
    
    // التحقق من المستخدمين المسجلين
    final userKey = 'user_$email';
    return prefs.containsKey(userKey);
  }

  // تسجيل مستخدم جديد
  Future<AuthResult> registerUser({
    required String email,
    required String password,
    required String name,
    String? photoUrl,
  }) async {
    isLoading.value = true;
    
    try {
      // التحقق مما إذا كان البريد الإلكتروني من المستخدمين المسموح لهم
      if (_allowedAdmins.containsKey(email)) {
        return AuthResult(
          success: false,
          errorMessage: 'هذا الحساب محجوز للمسؤولين فقط'.tr,
        );
      }
      
      // التحقق مما إذا كان البريد الإلكتروني مستخدماً بالفعل
      final emailExists = await isEmailRegistered(email);
      if (emailExists) {
        return AuthResult(
          success: false,
          errorMessage: 'البريد الإلكتروني مسجل بالفعل'.tr,
        );
      }
      
      // التحقق من صحة البريد الإلكتروني (إلا إذا كان من المستخدمين المسموح لهم)
      if (email != 'admin' && email != 'jbr' && 
          !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        return AuthResult(
          success: false,
          errorMessage: 'الرجاء إدخال بريد إلكتروني صحيح'.tr,
        );
      }
      
      // إنشاء مستخدم جديد
      final user = User(
        email: email,
        password: password,
        name: name,
        photoUrl: photoUrl,
        isAdmin: false,
      );
      
      // تخزين بيانات المستخدم
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_$email', jsonEncode(user.toJson()));
      
      // تخزين المستخدم الحالي
      await prefs.setString('current_user_email', email);
      
      // تحديث حالة المصادقة
      isLoggedIn.value = true;
      isAdmin.value = false;
      currentUserEmail.value = email;
      currentUserName.value = name;
      currentUserPhotoUrl.value = photoUrl ?? '';
      
      return AuthResult(success: true);
    } catch (e) {
      LoggerUtil.logger.e('خطأ في تسجيل مستخدم جديد: $e');
      return AuthResult(
        success: false,
        errorMessage: 'حدث خطأ أثناء إنشاء الحساب: $e'.tr,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<AuthResult> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;

    try {
      // التحقق مما إذا كان المستخدم من المسؤولين المسموح لهم
      if (_allowedAdmins.containsKey(email) && _allowedAdmins[email] == password) {
        // حفظ بيانات تسجيل الدخول
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('current_user_email', email);

        isLoggedIn.value = true;
        isAdmin.value = true;
        currentUserEmail.value = email;
        currentUserName.value = email;
        
        return AuthResult(success: true, isAdmin: true);
      } 
      // التحقق من قائمة المستخدمين المسجلين
      else {
        final prefs = await SharedPreferences.getInstance();
        final userJson = prefs.getString('user_$email');
        
        if (userJson != null) {
          final user = User.fromJson(jsonDecode(userJson));
          
          if (user.password == password) {
            // تسجيل دخول ناجح
            await prefs.setString('current_user_email', email);
            
            isLoggedIn.value = true;
            isAdmin.value = user.isAdmin;
            currentUserEmail.value = user.email;
            currentUserName.value = user.name;
            currentUserPhotoUrl.value = user.photoUrl ?? '';
            
            return AuthResult(success: true, isAdmin: user.isAdmin);
          }
        }
        
        return AuthResult(
          success: false,
          errorMessage: 'اسم المستخدم أو كلمة المرور غير صحيحة'.tr,
        );
      }
    } catch (e) {
      return AuthResult(
        success: false,
        errorMessage: 'حدث خطأ أثناء تسجيل الدخول: $e'.tr,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // الحصول على مستخدم حالي
  Future<User?> getCurrentUser() async {
    if (!isLoggedIn.value) return null;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = currentUserEmail.value;
      
      // التحقق إذا كان مسؤول من القائمة المسموحة
      if (_allowedAdmins.containsKey(email)) {
        return User(
          email: email,
          password: '', // لا نخزن كلمة المرور هنا للأمان
          name: email,
          isAdmin: true,
        );
      }
      
      // التحقق من المستخدمين المسجلين
      final userJson = prefs.getString('user_$email');
      if (userJson != null) {
        return User.fromJson(jsonDecode(userJson));
      }
    } catch (e) {
      LoggerUtil.logger.e('خطأ في الحصول على المستخدم الحالي: $e');
    }
    
    return null;
  }

  Future<void> signOut() async {
    isLoading.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('current_user_email');

      isLoggedIn.value = false;
      isAdmin.value = false;
      currentUserEmail.value = '';
      currentUserName.value = '';
      currentUserPhotoUrl.value = '';
    } catch (e) {
      LoggerUtil.logger.e('خطأ أثناء تسجيل الخروج: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> checkIfUserIsAdmin() async {
    return isAdmin.value;
  }

  Future<UserCredentials?> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('saved_email');
    final password = prefs.getString('saved_password');

    if (email != null && password != null) {
      return UserCredentials(email: email, password: password);
    }

    return null;
  }

  Future<void> saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_email', email);
    await prefs.setString('saved_password', password);
  }

  Future<void> clearSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_password');
  }

  // تغيير البيانات الشخصية للمستخدم
  Future<AuthResult> updateUserProfile({
    required String name,
    String? photoUrl,
  }) async {
    isLoading.value = true;
    
    try {
      if (!isLoggedIn.value) {
        return AuthResult(
          success: false,
          errorMessage: 'يجب تسجيل الدخول أولاً',
        );
      }
      
      final email = currentUserEmail.value;
      final prefs = await SharedPreferences.getInstance();
      
      // إذا كان المستخدم من المسؤولين المسموح لهم، لا يمكن تغيير بياناته
      if (_allowedAdmins.containsKey(email)) {
        return AuthResult(
          success: false,
          errorMessage: 'لا يمكن تغيير بيانات المسؤول الأساسي',
        );
      }
      
      // تحديث بيانات المستخدم
      final userJson = prefs.getString('user_$email');
      if (userJson != null) {
        final user = User.fromJson(jsonDecode(userJson));
        final updatedUser = User(
          email: user.email,
          password: user.password,
          isAdmin: user.isAdmin,
          name: name,
          photoUrl: photoUrl ?? user.photoUrl,
        );
        
        await prefs.setString('user_$email', jsonEncode(updatedUser.toJson()));
        
        currentUserName.value = name;
        if (photoUrl != null) {
          currentUserPhotoUrl.value = photoUrl;
        }
        
        return AuthResult(success: true);
      }
      
      return AuthResult(
        success: false,
        errorMessage: 'لم يتم العثور على بيانات المستخدم',
      );
    } catch (e) {
      LoggerUtil.logger.e('خطأ في تحديث بيانات المستخدم: $e');
      return AuthResult(
        success: false,
        errorMessage: 'حدث خطأ أثناء تحديث البيانات: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// تسجيل خروج المستخدم
  Future<void> logout() async {
    isLoading.value = true;
    
    try {
      // إعادة تعيين حالة تسجيل الدخول
      isLoggedIn.value = false;
      isAdmin.value = false;
      currentUserEmail.value = '';
      currentUserName.value = '';
      currentUserPhotoUrl.value = '';

      // مسح البيانات من التخزين المحلي
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('current_user_email');

      // رسالة توضيحية
      Get.snackbar(
        'تم تسجيل الخروج',
        'تم تسجيل خروجك بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.7),
        colorText: Colors.white,
      );
    } catch (e) {
      LoggerUtil.logger.e('خطأ أثناء تسجيل الخروج: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// مزامنة بيانات المستخدم الحالي
  Future<AuthResult> syncUserData() async {
    isLoading.value = true;
    
    try {
      // التحقق من تسجيل الدخول
      if (!isLoggedIn.value) {
        return AuthResult(
          success: false,
          errorMessage: 'يجب تسجيل الدخول أولاً لإجراء المزامنة',
        );
      }
      
      // التحقق مما إذا كان المستخدم هو jbr (المسؤول الرئيسي)
      final email = currentUserEmail.value;
      if (email != 'jbr') {
        return AuthResult(
          success: false,
          errorMessage: 'عملية المزامنة متاحة فقط للحساب الرئيسي',
        );
      }
      
      // الحصول على كل البيانات المحلية
      final prefs = await SharedPreferences.getInstance();
      final allKeys = prefs.getKeys();
      
      // إنشاء نسخة احتياطية من البيانات
      Map<String, dynamic> backupData = {};
      int userCount = 0;
      
      // تجميع بيانات المستخدمين
      for (String key in allKeys) {
        if (key.startsWith('user_')) {
          final userData = prefs.getString(key);
          if (userData != null) {
            backupData[key] = userData;
            userCount++;
          }
        }
      }
      
      // تجميع الإعدادات العامة
      List<String> settingsKeys = allKeys.where((key) => 
        key.startsWith('setting_') || 
        key.startsWith('theme_') || 
        key.startsWith('logo_') ||
        key == 'current_language' ||
        key == 'notification_settings'
      ).toList();
      
      for (String key in settingsKeys) {
        final value = prefs.getString(key);
        if (value != null) {
          backupData[key] = value;
        }
      }
      
      // حفظ النسخة الاحتياطية في مجلد مخصص
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final Directory backupDir = Directory('${appDocDir.path}/backups');
      
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }
      
      // تسمية الملف بتاريخ ووقت النسخ
      final now = DateTime.now();
      final fileName = 'backup_${now.year}${now.month}${now.day}_${now.hour}${now.minute}.json';
      final backupFile = File('${backupDir.path}/$fileName');
      
      // كتابة البيانات إلى الملف
      await backupFile.writeAsString(jsonEncode(backupData));
      
      // إظهار رسالة نجاح
      Get.snackbar(
        'تمت المزامنة بنجاح',
        'تم حفظ بيانات $userCount مستخدم والإعدادات في ${backupFile.path}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.7),
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
      
      return AuthResult(
        success: true, 
        errorMessage: 'تم حفظ البيانات في ${backupFile.path}'
      );
    } catch (e) {
      LoggerUtil.logger.e('خطأ أثناء مزامنة البيانات: $e');
      return AuthResult(
        success: false,
        errorMessage: 'حدث خطأ أثناء مزامنة البيانات: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  /// استعادة البيانات من نسخة احتياطية
  Future<AuthResult> restoreFromBackup(File backupFile) async {
    isLoading.value = true;
    
    try {
      // التحقق من تسجيل الدخول
      if (!isLoggedIn.value) {
        return AuthResult(
          success: false,
          errorMessage: 'يجب تسجيل الدخول أولاً لاستعادة البيانات',
        );
      }
      
      // التحقق مما إذا كان المستخدم هو jbr (المسؤول الرئيسي)
      final email = currentUserEmail.value;
      if (email != 'jbr') {
        return AuthResult(
          success: false,
          errorMessage: 'عملية استعادة البيانات متاحة فقط للحساب الرئيسي',
        );
      }
      
      // قراءة ملف النسخة الاحتياطية
      if (!await backupFile.exists()) {
        return AuthResult(
          success: false,
          errorMessage: 'ملف النسخة الاحتياطية غير موجود',
        );
      }
      
      final backupContent = await backupFile.readAsString();
      final Map<String, dynamic> backupData = jsonDecode(backupContent);
      
      // استعادة البيانات
      final prefs = await SharedPreferences.getInstance();
      int restoredCount = 0;
      
      // استعادة بيانات المستخدمين والإعدادات
      for (String key in backupData.keys) {
        await prefs.setString(key, backupData[key]);
        restoredCount++;
      }
      
      // إعادة تحميل الإعدادات الحالية
      await checkLoginStatus();
      
      // إظهار رسالة نجاح
      Get.snackbar(
        'تمت استعادة البيانات بنجاح',
        'تم استعادة $restoredCount عنصر من البيانات',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.7),
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
      
      return AuthResult(
        success: true, 
        errorMessage: 'تمت استعادة البيانات بنجاح'
      );
    } catch (e) {
      LoggerUtil.logger.e('خطأ أثناء استعادة البيانات: $e');
      return AuthResult(
        success: false,
        errorMessage: 'حدث خطأ أثناء استعادة البيانات: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  /// الحصول على قائمة النسخ الاحتياطية المتاحة
  Future<List<FileSystemEntity>> getAvailableBackups() async {
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final Directory backupDir = Directory('${appDocDir.path}/backups');
      
      if (!await backupDir.exists()) {
        return [];
      }
      
      final List<FileSystemEntity> backupFiles = await backupDir
          .list()
          .where((entity) => entity.path.endsWith('.json'))
          .toList();
      
      // ترتيب الملفات من الأحدث إلى الأقدم
      backupFiles.sort((a, b) => b.path.compareTo(a.path));
      
      return backupFiles;
    } catch (e) {
      LoggerUtil.logger.e('خطأ أثناء جلب قائمة النسخ الاحتياطية: $e');
      return [];
    }
  }
  
  /// مزامنة الصور
  Future<AuthResult> syncImages() async {
    isLoading.value = true;
    
    try {
      // التحقق من تسجيل الدخول
      if (!isLoggedIn.value) {
        return AuthResult(
          success: false,
          errorMessage: 'يجب تسجيل الدخول أولاً لمزامنة الصور',
        );
      }
      
      // التحقق مما إذا كان المستخدم هو jbr (المسؤول الرئيسي)
      final email = currentUserEmail.value;
      if (email != 'jbr') {
        return AuthResult(
          success: false,
          errorMessage: 'عملية مزامنة الصور متاحة فقط للحساب الرئيسي',
        );
      }
      
      // إنشاء مجلد للنسخ الاحتياطية للصور
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final Directory imagesBackupDir = Directory('${appDocDir.path}/backups/images');
      
      if (!await imagesBackupDir.exists()) {
        await imagesBackupDir.create(recursive: true);
      }
      
      // الحصول على مجلد صور التطبيق
      final Directory appImagesDir = Directory('${appDocDir.path}/images');
      
      if (!await appImagesDir.exists()) {
        return AuthResult(
          success: false,
          errorMessage: 'لا توجد صور لمزامنتها',
        );
      }
      
      // نسخ جميع الصور إلى مجلد النسخة الاحتياطية
      final List<FileSystemEntity> imageFiles = await appImagesDir
          .list(recursive: true)
          .where((entity) => 
            entity.path.toLowerCase().endsWith('.jpg') || 
            entity.path.toLowerCase().endsWith('.jpeg') || 
            entity.path.toLowerCase().endsWith('.png')
          )
          .toList();
      
      if (imageFiles.isEmpty) {
        return AuthResult(
          success: false,
          errorMessage: 'لا توجد صور لمزامنتها',
        );
      }
      
      int copiedCount = 0;
      for (FileSystemEntity entity in imageFiles) {
        if (entity is File) {
          final fileName = entity.path.split('/').last;
          final targetPath = '${imagesBackupDir.path}/$fileName';
          
          await entity.copy(targetPath);
          copiedCount++;
        }
      }
      
      // إظهار رسالة نجاح
      Get.snackbar(
        'تمت مزامنة الصور بنجاح',
        'تم نسخ $copiedCount صورة إلى ${imagesBackupDir.path}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.7),
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
      
      return AuthResult(
        success: true, 
        errorMessage: 'تمت مزامنة الصور بنجاح'
      );
    } catch (e) {
      LoggerUtil.logger.e('خطأ أثناء مزامنة الصور: $e');
      return AuthResult(
        success: false,
        errorMessage: 'حدث خطأ أثناء مزامنة الصور: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
