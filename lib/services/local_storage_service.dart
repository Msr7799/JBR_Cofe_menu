import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:gpr_coffee_shop/models/product.dart';
import 'package:gpr_coffee_shop/models/app_settings.dart';
import 'package:gpr_coffee_shop/models/category.dart';
import 'package:gpr_coffee_shop/models/order.dart';
import 'package:gpr_coffee_shop/utils/logger_util.dart';

class LocalStorageService extends GetxService {
  static const String PRODUCTS_BOX = 'products_box';
  static const String CATEGORIES_BOX = 'categories_box';
  static const String ORDERS_BOX = 'orders_box';
  static const String SETTINGS_BOX = 'settings_box';

  late Box _productsBox;
  late Box _categoriesBox;
  late Box _ordersBox;
  late Box _settingsBox;

  Future<LocalStorageService> init() async {
    try {
      // تهيئة Hive
      await Hive.initFlutter();

      // فتح صناديق التخزين
      _productsBox = await Hive.openBox(PRODUCTS_BOX);
      _categoriesBox = await Hive.openBox(CATEGORIES_BOX);
      _ordersBox = await Hive.openBox(ORDERS_BOX);
      _settingsBox = await Hive.openBox(SETTINGS_BOX);

      LoggerUtil.logger.i('تم تهيئة خدمة التخزين المحلي بنجاح');
      return this;
    } catch (e) {
      LoggerUtil.logger.e('خطأ في تهيئة خدمة التخزين المحلي: $e');

      // محاولة إعادة تشغيل Hive في حالة الخطأ
      try {
        await Hive.deleteFromDisk();
        await Future.delayed(const Duration(milliseconds: 500));
        await Hive.initFlutter();

        _productsBox = await Hive.openBox(PRODUCTS_BOX);
        _categoriesBox = await Hive.openBox(CATEGORIES_BOX);
        _ordersBox = await Hive.openBox(ORDERS_BOX);
        _settingsBox = await Hive.openBox(SETTINGS_BOX);

        LoggerUtil.logger
            .i('تم إعادة تهيئة خدمة التخزين المحلي بنجاح بعد المشكلة');
        return this;
      } catch (e2) {
        LoggerUtil.logger.e('فشل في إعادة تهيئة خدمة التخزين المحلي: $e2');
        rethrow;
      }
    }
  }

  // دوال المنتجات
  Future<List<Product>> getProducts() async {
    try {
      final productMaps = _productsBox.values.toList();
      final products = <Product>[];

      for (var item in productMaps) {
        if (item is Map) {
          try {
            products.add(Product.fromJson(Map<String, dynamic>.from(item)));
          } catch (e) {
            LoggerUtil.logger.e('خطأ في تحليل المنتج: $e');
          }
        }
      }

      return products;
    } catch (e) {
      LoggerUtil.logger.e('خطأ في الحصول على المنتجات: $e');
      return [];
    }
  }

  // دالة جديدة للحصول على البيانات الخام للمنتجات
  Future<List> getProductsRaw() async {
    try {
      return _productsBox.values.toList();
    } catch (e) {
      LoggerUtil.logger.e('خطأ في الحصول على البيانات الخام للمنتجات: $e');
      return [];
    }
  }

  // دالة جديدة للحصول على المنتجات بالصفحات
  Future<List<Product>> getProductsPaginated(int page, int pageSize) async {
    try {
      final productMaps = _productsBox.values.toList();
      final products = <Product>[];

      final startIndex = page * pageSize;
      final endIndex = startIndex + pageSize < productMaps.length
          ? startIndex + pageSize
          : productMaps.length;

      if (startIndex >= productMaps.length) {
        return [];
      }

      for (int i = startIndex; i < endIndex; i++) {
        var item = productMaps[i];
        if (item is Map) {
          try {
            products.add(Product.fromJson(Map<String, dynamic>.from(item)));
          } catch (e) {
            LoggerUtil.logger.e('خطأ في تحليل المنتج: $e');
          }
        }
      }

      return products;
    } catch (e) {
      LoggerUtil.logger.e('خطأ في الحصول على المنتجات المقسمة: $e');
      return [];
    }
  }

  Future<void> saveProduct(Product product) async {
    try {
      await _productsBox.put(product.id, product.toJson());
      LoggerUtil.logger.i('تم حفظ المنتج: ${product.name}');
    } catch (e) {
      LoggerUtil.logger.e('خطأ في حفظ المنتج: $e');
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _productsBox.delete(id);
      LoggerUtil.logger.i('تم حذف المنتج بمعرف: $id');
    } catch (e) {
      LoggerUtil.logger.e('خطأ في حذف المنتج: $e');
      rethrow;
    }
  }

  // دوال الفئات
  Future<List<Category>> getCategories() async {
    try {
      final categoryMaps = _categoriesBox.values.toList();
      final categories = <Category>[];

      for (var item in categoryMaps) {
        if (item is Map) {
          try {
            categories.add(Category.fromJson(Map<String, dynamic>.from(item)));
          } catch (e) {
            LoggerUtil.logger.e('خطأ في تحليل الفئة: $e');
          }
        }
      }

      return categories;
    } catch (e) {
      LoggerUtil.logger.e('خطأ في الحصول على الفئات: $e');
      return [];
    }
  }

  Future<void> saveCategory(Category category) async {
    try {
      await _categoriesBox.put(category.id, category.toJson());
      LoggerUtil.logger.i('تم حفظ الفئة: ${category.name}');
    } catch (e) {
      LoggerUtil.logger.e('خطأ في حفظ الفئة: $e');
      rethrow;
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      await _categoriesBox.delete(id);
      LoggerUtil.logger.i('تم حذف الفئة بمعرف: $id');
    } catch (e) {
      LoggerUtil.logger.e('خطأ في حذف الفئة: $e');
      rethrow;
    }
  }

  Future<void> clearCategories() async {
    try {
      final box = await Hive.openBox(CATEGORIES_BOX);
      await box.clear();
      LoggerUtil.logger.i('تم حذف جميع الفئات');
    } catch (e) {
      LoggerUtil.logger.e('خطأ في حذف الفئات: $e');
      rethrow;
    }
  }

  // دوال الطلبات
  Future<List<Order>> getOrders() async {
    try {
      final orderMaps = _ordersBox.values.toList();
      final orders = <Order>[];

      for (var item in orderMaps) {
        if (item is Map) {
          try {
            // Make sure we're working with a properly typed Map
            Map<String, dynamic> orderMap = _convertToStringKeyMap(item);

            // Check if the order items are properly formatted
            if (orderMap.containsKey('items') && orderMap['items'] is List) {
              List<dynamic> rawItems = orderMap['items'];
              List<Map<String, dynamic>> processedItems = [];

              // Convert each item to the proper format
              for (var orderItem in rawItems) {
                if (orderItem is Map) {
                  processedItems.add(_convertToStringKeyMap(orderItem));
                }
              }

              // Update the order map with properly formatted items
              orderMap['items'] = processedItems;
            }

            // Now create the Order object from the properly formatted map
            orders.add(Order.fromJson(orderMap));
          } catch (e) {
            LoggerUtil.logger.e('خطأ في تحليل الطلب: $e');
          }
        }
      }

      return orders;
    } catch (e) {
      LoggerUtil.logger.e('خطأ في الحصول على الطلبات: $e');
      return [];
    }
  }

  Future<void> saveOrder(Order order) async {
    try {
      await _ordersBox.put(order.id, order.toJson());
      LoggerUtil.logger.i('تم حفظ الطلب بمعرف: ${order.id}');
    } catch (e) {
      LoggerUtil.logger.e('خطأ في حفظ الطلب: $e');
      rethrow;
    }
  }

  Future<void> deleteOrder(String id) async {
    try {
      await _ordersBox.delete(id);
      LoggerUtil.logger.i('تم حذف الطلب بمعرف: $id');
    } catch (e) {
      LoggerUtil.logger.e('خطأ في حذف الطلب: $e');
      rethrow;
    }
  }

  // دوال الإعدادات
  Future<AppSettings?> getSettings() async {
    try {
      final box = await Hive.openBox(SETTINGS_BOX);
      if (box.isEmpty) {
        return null;
      }

      // استخراج البيانات الخام من Hive
      final rawData = box.get('app_settings');
      if (rawData == null) {
        return null;
      }

      // تحويل البيانات يدويًا بشكل متعمق
      if (rawData is Map) {
        final Map<String, dynamic> safeMap = _convertToStringKeyMap(rawData);
        return AppSettings.fromJson(safeMap);
      }

      LoggerUtil.logger.e('بيانات الإعدادات في تنسيق غير متوقع');
      return null;
    } catch (e) {
      LoggerUtil.logger.e('خطأ في الحصول على الإعدادات: $e');
      return null;
    }
  }

  // إضافة دالة جديدة للتحويل المتعمق
  Map<String, dynamic> _convertToStringKeyMap(Map map) {
    Map<String, dynamic> result = {};

    map.forEach((key, value) {
      String stringKey = key is String ? key : key.toString();

      if (value is Map) {
        result[stringKey] = _convertToStringKeyMap(value);
      } else if (value is List) {
        result[stringKey] = _convertList(value);
      } else {
        result[stringKey] = value;
      }
    });

    return result;
  }

  // دالة مساعدة لتحويل عناصر القائمة
  List _convertList(List list) {
    List result = [];

    for (var item in list) {
      if (item is Map) {
        result.add(_convertToStringKeyMap(item));
      } else if (item is List) {
        result.add(_convertList(item));
      } else {
        result.add(item);
      }
    }

    return result;
  }

  Future<void> saveSettings(AppSettings settings) async {
    try {
      final box = await Hive.openBox(SETTINGS_BOX);

      // تحويل إلى Map بشكل صريح
      final settingsMap = settings.toJson();

      // حفظ البيانات
      await box.put('app_settings', settingsMap);
      LoggerUtil.logger.i('تم حفظ الإعدادات بنجاح');
    } catch (e) {
      LoggerUtil.logger.e('خطأ في حفظ الإعدادات: $e');
      throw e; // إعادة إرسال الخطأ للمعالجة في المستوى الأعلى
    }
  }

  // حذف جميع البيانات
  Future<void> clearAllData() async {
    try {
      await _productsBox.clear();
      await _categoriesBox.clear();
      await _ordersBox.clear();
      await _settingsBox.clear();
      LoggerUtil.logger.i('تم حذف جميع البيانات');
    } catch (e) {
      LoggerUtil.logger.e('خطأ في حذف البيانات: $e');
      rethrow;
    }
  }

  // إغلاق جميع الصناديق
  Future<void> closeBoxes() async {
    try {
      await _productsBox.close();
      await _categoriesBox.close();
      await _ordersBox.close();
      await _settingsBox.close();
      LoggerUtil.logger.i('تم إغلاق جميع صناديق التخزين');
    } catch (e) {
      LoggerUtil.logger.e('خطأ في إغلاق صناديق التخزين: $e');
    }
  }

  read(String s) {}

  void write(String s, bool value) {}
}
