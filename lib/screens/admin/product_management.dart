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
import 'package:gpr_coffee_shop/models/category.dart';

class ProductManagement extends StatefulWidget {
  const ProductManagement({Key? key}) : super(key: key);

  @override
  State<ProductManagement> createState() => _ProductManagementState();
}

class _ProductManagementState extends State<ProductManagement> {
  final ProductController productController = Get.find<ProductController>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final Logger logger = Logger();

  // إضافة متغيرات لوضع التحديد المتعدد
  bool _isMultiSelectMode = false;
  final RxList<String> _selectedProductIds = <String>[].obs;

  // المتغيرات الأصلية
  String? _selectedImage;
  String? _originalImage;
  final ImagePicker _picker = ImagePicker();
  String _searchQuery = '';
  Set<String> _selectedCategoryFilters = {};
  bool _processingImage = false;

  // متغيرات جديدة للفرز والفلترة المتقدمة
  String _sortBy = 'name'; // الفرز الافتراضي حسب الاسم
  bool _sortAscending = true; // ترتيب تصاعدي افتراضياً
  double _priceFilterMin = 0; // الحد الأدنى للسعر
  double _priceFilterMax = 100; // الحد الأقصى للسعر
  bool _showOnlyAvailable = false; // عرض المنتجات المتاحة فقط

  @override
  void initState() {
    super.initState();

    // استخدام PostFrameCallback لضمان اكتمال البناء قبل أي عملية قد تؤثر على التخطيط
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // أي تهيئة إضافية تحتاج لها بعد اكتمال البناء
        _loadInitialData();
      }
    });
  }

  void _loadInitialData() {
    // استدعاء أي بيانات ضرورية هنا (إذا كنت بحاجة للتحميل المبدئي)
  }

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

  // تعديل الدالة من Future<void> إلى Future<String?>
  Future<String?> _pickImage() async {
    if (_processingImage) return null;

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
        final savedImagePath = path.join(
          appDir.path,
          'product_images',
          fileName,
        );

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

        // إضافة هذا السطر لإرجاع مسار الصورة المحفوظة
        return savedImagePath;
      }

      return null; // في حالة عدم اختيار صورة
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
      return null; // في حالة حدوث خطأ
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          autofocus: true,
          onSubmitted: (value) {
            setState(() => _searchQuery = value);
            Get.back();
          },
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              setState(() => _searchQuery = searchController.text);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('بحث'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    // نسخ الفئات المختارة إلى متغير مؤقت للتعديل
    Set<String> tempFilters = Set.from(_selectedCategoryFilters);

    Get.dialog(
      StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('تصفية حسب الفئة'),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // إضافة زر لعرض جميع المنتجات
                  ListTile(
                    leading: IconButton(
                      icon: Icon(
                        tempFilters.isEmpty
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: tempFilters.isEmpty
                            ? AppTheme.primaryColor
                            : const Color.fromARGB(255, 22, 21, 21),
                      ),
                      onPressed: () {
                        // إلغاء جميع الفئات المحددة
                        setDialogState(() {
                          tempFilters.clear();
                        });
                      },
                    ),
                    title: const Text(
                      'عرض جميع المنتجات',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      // إلغاء جميع الفئات المحددة
                      setDialogState(() {
                        tempFilters.clear();
                      });
                    },
                  ),
                  const Divider(),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.4,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: categoryController.categories.map((category) {
                          final isSelected = tempFilters.contains(category.id);
                          return CheckboxListTile(
                            title: Text(category.name),
                            subtitle: Text(
                              '${_countProductsInCategory(category.id)} منتج',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600]),
                            ),
                            value: isSelected,
                            activeColor: AppTheme.primaryColor,
                            onChanged: (bool? value) {
                              setDialogState(() {
                                if (value == true) {
                                  tempFilters.add(category.id);
                                } else {
                                  tempFilters.remove(category.id);
                                }
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          );
                        }).toList(),
                      ),
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
                  setState(() => _selectedCategoryFilters = tempFilters);
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                ),
                child: const Text('تطبيق'),
              ),
            ],
          );
        },
      ),
    );
  }

  // دالة لحساب عدد المنتجات في كل فئة
  int _countProductsInCategory(String categoryId) {
    return productController.products
        .where((product) => product.categoryId == categoryId)
        .length;
  }

  // دالة _showAddEditProductDialog المعدلة لدعم معاينة الصورة بشكل فوري

  Future<void> _showAddEditProductDialog(
    BuildContext context, [
    Product? product,
  ]) async {
    final isEditing = product != null;

    // متغيرات للنماذج...
    final nameController = TextEditingController(
      text: isEditing ? product.name : '',
    );
    final descriptionController = TextEditingController(
      text: isEditing ? product.description : '',
    );
    final priceController = TextEditingController(
      text: isEditing ? product.price.toString() : '',
    );
    final costController = TextEditingController(
      text: isEditing ? product.cost.toString() : '',
    );

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

    // استخدام Rx للتحديث التلقائي للواجهة عند تغيير الصورة
    final Rx<String?> rxSelectedImage =
        (isEditing ? product?.imageUrl : null).obs;

    await Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            width:
                MediaQuery.of(context).size.width * 0.85, // صغرنا العرض قليلاً
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isEditing ? 'تعديل منتج' : 'إضافة منتج جديد',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            _cleanupUnusedImage();
                            Get.back();
                          },
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
                          // صورة المنتج - مع تحسين المعاينة
                          Center(
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                GestureDetector(
                                  onTap: _processingImage
                                      ? null
                                      : () async {
                                          final pickedImage =
                                              await _pickImage();
                                          if (pickedImage != null) {
                                            _selectedImage = pickedImage;
                                            // تحديث المتغير التفاعلي لتحديث الواجهة فورًا
                                            rxSelectedImage.value = pickedImage;
                                          }
                                        },
                                  child: Container(
                                    height: 120,
                                    width: 120,
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
                                    child: _processingImage
                                        ? const Center(
                                            child: CircularProgressIndicator())
                                        : Obx(
                                            () => rxSelectedImage.value != null
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    child: _buildProductImage(
                                                        rxSelectedImage.value!),
                                                  )
                                                : const Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .add_photo_alternate,
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
                                // زر تغيير الصورة
                                Obx(() => rxSelectedImage.value != null
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
                                            onPressed: _processingImage
                                                ? null
                                                : () async {
                                                    final pickedImage =
                                                        await _pickImage();
                                                    if (pickedImage != null) {
                                                      _selectedImage =
                                                          pickedImage;
                                                      rxSelectedImage.value =
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
                                    : const SizedBox.shrink()),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // اسم المنتج
                          Neumorphic(
                            style: const NeumorphicStyle(
                              depth: -3,
                              intensity: 0.7,
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                labelText: 'اسم المنتج *',
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'يرجى إدخال اسم المنتج';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 16),

                          // وصف المنتج
                          Neumorphic(
                            style: const NeumorphicStyle(
                              depth: -3,
                              intensity: 0.7,
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              controller: descriptionController,
                              maxLines: 2,
                              decoration: const InputDecoration(
                                labelText: 'وصف المنتج',
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // السعر والتكلفة
                          Row(
                            children: [
                              Expanded(
                                child: Neumorphic(
                                  style: const NeumorphicStyle(
                                    depth: -3,
                                    intensity: 0.7,
                                    color: Colors.white,
                                  ),
                                  child: TextFormField(
                                    controller: priceController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                    decoration: const InputDecoration(
                                      labelText: 'السعر (د.ب) *',
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 16),
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
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Neumorphic(
                                  style: const NeumorphicStyle(
                                    depth: -3,
                                    intensity: 0.7,
                                    color: Colors.white,
                                  ),
                                  child: TextFormField(
                                    controller: costController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                    decoration: const InputDecoration(
                                      labelText: 'التكلفة (د.ب)',
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 16),
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
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // الفئة
                          Neumorphic(
                            style: const NeumorphicStyle(
                              depth: -3,
                              intensity: 0.7,
                              color: Colors.white,
                            ),
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'الفئة *',
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16),
                              ),
                              value: selectedCategoryId,
                              items:
                                  categoryController.categories.map((category) {
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
                          ),
                          const SizedBox(height: 16),

                          // متوفر للبيع
                          NeumorphicSwitch(
                            value: isAvailable,
                            style: const NeumorphicSwitchStyle(
                              activeTrackColor: AppTheme.primaryColor,
                              inactiveTrackColor: Colors.grey,
                            ),
                            onChanged: (value) {
                              setState(() => isAvailable = value);
                            },
                            isEnabled: true,
                          ),
                          Text(
                            isAvailable ? 'متوفر للبيع' : 'غير متوفر',
                            style: TextStyle(
                              color: isAvailable
                                  ? AppTheme.primaryColor
                                  : Colors.grey[600],
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
                            onPressed: () {
                              _cleanupUnusedImage();
                              Get.back();
                            },
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
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                final name = nameController.text;
                                final description = descriptionController.text;
                                final price =
                                    double.tryParse(priceController.text) ??
                                        0.0;
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
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                    margin: const EdgeInsets.all(10),
                                    borderRadius: 10,
                                  );
                                }
                              }
                            },
                            child: Center(
                              child: Text(
                                isEditing ? 'حفظ التعديلات' : 'إضافة المنتج',
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
      ),
      barrierDismissible: false,
    );
  }

  // استبدل دالة _deleteSelectedProducts الحالية بهذه النسخة المحسنة
  Future<void> _deleteSelectedProducts() async {
    if (_selectedProductIds.isEmpty) return;

    final int count = _selectedProductIds.length;

    Get.dialog(
      AlertDialog(
        title: const Text('حذف المنتجات المحددة'),
        content: Text(
            'هل أنت متأكد من حذف $count منتج${count > 1 ? 'ات' : ''} محدد${count > 1 ? 'ة' : ''}؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();

              // عرض مؤشر التحميل
              Get.dialog(
                const Center(child: CircularProgressIndicator()),
                barrierDismissible: false,
              );

              // استخدام الدالة الجديدة لحذف متعدد للمنتجات
              // نسخ القائمة لتجنب أي تعديلات أثناء العملية
              final List<String> selectedIds =
                  List<String>.from(_selectedProductIds);
              final result =
                  await productController.deleteMultipleProducts(selectedIds);

              // إغلاق مؤشر التحميل
              Get.back();

              // عرض إشعار واحد فقط بعد الانتهاء
              if (result) {
                Get.snackbar(
                  'تمت العملية بنجاح',
                  'تم حذف ${selectedIds.length} منتج${selectedIds.length > 1 ? 'ات' : ''} بنجاح',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 3),
                  borderRadius: 10,
                  margin: const EdgeInsets.all(10),
                );
              } else {
                Get.snackbar(
                  'فشلت العملية',
                  'حدث خطأ أثناء حذف المنتجات',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 3),
                  borderRadius: 10,
                  margin: const EdgeInsets.all(10),
                );
              }

              // إلغاء وضع التحديد المتعدد
              setState(() {
                _isMultiSelectMode = false;
                _selectedProductIds.clear();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _showResetConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إعادة ضبط قائمة المنتجات'),
        content: const Text(
          'هل تريد إعادة ضبط قائمة المنتجات إلى القائمة الأساسية؟\nسيؤدي ذلك إلى حذف جميع المنتجات الحالية وإضافة المنتجات الأساسية من ملف menu_data.dart.',
        ),
        actions: [
          TextButton(
            child: const Text('إلغاء'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('إعادة الضبط'),
            onPressed: () async {
              Navigator.pop(context);
              // إظهار مؤشر التحميل
              Get.dialog(
                const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'جاري إعادة تعيين المنتجات...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                barrierDismissible: false,
              );

              // استدعاء دالة إعادة تعيين المنتجات
              await productController.resetProductsToDefault();

              // إغلاق مؤشر التحميل
              Get.back();

              // عرض رسالة نجاح
              Get.snackbar(
                'تمت العملية بنجاح',
                'تم إعادة ضبط قائمة المنتجات إلى القائمة الأساسية',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: const Duration(seconds: 3),
                margin: const EdgeInsets.all(10),
                borderRadius: 10,
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
        title: _isMultiSelectMode
            ? Text(
                'تم تحديد ${_selectedProductIds.length} منتج${_selectedProductIds.length > 1 ? 'ات' : ''}')
            : const Text('إدارة المنتجات'),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_isMultiSelectMode) {
              _toggleMultiSelectMode();
            } else {
              Get.back();
            }
          },
        ),
        actions: _isMultiSelectMode
            ? [
                // أزرار وضع التحديد المتعدد
                IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: 'حذف المحدد',
                  onPressed: _selectedProductIds.isNotEmpty
                      ? _deleteSelectedProducts
                      : null,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: 'إلغاء',
                  onPressed: _toggleMultiSelectMode,
                ),
              ]
            : [
                // إضافة زر إعادة تعيين المنتجات
                IconButton(
                  icon: const Icon(Icons.restart_alt),
                  tooltip: 'إعادة ضبط المنتجات',
                  onPressed: () => _showResetConfirmDialog(context),
                ),
                IconButton(
                  icon: const Icon(Icons.sort),
                  tooltip: 'خيارات الترتيب',
                  onPressed: _showSortOptionsDialog,
                ),
                IconButton(
                  icon: const Icon(Icons.filter_alt),
                  tooltip: 'فلترة متقدمة',
                  onPressed: _showAdvancedFilterDialog,
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  tooltip: 'بحث',
                  onPressed: () => _showSearchDialog(),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'إضافة منتج',
                  onPressed: () => _showAddEditProductDialog(context),
                ),
                IconButton(
                  icon: const Icon(Icons.select_all),
                  tooltip: 'تحديد متعدد',
                  onPressed: _toggleMultiSelectMode,
                ),
              ],
      ),
      body: Obx(
        () => productController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // عرض الفلاتر النشطة
                  _buildActiveFilters(),

                  // شريط المعلومات
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        // عدد المنتجات المعروضة
                        Text(
                          'عرض ${_getFilteredProducts().length} من ${productController.products.length} منتج',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // مربع تحديد الكل (في وضع التحديد المتعدد)
                  if (_isMultiSelectMode)
                    Container(
                      color: Colors.grey[100],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _selectedProductIds.length ==
                                    _getFilteredProducts().length &&
                                _getFilteredProducts().isNotEmpty,
                            activeColor: AppTheme.primaryColor,
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  _selectedProductIds.clear();
                                  for (final product
                                      in _getFilteredProducts()) {
                                    _selectedProductIds.add(product.id);
                                  }
                                } else {
                                  _selectedProductIds.clear();
                                }
                              });
                            },
                          ),
                          const Text('تحديد الكل'),
                          const Spacer(),
                          if (_selectedProductIds.isNotEmpty)
                            TextButton.icon(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              label: const Text(
                                'حذف المحدد',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: _deleteSelectedProducts,
                            ),
                        ],
                      ),
                    ),

                  // قائمة المنتجات
                  Expanded(
                    child: _getFilteredProducts().isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 80,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'لا توجد منتجات تطابق معايير البحث',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('إعادة تعيين الفلاتر'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _selectedCategoryFilters.clear();
                                      _searchQuery = '';
                                      _priceFilterMin = 0;
                                      _priceFilterMax = 100;
                                      _showOnlyAvailable = false;
                                    });
                                  },
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _getFilteredProducts().length,
                            itemBuilder: (context, index) {
                              final product = _getFilteredProducts()[index];
                              final bool isSelected =
                                  _selectedProductIds.contains(product.id);

                              return _buildProductCard(product, isSelected);
                            },
                          ),
                  ),
                ],
              ),
      ),
      floatingActionButton: _isMultiSelectMode
          ? null
          : FloatingActionButton(
              backgroundColor: AppTheme.primaryColor,
              child: const Icon(Icons.add),
              onPressed: () => _showAddEditProductDialog(context),
            ),
    );
  }

  void _toggleMultiSelectMode() {
    if (!mounted) return;

    setState(() {
      _isMultiSelectMode = !_isMultiSelectMode;
      if (!_isMultiSelectMode) {
        _selectedProductIds.clear();
      }
    });
  }

  void _toggleProductSelection(String productId) {
    if (!mounted) return;

    setState(() {
      if (_selectedProductIds.contains(productId)) {
        _selectedProductIds.remove(productId);
      } else {
        _selectedProductIds.add(productId);
      }
    });
  }

  void _showDeleteConfirmationDialog(Product product) {
    Get.dialog(
      AlertDialog(
        title: const Text('حذف منتج'),
        content: Text('هل أنت متأكد من حذف "${product.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();

              // عرض مؤشر التحميل
              Get.dialog(
                const Center(child: CircularProgressIndicator()),
                barrierDismissible: false,
              );

              final result = await productController.deleteProduct(product.id);

              // إغلاق مؤشر التحميل
              Get.back();

              if (result) {
                Get.snackbar(
                  'تم الحذف',
                  'تم حذف المنتج بنجاح',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                );
              } else {
                Get.snackbar(
                  'خطأ',
                  'فشل حذف المنتج',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
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
    );
  }

  // تعديل دالة _getFilteredProducts لدعم الترتيب
  List<Product> _getFilteredProducts() {
    List<Product> filtered = List.from(productController.products);

    // تطبيق فلتر الفئة
    if (_selectedCategoryFilters.isNotEmpty) {
      filtered = filtered
          .where((p) => _selectedCategoryFilters.contains(p.categoryId))
          .toList();
    }

    // تطبيق فلتر البحث
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((p) =>
              p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.description.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // تطبيق فلتر نطاق السعر
    filtered = filtered
        .where((p) => p.price >= _priceFilterMin && p.price <= _priceFilterMax)
        .toList();

    // تطبيق فلتر التوفر
    if (_showOnlyAvailable) {
      filtered = filtered.where((p) => p.isAvailable).toList();
    }

    // تطبيق الفرز
    filtered.sort((a, b) {
      int result;
      switch (_sortBy) {
        case 'name':
          result = a.name.compareTo(b.name);
          break;
        case 'price':
          result = a.price.compareTo(b.price);
          break;
        case 'availability':
          result =
              a.isAvailable == b.isAvailable ? 0 : (a.isAvailable ? -1 : 1);
          break;
        default:
          result = a.name.compareTo(b.name);
      }

      return _sortAscending ? result : -result;
    });

    return filtered;
  }

  // دالة للحصول على اسم الفئة من معرفها
  String _getCategoryName(String categoryId) {
    final category = categoryController.categories.firstWhere(
      (c) => c.id == categoryId,
      orElse: () => Category(
          id: '',
          name: 'غير معروف',
          nameEn: 'Unknown',
          description: '',
          descriptionEn: '',
          iconPath: '',
          order: 0),
    );

    return category.name;
  }

  Widget _buildSelectedFiltersBar() {
    if (_selectedCategoryFilters.isEmpty) {
      return Container();
    }

    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الفئات المحددة:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedCategoryFilters.map((categoryId) {
              return Chip(
                label: Text(_getCategoryName(categoryId)),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () {
                  setState(() {
                    _selectedCategoryFilters.remove(categoryId);
                  });
                },
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                deleteIconColor: AppTheme.primaryColor,
                labelStyle: const TextStyle(fontSize: 12),
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.clear_all, size: 16),
                label: const Text('مسح الكل'),
                onPressed: () {
                  setState(() {
                    _selectedCategoryFilters.clear();
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAdvancedFilterDialog() {
    // إنشاء نسخة مؤقتة من متغيرات الفلترة
    double tempMinPrice = _priceFilterMin;
    double tempMaxPrice = _priceFilterMax;
    bool tempShowOnlyAvailable = _showOnlyAvailable;
    Set<String> tempCategoryFilters = Set.from(_selectedCategoryFilters);

    Get.dialog(
      StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('فلترة متقدمة'),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // قسم فلترة الفئات
                    const Text(
                      'تصفية حسب الفئة:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        itemCount: categoryController.categories.length,
                        itemBuilder: (context, index) {
                          final category = categoryController.categories[index];
                          return CheckboxListTile(
                            title: Text(category.name),
                            subtitle: Text(
                              '${_countProductsInCategory(category.id)} منتج',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600]),
                            ),
                            value: tempCategoryFilters.contains(category.id),
                            activeColor: AppTheme.primaryColor,
                            onChanged: (bool? value) {
                              setDialogState(() {
                                if (value == true) {
                                  tempCategoryFilters.add(category.id);
                                } else {
                                  tempCategoryFilters.remove(category.id);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),
                    // قسم فلترة نطاق السعر
                    const Text(
                      'تصفية حسب نطاق السعر:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    RangeSlider(
                      values: RangeValues(tempMinPrice, tempMaxPrice),
                      min: 0,
                      max: 100,
                      divisions: 100,
                      labels: RangeLabels(
                        tempMinPrice.toStringAsFixed(1),
                        tempMaxPrice.toStringAsFixed(1),
                      ),
                      onChanged: (RangeValues values) {
                        setDialogState(() {
                          tempMinPrice = values.start;
                          tempMaxPrice = values.end;
                        });
                      },
                      activeColor: AppTheme.primaryColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${tempMinPrice.toStringAsFixed(1)} د.ب'),
                        Text('${tempMaxPrice.toStringAsFixed(1)} د.ب'),
                      ],
                    ),

                    const SizedBox(height: 20),
                    // قسم فلترة التوفر
                    SwitchListTile(
                      title: const Text('عرض المنتجات المتاحة فقط'),
                      value: tempShowOnlyAvailable,
                      activeColor: AppTheme.primaryColor,
                      onChanged: (bool value) {
                        setDialogState(() {
                          tempShowOnlyAvailable = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () {
                  setDialogState(() {
                    tempCategoryFilters.clear();
                    tempMinPrice = 0;
                    tempMaxPrice = 100;
                    tempShowOnlyAvailable = false;
                  });
                },
                child: const Text('إعادة تعيين'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedCategoryFilters = tempCategoryFilters;
                    _priceFilterMin = tempMinPrice;
                    _priceFilterMax = tempMaxPrice;
                    _showOnlyAvailable = tempShowOnlyAvailable;
                  });
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                ),
                child: const Text('تطبيق'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActiveFilters() {
    final List<Widget> filters = [];

    // إضافة شرائح الفلاتر النشطة
    if (_selectedCategoryFilters.isNotEmpty) {
      filters.add(Chip(
        label: Text('${_selectedCategoryFilters.length} فئة محددة'),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: () {
          setState(() => _selectedCategoryFilters.clear());
        },
      ));
    }

    if (_searchQuery.isNotEmpty) {
      filters.add(Chip(
        label: Text('بحث: $_searchQuery'),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: () {
          setState(() => _searchQuery = '');
        },
      ));
    }

    if (_priceFilterMin > 0 || _priceFilterMax < 100) {
      filters.add(Chip(
        label: Text(
            'السعر: ${_priceFilterMin.toStringAsFixed(1)}-${_priceFilterMax.toStringAsFixed(1)} د.ب'),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: () {
          setState(() {
            _priceFilterMin = 0;
            _priceFilterMax = 100;
          });
        },
      ));
    }

    if (_showOnlyAvailable) {
      filters.add(Chip(
        label: const Text('المنتجات المتاحة فقط'),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: () {
          setState(() => _showOnlyAvailable = false);
        },
      ));
    }

    // إذا لم تكن هناك فلاتر نشطة، لا نعرض أي شيء
    if (filters.isEmpty) {
      return Container();
    }

    // عرض الفلاتر النشطة
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الفلاتر النشطة:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: filters,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('إعادة تعيين الجميع'),
                onPressed: () {
                  setState(() {
                    _selectedCategoryFilters.clear();
                    _searchQuery = '';
                    _priceFilterMin = 0;
                    _priceFilterMax = 100;
                    _showOnlyAvailable = false;
                    _sortBy = 'name';
                    _sortAscending = true;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product, bool isSelected) {
    final category = _getCategoryName(product.categoryId);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: isSelected
              ? const BorderSide(color: AppTheme.primaryColor, width: 2)
              : BorderSide.none,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            if (_isMultiSelectMode) {
              _toggleProductSelection(product.id);
            } else {
              _showAddEditProductDialog(context, product);
            }
          },
          onLongPress: () {
            if (!_isMultiSelectMode) {
              _toggleMultiSelectMode();
              _toggleProductSelection(product.id);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // صورة المنتج
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: _buildProductImage(product.imageUrl ?? ''),
                  ),
                ),
                const SizedBox(width: 12),

                // محتوى المنتج
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (_isMultiSelectMode)
                            Checkbox(
                              value: _selectedProductIds.contains(product.id),
                              activeColor: AppTheme.primaryColor,
                              onChanged: (bool? value) {
                                _toggleProductSelection(product.id);
                              },
                            ),
                          Expanded(
                            child: Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      if (product.description.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            product.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ),

                      const SizedBox(height: 8),

                      // عرض معلومات الفئة والسعر
                      Row(
                        children: [
                          // بطاقة الفئة
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              category,
                              style: const TextStyle(
                                color: AppTheme.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          // مؤشر التوفر
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: product.isAvailable
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  product.isAvailable
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  size: 12,
                                  color: product.isAvailable
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  product.isAvailable ? 'متاح' : 'غير متاح',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: product.isAvailable
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Spacer(),

                          // السعر
                          Text(
                            '${product.price.toStringAsFixed(3)} د.ب',
                            style: const TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                      if (!_isMultiSelectMode)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                color: Colors.blue,
                                onPressed: () =>
                                    _showAddEditProductDialog(context, product),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              const SizedBox(width: 16),
                              IconButton(
                                icon: const Icon(Icons.delete, size: 20),
                                color: Colors.red,
                                onPressed: () =>
                                    _showDeleteConfirmationDialog(product),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
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
    );
  }

  void _showSortOptionsDialog() {
    Get.dialog(
      StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('خيارات الترتيب'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: const Text('الاسم'),
                  value: 'name',
                  groupValue: _sortBy,
                  onChanged: (value) {
                    setDialogState(() => _sortBy = value!);
                  },
                  activeColor: AppTheme.primaryColor,
                ),
                RadioListTile<String>(
                  title: const Text('السعر'),
                  value: 'price',
                  groupValue: _sortBy,
                  onChanged: (value) {
                    setDialogState(() => _sortBy = value!);
                  },
                  activeColor: AppTheme.primaryColor,
                ),
                RadioListTile<String>(
                  title: const Text('التوفر'),
                  value: 'availability',
                  groupValue: _sortBy,
                  onChanged: (value) {
                    setDialogState(() => _sortBy = value!);
                  },
                  activeColor: AppTheme.primaryColor,
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('ترتيب تصاعدي'),
                  value: _sortAscending,
                  onChanged: (value) {
                    setDialogState(() => _sortAscending = value);
                  },
                  activeColor: AppTheme.primaryColor,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  setState(() {}); // تحديث الواجهة بعد تغيير الترتيب
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                ),
                child: const Text('تطبيق'),
              ),
            ],
          );
        },
      ),
    );
  }
}
