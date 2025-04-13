import 'package:flutter/material.dart';
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
        backgroundColor: AppTheme.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'استعادة الفئات الافتراضية',
            onPressed: () => _showResetCategoriesDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEditCategoryDialog(context),
          ),
        ],
      ),
      body: Obx(
        () => categoryController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : categoryController.categories.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.category_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'لا توجد فئات حاليًا',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _showAddEditCategoryDialog(context),
                          child: const Text('إضافة فئة جديدة'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: categoryController.categories.length,
                    itemBuilder: (context, index) {
                      final category = categoryController.categories[index];
                      return _buildCategoryCard(context, category);
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
        onPressed: () => _showAddEditCategoryDialog(context),
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
    if (path.startsWith('C:') || path.startsWith('/') || path.contains('Documents')) {
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
    final Rx<String?> rxSelectedImagePath = (isEditing ? category.iconPath : null).obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isEditing ? 'تعديل فئة' : 'إضافة فئة جديدة',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // إضافة صورة للفئة
                  GestureDetector(
                    onTap: () async {
                      final pickedImage = await _pickImage();
                      if (pickedImage != null) {
                        selectedImagePath = pickedImage;
                        rxSelectedImagePath.value = pickedImage;
                      }
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(
                        child: Obx(() => rxSelectedImagePath.value != null
                            ? _buildCategoryImage(rxSelectedImagePath.value!)
                            : const Icon(Icons.add_photo_alternate, size: 40)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('اضغط لإضافة صورة',
                      style: TextStyle(fontSize: 12)),

                  const SizedBox(height: 16),
                  // اسم بالعربية
                  Neumorphic(
                    style: const NeumorphicStyle(
                      depth: -3,
                      intensity: 0.7,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'اسم الفئة (عربي)',
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال اسم الفئة بالعربية';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  // اسم بالإنجليزية
                  Neumorphic(
                    style: const NeumorphicStyle(
                      depth: -3,
                      intensity: 0.7,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        controller: nameEnController,
                        decoration: const InputDecoration(
                          labelText: 'اسم الفئة (إنجليزي)',
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال اسم الفئة بالإنجليزية';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  // وصف بالعربية
                  Neumorphic(
                    style: const NeumorphicStyle(
                      depth: -3,
                      intensity: 0.7,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'وصف الفئة (عربي)',
                          border: InputBorder.none,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  // وصف بالإنجليزية
                  Neumorphic(
                    style: const NeumorphicStyle(
                      depth: -3,
                      intensity: 0.7,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        controller: descriptionEnController,
                        decoration: const InputDecoration(
                          labelText: 'وصف الفئة (إنجليزي)',
                          border: InputBorder.none,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('إلغاء'),
                      ),
                      const SizedBox(width: 16),
                      NeumorphicButton(
                        style: const NeumorphicStyle(
                          color: AppTheme.primaryColor,
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
                            );
                          }
                        },
                        child: Text(
                          isEditing ? 'حفظ التعديلات' : 'إضافة',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
