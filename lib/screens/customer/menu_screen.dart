import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/product_controller.dart';
import 'package:gpr_coffee_shop/controllers/category_controller.dart';
import 'package:gpr_coffee_shop/controllers/settings_controller.dart';
import 'package:gpr_coffee_shop/models/product.dart';
import 'package:gpr_coffee_shop/models/category.dart';
import 'package:gpr_coffee_shop/widgets/enhanced_product_card.dart';
import 'package:gpr_coffee_shop/screens/home_screen.dart';
import 'package:gpr_coffee_shop/utils/view_options_helper.dart';
import 'package:gpr_coffee_shop/utils/image_helper.dart';
import 'package:gpr_coffee_shop/widgets/category_card.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gpr_coffee_shop/controllers/order_controller.dart';
import 'package:gpr_coffee_shop/models/order.dart';

class MenuScreen extends StatelessWidget {
  final ProductController productController = Get.find<ProductController>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final SettingsController settingsController = Get.find<SettingsController>();

  // استخدام ViewOptionsHelper للحصول على إعدادات العرض
  final String viewMode = ViewOptionsHelper.getViewMode();
  final String displayMode = ViewOptionsHelper.getDisplayMode();
  final bool showImages = ViewOptionsHelper.getShowImages();
  final bool useAnimations = ViewOptionsHelper.getUseAnimations();
  final bool showOrderButton = ViewOptionsHelper.getShowOrderButton();
  final double cardSize = ViewOptionsHelper.getCardSize();
  final Color textColor = ViewOptionsHelper.getTextColorAsColor();
  final Color priceColor = ViewOptionsHelper.getPriceColorAsColor();

  // تتبع كميات المنتجات
  final RxMap<String, int> productQuantities = <String, int>{}.obs;
  // حالة البحث
  final RxString searchQuery = ''.obs;
  // متغير للتحكم في عرض شاشة الفئات أو المنتجات
  final RxBool showCategoryView = RxBool(false);
  // الفئة المحددة للعرض
  final Rx<Category?> selectedCategory = Rx<Category?>(null);

  // داخل كلاس MenuScreen، مع باقي المتغيرات
  final RxSet<String> selectedCategoryFilters = <String>{}.obs;
  final RxDouble priceFilterMin = 0.0.obs;
  final RxDouble priceFilterMax = 100.0.obs;
  final RxBool showOnlyAvailable = false.obs;

  MenuScreen({Key? key}) : super(key: key) {
    // تحديد طريقة العرض الأولية بناءً على إعدادات المستخدم
    showCategoryView.value = displayMode == 'categories';
  }

  // التحكم في كمية المنتجات
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
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;
    // Add more granular screen size checks
    final isVerySmallScreen = screenWidth < 360;

    return Scaffold(
      appBar: AppBar(
        title: Text('القائمة',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontSize: isVerySmallScreen ? 18 : 20,
            )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.offAll(() => const HomeScreen()),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => _showAdvancedFilterDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.view_list),
            onPressed: () => _showViewOptionsDialog(context),
          ),
          if (showCategoryView.value)
            IconButton(
              icon: const Icon(Icons.grid_view),
              tooltip: 'عرض جميع المنتجات',
              onPressed: () => showCategoryView.value = false,
            )
          else
            IconButton(
              icon: const Icon(Icons.category),
              tooltip: 'عرض حسب الفئات',
              onPressed: () => showCategoryView.value = true,
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Add refresh functionality if needed
          await Future.delayed(Duration(milliseconds: 500));
        },
        child: Obx(
          () => categoryController.isLoading.value ||
                  productController.isLoading.value
              ? _buildLoadingView()
              : Column(
                  children: [
                    // شريط البحث السريع - adjust padding based on screen size
                    Padding(
                      padding: EdgeInsets.fromLTRB(isVerySmallScreen ? 8 : 16,
                          8, isVerySmallScreen ? 8 : 16, 0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'بحث سريع عن المنتجات...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: Obx(() => searchQuery.value.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    searchQuery.value = '';
                                    // إعادة تعيين FocusNode لإخفاء لوحة المفاتيح
                                    FocusScope.of(context).unfocus();
                                  },
                                )
                              : const SizedBox.shrink()),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          // Adjust content padding based on screen size
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: isVerySmallScreen ? 8 : 16,
                              vertical: isVerySmallScreen ? 8 : 12),
                        ),
                        onChanged: (value) {
                          searchQuery.value = value;
                        },
                        // Make text smaller on very small screens
                        style: TextStyle(fontSize: isVerySmallScreen ? 14 : 16),
                      ),
                    ),

                    // قسم تصفية الفئات (يظهر فقط في طريقة عرض المنتجات)
                    if (!showCategoryView.value)
                      Container(
                        height: 50,
                        child: _buildCategoriesSection(isVerySmallScreen),
                      ),

                    // عرض الفئات أو المنتجات حسب الخيار المحدد
                    Expanded(
                      child: Obx(() => showCategoryView.value
                          ? _buildCategoriesView(
                              isSmallScreen, isVerySmallScreen)
                          : _buildProductsSection(
                              viewMode, isSmallScreen, isVerySmallScreen)),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // عرض شاشة التحميل
  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('جاري تحميل المنتجات...',
              style: TextStyle(color: AppTheme.primaryColor)),
        ],
      ),
    );
  }

  // شريط تصفية الفئات
  Widget _buildCategoriesSection(bool isVerySmallScreen) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: categoryController.categories.length + 1,
      padding: EdgeInsets.symmetric(
          horizontal: isVerySmallScreen ? 8 : 16, vertical: 8),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Obx(() => ChoiceChip(
                  label: Text(
                    'الكل',
                    style: TextStyle(fontSize: isVerySmallScreen ? 12 : 14),
                  ),
                  selected: categoryController.selectedCategoryId.value.isEmpty,
                  onSelected: (selected) {
                    if (selected) {
                      categoryController.selectedCategoryId.value = '';
                    }
                  },
                  backgroundColor: AppTheme.backgroundColor,
                  selectedColor: AppTheme.primaryColor.withAlpha(51),
                  labelStyle: TextStyle(
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
                label: Text(
                  category.localizedName,
                  style: TextStyle(fontSize: isVerySmallScreen ? 12 : 14),
                ), // استخدام الاسم المترجم
                selected:
                    categoryController.selectedCategoryId.value == category.id,
                onSelected: (selected) {
                  if (selected) {
                    categoryController.selectedCategoryId.value = category.id;
                  } else {
                    categoryController.selectedCategoryId.value = '';
                  }
                },
                backgroundColor: AppTheme.backgroundColor,
                selectedColor: AppTheme.primaryColor.withAlpha(51),
                labelStyle: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              )),
        );
      },
    );
  }

  // عرض شاشة الفئات
  Widget _buildCategoriesView(bool isSmallScreen, bool isVerySmallScreen) {
    return Obx(() {
      if (categoryController.categories.isEmpty) {
        return const Center(
          child: Text('لا توجد فئات متاحة',
              style: TextStyle(fontSize: 18, color: Colors.grey)),
        );
      }

      // فلترة الفئات حسب البحث
      final List<Category> filteredCategories = searchQuery.value.isEmpty
          ? categoryController.categories
          : categoryController.categories
              .where((cat) =>
                  cat.name
                      .toLowerCase()
                      .contains(searchQuery.value.toLowerCase()) ||
                  cat.nameEn
                      .toLowerCase()
                      .contains(searchQuery.value.toLowerCase()))
              .toList();

      if (filteredCategories.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              const Text(
                'لا توجد فئات تطابق البحث',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        );
      }

      // استخدام عرض الشبكة للفئات - Adaptively determine crossAxisCount based on screen width
      final crossAxisCount = isVerySmallScreen ? 2 : (isSmallScreen ? 2 : 3);
      final childAspectRatio = isVerySmallScreen ? 0.8 : 0.9;
      final spacing = isVerySmallScreen ? 8.0 : 16.0;

      return Padding(
        padding: EdgeInsets.all(isVerySmallScreen ? 8 : 16),
        child: useAnimations
            ? AnimationLimiter(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: childAspectRatio,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                  ),
                  itemCount: filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = filteredCategories[index];
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      columnCount: crossAxisCount,
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: CategoryCard(
                            category: category,
                            onTap: () {
                              selectedCategory.value = category;
                              categoryController.selectedCategoryId.value =
                                  category.id;
                              showCategoryView.value = false;
                            },
                            cardSize: cardSize,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: childAspectRatio,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                ),
                itemCount: filteredCategories.length,
                itemBuilder: (context, index) {
                  final category = filteredCategories[index];
                  return CategoryCard(
                    category: category,
                    onTap: () {
                      selectedCategory.value = category;
                      categoryController.selectedCategoryId.value = category.id;
                      showCategoryView.value = false;
                    },
                    cardSize: cardSize,
                  );
                },
              ),
      );
    });
  }

  // عرض شاشة المنتجات
  Widget _buildProductsSection(
      String viewMode, bool isSmallScreen, bool isVerySmallScreen) {
    return Obx(() {
      // استخدام الفلترة المتقدمة
      List<Product> filteredProducts = _getFilteredProducts();

      if (filteredProducts.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.no_food, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              const Text(
                'لا توجد منتجات متاحة',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              if (displayMode == 'categories')
                ElevatedButton.icon(
                  icon: const Icon(Icons.category),
                  label: const Text('عودة إلى الفئات'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    showCategoryView.value = true;
                    categoryController.selectedCategoryId.value = '';
                  },
                ),
            ],
          ),
        );
      }

      if (viewMode == 'grid') {
        return _buildGridView(
            filteredProducts, showImages, isSmallScreen, isVerySmallScreen);
      } else if (viewMode == 'list') {
        return _buildListView(filteredProducts, showImages, isVerySmallScreen);
      } else {
        return _buildCompactView(
            filteredProducts, showImages, isVerySmallScreen);
      }
    });
  }

  // عرض المنتجات كشبكة
  Widget _buildGridView(List<Product> products, bool showImages,
      bool isSmallScreen, bool isVerySmallScreen) {
    // الحصول على الأبعاد مباشرة من ViewOptionsHelper
    final isLargeScreenSetting = ViewOptionsHelper.getIsLargeScreen();
    final double cardWidth = ViewOptionsHelper.getProductCardWidth();
    final double cardHeight = ViewOptionsHelper.getProductCardHeight();

    // حساب عدد الأعمدة بناءً على حجم الشاشة الفعلي
    final screenWidth = MediaQuery.of(Get.context!).size.width;
    final crossAxisCount = screenWidth < 480 ? 1 : (screenWidth < 720 ? 2 : 3);

    // حساب النسبة المناسبة استنادًا إلى الأبعاد المخزنة
    final aspectRatio = cardWidth / cardHeight;

    final padding = isVerySmallScreen ? 8.0 : 16.0;
    final spacing = isVerySmallScreen ? 8.0 : 16.0;

    return Padding(
      padding: EdgeInsets.all(padding),
      child: useAnimations
          ? AnimationLimiter(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: aspectRatio,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                ),
                physics:
                    const AlwaysScrollableScrollPhysics(), // Enable scrolling
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    columnCount: crossAxisCount,
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: EnhancedProductCard(
                          product: product,
                          onTap: () => _handleProductTap(product),
                          showDetails: true,
                          heroTag: 'product-${product.id}',
                          onOrderPlaced: (product, quantity) {
                            final OrderController orderController =
                                Get.find<OrderController>();
                            orderController
                                .processOrder(product, quantity)
                                .then((_) {
                              productQuantities[product.id] = quantity;
                            });
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: aspectRatio,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
              ),
              physics:
                  const AlwaysScrollableScrollPhysics(), // Enable scrolling
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return EnhancedProductCard(
                  product: product,
                  onTap: () => _handleProductTap(product),
                  showDetails: true,
                  heroTag: 'product-${product.id}',
                  onOrderPlaced: (product, quantity) {
                    final OrderController orderController =
                        Get.find<OrderController>();
                    orderController.processOrder(product, quantity).then((_) {
                      productQuantities[product.id] = quantity;
                    });
                  },
                );
              },
            ),
    );
  }

  // عرض المنتجات كقائمة
  Widget _buildListView(
      List<Product> products, bool showImages, bool isVerySmallScreen) {
    final padding = isVerySmallScreen ? 8.0 : 16.0;
    final margin = isVerySmallScreen ? 8.0 : 12.0;

    return ListView.builder(
      padding: EdgeInsets.all(padding),
      itemCount: products.length,
      physics: const AlwaysScrollableScrollPhysics(), // Enable scrolling
      itemBuilder: (context, index) {
        final product = products[index];

        final itemWidget = Card(
          margin: EdgeInsets.only(bottom: margin),
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(isVerySmallScreen ? 8.0 : 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showImages && product.imageUrl != null)
                  Container(
                    width: isVerySmallScreen ? 80 * cardSize : 100 * cardSize,
                    height: isVerySmallScreen ? 80 * cardSize : 100 * cardSize,
                    margin: EdgeInsets.only(right: isVerySmallScreen ? 8 : 12),
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isVerySmallScreen ? 16 : 18,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: isVerySmallScreen ? 4 : 6),
                      Text(
                        product.localizedDescription,
                        style: TextStyle(fontSize: isVerySmallScreen ? 12 : 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isVerySmallScreen ? 6 : 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${product.price.toStringAsFixed(3)} د.ب',
                            style: TextStyle(
                              color: priceColor,
                              fontWeight: FontWeight.bold,
                              fontSize: isVerySmallScreen ? 14 : 16,
                            ),
                          ),
                          _buildQuantitySelector(product.id, isVerySmallScreen),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

        return useAnimations
            ? AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: GestureDetector(
                      onTap: () => _showProductDetails(product),
                      child: itemWidget,
                    ),
                  ),
                ),
              )
            : GestureDetector(
                onTap: () => _showProductDetails(product),
                child: itemWidget,
              );
      },
    );
  }

  // عرض المنتجات بطريقة مدمجة
  Widget _buildCompactView(
      List<Product> products, bool showImages, bool isVerySmallScreen) {
    final padding = isVerySmallScreen ? 8.0 : 16.0;
    final margin = isVerySmallScreen ? 6.0 : 8.0;

    return ListView.builder(
      padding: EdgeInsets.all(padding),
      itemCount: products.length,
      physics: const AlwaysScrollableScrollPhysics(), // Enable scrolling
      itemBuilder: (context, index) {
        final product = products[index];

        final itemWidget = Card(
          margin: EdgeInsets.only(bottom: margin),
          child: Padding(
            padding: EdgeInsets.all(isVerySmallScreen ? 8.0 : 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (showImages && product.imageUrl != null)
                  Container(
                    width: isVerySmallScreen ? 50 * cardSize : 60 * cardSize,
                    height: isVerySmallScreen ? 50 * cardSize : 60 * cardSize,
                    margin: EdgeInsets.only(right: isVerySmallScreen ? 8 : 12),
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isVerySmallScreen ? 14 : 16,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: isVerySmallScreen ? 2 : 4),
                      Text(
                        '${product.price.toStringAsFixed(3)} د.ب',
                        style: TextStyle(
                          color: priceColor,
                          fontWeight: FontWeight.bold,
                          fontSize: isVerySmallScreen ? 13 : 14,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildQuantitySelector(product.id, isVerySmallScreen),
              ],
            ),
          ),
        );

        return useAnimations
            ? AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: GestureDetector(
                      onTap: () => _showProductDetails(product),
                      child: itemWidget,
                    ),
                  ),
                ),
              )
            : GestureDetector(
                onTap: () => _showProductDetails(product),
                child: itemWidget,
              );
      },
    );
  }

  // بناء عنصر التحكم بالكمية
  Widget _buildQuantitySelector(String productId, bool isVerySmallScreen) {
    final buttonSize = isVerySmallScreen ? 30.0 : 36.0;
    final iconSize = isVerySmallScreen ? 16.0 : 20.0;
    final counterWidth = isVerySmallScreen ? 32.0 : 40.0;
    final fontSize = isVerySmallScreen ? 14.0 : 16.0;

    return Obx(() => Row(
          children: [
            InkWell(
              onTap: () => decrementQuantity(productId),
              child: Container(
                width: buttonSize,
                height: buttonSize,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.remove,
                  color: AppTheme.primaryColor,
                  size: iconSize,
                ),
              ),
            ),
            Container(
              width: counterWidth,
              height: buttonSize,
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${getQuantity(productId)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
            ),
            InkWell(
              onTap: () => incrementQuantity(productId),
              child: Container(
                width: buttonSize,
                height: buttonSize,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: iconSize,
                ),
              ),
            ),
          ],
        ));
  }

  // عرض تفاصيل المنتج
  void _showProductDetails(Product product) {
    final RxInt quantity = (getQuantity(product.id)).obs;
    final double imageSize = MediaQuery.of(Get.context!).size.width * 0.7;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.imageUrl != null)
                  Center(
                    child: Hero(
                      tag: 'product-${product.id}',
                      child: Container(
                        width: imageSize,
                        height: imageSize * 0.8,
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
                          borderRadius: BorderRadius.circular(12),
                          child: _buildProductImage(product.imageUrl),
                        ),
                      ),
                    ),
                  ),
                Text(
                  product.localizedName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
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
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: priceColor,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
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
                        // حفظ الكمية المحددة
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                      ),
                      child: const Text('إضافة للطلب'),
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

  // التعامل مع الضغط على المنتج
  void _handleProductTap(Product product) {
    // استدعاء دالة عرض تفاصيل المنتج الموجودة بالفعل
    _showProductDetails(product);
  }

  // عرض مربع حوار البحث
  void _showSearchDialog(BuildContext context) {
    final searchController = TextEditingController(text: searchQuery.value);

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
            searchQuery.value = value;
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
              searchQuery.value = searchController.text;
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

  // عرض مربع حوار خيارات العرض
  void _showViewOptionsDialog(BuildContext context) {
    final RxString viewMode = ViewOptionsHelper.getViewMode().obs;
    final RxBool showImages = ViewOptionsHelper.getShowImages().obs;

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
            const Divider(),
            const Text(
              'لتخصيص العرض بشكل أكبر، يرجى الانتقال إلى صفحة خيارات العرض في الشاشة الرئيسية.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
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
              ViewOptionsHelper.saveViewMode(viewMode.value);
              ViewOptionsHelper.saveShowImages(showImages.value);
              Get.back();
              Get.offAll(() => MenuScreen());

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

  // تطبيق الفلترة المتقدمة
  List<Product> _getFilteredProducts() {
    List<Product> filtered = List.from(productController.products);

    // تطبيق فلتر الفئة المحددة من شريط التصفية
    if (categoryController.selectedCategoryId.value.isNotEmpty) {
      filtered = filtered
          .where((p) =>
              p.categoryId == categoryController.selectedCategoryId.value)
          .toList();
    }

    // تطبيق فلتر الفئات المتعددة إذا كانت محددة
    if (selectedCategoryFilters.isNotEmpty) {
      filtered = filtered
          .where((p) => selectedCategoryFilters.contains(p.categoryId))
          .toList();
    }

    // تطبيق فلتر البحث
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered
          .where((p) =>
              p.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
              p.description
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    // تطبيق فلتر نطاق السعر
    filtered = filtered
        .where((p) =>
            p.price >= priceFilterMin.value && p.price <= priceFilterMax.value)
        .toList();

    // تطبيق فلتر التوفر
    if (showOnlyAvailable.value) {
      filtered = filtered.where((p) => p.isAvailable).toList();
    }

    return filtered;
  }

  // داخل كلاس MenuScreen، أضف هذه الدالة

  void _showAdvancedFilterDialog(BuildContext context) {
    // نسخ قيم الفلترة الحالية إلى متغيرات مؤقتة
    RxSet<String> tempCategoryFilters = RxSet<String>();
    tempCategoryFilters.addAll(selectedCategoryFilters);

    RxDouble tempMinPrice = RxDouble(priceFilterMin.value);
    RxDouble tempMaxPrice = RxDouble(priceFilterMax.value);
    RxBool tempShowOnlyAvailable = RxBool(showOnlyAvailable.value);

    Get.dialog(
      AlertDialog(
        title: const Text('فلترة متقدمة'),
        content: Container(
          width: double.maxFinite,
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
                  child: Obx(() => ListView.builder(
                        itemCount: categoryController.categories.length,
                        itemBuilder: (context, index) {
                          final category = categoryController.categories[index];
                          return CheckboxListTile(
                            title: Text(category.name),
                            subtitle: Text(
                              '${productController.products.where((p) => p.categoryId == category.id).length} منتج',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600]),
                            ),
                            value: tempCategoryFilters.contains(category.id),
                            activeColor: AppTheme.primaryColor,
                            onChanged: (bool? value) {
                              if (value == true) {
                                tempCategoryFilters.add(category.id);
                              } else {
                                tempCategoryFilters.remove(category.id);
                              }
                            },
                          );
                        },
                      )),
                ),

                const SizedBox(height: 20),
                // قسم فلترة نطاق السعر
                const Text(
                  'تصفية حسب نطاق السعر:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Obx(() => RangeSlider(
                      values:
                          RangeValues(tempMinPrice.value, tempMaxPrice.value),
                      min: 0,
                      max: 100,
                      divisions: 100,
                      labels: RangeLabels(
                        tempMinPrice.value.toStringAsFixed(1),
                        tempMaxPrice.value.toStringAsFixed(1),
                      ),
                      onChanged: (RangeValues values) {
                        tempMinPrice.value = values.start;
                        tempMaxPrice.value = values.end;
                      },
                      activeColor: AppTheme.primaryColor,
                    )),
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${tempMinPrice.value.toStringAsFixed(1)} د.ب'),
                        Text('${tempMaxPrice.value.toStringAsFixed(1)} د.ب'),
                      ],
                    )),

                const SizedBox(height: 20),
                // قسم فلترة التوفر
                Obx(() => SwitchListTile(
                      title: const Text('عرض المنتجات المتاحة فقط'),
                      value: tempShowOnlyAvailable.value,
                      activeColor: AppTheme.primaryColor,
                      onChanged: (bool value) {
                        tempShowOnlyAvailable.value = value;
                      },
                    )),
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
              // إعادة تعيين الفلاتر
              tempCategoryFilters.clear();
              tempMinPrice.value = 0;
              tempMaxPrice.value = 100;
              tempShowOnlyAvailable.value = false;
            },
            child: const Text('إعادة تعيين'),
          ),
          ElevatedButton(
            onPressed: () {
              // تطبيق الفلاتر
              selectedCategoryFilters.value = tempCategoryFilters;
              priceFilterMin.value = tempMinPrice.value;
              priceFilterMax.value = tempMaxPrice.value;
              showOnlyAvailable.value = tempShowOnlyAvailable.value;
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('تطبيق'),
          ),
        ],
      ),
    );
  }
}
