import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/controllers/auth_controller.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/screens/home_screen.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Navigator.of(context).canPop(),
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          Get.offAll(() => const HomeScreen());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تسجيل الدخول'),
          centerTitle: true,
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Neumorphic(
                  style: NeumorphicStyle(
                    depth: -3,
                    intensity: 0.7,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'البريد الإلكتروني',
                        border: InputBorder.none,
                        icon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال البريد الإلكتروني';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Neumorphic(
                  style: NeumorphicStyle(
                    depth: -3,
                    intensity: 0.7,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'كلمة المرور',
                        border: InputBorder.none,
                        icon: Icon(Icons.lock),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال كلمة المرور';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Obx(() {
                  return NeumorphicButton(
                    style: NeumorphicStyle(
                      depth: 5,
                      intensity: 0.8,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(12)),
                    ),
                    onPressed: authController.isLoading.value
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              final result = await authController
                                  .signInWithEmailAndPassword(
                                email: emailController.text.trim(),
                                password: passwordController.text,
                              );

                              if (result.success) {
                                // استخدام التنقل باسم المسار بدلاً من الكائن المباشر
                                Get.offNamed('/admin');
                              } else {
                                Get.snackbar(
                                  'خطأ في تسجيل الدخول',
                                  result.errorMessage ?? 'حدث خطأ غير معروف',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red[100],
                                  colorText: Colors.red[900],
                                );
                              }
                            }
                          },
                    child: authController.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : const Text(
                            'تسجيل الدخول',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                  );
                }),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Get.offAll(() => const HomeScreen()),
                  child: const Text('العودة'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
