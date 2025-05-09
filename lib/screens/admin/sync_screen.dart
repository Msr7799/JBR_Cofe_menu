import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/controllers/auth_controller.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class SyncScreen extends StatefulWidget {
  const SyncScreen({Key? key}) : super(key: key);

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  final AuthController authController = Get.find<AuthController>();
  List<FileSystemEntity> backupFiles = [];
  bool isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _loadBackups();
  }
  
  Future<void> _loadBackups() async {
    setState(() {
      isLoading = true;
    });
    
    backupFiles = await authController.getAvailableBackups();
    
    setState(() {
      isLoading = false;
    });
  }
  
  String _formatBackupDate(String fileName) {
    try {
      // استخراج التاريخ من اسم الملف (backup_YYYYMMDD_HHMM.json)
      final parts = fileName.split('_');
      if (parts.length >= 2) {
        final dateStr = parts[1];
        final timeStr = parts[2].replaceAll('.json', '');
        
        final year = dateStr.substring(0, 4);
        final month = dateStr.substring(4, 6);
        final day = dateStr.substring(6, 8);
        
        final hour = timeStr.substring(0, 2);
        final minute = timeStr.substring(2, 4);
        
        final date = DateTime.parse('$year-$month-$day $hour:$minute:00');
        return DateFormat('dd/MM/yyyy HH:mm').format(date);
      }
    } catch (e) {
      // إذا حدث خطأ في تنسيق التاريخ، أعد اسم الملف كما هو
    }
    
    return fileName;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مزامنة البيانات'.tr),
        backgroundColor: const Color.fromARGB(255, 49, 50, 50),
        foregroundColor: const Color.fromARGB(255, 252, 252, 252),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor.withOpacity(0.8),
              AppTheme.secondaryColor.withOpacity(0.6),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // عنوان الصفحة
                const SizedBox(height: 20),
                Neumorphic(
                  style: NeumorphicStyle(
                    depth: 3,
                    intensity: 0.7,
                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                    color: Colors.white.withOpacity(0.9),
                    lightSource: LightSource.topLeft,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مركز المزامنة'.tr,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'يمكنك إنشاء نسخة احتياطية من البيانات والإعدادات أو استعادتها'.tr,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // أزرار المزامنة
                Row(
                  children: [
                    Expanded(
                      child: _buildSyncButton(
                        title: 'مزامنة البيانات'.tr,
                        icon: Icons.sync,
                        onPressed: () async {
                          final result = await authController.syncUserData();
                          if (result.success) {
                            _loadBackups(); // تحديث القائمة بعد المزامنة
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSyncButton(
                        title: 'مزامنة الصور'.tr,
                        icon: Icons.image,
                        onPressed: () => authController.syncImages(),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // قائمة النسخ الاحتياطية
                Expanded(
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      depth: -3,
                      intensity: 0.7,
                      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                      color: Colors.white.withOpacity(0.9),
                      lightSource: LightSource.topLeft,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'النسخ الاحتياطية المتاحة'.tr,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.refresh),
                                onPressed: _loadBackups,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          isLoading 
                            ? const Center(child: CircularProgressIndicator())
                            : Expanded(
                                child: backupFiles.isEmpty
                                  ? Center(
                                      child: Text(
                                        'لا توجد نسخ احتياطية متاحة'.tr,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: backupFiles.length,
                                      itemBuilder: (context, index) {
                                        final fileName = backupFiles[index].path.split('/').last;
                                        final formattedDate = _formatBackupDate(fileName);
                                        
                                        return Neumorphic(
                                          margin: const EdgeInsets.only(bottom: 10),
                                          style: NeumorphicStyle(
                                            depth: 2,
                                            intensity: 0.5,
                                            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
                                            color: Colors.white,
                                          ),
                                          child: ListTile(
                                            leading: const Icon(Icons.backup, color: AppTheme.primaryColor),
                                            title: Text(formattedDate),
                                            subtitle: Text(
                                              fileName,
                                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            trailing: IconButton(
                                              icon: const Icon(Icons.restore, color: Colors.blue),
                                              onPressed: () async {
                                                final confirm = await Get.dialog(
                                                  AlertDialog(
                                                    title: Text('تأكيد الاستعادة'.tr),
                                                    content: Text('هل أنت متأكد من استعادة البيانات من هذه النسخة؟ سيتم استبدال البيانات الحالية.'.tr),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () => Get.back(result: false),
                                                        child: Text('إلغاء'.tr),
                                                      ),
                                                      TextButton(
                                                        onPressed: () => Get.back(result: true),
                                                        child: Text('استعادة'.tr),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                                
                                                if (confirm == true) {
                                                  await authController.restoreFromBackup(File(backupFiles[index].path));
                                                }
                                              },
                                            ),
                                          ),
                                        );
                                      },
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
    );
  }
  
  Widget _buildSyncButton({
    required String title,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return NeumorphicButton(
      style: NeumorphicStyle(
        depth: 4,
        intensity: 0.7,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        color: Colors.white.withOpacity(0.9),
        lightSource: LightSource.topLeft,
      ),
      onPressed: onPressed,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 28,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}