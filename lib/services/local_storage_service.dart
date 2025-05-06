import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:gpr_coffee_shop/models/product.dart';
import 'package:gpr_coffee_shop/models/app_settings.dart';
import 'package:gpr_coffee_shop/models/category.dart';
import 'package:gpr_coffee_shop/models/order.dart';
import 'package:gpr_coffee_shop/utils/logger_util.dart';
import 'package:logger/logger.dart';

class LocalStorageService extends GetxService {
  static const String PRODUCTS_BOX = 'products_box';
  static const String CATEGORIES_BOX = 'categories_box';
  static const String ORDERS_BOX = 'orders_box';
  static const String SETTINGS_BOX = 'settings_box';
  static const String CART_BOX = 'cart_box'; // Added cart box constant

  late Box _productsBox;
  late Box _categoriesBox;
  late Box _ordersBox;
  late Box _settingsBox;
  late Box _cartBox; // Added cart box

  Future<LocalStorageService> init() async {
    try {
      // تهيئة Hive
      await Hive.initFlutter();

      // فتح صناديق التخزين
      _productsBox = await Hive.openBox(PRODUCTS_BOX);
      _categoriesBox = await Hive.openBox(CATEGORIES_BOX);
      _ordersBox = await Hive.openBox(ORDERS_BOX);
      _settingsBox = await Hive.openBox(SETTINGS_BOX);
      _cartBox = await Hive.openBox(CART_BOX); // Open cart box

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
        _cartBox = await Hive.openBox(CART_BOX); // Open cart box in retry

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

  // أضف هذه الدالة جديدة إلى LocalStorageService
  Future<bool> deleteMultipleProducts(List<String> productIds) async {
    if (productIds.isEmpty) return true;

    try {
      // لا حاجة لفتح صندوق جديد - استخدام _productsBox الموجود مسبقًا
      for (final id in productIds) {
        await _productsBox.delete(id);
      }

      // تصحيح: استخدام LoggerUtil.logger بدلاً من logger
      LoggerUtil.logger.i('تم حذف ${productIds.length} منتجات دفعة واحدة');

      return true;
    } catch (e) {
      // تصحيح: استخدام LoggerUtil.logger بدلاً من logger
      LoggerUtil.logger.e('حدث خطأ أثناء حذف المنتجات المتعددة: $e');
      return false;
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
            // تحويل البيانات الخام إلى Map<String, dynamic>
            Map<String, dynamic> orderMap = _convertToStringKeyMap(item);
            
            // معالجة عناصر الطلب بشكل صحيح
            if (orderMap.containsKey('items') && orderMap['items'] is List) {
              List itemsList = orderMap['items'] as List;
              List<OrderItem> orderItems = [];
              
              // تحويل كل عنصر في الطلب
              for (var itemData in itemsList) {
                if (itemData is Map) {
                  Map<String, dynamic> itemMap = _convertToStringKeyMap(itemData);
                  
                  orderItems.add(OrderItem(
                    productId: itemMap['productId'] as String,
                    name: itemMap['name'] as String? ?? "منتج غير معروف",
                    price: (itemMap['price'] as num?)?.toDouble() ?? 0.0,
                    cost: (itemMap['cost'] as num?)?.toDouble() ?? 0.0,
                    quantity: (itemMap['quantity'] as num?)?.toInt() ?? 1,
                    notes: itemMap['notes'] as String?,
                  ));
                }
              }
              
              // استبدال البيانات الخام بالعناصر المحولة
              orderMap['items'] = orderItems;
            } else {
              // في حالة عدم وجود عناصر، نضع قائمة فارغة
              orderMap['items'] = <OrderItem>[];
            }
            
            // إنشاء كائن Order من البيانات المعالجة
            orders.add(Order(
              id: orderMap['id'] as String,
              items: (orderMap['items'] as List<OrderItem>),
              status: OrderStatus.values[orderMap['status'] as int],
              createdAt: DateTime.parse(orderMap['createdAt'] as String),
              customerId: orderMap['customerId'] as String,
              customerName: orderMap['customerName'] as String?,
              paymentType: PaymentType.values[orderMap['paymentType'] as int],
              notes: orderMap['notes'] as String?,
            ));
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
      // First, manually transform the order with proper item serialization
      final orderJson = _ensureProperOrderSerialization(order);
      
      // Save the properly serialized order
      await _ordersBox.put(order.id, orderJson);
      
      LoggerUtil.logger.i('تم حفظ الطلب بمعرف: ${order.id}');
      LoggerUtil.logger.i('Saving order with ID: ${order.id}, items count: ${order.items.length}');
      if (order.items.isNotEmpty) {
        LoggerUtil.logger.i('First item: ${order.items.first.name} x ${order.items.first.quantity}');
      }
    } catch (e) {
      LoggerUtil.logger.e('خطأ في حفظ الطلب: $e');
      rethrow;
    }
  }

  // Add this helper method to ensure proper order serialization
  Map<String, dynamic> _ensureProperOrderSerialization(Order order) {
    // Start with the basic order properties
    final Map<String, dynamic> orderMap = {
      'id': order.id,
      'status': order.status.index, // Store as index for Hive compatibility
      'createdAt': order.createdAt.toIso8601String(),
      'customerId': order.customerId,
      'customerName': order.customerName,
      'paymentType': order.paymentType.index, // Store as index for Hive compatibility
      'notes': order.notes,
    };
    
    // Properly serialize each item in the order
    final List<Map<String, dynamic>> serializedItems = [];
    for (var item in order.items) {
      serializedItems.add({
        'productId': item.productId,
        'name': item.name,
        'price': item.price,
        'cost': item.cost,
        'quantity': item.quantity,
        'notes': item.notes,
      });
    }
    
    // Add the properly serialized items to the order
    orderMap['items'] = serializedItems;
    
    return orderMap;
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

  // دالة للحصول على طلب بواسطة المعرف
  Future<Order?> getOrderById(String id) async {
    try {
      final rawData = _ordersBox.get(id);
      if (rawData == null) return null;

      if (rawData is Map) {
        // تحويل البيانات الخام إلى Map<String, dynamic>
        Map<String, dynamic> orderMap = _convertToStringKeyMap(rawData);
        
        // معالجة عناصر الطلب
        List<OrderItem> orderItems = [];
        if (orderMap.containsKey('items') && orderMap['items'] is List) {
          List itemsList = orderMap['items'] as List;
          
          for (var itemData in itemsList) {
            if (itemData is Map) {
              Map<String, dynamic> itemMap = _convertToStringKeyMap(itemData);
              
              orderItems.add(OrderItem(
                productId: itemMap['productId'] as String,
                name: itemMap['name'] as String? ?? "منتج غير معروف",
                price: (itemMap['price'] as num?)?.toDouble() ?? 0.0,
                cost: (itemMap['cost'] as num?)?.toDouble() ?? 0.0,
                quantity: (itemMap['quantity'] as num?)?.toInt() ?? 1,
                notes: itemMap['notes'] as String?,
              ));
            }
          }
        }
        
        // إنشاء كائن Order
        final order = Order(
          id: orderMap['id'] as String,
          items: orderItems,
          status: OrderStatus.values[orderMap['status'] as int],
          createdAt: DateTime.parse(orderMap['createdAt'] as String),
          customerId: orderMap['customerId'] as String,
          customerName: orderMap['customerName'] as String?,
          paymentType: PaymentType.values[orderMap['paymentType'] as int],
          notes: orderMap['notes'] as String?,
        );
        
        LoggerUtil.logger.i('تم استعادة الطلب ${id}، عدد العناصر: ${order.items.length}');
        return order;
      }
      return null;
    } catch (e) {
      LoggerUtil.logger.e('خطأ في الحصول على الطلب حسب المعرف: $e');
      return null;
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

  // دوال سلة التسوق
  // Cart methods
  Future<List<Map<String, dynamic>>> getCartItems() async {
    try {
      final cartData = _cartBox.get('cart_items');
      if (cartData == null) {
        return [];
      }

      if (cartData is List) {
        return List<Map<String, dynamic>>.from(
            cartData.map((item) => Map<String, dynamic>.from(item)));
      }

      return [];
    } catch (e) {
      LoggerUtil.logger.e('خطأ في الحصول على عناصر سلة التسوق: $e');
      return [];
    }
  }

  Future<void> saveCartItems(List<Map<String, dynamic>> cartItems) async {
    try {
      await _cartBox.put('cart_items', cartItems);
      LoggerUtil.logger.i('تم حفظ عناصر سلة التسوق بنجاح');
    } catch (e) {
      LoggerUtil.logger.e('خطأ في حفظ عناصر سلة التسوق: $e');
      rethrow;
    }
  }

  Future<void> clearCart() async {
    try {
      await _cartBox.delete('cart_items');
      LoggerUtil.logger.i('تم مسح سلة التسوق بنجاح');
    } catch (e) {
      LoggerUtil.logger.e('خطأ في مسح سلة التسوق: $e');
      rethrow;
    }
  }
}
