import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/product_controller.dart';
import 'package:gpr_coffee_shop/controllers/category_controller.dart';
import 'package:gpr_coffee_shop/widgets/product_card.dart';

class MenuScreen extends StatelessWidget {
  final ProductController productController = Get.find<ProductController>();
  final CategoryController categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => categoryController.isLoading.value || productController.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 120.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        'قائمة المنتجات',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      centerTitle: true,
                    ),
                  ),
                  // Categories Section
                  SliverToBoxAdapter(
                    child: _buildCategoriesSection(),
                  ),
                  // Products Grid
                  _buildProductsGrid(),
                ],
              ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoryController.categories.length,
        itemBuilder: (context, index) {
          final category = categoryController.categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(category.name),
              selected: categoryController.selectedCategoryId.value == category.id,
              onSelected: (selected) {
                if (selected) {
                  categoryController.selectedCategoryId.value = category.id;
                } else {
                  categoryController.selectedCategoryId.value = '';
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsGrid() {
    final productsList = productController.products
        .where((product) =>
            categoryController.selectedCategoryId.value.isEmpty ||
            product.categoryId == categoryController.selectedCategoryId.value)
        .toList();

    return SliverPadding(
      padding: EdgeInsets.all(8.0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = productsList[index];
            return ProductCard(
              product: product,
              onTap: () => _showProductDetails(product),
              showAddButton: true,
              onAddToCart: () => _addToCart(product),
            );
          },
          childCount: productsList.length,
        ),
      ),
    );
  }

  void _showProductDetails(product) {
    // TODO: Implement product details dialog
    Get.snackbar(
      'عذراً',
      'سيتم إضافة هذه الميزة قريباً',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _addToCart(product) {
    // TODO: Implement add to cart functionality
    Get.snackbar(
      'عذراً',
      'سيتم إضافة هذه الميزة قريباً',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
