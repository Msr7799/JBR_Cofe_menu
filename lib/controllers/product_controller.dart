import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/models/product.dart';
// import 'package:gpr_coffee_shop/models/category.dart'; // Add this import for Category class
import 'package:gpr_coffee_shop/services/local_storage_service.dart';
import 'package:gpr_coffee_shop/services/product_service.dart'; // Add this import for ProductService
// import 'package:uuid/uuid.dart';
import 'package:gpr_coffee_shop/utils/logger_util.dart';


class ProductController extends GetxController {
  final LocalStorageService _storage;

  // State variables
  final products = <Product>[].obs;
  final isLoading = RxBool(false);
  final RxList<Product> allProducts = <Product>[].obs;
  final selectedProduct = Rxn<Product>();

  ProductController(this._storage);

  @override
  void onInit() {
    super.onInit();
    fetchAllProducts();
  }

  Future<bool> fetchAllProducts() async {
    try {
      isLoading.value = true;
      final success = await loadProducts();
      if (success) {
        // Sort both lists after loading
        final sortedProducts = List<Product>.from(products)
          ..sort((a, b) {
            int categoryComparison = a.categoryId.compareTo(b.categoryId);
            if (categoryComparison != 0) return categoryComparison;
            return a.name.compareTo(b.name);
          });

        products.assignAll(sortedProducts);
        allProducts.assignAll(sortedProducts);
        products.refresh();
        allProducts.refresh();
      }
      return success;
    } catch (e) {
      LoggerUtil.logger.e('Error fetching products: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تحميل المنتجات',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> loadProducts() async {
    isLoading.value = true;
    try {
      final loadedProducts = await _storage.getProducts();
      products.assignAll(loadedProducts);
      allProducts.assignAll(loadedProducts);

      if (products.isEmpty) {
        await _addSampleProducts();
      }

      // Sort products by category and name
      products.sort((a, b) {
        int categoryComparison = a.categoryId.compareTo(b.categoryId);
        if (categoryComparison != 0) return categoryComparison;
        return a.name.compareTo(b.name);
      });

      products.refresh();
      allProducts.refresh();
      return true;
    } catch (e) {
      LoggerUtil.logger.e('Error loading products: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تحميل المنتجات',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      await _addSampleProducts();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addProduct(Product product) async {
    try {
      isLoading.value = true;
      await _storage.saveProduct(product);
      products.add(product);
      allProducts.add(product);
      products.refresh();
      allProducts.refresh();
      Get.snackbar(
        'نجاح',
        'تم إضافة المنتج بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return true;
    } catch (e) {
      LoggerUtil.logger.e('Error saving product: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء حفظ المنتج',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    return await saveProduct(product);
  }

  Future<bool> saveProduct(Product product) async {
    try {
      isLoading.value = true;
      await _storage.saveProduct(product);
      final index = products.indexWhere((p) => p.id == product.id);
      if (index == -1) {
        products.add(product);
        allProducts.add(product);
      } else {
        products[index] = product;
        allProducts[index] = product;
      }
      products.refresh();
      allProducts.refresh();
      Get.snackbar(
        'نجاح',
        'تم تحديث المنتج بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return true;
    } catch (e) {
      LoggerUtil.logger.e('Error saving product: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء حفظ المنتج',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteProduct(String id) async {
    try {
      isLoading.value = true;
      await _storage.deleteProduct(id);
      products.removeWhere((product) => product.id == id);
      allProducts.removeWhere((product) => product.id == id);
      products.refresh();
      allProducts.refresh();
      Get.snackbar(
        'نجاح',
        'تم حذف المنتج بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return true;
    } catch (e) {
      LoggerUtil.logger.e('Error deleting product: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء حذف المنتج',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  List<Product> getProductsByCategory(String categoryId) {
    return allProducts
        .where((product) => product.categoryId == categoryId)
        .toList();
  }

  List<ProductSalesData> getTopProducts({int limit = 5}) {
    // For now, return mock data for demonstration
    return allProducts.take(limit).map((product) {
      return ProductSalesData(
        productName: product.name,
        salesCount: (product.price * 10).toInt(), // Mock sales count
      );
    }).toList();
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      products.value = allProducts;
    } else {
      products.value = allProducts
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()) ||
              product.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void sortProducts({required String field, bool ascending = true}) {
    products.sort((a, b) {
      switch (field) {
        case 'name':
          return ascending
              ? a.name.compareTo(b.name)
              : b.name.compareTo(a.name);
        case 'price':
          return ascending
              ? a.price.compareTo(b.price)
              : b.price.compareTo(a.price);
        default:
          return 0;
      }
    });
  }

  Product? getProductById(String id) {
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  void selectProduct(Product product) {
    selectedProduct.value = product;
  }

  void clearSelectedProduct() {
    selectedProduct.value = null;
  }

  Future<void> _addSampleProducts() async {
    final sampleProducts = [
      Product(
        id: '1',
        name: 'قهوة أمريكية',
        description: 'قهوة أمريكية منعشة',
        price: 10,
        imageUrl: 'assets/images/JBRH3.png',
        categoryId: '1',
        isAvailable: true,
        cost: 8,
        options: [],
      ),
      Product(
        id: '2',
        name: "موهيتو بلو",
        description: 'موهيتو منعش أزرق',
        price: 12,
        imageUrl: 'assets/images/JBRD2.png',
        categoryId: '1',
        isAvailable: true,
        cost: 9,
        options: [],
      ),
      Product(
        id: '4',
        name: 'كيك الفراولة',
        description: 'كيك الفراوله الطرية',
        price: 18,
        imageUrl: 'assets/images/JBRC1.png',
        categoryId: '3',
        isAvailable: true,
        cost: 12,
        options: [],
      ),
    ];

    for (var product in sampleProducts) {
      await _storage.saveProduct(product);
    }

    products.assignAll(sampleProducts);
    allProducts.assignAll(sampleProducts);
  }

  /// Updates products by removing items without images and adding new predefined products
  Future<void> updateProductsWithNewData() async {
    try {
      isLoading.value = true;

      // Create a ProductService instance to handle the update
      final productService = ProductService(_storage);

      // Call the service method to update products
      await productService.updateProductsWithNewData();

      // Reload products after update
      await fetchAllProducts();

      Get.snackbar(
        'تم التحديث',
        'تم تحديث المنتجات بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      LoggerUtil.logger.e('خطأ أثناء تحديث المنتجات: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تحديث المنتجات',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

class ProductSalesData {
  final String productName;
  final int salesCount;

  ProductSalesData({
    required this.productName,
    required this.salesCount,
  });
}
