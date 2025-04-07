import 'package:hive_flutter/hive_flutter.dart';
import 'package:gpr_coffee_shop/models/product.dart';
import 'package:gpr_coffee_shop/models/category.dart';
import 'package:gpr_coffee_shop/models/order.dart';
import 'package:gpr_coffee_shop/models/app_settings.dart';
import 'package:uuid/uuid.dart';
import 'package:logger/logger.dart';

class LocalStorageService {
  static const String productsBox = 'products';
  static const String categoriesBox = 'categories';
  static const String ordersBox = 'orders';
  static const String settingsBox = 'settings';

  final logger = Logger();

  Future<void> init() async {
    try {
      await Hive.initFlutter();

      // Register adapters
      _registerAdapters();

      // Safely open boxes
      await _safeOpenBoxes();
    } catch (e) {
      logger.e('Error initializing local storage: $e');
      // Attempt recovery
      await Hive.deleteFromDisk();
      await Future.delayed(const Duration(milliseconds: 300));
      await Hive.initFlutter();

      // Re-register adapters
      _registerAdapters();

      // Try opening boxes again
      await _safeOpenBoxes();
    }
  }

  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ProductAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(CategoryAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(OrderAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(OrderItemAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(OrderStatusAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(PaymentTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(AppSettingsAdapter());
    }
    if (!Hive.isAdapterRegistered(11)) {
      Hive.registerAdapter(SocialMediaAccountAdapter());
    }

    // These adapter registrations will work after running build_runner
    if (!Hive.isAdapterRegistered(12)) {
      Hive.registerAdapter(BackgroundSettingsAdapter());
    }
    if (!Hive.isAdapterRegistered(13)) {
      Hive.registerAdapter(BackgroundTypeAdapter());
    }
  }

  Future<void> _safeOpenBoxes() async {
    try {
      await Future.wait([
        Hive.openBox<Product>(productsBox),
        Hive.openBox<Category>(categoriesBox),
        Hive.openBox<Order>(ordersBox),
        Hive.openBox<AppSettings>(settingsBox),
      ]);
    } catch (e) {
      logger.e('Error opening Hive boxes: $e');

      // If there's an error, we need to completely reset Hive
      try {
        await Hive.deleteFromDisk();
        await Future.delayed(const Duration(milliseconds: 500));

        // Re-initialize Hive
        await Hive.initFlutter();
        _registerAdapters();

        // Try opening fresh boxes
        await Future.wait([
          Hive.openBox<Product>(productsBox),
          Hive.openBox<Category>(categoriesBox),
          Hive.openBox<Order>(ordersBox),
          Hive.openBox<AppSettings>(settingsBox),
        ]);

        // After opening fresh boxes, save default settings
        final defaultSettings = AppSettings.defaultSettings();
        await saveSettings(defaultSettings);
      } catch (e2) {
        logger.e('Fatal error rebuilding database: $e2');
        // At this point, we can't do much more
      }
    }
  }

  // Products
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

  /// Updates products by removing items without images and adding new predefined products
  Future<void> updateProductsWithNewData() async {
    // Get all products
    final allProducts = await getProducts();

    // Remove products without images
    final productsWithoutImages = allProducts
        .where(
            (product) => product.imageUrl == null || product.imageUrl!.isEmpty)
        .toList();

    for (var product in productsWithoutImages) {
      await deleteProduct(product.id);
    }

    // Create the new product objects with appropriate category IDs
    final categoryList = await getCategories();
    String sweetsCategoryId = '';
    String coldDrinksCategoryId = '';
    String hotDrinksCategoryId = '';

    // Find the appropriate category IDs from the existing categories
    for (var category in categoryList) {
      final categoryNameLower = category.name.toLowerCase();
      if (categoryNameLower.contains('حلو') ||
          categoryNameLower.contains('كيك') ||
          categoryNameLower.contains('sweets') ||
          categoryNameLower.contains('dessert')) {
        sweetsCategoryId = category.id;
      } else if (categoryNameLower.contains('بارد') ||
          categoryNameLower.contains('cold')) {
        coldDrinksCategoryId = category.id;
      } else if (categoryNameLower.contains('ساخن') ||
          categoryNameLower.contains('hot')) {
        hotDrinksCategoryId = category.id;
      }
    }

    // If no matching categories were found, create default IDs
    sweetsCategoryId =
        sweetsCategoryId.isNotEmpty ? sweetsCategoryId : 'sweets_category';
    coldDrinksCategoryId = coldDrinksCategoryId.isNotEmpty
        ? coldDrinksCategoryId
        : 'cold_drinks_category';
    hotDrinksCategoryId = hotDrinksCategoryId.isNotEmpty
        ? hotDrinksCategoryId
        : 'hot_drinks_category';

    // Add new products
    final newProducts = [
      // Sweets category
      Product(
        id: const Uuid().v4(),
        name: 'كعكة كندر',
        description:
            'كعكة الكندر اللذيذة محضرة بطبقات من الكيك الإسفنجي الطري والكريمة الغنية بنكهة الشوكولاتة والحليب، مزينة بقطع من شوكولاتة كندر.',
        price: 2.500,
        cost: 1.000,
        categoryId: sweetsCategoryId,
        imageUrl: 'assets/images/JBR2.png',
        isAvailable: true,
        options: [],
      ),
      Product(
        id: const Uuid().v4(),
        name: 'كيكة رد فولفت',
        description:
            'كيكة الرد فلفت الكلاسيكية بلونها الأحمر المميز وطعمها الرائع، محشوة بكريمة الجبن الناعمة ومغطاة بطبقة من كريمة الجبن الحريرية.',
        price: 2.400,
        cost: 1.000,
        categoryId: sweetsCategoryId,
        imageUrl: 'assets/images/JBR3.png',
        isAvailable: true,
        options: [],
      ),

      // Cold Drinks category
      Product(
        id: const Uuid().v4(),
        name: 'سبانش لاتيه بارد',
        description:
            'سبانش لاتيه البارد، مزيج مثالي من الإسبريسو القوي والحليب المخفوق مع الحليب المكثف المحلى، منعش ومنبه في آن واحد.',
        price: 2.200,
        cost: 1.000,
        categoryId: coldDrinksCategoryId,
        imageUrl: 'assets/images/JBRD1.png',
        isAvailable: true,
        options: [],
      ),
      Product(
        id: const Uuid().v4(),
        name: 'موهيتو بلو مع ريدبول',
        description:
            'موهيتو بلو منعش مع ريدبول، مزيج مبتكر من النعناع الطازج والليمون مع شراب التوت الأزرق، معزز بطاقة ريدبول لتنشيط يومك.',
        price: 2.300,
        cost: 1.000,
        categoryId: coldDrinksCategoryId,
        imageUrl: 'assets/images/JBRD2.png',
        isAvailable: true,
        options: [],
      ),

      // Hot Drinks category
      Product(
        id: const Uuid().v4(),
        name: 'وايت موكا حار',
        description:
            'وايت موكا حار، مشروب فاخر من الإسبريسو الغني ممزوج بالشوكولاتة البيضاء الكريمية والحليب المبخر، يقدم مع طبقة من الكريمة المخفوقة.',
        price: 2.100,
        cost: 1.000,
        categoryId: hotDrinksCategoryId,
        imageUrl: 'assets/images/JBRH1.png',
        isAvailable: true,
        options: [],
      ),
      Product(
        id: const Uuid().v4(),
        name: 'أمريكانو كولومبي 360',
        description:
            'أمريكانو كولومبي 360، مشروب مميز محضر من أجود أنواع البن الكولومبي المحمص بعناية، يتميز بنكهته الغنية والمتوازنة مع لمسة من الحموضة اللطيفة.',
        price: 2.000,
        cost: 1.000,
        categoryId: hotDrinksCategoryId,
        imageUrl: 'assets/images/JBRH3.png',
        isAvailable: true,
        options: [],
      ),
      Product(
        id: const Uuid().v4(),
        name: 'دبل شوت أكسبريسو',
        description:
            'دبل شوت أكسبريسو من البن الأثيوبي الفاخر، يتميز بنكهته الزهرية والفواكه الاستوائية مع لمسة من التوت البري، محمص بدرجة متوسطة لإبراز نكهته الفريدة.',
        price: 2.100,
        cost: 0.600,
        categoryId: hotDrinksCategoryId,
        imageUrl: 'assets/images/JBRH2.png',
        isAvailable: true,
        options: [],
      ),
    ];

    // Add each new product
    for (var product in newProducts) {
      await saveProduct(product);
    }
  }

  // Categories
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

  // Orders
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

  // Settings
  Future<AppSettings?> getSettings() async {
    final box = Hive.box<AppSettings>(settingsBox);
    return box.get('settings');
  }

  Future<void> saveSettings(AppSettings settings) async {
    final box = Hive.box<AppSettings>(settingsBox);
    await box.put('settings', settings);
  }

  // Clear all data
  Future<void> clearAllData() async {
    try {
      await Future.wait([
        Hive.box<Product>(productsBox).clear(),
        Hive.box<Category>(categoriesBox).clear(),
        Hive.box<Order>(ordersBox).clear(),
        Hive.box<AppSettings>(settingsBox).clear(),
      ]);
    } catch (e) {
      logger.e('Error clearing data: $e');
    }
  }

  // Close boxes
  Future<void> closeBoxes() async {
    await Hive.close();
  }
}
