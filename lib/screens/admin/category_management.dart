import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/category_controller.dart';
import 'package:gpr_coffee_shop/models/category.dart';

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
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: category.iconPath != null
                  ? Image.asset(
                      category.iconPath!,
                      fit: BoxFit.cover,
                    )
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

  void _showAddEditCategoryDialog(BuildContext context, [Category? category]) {
    final isEditing = category != null;
    final nameController =
        TextEditingController(text: isEditing ? category.name : '');
    final descriptionController =
        TextEditingController(text: isEditing ? category.description : '');
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
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
                        labelText: 'اسم الفئة',
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال اسم الفئة';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
                        labelText: 'وصف الفئة',
                        border: InputBorder.none,
                      ),
                      maxLines: 3,
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
                              description: descriptionController.text,
                              iconPath: category.iconPath ?? 'assets/images/placeholder.png',
                              order: category.order,
                            );
                            categoryController.updateCategory(updatedCategory);
                          } else {
                            final newCategory = Category(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              name: nameController.text,
                              description: descriptionController.text,
                              iconPath: 'assets/images/placeholder.png',
                              order: categoryController.categories.length,
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
    );
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
}
