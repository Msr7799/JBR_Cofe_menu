import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/category_controller.dart';
import 'package:gpr_coffee_shop/models/category.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class CategoryManagement extends StatelessWidget {
  final CategoryController categoryController;

  CategoryManagement({super.key})
      : categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الفئات'),
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'استعادة الفئات الافتراضية',
            onPressed: () => _showResetCategoriesDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'إضافة فئة جديدة',
            onPressed: () => _showAddEditCategoryDialog(context),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Obx(
          () => categoryController.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary))
              : categoryController.categories.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.category_outlined,
                              size: 60,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'لا توجد فئات حاليًا',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'قم بإضافة فئات جديدة لتصنيف المنتجات',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 24),
                          NeumorphicButton(
                            style: NeumorphicStyle(
                              color: Theme.of(context).colorScheme.primary,
                              depth: 3,
                            ),
                            onPressed: () =>
                                _showAddEditCategoryDialog(context),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Text(
                                'إضافة فئة جديدة',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: categoryController.categories.length,
                        itemBuilder: (context, index) {
                          final category = categoryController.categories[index];
                          return _buildCategoryCard(context, category);
                        },
                      ),
                    ),
        ),
      ),
      floatingActionButton: Obx(
        () => categoryController.categories.isNotEmpty
            ? FloatingActionButton(
                backgroundColor: AppTheme.primaryColor,
                elevation: 4,
                onPressed: () => _showAddEditCategoryDialog(context),
                child: const Icon(Icons.add),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Category category) {
    return Neumorphic(
      margin: const EdgeInsets.only(bottom: 16),
      style: NeumorphicStyle(
        depth: 3,
        intensity: 0.7,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 29, 27, 27),
                borderRadius: BorderRadius.circular(8),
              ),
              child: category.iconPath != null
                  ? _buildCategoryImage(category.iconPath!)
                  : const Icon(Icons.image_not_supported),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (category.description.isNotEmpty)
                    Text(
                      category.description,
                      style: TextStyle(color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () =>
                      _showAddEditCategoryDialog(context, category),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteConfirmationDialog(category),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to determine if the image is an asset or a file
  Widget _buildCategoryImage(String path) {
    // Check if the path is a local file path
    if (path.startsWith('C:') ||
        path.startsWith('/') ||
        path.contains('Documents')) {
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('خطأ تحميل الصورة: $path, $error');
          return const Icon(Icons.broken_image);
        },
      );
    } else {
      // Otherwise assume it's an asset path
      return Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('خطأ تحميل الأصول: $path, $error');
          return const Icon(Icons.broken_image);
        },
      );
    }
  }

  // استبدل دالة _showAddEditCategoryDialog بهذه الدالة المحسنة
  void _showAddEditCategoryDialog(BuildContext context, [Category? category]) {
    final isEditing = category != null;
    final nameController =
        TextEditingController(text: isEditing ? category.name : '');
    final nameEnController =
        TextEditingController(text: isEditing ? category.nameEn : '');
    final descriptionController =
        TextEditingController(text: isEditing ? category.description : '');
    final descriptionEnController =
        TextEditingController(text: isEditing ? category.descriptionEn : '');
    final formKey = GlobalKey<FormState>();
    String? selectedImagePath = isEditing ? category.iconPath : null;

    // Use RxString to trigger UI updates when image changes
    final Rx<String?> rxSelectedImagePath =
        (isEditing ? category.iconPath : null).obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85, // صغرنا العرض قليلاً
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height *
                0.75, // تحديد الارتفاع الأقصى
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // رأس النافذة مع زر إغلاق
                Container(
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isEditing ? 'تعديل فئة' : 'إضافة فئة جديدة',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Get.back(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),

                // محتوى النموذج
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // صورة الفئة - مع تحسين المعاينة
                        Center(
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final pickedImage = await _pickImage();
                                  if (pickedImage != null) {
                                    selectedImagePath = pickedImage;
                                    rxSelectedImagePath.value = pickedImage;
                                  }
                                },
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Obx(
                                    () => rxSelectedImagePath.value != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: _buildCategoryImage(
                                                rxSelectedImagePath.value!),
                                          )
                                        : const Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add_photo_alternate,
                                                size: 40,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                'إضافة صورة',
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                              Obx(
                                () => rxSelectedImagePath.value != null
                                    ? Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: AppTheme.primaryColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: IconButton(
                                            icon: const Icon(Icons.edit,
                                                size: 20, color: Colors.white),
                                            onPressed: () async {
                                              final pickedImage =
                                                  await _pickImage();
                                              if (pickedImage != null) {
                                                selectedImagePath = pickedImage;
                                                rxSelectedImagePath.value =
                                                    pickedImage;
                                              }
                                            },
                                            constraints: const BoxConstraints(
                                              minWidth: 36,
                                              minHeight: 36,
                                            ),
                                            padding: EdgeInsets.zero,
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // اسم بالعربية
                        const Text(
                          'اسم الفئة (عربي) *',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Neumorphic(
                          style: const NeumorphicStyle(
                            depth: -3,
                            intensity: 0.7,
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              hintText: 'أدخل اسم الفئة بالعربية',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال اسم الفئة بالعربية';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),

                        // اسم بالإنجليزية
                        const Text(
                          'اسم الفئة (إنجليزي) *',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Neumorphic(
                          style: const NeumorphicStyle(
                            depth: -3,
                            intensity: 0.7,
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            controller: nameEnController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              hintText: 'أدخل اسم الفئة بالإنجليزية',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال اسم الفئة بالإنجليزية';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),

                        // وصف بالعربية
                        const Text(
                          'وصف الفئة (عربي)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Neumorphic(
                          style: const NeumorphicStyle(
                            depth: -3,
                            intensity: 0.7,
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            controller: descriptionController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              hintText: 'أدخل وصف الفئة بالعربية (اختياري)',
                            ),
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // وصف بالإنجليزية
                        const Text(
                          'وصف الفئة (إنجليزي)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Neumorphic(
                          style: const NeumorphicStyle(
                            depth: -3,
                            intensity: 0.7,
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            controller: descriptionEnController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              hintText: 'أدخل وصف الفئة بالإنجليزية (اختياري)',
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // أزرار الإغلاق والحفظ
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: NeumorphicButton(
                          style: const NeumorphicStyle(
                            color: Colors.white,
                            depth: 2,
                          ),
                          onPressed: () => Get.back(),
                          child: const Center(
                            child: Text(
                              'إلغاء',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: NeumorphicButton(
                          style: const NeumorphicStyle(
                            color: AppTheme.primaryColor,
                            depth: 2,
                          ),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              if (isEditing) {
                                final updatedCategory = Category(
                                  id: category.id,
                                  name: nameController.text,
                                  nameEn: nameEnController.text,
                                  description: descriptionController.text,
                                  descriptionEn: descriptionEnController.text,
                                  iconPath: selectedImagePath ??
                                      category.iconPath ??
                                      'assets/images/placeholder.png',
                                  order: category.order,
                                  isActive: category.isActive,
                                );
                                categoryController
                                    .updateCategory(updatedCategory);
                              } else {
                                final newCategory = Category(
                                  id: DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString(),
                                  name: nameController.text,
                                  nameEn: nameEnController.text,
                                  description: descriptionController.text,
                                  descriptionEn: descriptionEnController.text,
                                  iconPath: selectedImagePath ??
                                      'assets/images/placeholder.png',
                                  order: categoryController.categories.length,
                                  isActive: true,
                                );
                                categoryController.addCategory(newCategory);
                              }
                              Get.back();
                              Get.snackbar(
                                'تم بنجاح',
                                isEditing ? 'تم تحديث الفئة' : 'تم إضافة الفئة',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );
                            }
                          },
                          child: Center(
                            child: Text(
                              isEditing ? 'حفظ التعديلات' : 'إضافة',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<String?> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName =
            'category_${DateTime.now().millisecondsSinceEpoch}${path.extension(pickedFile.path)}';
        final savedImagePath =
            path.join(appDir.path, 'category_images', fileName);

        final imageDir = Directory(path.join(appDir.path, 'category_images'));
        if (!await imageDir.exists()) {
          await imageDir.create(recursive: true);
        }

        final File imageFile = File(pickedFile.path);
        await imageFile.copy(savedImagePath);

        return savedImagePath;
      }
      return null;
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء اختيار الصورة',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }
  }

  void _showDeleteConfirmationDialog(Category category) {
    Get.dialog(
      AlertDialog(
        title: const Text('حذف الفئة'),
        content: Text('هل أنت متأكد من حذف "${category.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              categoryController.deleteCategory(category.id);
              Get.back();
            },
            child: const Text(
              'حذف',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showResetCategoriesDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('استعادة الفئات الافتراضية'),
        content: const Text('هل أنت متأكد من استعادة الفئات الافتراضية؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              categoryController.resetCategories();
              Get.back();
            },
            child: const Text(
              'استعادة',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}
