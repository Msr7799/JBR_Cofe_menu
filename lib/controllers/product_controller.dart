import 'package:get/get.dart';
import 'package:gpr_coffee_shop/models/product.dart';
import 'package:gpr_coffee_shop/services/local_storage_service.dart';

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

  Future<void> fetchAllProducts() async {
    await loadProducts();
  }

  Future<void> loadProducts() async {
    isLoading.value = true;
    try {
      final loadedProducts = await _storage.getProducts();
      products.assignAll(loadedProducts);

      if (products.isEmpty) {
        await _addSampleProducts();
      }
    } catch (e) {
      print('Error loading products: $e');
      await _addSampleProducts();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addProduct(Product product) async {
    await saveProduct(product);
  }

  Future<void> updateProduct(Product product) async {
    await saveProduct(product);
  }

  Future<void> saveProduct(Product product) async {
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
      Get.snackbar(
        'نجاح',
        'تم حفظ المنتج بنجاح',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error saving product: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء حفظ المنتج',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      isLoading.value = true;
      await _storage.deleteProduct(id);
      products.removeWhere((product) => product.id == id);
      allProducts.removeWhere((product) => product.id == id);
      Get.snackbar(
        'نجاح',
        'تم حذف المنتج بنجاح',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error deleting product: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء حذف المنتج',
        snackPosition: SnackPosition.BOTTOM,
      );
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
    // TODO: Implement actual sales data tracking
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
        imageUrl: 'assets/images/placeholder.png',
        categoryId: '1',
        isAvailable: true,
        cost: 8,
        options: [],
      ),
      Product(
        id: '2',
        name: 'كابتشينو',
        description: 'كابتشينو كريمي مع رغوة الحليب',
        price: 12,
        imageUrl: 'assets/images/placeholder.png',
        categoryId: '1',
        isAvailable: true,
        cost: 9,
        options: [],
      ),
      Product(
        id: '3',
        name: 'آيس لاتيه',
        description: 'لاتيه بارد منعش',
        price: 15,
        imageUrl: 'assets/images/placeholder.png',
        categoryId: '2',
        isAvailable: true,
        cost: 11,
        options: [],
      ),
      Product(
        id: '4',
        name: 'كيك الشوكولاتة',
        description: 'كيك الشوكولاتة الطرية',
        price: 18,
        imageUrl: 'assets/images/placeholder.png',
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
}

class ProductSalesData {
  final String productName;
  final int salesCount;

  ProductSalesData({
    required this.productName,
    required this.salesCount,
  });
}
