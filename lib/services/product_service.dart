import 'package:gpr_coffee_shop/models/product.dart';
import 'package:gpr_coffee_shop/services/local_storage_service.dart';
import 'package:gpr_coffee_shop/utils/logger_util.dart';
import 'package:gpr_coffee_shop/data/menu_data.dart'; // إضافة استيراد ملف menu_data

class ProductService {
  final LocalStorageService _storage;
  // صورة افتراضية للمنتجات
  static const placeholderImage = 'assets/images/placeholder.png';

  ProductService(this._storage);

  Future<List<Product>> getProducts() async {
    return await _storage.getProducts();
  }

  Future<void> saveProduct(Product product) async {
    await _storage.saveProduct(product);
  }

  Future<void> deleteProduct(String productId) async {
    await _storage.deleteProduct(productId);
  }

  /// Updates products by removing items without images and adding new predefined products
  Future<void> updateProductsWithNewData() async {
    try {
      // Get existing products
      final products = await _storage.getProducts();

      // Filter out products with missing images
      final productsToDelete = products
          .where((product) =>
              product.imageUrl == null || product.imageUrl!.isEmpty)
          .map((product) => product.id)
          .toList();

      // Delete products with missing images
      if (productsToDelete.isNotEmpty) {
        await _storage.deleteMultipleProducts(productsToDelete);
      }

      // Define new products with complete data
      final newProducts = [
        Product(
          id: '${DateTime.now().millisecondsSinceEpoch}1',
          name: 'قهوة لاتيه',
          description: 'قهوة لاتيه كريمية',
          price: 12,
          imageUrl: 'assets/images/JBRC3.png',
          categoryId: '1',
          isAvailable: true,
          cost: 7,
          options: [],
          order: 1,
          isPopular: true,
        ),
        Product(
          id: '${DateTime.now().millisecondsSinceEpoch}2',
          name: 'كيك شوكولاتة',
          description: 'كيك شوكولاتة بالكريمة',
          price: 15,
          imageUrl: 'assets/images/JBRC2.png',
          categoryId: '3',
          isAvailable: true,
          cost: 8,
          options: [],
          order: 4,
          isPopular: false,
        ),
      ];

      // Save the new products
      for (final product in newProducts) {
        await _storage.saveProduct(product);
      }

      LoggerUtil.logger.i('تم تحديث المنتجات بنجاح');
    } catch (e) {
      LoggerUtil.logger.e('خطأ أثناء تحديث المنتجات: $e');
      rethrow;
    }
  }

  /// Reset products to default catalog from menu_data.dart
  Future<void> resetProductsToDefault() async {
    try {
      // Get existing products
      final products = await _storage.getProducts();

      // Delete all existing products
      if (products.isNotEmpty) {
        final productIds = products.map((p) => p.id).toList();
        await _storage.deleteMultipleProducts(productIds);
      }

      // استخدام المنتجات من ملف menu_data.dart
      final defaultProducts = MenuData.getProducts();

      // Save the default products
      for (final product in defaultProducts) {
        await _storage.saveProduct(product);
      }

      LoggerUtil.logger.i('تم إعادة ضبط المنتجات إلى القائمة الأساسية من menu_data.dart');
    } catch (e) {
      LoggerUtil.logger.e('خطأ أثناء إعادة ضبط المنتجات: $e');
      rethrow;
    }
  }
}
