import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/product_controller.dart';
import 'package:gpr_coffee_shop/controllers/category_controller.dart';
import 'package:gpr_coffee_shop/controllers/settings_controller.dart';
import 'package:gpr_coffee_shop/models/app_settings.dart';
import 'package:gpr_coffee_shop/widgets/product_card.dart';
import 'package:gpr_coffee_shop/widgets/pop_scope.dart';
import 'package:gpr_coffee_shop/screens/home_screen.dart';

class MenuScreen extends StatelessWidget {
  final ProductController productController = Get.find<ProductController>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final SettingsController settingsController = Get.find<SettingsController>();

  MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return GetBuilder<SettingsController>(
      builder: (settingsController) {
        final viewMode = settingsController.viewMode;

        return PopScope(
          canPop: Navigator.of(context).canPop(),
          onPopInvokedWithResult: (didPop, result) async {
            if (!didPop) {
              Get.offAll(() => const HomeScreen());
            }
          },
          child: Scaffold(
            body: Obx(
              () => categoryController.isLoading.value ||
                      productController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          expandedHeight: 120.0,
                          floating: false,
                          pinned: true,
                          flexibleSpace: const FlexibleSpaceBar(
                            title: Text(
                              'القائمة ',
                              style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            centerTitle: true,
                          ),
                          actions: [
                            IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                Get.snackbar(
                                  'البحث',
                                  'سيتم إضافة ميزة البحث قريباً',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              },
                            ),
                          ],
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          sliver: SliverToBoxAdapter(
                            child: _buildCategoriesSection(),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.all(16.0),
                          sliver: _buildViewMode(viewMode, isSmallScreen),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildViewMode(MenuViewMode viewMode, bool isSmallScreen) {
    final filteredProducts = productController.products
        .where((product) =>
            categoryController.selectedCategoryId.value.isEmpty ||
            product.categoryId == categoryController.selectedCategoryId.value)
        .toList();

    switch (viewMode) {
      case MenuViewMode.list:
        return _buildListView(filteredProducts);
      case MenuViewMode.textOnly:
        return _buildTextOnlyView(filteredProducts);
      case MenuViewMode.singleProduct:
        return _buildSingleProductView(filteredProducts);
      case MenuViewMode.categories:
        return _buildCategoriesView();
      case MenuViewMode.cards:
      default:
        return _buildProductsGrid(isSmallScreen, filteredProducts);
    }
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
                    selectedColor: AppTheme.primaryColor
                        .withAlpha(51), // Changed from withOpacity(0.2)
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
                  label: Text(category.name),
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
                  selectedColor: AppTheme.primaryColor
                      .withAlpha(51), // Changed from withOpacity(0.2)
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

  Widget _buildProductsGrid(bool isSmallScreen, List<Product> filteredProducts) {
    return filteredProducts.isEmpty
        ? SliverToBoxAdapter(
            child: Center(
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
            ),
          )
        : SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isSmallScreen ? 1 : 2,
              childAspectRatio:
                  1.0, // تغيير من 0.8 إلى 1.0 ليصبح مربع أو قيمة أخرى مناسبة
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = filteredProducts[index];
                return ProductCard(
                  product: product,
                  onTap: () => _showProductDetails(product),
                );
              },
              childCount: filteredProducts.length,
            ),
          );
  }

  Widget _buildListView(List<Product> products) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text(product.description),
            trailing: Text('${product.price.toStringAsFixed(3)} د.ب'),
            onTap: () => _showProductDetails(product),
          );
        },
        childCount: products.length,
      ),
    );
  }

  Widget _buildTextOnlyView(List<Product> products) {
    return SliverToBoxAdapter(
      child: Column(
        children: products.map((product) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSingleProductView(List<Product> products) {
    if (products.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: const Text(
            'لا توجد منتجات',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      );
    }

    final product = products.first;
    return SliverToBoxAdapter(
      child: ProductCard(
        product: product,
        onTap: () => _showProductDetails(product),
      ),
    );
  }

  Widget _buildCategoriesView() {
    return SliverToBoxAdapter(
      child: Column(
        children: categoryController.categories.map((category) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              category.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showProductDetails(dynamic product) {
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
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                product.description,
                style: const TextStyle(
                  fontSize: 18,
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
                      Get.back();
                      Get.snackbar(
                        'تم الإضافة',
                        'تمت إضافة ${product.name} إلى طلبك',
                        snackPosition: SnackPosition.BOTTOM,
                      );
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
}
