import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/category_controller.dart';
import 'package:gpr_coffee_shop/models/category.dart';

class CategoryManagement extends StatelessWidget {
  final CategoryController categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إدارة الفئات'),
        backgroundColor: AppTheme.primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddEditCategoryDialog(context),
          ),
        ],
      ),
      body: Obx(
        () => categoryController.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : categoryController.categories.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'لا توجد فئات حاليًا',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _showAddEditCategoryDialog(context),
                          child: Text('إضافة فئة جديدة'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: categoryController.categories.length,
                    itemBuilder: (context, index) {
                      final category = categoryController.categories[index];
                      return _buildCategoryCard(context, category);
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        child: Icon(Icons.add),
        onPressed: () => _showAddEditCategoryDialog(context),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Category category) {
    return Neumorphic(
      margin: EdgeInsets.only(bottom: 16),
      style: NeumorphicStyle(
        depth: 3,
        intensity: 0.7,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
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
                  : Icon(Icons.image_not_supported),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: TextStyle(
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
                  icon: Icon(Icons.edit),
                  onPressed: () =>
                      _showAddEditCategoryDialog(context, category),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
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
          padding: EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isEditing ? 'تعديل فئة' : 'إضافة فئة جديدة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Neumorphic(
                  style: NeumorphicStyle(
                    depth: -3,
                    intensity: 0.7,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
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
                SizedBox(height: 16),
                Neumorphic(
                  style: NeumorphicStyle(
                    depth: -3,
                    intensity: 0.7,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'وصف الفئة',
                        border: InputBorder.none,
                      ),
                      maxLines: 3,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text('إلغاء'),
                    ),
                    SizedBox(width: 16),
                    NeumorphicButton(
                      style: NeumorphicStyle(
                        color: AppTheme.primaryColor,
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          if (isEditing) {
                            // إنشاء نسخة معدلة من الفئة الحالية مع القيم الجديدة
                            final updatedCategory = category.copyWith(
                              name: nameController.text,
                              description: descriptionController.text,
                            );
                            categoryController.updateCategory(updatedCategory);
                          } else {
                            // إنشاء كائن فئة جديد
                            final newCategory = Category(
                              id: DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              name: nameController.text,
                              description: descriptionController.text,
                              iconPath:
                                  'assets/images/categories/default.png', // مسار افتراضي للأيقونة
                            );
                            categoryController.addCategory(newCategory);
                          }
                          Get.back();
                        }
                      },
                      child: Text(
                        isEditing ? 'حفظ التعديلات' : 'إضافة',
                        style: TextStyle(color: Colors.white),
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
        title: Text('حذف الفئة'),
        content: Text('هل أنت متأكد من حذف "${category.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              categoryController.deleteCategory(category.id);
              Get.back();
            },
            child: Text(
              'حذف',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
