import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  final String nextRoute; // مسار الشاشة التالية بعد شاشة البداية
  final Map<String, dynamic> arguments; // المتغيرات المرافقة للشاشة التالية

  const SplashScreen({
    Key? key, 
    this.nextRoute = '/',  // المسار الافتراضي هو الشاشة الرئيسية
    this.arguments = const {},
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    // تأخير ثم الانتقال للشاشة التالية
    Timer(const Duration(seconds: 4), () {
      if (widget.nextRoute == '/') {
        Get.offAllNamed(widget.nextRoute, arguments: widget.arguments);
      } else {
        Get.offNamed(widget.nextRoute, arguments: widget.arguments);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // خلفية سوداء
      body: Center(
        child: Image.asset(
          'assets/images/splash_screen.gif',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
