import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/settings_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:gpr_coffee_shop/utils/logger_util.dart';


class BenefitPayQrManagement extends StatefulWidget {
  const BenefitPayQrManagement({Key? key}) : super(key: key);

  @override
  State<BenefitPayQrManagement> createState() => _BenefitPayQrManagementState();
}

class _BenefitPayQrManagementState extends State<BenefitPayQrManagement> {
  final SettingsController settingsController = Get.find<SettingsController>();
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة باركود البنفت بي'),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: GetBuilder<SettingsController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'قم بتحميل صورة الباركود الخاص بحساب البنفت بي',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'سيتم عرض هذا الباركود للعملاء في الشاشة الرئيسية ليتمكنوا من الدفع مباشرة',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                _buildQrCodePreview(controller),
                const SizedBox(height: 32),
                _buildActionButtons(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQrCodePreview(SettingsController controller) {
    final qrCodeUrl = controller.benefitPayQrCodeUrl;

    if (isLoading) {
      return const SizedBox(
        height: 250,
        width: 250,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (qrCodeUrl == null || qrCodeUrl.isEmpty) {
      return Container(
        height: 250,
        width: 250,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.qr_code,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'لم يتم تحميل باركود البنفت بي بعد',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    } else {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'امسح للدفع',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Image.file(
                File(qrCodeUrl),
                height: 250,
                width: 250,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'خطأ في تحميل الصورة',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'البنفت بي',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildActionButtons() {
    final hasExistingQrCode = settingsController.benefitPayQrCodeUrl != null &&
        settingsController.benefitPayQrCodeUrl!.isNotEmpty;

    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _uploadQrCode,
          icon: const Icon(Icons.upload),
          label: const Text('تحميل باركود جديد'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
        if (hasExistingQrCode) ...[
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _deleteQrCode,
            icon: const Icon(Icons.delete, color: Colors.red),
            label: const Text(
              'حذف الباركود الحالي',
              style: TextStyle(color: Colors.red),
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              side: const BorderSide(color: Colors.red),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _uploadQrCode() async {
    try {
      // التقاط صورة من المعرض
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) return;

      setState(() {
        isLoading = true;
      });

      // نسخ الصورة إلى مجلد التطبيق للتخزين الدائم
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName =
          'benefit_pay_qr_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String filePath = path.join(appDir.path, fileName);

      // نسخ الملف
      final File newImage = await File(image.path).copy(filePath);

      // حفظ المسار في الإعدادات
      await settingsController.setBenefitPayQrCodeUrl(newImage.path);

      Get.snackbar(
        'تم',
        'تم تحميل صورة الباركود بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      LoggerUtil.logger.e('Error uploading QR code: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تحميل الصورة',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteQrCode() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('حذف باركود البنفت بي'),
          content: const Text('هل أنت متأكد من رغبتك في حذف الباركود الحالي؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();

                setState(() {
                  isLoading = true;
                });

                try {
                  // حذف الملف
                  final String? filePath =
                      settingsController.benefitPayQrCodeUrl;
                  if (filePath != null && filePath.isNotEmpty) {
                    final file = File(filePath);
                    if (await file.exists()) {
                      await file.delete();
                    }
                  }

                  // مسح المسار من الإعدادات
                  await settingsController.setBenefitPayQrCodeUrl('');

                  Get.snackbar(
                    'تم',
                    'تم حذف باركود البنفت بي بنجاح',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                } catch (e) {
                  LoggerUtil.logger.e('Error deleting QR code: $e');
                  Get.snackbar(
                    'خطأ',
                    'حدث خطأ أثناء حذف الباركود',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                } finally {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              child: const Text(
                'حذف',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
