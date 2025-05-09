import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/controllers/auth_controller.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/screens/home_screen.dart';
import 'package:gpr_coffee_shop/utils/image_helper.dart';
import 'package:gpr_coffee_shop/controllers/settings_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final AuthController authController = Get.find<AuthController>();
  final SettingsController settingsController = Get.find<SettingsController>();
  
  // للتسجيل والدخول
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  // للتسجيل فقط
  final TextEditingController nameController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  // وضعين: تسجيل الدخول أو إنشاء حساب جديد
  bool _isLoginMode = true;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _switchMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
      
      // مسح الحقول عند التبديل بين الأوضاع
      if (!_isLoginMode) {
        // عند التبديل إلى وضع التسجيل، نحتفظ بالبريد ونمسح كلمة المرور
        passwordController.clear();
      } else {
        // عند العودة إلى وضع تسجيل الدخول، نمسح البيانات الإضافية
        nameController.clear();
        confirmPasswordController.clear();
        _selectedImage = null;
      }
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_isLoginMode) {
        // تسجيل الدخول
        final result = await authController.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        if (result.success) {
          if (result.isAdmin) {
            Get.offNamed('/admin');
          } else {
            Get.offNamed('/user_profile'); // يمكنك إنشاء صفحة ملف المستخدم
          }
        } else {
          _showErrorMessage(result.errorMessage ?? 'حدث خطأ غير معروف'.tr);
        }
      } else {
        // إنشاء حساب جديد
        if (passwordController.text != confirmPasswordController.text) {
          _showErrorMessage('كلمتا المرور غير متطابقتين'.tr);
          return;
        }

        String? photoUrl;
        if (_selectedImage != null) {
          // هنا يمكنك تخزين الصورة ثم استرجاع رابطها المحلي
          photoUrl = _selectedImage!.path;
          // في المستقبل ستستبدل هذا برفع الصورة إلى Firebase Storage
        }

        final result = await authController.registerUser(
          email: emailController.text.trim(),
          password: passwordController.text,
          name: nameController.text.trim(),
          photoUrl: photoUrl,
        );

        if (result.success) {
          Get.offNamed('/user_profile'); // توجيه المستخدم إلى ملفه الشخصي
        } else {
          _showErrorMessage(result.errorMessage ?? 'حدث خطأ أثناء إنشاء الحساب'.tr);
        }
      }
    }
  }

  void _showErrorMessage(String message) {
    Get.snackbar(
      'خطأ'.tr,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red[100],
      colorText: Colors.red[900],
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final logoPath = settingsController.logoPath ?? 'assets/images/logo.png';
    
    return PopScope(
      canPop: Navigator.of(context).canPop(),
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          Get.offAll(() => const HomeScreen());
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primaryColor.withOpacity(0.8),
                AppTheme.secondaryColor.withOpacity(0.6),
              ],
            ),
          ),
          child: SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // اللوغو
                        _buildLogo(logoPath, isSmallScreen),
                        SizedBox(height: isSmallScreen ? 30 : 40),
                        
                        // كارد تسجيل الدخول/إنشاء حساب
                        Neumorphic(
                          style: NeumorphicStyle(
                            depth: 10,
                            intensity: 0.7,
                            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                            lightSource: LightSource.topLeft,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          child: Container(
                            width: isSmallScreen ? screenSize.width * 0.85 : 450,
                            padding: const EdgeInsets.all(24),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // عنوان الشاشة
                                  Text(
                                    _isLoginMode ? 'تسجيل الدخول'.tr : 'إنشاء حساب جديد'.tr,
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 24 : 28,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 25),
                                  
                                  // صورة المستخدم (للتسجيل فقط)
                                  if (!_isLoginMode) _buildUserImagePicker(),
                                  
                                  // اسم المستخدم (للتسجيل فقط)
                                  if (!_isLoginMode) ...[
                                    const SizedBox(height: 20),
                                    _buildTextField(
                                      controller: nameController,
                                      icon: Icons.person_rounded,
                                      label: 'الاسم'.tr,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'الرجاء إدخال الاسم'.tr;
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                  
                                  const SizedBox(height: 20),
                                  
                                  // حقل البريد الإلكتروني
                                  _buildTextField(
                                    controller: emailController,
                                    icon: Icons.email_rounded,
                                    label: 'البريد الإلكتروني'.tr,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'الرجاء إدخال البريد الإلكتروني'.tr;
                                      } 
                                      // إضافة استثناء للمستخدمين المسموح لهم
                                      else if (value != 'admin' && value != 'jbr' && 
                                              !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                        return 'الرجاء إدخال بريد إلكتروني صحيح'.tr;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  
                                  // حقل كلمة المرور
                                  _buildTextField(
                                    controller: passwordController,
                                    icon: Icons.lock_rounded,
                                    label: 'كلمة المرور'.tr,
                                    obscureText: _obscurePassword,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'الرجاء إدخال كلمة المرور'.tr;
                                      } else if (!_isLoginMode && value.length < 6) {
                                        return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل'.tr;
                                      }
                                      return null;
                                    },
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                      child: Icon(
                                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  
                                  // تأكيد كلمة المرور (للتسجيل فقط)
                                  if (!_isLoginMode) ...[
                                    const SizedBox(height: 20),
                                    _buildTextField(
                                      controller: confirmPasswordController,
                                      icon: Icons.lock_rounded,
                                      label: 'تأكيد كلمة المرور'.tr,
                                      obscureText: _obscureConfirmPassword,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'الرجاء تأكيد كلمة المرور'.tr;
                                        } else if (value != passwordController.text) {
                                          return 'كلمتا المرور غير متطابقتين'.tr;
                                        }
                                        return null;
                                      },
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _obscureConfirmPassword = !_obscureConfirmPassword;
                                          });
                                        },
                                        child: Icon(
                                          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                  
                                  const SizedBox(height: 10),
                                  
                                  // نسيت كلمة المرور (للتسجيل الدخول فقط)
                                  if (_isLoginMode)
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextButton(
                                        onPressed: () {
                                          // يمكن إضافة منطق "نسيت كلمة المرور" هنا
                                        },
                                        child: Text(
                                          'نسيت كلمة المرور؟'.tr,
                                          style: TextStyle(
                                            color: AppTheme.primaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 20),
                                  
                                  // زر تسجيل الدخول/إنشاء حساب
                                  Obx(() => _buildSubmitButton(isSmallScreen)),
                                  
                                  const SizedBox(height: 25),
                                  
                                  // زر تبديل الوضع بين تسجيل الدخول وإنشاء حساب
                                  _buildToggleModeButton(),
                                  
                                  const SizedBox(height: 20),
                                  
                                  // زر العودة
                                  TextButton(
                                    onPressed: () => Get.offAll(() => const HomeScreen()),
                                    child: Text(
                                      'العودة للشاشة الرئيسية'.tr,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(String logoPath, bool isSmallScreen) {
    final logoSize = isSmallScreen ? 120.0 : 150.0;
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 8,
        intensity: 0.7,
        boxShape: const NeumorphicBoxShape.circle(),
        lightSource: LightSource.topLeft,
        color: Colors.white,
      ),
      child: SizedBox(
        width: logoSize,
        height: logoSize,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ImageHelper.buildImage(
            logoPath,
            fit: BoxFit.contain,
            isCircular: true,
          ),
        ),
      ),
    );
  }

  Widget _buildUserImagePicker() {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: _selectedImage != null
                    ? ClipOval(
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        size: 70,
                        color: Colors.grey,
                      ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'صورة المستخدم (اختياري)'.tr,
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    bool obscureText = false,
    required String? Function(String?) validator,
    Widget? suffixIcon,
  }) {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: -4,
        intensity: 0.8,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
        lightSource: LightSource.topLeft,
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            border: InputBorder.none,
            icon: Icon(icon, color: AppTheme.primaryColor),
            labelText: label,
            labelStyle: TextStyle(color: Colors.grey[600]),
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(bool isSmallScreen) {
    return ElevatedButton(
      onPressed: authController.isLoading.value ? null : _submitForm,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
      ),
      child: authController.isLoading.value
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            )
          : Text(
              _isLoginMode ? 'تسجيل الدخول'.tr : 'إنشاء حساب'.tr,
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }

  Widget _buildToggleModeButton() {
    return TextButton(
      onPressed: _switchMode,
      child: Text(
        _isLoginMode ? 'ليس لديك حساب؟ سجل الآن'.tr : 'لديك حساب بالفعل؟ سجل دخولك'.tr,
        style: TextStyle(
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
