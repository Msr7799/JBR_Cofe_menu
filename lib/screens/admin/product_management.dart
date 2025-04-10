import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/product_controller.dart';
import 'package:gpr_coffee_shop/controllers/category_controller.dart';
import 'package:gpr_coffee_shop/models/product.dart';
import 'package:logger/logger.dart';

class ProductManagement extends StatefulWidget {
  const ProductManagement({Key? key}) : super(key: key);

  @override
  State<ProductManagement> createState() => _ProductManagementState();
}

class _ProductManagementState extends State<ProductManagement> {
  final ProductController productController = Get.find<ProductController>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final Logger logger = Logger();

  String? _selectedImage;
  String? _originalImage;
  final ImagePicker _picker = ImagePicker();
  String _searchQuery = '';
  String _selectedCategoryFilter = '';
  bool _processingImage = false;

  @override
  void dispose() {
    _cleanupUnusedImage();
    super.dispose();
  }

  Future<void> _cleanupUnusedImage() async {
    try {
      if (_selectedImage != null &&
          _selectedImage != _originalImage &&
          !_selectedImage!.startsWith('assets/') &&
          File(_selectedImage!).existsSync()) {
        await File(_selectedImage!).delete();
      }
    } catch (e) {
      logger.e('Error cleaning up image: $e');
    }
  }

  Widget _buildProductImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return const Icon(Icons.image_not_supported, color: Colors.grey);
    }

    try {
      if (imageUrl.startsWith('assets/')) {
        return Image.asset(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (ctx, error, _) =>
              const Icon(Icons.broken_image, color: Colors.grey),
        );
      } else if (imageUrl.startsWith('http')) {
        return Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (ctx, error, _) =>
              const Icon(Icons.broken_image, color: Colors.grey),
        );
      } else {
        final file = File(imageUrl);
        if (!file.existsSync()) {
          return const Icon(Icons.broken_image, color: Colors.grey);
        }
        return Image.file(
          file,
          fit: BoxFit.cover,
          errorBuilder: (ctx, error, _) =>
              const Icon(Icons.broken_image, color: Colors.grey),
        );
      }
    } catch (e) {
      logger.e('Error loading image: $e');
      return const Icon(Icons.broken_image, color: Colors.grey);
    }
  }

  Future<void> _pickImage() async {
    if (_processingImage) return;

    try {
      setState(() => _processingImage = true);

      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${path.basename(pickedFile.path)}';
        final savedImagePath =
            path.join(appDir.path, 'product_images', fileName);

        final imageDir = Directory(path.join(appDir.path, 'product_images'));
        if (!await imageDir.exists()) {
          await imageDir.create(recursive: true);
        }

        final File imageFile = File(pickedFile.path);
        await imageFile.copy(savedImagePath);

        if (_selectedImage != null &&
            _selectedImage != _originalImage &&
            !_selectedImage!.startsWith('assets/') &&
            File(_selectedImage!).existsSync()) {
          await File(_selectedImage!).delete();
        }

        setState(() => _selectedImage = savedImagePath);

        Get.snackbar(
          'نجاح',
          'تم اختيار وحفظ الصورة بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      logger.e('Error picking image: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء اختيار الصورة',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      setState(() => _selectedImage = _originalImage);
    } finally {
      setState(() => _processingImage = false);
    }
  }

  Future<bool> _saveProduct({
    required String name,
    required String description,
    required double price,
    required double cost,
    required String categoryId,
    required bool isAvailable,
    required Product? existingProduct,
  }) async {
    try {
      final String finalImagePath =
          _selectedImage ?? 'assets/images/placeholder.png';

      if (existingProduct != null) {
        if (existingProduct.imageUrl != finalImagePath &&
            existingProduct.imageUrl != null &&
            !existingProduct.imageUrl!.startsWith('assets/') &&
            File(existingProduct.imageUrl!).existsSync()) {
          await File(existingProduct.imageUrl!).delete();
        }

        final updatedProduct = existingProduct.copyWith(
          name: name.trim(),
          description: description.trim(),
          price: price,
          cost: cost,
          categoryId: categoryId,
          imageUrl: finalImagePath,
          isAvailable: isAvailable,
        );
        return await productController.updateProduct(updatedProduct);
      } else {
        final newProduct = Product(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name.trim(),
          description: description.trim(),
          price: price,
          cost: cost,
          categoryId: categoryId,
          imageUrl: finalImagePath,
          isAvailable: isAvailable,
          options: [],
          order: productController.products.length,
        );
        return await productController.addProduct(newProduct);
      }
    } catch (e) {
      logger.e('Error saving product: $e');
      return false;
    }
  }

  void _showSearchDialog() {
    final searchController = TextEditingController(text: _searchQuery);

    Get.dialog(
      AlertDialog(
        title: const Text('بحث عن منتج'),
        content: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'اكتب اسم المنتج أو الوصف',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          autofocus: true,
          onSubmitted: (value) {
            setState(() => _searchQuery = value);
            Get.back();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _searchQuery = searchController.text);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor),
            child: const Text('بحث'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    String tempFilter = _selectedCategoryFilter;

    Get.dialog(
      AlertDialog(
        title: const Text('تصفية حسب الفئة'),
        content: SizedBox(
          width: MediaQuery.of(Get.context!).size.width * 0.7,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('جميع الفئات'),
                value: '',
                groupValue: tempFilter,
                onChanged: (value) => tempFilter = value!,
              ),
              const Divider(),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: categoryController.categories.length,
                  itemBuilder: (context, index) {
                    final category = categoryController.categories[index];
                    return RadioListTile<String>(
                      title: Text(category.name),
                      value: category.id,
                      groupValue: tempFilter,
                      onChanged: (value) => tempFilter = value!,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _selectedCategoryFilter = tempFilter);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor),
            child: const Text('تطبيق'),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddEditProductDialog(BuildContext context,
      [Product? product]) async {
    final isEditing = product != null;

    final nameController =
        TextEditingController(text: isEditing ? product.name : '');
    final descriptionController =
        TextEditingController(text: isEditing ? product.description : '');
    final priceController =
        TextEditingController(text: isEditing ? product.price.toString() : '');
    final costController =
        TextEditingController(text: isEditing ? product.cost.toString() : '');

    final formKey = GlobalKey<FormState>();
    bool isAvailable = isEditing ? product.isAvailable : true;

    String selectedCategoryId = isEditing
        ? product.categoryId
        : categoryController.categories.isNotEmpty
            ? categoryController.categories.first.id
            : '';

    setState(() {
      _selectedImage = isEditing ? product.imageUrl : null;
      _originalImage = isEditing ? product.imageUrl : null;
    });

    await Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isEditing ? 'تعديل منتج' : 'إضافة منتج جديد',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _processingImage ? null : () => _pickImage(),
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: _selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: _buildProductImage(_selectedImage!),
                              )
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate,
                                      size: 40, color: Colors.grey),
                                  SizedBox(height: 8),
                                  Text(
                                    'إضافة صورة',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'اسم المنتج *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال اسم المنتج';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'وصف المنتج',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: priceController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'السعر (د.ب) *',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'أدخل السعر';
                              }
                              final price = double.tryParse(value);
                              if (price == null || price <= 0) {
                                return 'سعر غير صالح';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: costController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'التكلفة (د.ب)',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final cost = double.tryParse(value);
                                if (cost == null || cost < 0) {
                                  return 'تكلفة غير صالحة';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'الفئة *',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedCategoryId,
                      items: categoryController.categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category.id,
                          child: Text(category.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          selectedCategoryId = value;
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى اختيار فئة';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('متوفر للبيع'),
                      value: isAvailable,
                      activeColor: AppTheme.primaryColor,
                      onChanged: (newValue) {
                        setState(() {
                          isAvailable = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            _cleanupUnusedImage();
                            Get.back();
                          },
                          child: const Text('إلغاء'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              final name = nameController.text;
                              final description = descriptionController.text;
                              final price =
                                  double.tryParse(priceController.text) ?? 0.0;
                              final cost =
                                  double.tryParse(costController.text) ?? 0.0;

                              // إغلاق النافذة الحوارية أولاً
                              Get.back();

                              final success = await _saveProduct(
                                name: name,
                                description: description,
                                price: price,
                                cost: cost,
                                categoryId: selectedCategoryId,
                                isAvailable: isAvailable,
                                existingProduct: product,
                              );

                              // عرض إشعار النجاح أو الفشل بعد إغلاق النافذة
                              if (success) {
                                Get.snackbar(
                                  'نجاح',
                                  isEditing
                                      ? 'تم تعديل المنتج بنجاح'
                                      : 'تم إضافة المنتج بنجاح',
                                  snackPosition: SnackPosition.TOP,
                                  duration: const Duration(seconds: 3),
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                  margin: const EdgeInsets.all(10),
                                  borderRadius: 10,
                                );
                              } else {
                                Get.snackbar(
                                  'خطأ',
                                  'حدث خطأ أثناء حفظ المنتج',
                                  snackPosition: SnackPosition.TOP,
                                  duration: const Duration(seconds: 3),
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  margin: const EdgeInsets.all(10),
                                  borderRadius: 10,
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                          ),
                          child: Text(
                            isEditing ? 'حفظ التعديلات' : 'إضافة المنتج',
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
      ),
    );
  }

  void _showUpdateConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تحديث قائمة المنتجات'),
        content: const Text(
            'هل تريد تحديث المنتجات بالمنتجات الجديدة؟ سيتم حذف المنتجات القديمة واستبدالها بالمنتجات الجديدة.'),
        actions: [
          TextButton(
            child: const Text('إلغاء'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('تحديث القائمة'),
            onPressed: () async {
              Navigator.pop(context);
              // Show loading indicator
              Get.dialog(
                const Center(
                  child: CircularProgressIndicator(),
                ),
                barrierDismissible: false,
              );

              await productController.updateProductsWithNewData();

              // Close loading indicator
              Get.back();

              Get.snackbar(
                'تم التحديث',
                'تم تحديث قائمة المنتجات بنجاح',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: const Duration(seconds: 3),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المنتجات'),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEditProductDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.update),
            tooltip: 'تحديث المنتجات الجديدة',
            onPressed: () {
              _showUpdateConfirmDialog(context);
            },
          ),
        ],
      ),
      body: Obx(
        () => productController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: productController.products.length,
                itemBuilder: (context, index) {
                  final product = productController.products[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      leading: SizedBox(
                        width: 60,
                        height: 60,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _buildProductImage(product.imageUrl ?? ''),
                        ),
                      ),
                      title: Text(product.name),
                      subtitle: Text(product.description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () =>
                                _showAddEditProductDialog(context, product),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => Get.dialog(
                              AlertDialog(
                                title: const Text('حذف المنتج'),
                                content: Text(
                                    'هل أنت متأكد من حذف "${product.name}"؟'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text('إلغاء'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (await productController
                                          .deleteProduct(product.id)) {
                                        Get.back();
                                        Get.snackbar(
                                          'نجاح',
                                          'تم حذف المنتج بنجاح',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: Colors.green,
                                          colorText: Colors.white,
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: const Text('حذف'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
        onPressed: () => _showAddEditProductDialog(context),
      ),
    );
  }
}
