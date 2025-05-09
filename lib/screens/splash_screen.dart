import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    // إعداد الفيديو
    _videoController =
        VideoPlayerController.asset('assets/splash_video.mp4') // مسار الفيديو
          ..initialize().then((_) {
            // تشغيل الفيديو تلقائيًا
            _videoController.play();
            setState(() {});
          });

    // الانتقال إلى الشاشة الرئيسية بعد انتهاء الفيديو
    _videoController.addListener(() {
      if (_videoController.value.position == _videoController.value.duration) {
        Get.offAllNamed('/'); // الانتقال إلى الشاشة الرئيسية
      }
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // خلفية سوداء لعرض الفيديو
      body: Center(
        child: _videoController.value.isInitialized
            ? AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: VideoPlayer(_videoController),
              )
            : const CircularProgressIndicator(), // يظهر أثناء تحميل الفيديو
      ),
    );
  }
}