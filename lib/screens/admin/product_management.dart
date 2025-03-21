import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/product_controller.dart';
import 'package:gpr_coffee_shop/controllers/category_controller.dart';
import 'package:gpr_coffee_shop/models/product.dart';

class ProductManagement extends StatelessWidget {
  final ProductController productController = Get.find<ProductController>();
  final CategoryController categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إدارة المنتجات'),
        backgroundColor: AppTheme.primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddEditProductDialog(context),
          ),
        ],
      ),
      body: Obx(
        () => productController.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : productController.products.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.coffee,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'لا توجد منتجات حاليًا',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _showAddEditProductDialog(context),
                          child: Text('إضافة منتج جديد'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: productController.products.length,
                    itemBuilder: (context, index) {
                      final product = productController.products[index];
                      return _buildProductCard(context, product);
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        child: Icon(Icons.add),
        onPressed: () => _showAddEditProductDialog(context),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    // احصل على اسم الفئة من معرف الفئة
    final category = categoryController.categories
        .firstWhereOrNull((c) => c.id == product.categoryId);
    final categoryName = category?.name ?? 'غير مصنف';

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
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: product.imageUrl != null
                  ? Image.asset(
                      product.imageUrl!,
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
                    product.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    categoryName,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  if (product.description.isNotEmpty)
                    Text(
                      product.description,
                      style: TextStyle(color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  SizedBox(height: 4),
                  Text(
                    '${product.price} ر.س',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _showAddEditProductDialog(context, product),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteConfirmationDialog(product),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddEditProductDialog(BuildContext context, [Product? product]) {
    final isEditing = product != null;
    final nameController =
        TextEditingController(text: isEditing ? product.name : '');
    final descriptionController =
        TextEditingController(text: isEditing ? product.description : '');
    final priceController =
        TextEditingController(text: isEditing ? product.price.toString() : '');
    final formKey = GlobalKey<FormState>();

    Rx<String> selectedCategoryId = Rx(isEditing
        ? product.categoryId
        : categoryController.categories.isNotEmpty
            ? categoryController.categories.first.id
            : '');

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isEditing ? 'تعديل منتج' : 'إضافة منتج جديد',
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
                          labelText: 'اسم المنتج',
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال اسم المنتج';
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
                          labelText: 'وصف المنتج',
                          border: InputBorder.none,
                        ),
                        maxLines: 3,
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
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'السعر (ر.س)',
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال سعر المنتج';
                          }
                          if (double.tryParse(value) == null) {
                            return 'يرجى إدخال سعر صحيح';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Obx(() => DropdownButtonFormField<String>(
                        value: selectedCategoryId.value,
                        decoration: InputDecoration(
                          labelText: 'الفئة',
                          border: OutlineInputBorder(),
                        ),
                        items: categoryController.categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category.id,
                            child: Text(category.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            selectedCategoryId.value = value;
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى اختيار فئة';
                          }
                          return null;
                        },
                      )),
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
                              final updatedProduct = product.copyWith(
                                name: nameController.text,
                                description: descriptionController.text,
                                price: double.parse(priceController.text),
                                categoryId: selectedCategoryId.value,
                              );
                              productController.updateProduct(updatedProduct);
                            } else {
                              final newProduct = Product(
                                id: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                name: nameController.text,
                                description: descriptionController.text,
                                price: double.parse(priceController.text),
                                categoryId: selectedCategoryId.value,
                                isAvailable: true,
                                cost: 0,
                                imageUrl: 'assets/images/placeholder.png',
                                options: [],
                              );
                              productController.addProduct(newProduct);
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
      ),
    );
  }

  void _showDeleteConfirmationDialog(Product product) {
    Get.dialog(
      AlertDialog(
        title: Text('حذف المنتج'),
        content: Text('هل أنت متأكد من حذف "${product.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              productController.deleteProduct(product.id);
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
