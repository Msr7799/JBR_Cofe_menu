import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gpr_coffee_shop/models/user_credentials.dart';

class AuthResult {
  final bool success;
  final String? errorMessage;

  AuthResult({required this.success, this.errorMessage});
}

class AuthController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs; // تعديل هنا
  final RxBool isAdmin = false.obs;

  // المستخدمون المسموح لهم بتسجيل الدخول كمسؤولين
  final Map<String, String> _allowedAdmins = {
    'admin@gpr.com': 'admin123',
    'manager@gpr.com': 'manager123',
  };

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('admin_email');

    if (savedEmail != null && _allowedAdmins.containsKey(savedEmail)) {
      isLoggedIn.value = true;
      isAdmin.value = true;
    } else {
      isLoggedIn.value = false;
      isAdmin.value = false;
    }
  }

  Future<AuthResult> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;

    try {
      // التحقق مما إذا كان المستخدم موجودًا في قائمة المستخدمين المسموح لهم
      if (_allowedAdmins.containsKey(email) &&
          _allowedAdmins[email] == password) {
        // حفظ بيانات تسجيل الدخول
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('admin_email', email);

        isLoggedIn.value = true;
        isAdmin.value = true;
        return AuthResult(success: true);
      } else {
        return AuthResult(
          success: false,
          errorMessage: 'اسم المستخدم أو كلمة المرور غير صحيحة',
        );
      }
    } catch (e) {
      return AuthResult(
        success: false,
        errorMessage: 'حدث خطأ أثناء تسجيل الدخول: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    isLoading.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('admin_email');

      isLoggedIn.value = false;
      isAdmin.value = false;
    } catch (e) {
      print('خطأ أثناء تسجيل الخروج: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> checkIfUserIsAdmin() async {
    return isAdmin.value;
  }

  Future<UserCredentials?> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('admin_email');
    final password = prefs.getString('admin_password');

    if (email != null && password != null) {
      return UserCredentials(email: email, password: password);
    }

    return null;
  }

  Future<void> saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('admin_email', email);
    await prefs.setString('admin_password', password);
  }

  Future<void> clearSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('admin_password');
  }
}
