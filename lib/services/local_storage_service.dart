import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:gpr_coffee_shop/models/product.dart';
import 'package:gpr_coffee_shop/models/category.dart';
import 'package:gpr_coffee_shop/models/order.dart';
import 'package:gpr_coffee_shop/models/app_settings.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorageService {
  static const String productsBox = 'products';
  static const String categoriesBox = 'categories';
  static const String ordersBox = 'orders';
  static const String settingsBox = 'settings';

  // تهيئة التخزين المحلي
  Future<void> init() async {
    // تهيئة Hive
    await Hive.initFlutter();

    // تسجيل المحولات بطريقة آمنة، نتحقق أولاً إذا كان المحول مسجلاً
    final registeredAdapters = <int>[];

    void registerAdapterSafely(int typeId, TypeAdapter adapter) {
      if (!registeredAdapters.contains(typeId) &&
          !Hive.isAdapterRegistered(typeId)) {
        Hive.registerAdapter(adapter);
        registeredAdapters.add(typeId);
      }
    }

    try {
      // تسجيل المحولات
      registerAdapterSafely(0, ProductAdapter());
      registerAdapterSafely(1, CategoryAdapter());
      registerAdapterSafely(2, OrderAdapter());
      registerAdapterSafely(3, OrderItemAdapter());
      registerAdapterSafely(4, OrderStatusAdapter());
      registerAdapterSafely(5, PaymentTypeAdapter());
      registerAdapterSafely(6, AppSettingsAdapter());
      registerAdapterSafely(7, SocialMediaAccountAdapter());
    } catch (e) {
      print('خطأ عند تسجيل المحولات: $e');
    }

    // فتح الصناديق
    await Future.wait([
      Hive.openBox<Product>(productsBox),
      Hive.openBox<Category>(categoriesBox),
      Hive.openBox<Order>(ordersBox),
      Hive.openBox<AppSettings>(settingsBox),
    ]);
  }

  // المنتجات
  Future<List<Product>> getProducts() async {
    final box = Hive.box<Product>(productsBox);
    return box.values.toList();
  }

  Future<Product?> getProductById(String id) async {
    final box = Hive.box<Product>(productsBox);
    return box.get(id);
  }

  Future<void> saveProduct(Product product) async {
    final box = Hive.box<Product>(productsBox);
    await box.put(product.id, product);
  }

  Future<void> deleteProduct(String id) async {
    final box = Hive.box<Product>(productsBox);
    await box.delete(id);
  }

  // الفئات
  Future<List<Category>> getCategories() async {
    final box = Hive.box<Category>(categoriesBox);
    return box.values.toList();
  }

  Future<Category?> getCategoryById(String id) async {
    final box = Hive.box<Category>(categoriesBox);
    return box.get(id);
  }

  Future<void> saveCategory(Category category) async {
    final box = Hive.box<Category>(categoriesBox);
    await box.put(category.id, category);
  }

  Future<void> deleteCategory(String id) async {
    final box = Hive.box<Category>(categoriesBox);
    await box.delete(id);
  }

  // الطلبات
  Future<List<Order>> getOrders() async {
    final box = Hive.box<Order>(ordersBox);
    return box.values.toList();
  }

  Future<Order?> getOrderById(String id) async {
    final box = Hive.box<Order>(ordersBox);
    return box.get(id);
  }

  Future<void> saveOrder(Order order) async {
    final box = Hive.box<Order>(ordersBox);
    await box.put(order.id, order);
  }

  Future<void> deleteOrder(String id) async {
    final box = Hive.box<Order>(ordersBox);
    await box.delete(id);
  }

  // الإعدادات
  Future<AppSettings?> getSettings() async {
    final box = Hive.box<AppSettings>(settingsBox);
    return box.get('settings');
  }

  Future<void> saveSettings(AppSettings settings) async {
    final box = Hive.box<AppSettings>(settingsBox);
    await box.put('settings', settings);
  }

  // حذف جميع البيانات
  Future<void> clearAllData() async {
    await Future.wait([
      Hive.box<Product>(productsBox).clear(),
      Hive.box<Category>(categoriesBox).clear(),
      Hive.box<Order>(ordersBox).clear(),
      Hive.box<AppSettings>(settingsBox).clear(),
    ]);
  }

  // إغلاق الصناديق
  Future<void> closeBoxes() async {
    await Hive.close();
  }
}

// Singleton instance
final localStorageService = LocalStorageService();
