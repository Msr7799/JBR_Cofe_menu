import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/product_controller.dart';
import 'package:gpr_coffee_shop/controllers/category_controller.dart';
import 'package:gpr_coffee_shop/controllers/settings_controller.dart';
import 'package:gpr_coffee_shop/models/product.dart';
import 'package:gpr_coffee_shop/models/menu_view_mode.dart';
import 'package:gpr_coffee_shop/widgets/product_card.dart';
import 'package:gpr_coffee_shop/screens/home_screen.dart';
import 'package:gpr_coffee_shop/utils/view_options_helper.dart';
import 'package:gpr_coffee_shop/utils/image_helper.dart';
import 'dart:io';

class MenuScreen extends StatelessWidget {
  final ProductController productController = Get.find<ProductController>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final SettingsController settingsController = Get.find<SettingsController>();

  MenuScreen({Key? key}) : super(key: key);

  // Use the ViewOptionsHelper to get current view preferences
  final String viewMode = ViewOptionsHelper.getViewMode();
  final bool showImages = ViewOptionsHelper.getShowImages();
  final bool useAnimations = ViewOptionsHelper.getUseAnimations();
  final bool showOrderButton = ViewOptionsHelper.getShowOrderButton();

  // Add this map to track product quantities
  final RxMap<String, int> productQuantities = <String, int>{}.obs;

  // Add methods to handle quantity changes
  void incrementQuantity(String productId) {
    if (productQuantities.containsKey(productId)) {
      productQuantities[productId] = productQuantities[productId]! + 1;
    } else {
      productQuantities[productId] = 1;
    }
  }

  void decrementQuantity(String productId) {
    if (productQuantities.containsKey(productId) &&
        productQuantities[productId]! > 0) {
      productQuantities[productId] = productQuantities[productId]! - 1;
    }
  }

  int getQuantity(String productId) {
    return productQuantities[productId] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('القائمة',
            style: TextStyle(color: AppTheme.primaryColor)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.offAll(() => const HomeScreen()),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.view_list),
            onPressed: () => _showViewOptionsDialog(context),
          ),
        ],
      ),
      body: Obx(
        () => categoryController.isLoading.value ||
                productController.isLoading.value
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('جاري تحميل المنتجات...',
                        style: TextStyle(color: AppTheme.primaryColor)),
                  ],
                ),
              )
            : Column(
                children: [
                  _buildCategoriesSection(),
                  Expanded(
                    child: _buildProductsSection(viewMode, isSmallScreen),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoryController.categories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Obx(() => ChoiceChip(
                    label: const Text('الكل'),
                    selected:
                        categoryController.selectedCategoryId.value.isEmpty,
                    onSelected: (selected) {
                      if (selected) {
                        categoryController.selectedCategoryId.value = '';
                      }
                    },
                    backgroundColor: AppTheme.backgroundColor,
                    selectedColor: AppTheme.primaryColor.withAlpha(51),
                    labelStyle: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            );
          }

          final category = categoryController.categories[index - 1];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Obx(() => ChoiceChip(
                  label: Text(category.localizedName), // Use localized name
                  selected: categoryController.selectedCategoryId.value ==
                      category.id,
                  onSelected: (selected) {
                    if (selected) {
                      categoryController.selectedCategoryId.value = category.id;
                    } else {
                      categoryController.selectedCategoryId.value = '';
                    }
                  },
                  backgroundColor: AppTheme.backgroundColor,
                  selectedColor: AppTheme.primaryColor.withAlpha(51),
                  labelStyle: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          );
        },
      ),
    );
  }

  Widget _buildProductsSection(String viewMode, bool isSmallScreen) {
    final filteredProducts = productController.products
        .where((product) =>
            categoryController.selectedCategoryId.value.isEmpty ||
            product.categoryId == categoryController.selectedCategoryId.value)
        .toList();

    if (viewMode == 'grid') {
      return _buildGridView(filteredProducts, showImages);
    } else if (viewMode == 'list') {
      return _buildListView(filteredProducts, showImages);
    } else {
      return _buildCompactView(filteredProducts, showImages);
    }
  }

  Widget _buildGridView(List<Product> products, bool showImages) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Icon(
              Icons.no_food,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'لا توجد منتجات في هذه الفئة',
              style: TextStyle(
                fontSize: 21,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.75, // نسبة العرض إلى الارتفاع المناسبة للبطاقات
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      padding: const EdgeInsets.all(15),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          showImage: showImages,
          onTap: () => _showProductDetails(product),
        );
      },
    );
  }

  Widget _buildListView(List<Product> products, bool showImages) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showImages && product.imageUrl != null)
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(right: 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _buildProductImage(product.imageUrl),
                    ),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.localizedName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        product.localizedDescription,
                        style: const TextStyle(fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${product.price.toStringAsFixed(3)} د.ب',
                            style: const TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          _buildQuantitySelector(product.id),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompactView(List<Product> products, bool showImages) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (showImages && product.imageUrl != null)
                  Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.only(right: 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _buildProductImage(product.imageUrl),
                    ),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.localizedName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${product.price.toStringAsFixed(3)} د.ب',
                        style: TextStyle(
                          color: Theme.of(Get.context!).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildQuantitySelector(product.id),
              ],
            ),
          ),
        );
      },
    );
  }

  // Add this new widget for quantity selection
  Widget _buildQuantitySelector(String productId) {
    return Obx(() => Row(
          children: [
            InkWell(
              onTap: () => decrementQuantity(productId),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.remove,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
            ),
            Container(
              width: 40,
              height: 36,
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${getQuantity(productId)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            InkWell(
              onTap: () => incrementQuantity(productId),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ));
  }

  void _showProductDetails(Product product) {
    final RxInt quantity = (getQuantity(product.id)).obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (product.imageUrl != null)
                Center(
                  child: Container(
                    width: 300,
                    height: 250,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _buildProductImage(product.imageUrl),
                    ),
                  ),
                ),
              Text(
                product.localizedName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                product.localizedDescription,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${product.price.toStringAsFixed(3)} د.ب',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'الكمية:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () {
                      if (quantity.value > 0) quantity.value--;
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.remove,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  Obx(() => Container(
                        width: 50,
                        height: 40,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${quantity.value}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      )),
                  InkWell(
                    onTap: () => quantity.value++,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('إغلاق'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Save the selected quantity
                      if (quantity.value > 0) {
                        productQuantities[product.id] = quantity.value;
                        Get.back();
                        Get.snackbar(
                          'تم الإضافة',
                          'تمت إضافة ${quantity.value} × ${product.localizedName} إلى طلبك',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      } else {
                        Get.snackbar(
                          'تنبيه',
                          'الرجاء تحديد الكمية',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.amber,
                        );
                      }
                    },
                    child: const Text('إضافة للطلب'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showViewOptionsDialog(BuildContext context) {
    final RxString viewMode = this.viewMode.obs;
    final RxBool showImages = this.showImages.obs;

    Get.dialog(
      AlertDialog(
        title: const Text('خيارات العرض'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'طريقة عرض المنتجات:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(() => RadioListTile<String>(
                  title: const Text('عرض شبكي'),
                  value: 'grid',
                  groupValue: viewMode.value,
                  onChanged: (value) => viewMode.value = value!,
                )),
            Obx(() => RadioListTile<String>(
                  title: const Text('عرض قائمة'),
                  value: 'list',
                  groupValue: viewMode.value,
                  onChanged: (value) => viewMode.value = value!,
                )),
            Obx(() => RadioListTile<String>(
                  title: const Text('عرض مدمج'),
                  value: 'compact',
                  groupValue: viewMode.value,
                  onChanged: (value) => viewMode.value = value!,
                )),
            const Divider(),
            Obx(() => SwitchListTile(
                  title: const Text('عرض الصور'),
                  value: showImages.value,
                  onChanged: (value) => showImages.value = value,
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              // Save the settings
              ViewOptionsHelper.saveViewMode(viewMode.value);
              ViewOptionsHelper.saveShowImages(showImages.value);

              Get.back();
              // Refresh the view to apply changes
              Get.forceAppUpdate();

              Get.snackbar(
                'تم الحفظ',
                'تم حفظ إعدادات العرض بنجاح',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green.withAlpha(180),
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  // Helper method to properly load product images
  Widget _buildProductImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return const Icon(Icons.image_not_supported, size: 60);
    }

    try {
      // Check if the path is a local file path
      if (imagePath.startsWith('C:') ||
          imagePath.startsWith('/') ||
          imagePath.contains('Documents')) {
        return Image.file(
          File(imagePath),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print('خطأ تحميل الصورة: $imagePath, $error');
            return const Icon(Icons.broken_image, size: 60);
          },
        );
      } else {
        // Otherwise assume it's an asset path
        return Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print('خطأ تحميل الأصول: $imagePath, $error');
            return const Icon(Icons.broken_image, size: 60);
          },
        );
      }
    } catch (e) {
      print('Error building product image: $e');
      return const Icon(Icons.broken_image, size: 60);
    }
  }
}
