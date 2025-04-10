import 'package:gpr_coffee_shop/models/product.dart';
import 'package:gpr_coffee_shop/services/local_storage_service.dart';
import 'package:gpr_coffee_shop/utils/logger_util.dart';
import 'package:uuid/uuid.dart';
import 'package:gpr_coffee_shop/data/menu_data.dart';

class ProductService {
  final LocalStorageService _storage;

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

  Future<void> updateProductsWithNewData() async {
    try {
      // Get existing products
      final existingProducts = await _storage.getProducts();

      // Remove products without images
      for (var product in existingProducts) {
        if (product.imageUrl == null || product.imageUrl!.isEmpty) {
          await _storage.deleteProduct(product.id);
          LoggerUtil.logger.i('Removed product without image: ${product.name}');
        }
      }

      // Add all the menu products
      final newProducts = MenuData.getProducts();

      // Check if each product already exists by ID
      for (var product in newProducts) {
        final exists = existingProducts.any((p) => p.name == product.name);
        if (!exists) {
          await _storage.saveProduct(product);
          LoggerUtil.logger.i('Added new product: ${product.name}');
        }
      }

      LoggerUtil.logger.i('Products update completed successfully');
    } catch (e) {
      LoggerUtil.logger.e('Error updating products with new data: $e');
      throw Exception('Failed to update products: $e');
    }
  }

  // This method is now simplified since we get products from MenuData
  List<Product> _getPredefinedProducts() {
    return MenuData.getProducts();
  }
}
