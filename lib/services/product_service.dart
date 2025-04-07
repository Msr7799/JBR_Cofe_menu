import 'package:gpr_coffee_shop/models/product.dart';
import 'package:gpr_coffee_shop/models/category.dart'; // إضافة استيراد Category
import 'package:gpr_coffee_shop/services/local_storage_service.dart';
import 'package:uuid/uuid.dart';

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
      print('بدء تحديث المنتجات...');

      // حذف المنتجات القديمة بدون صور
      final allProducts = await getProducts();
      print('عدد المنتجات قبل الحذف: ${allProducts.length}');

      final productsToDelete = allProducts
          .where((product) =>
              product.imageUrl == null ||
              product.imageUrl!.isEmpty ||
              (!product.imageUrl!.contains('JBR2') &&
                  !product.imageUrl!.contains('JBR3') &&
                  !product.imageUrl!.contains('JBRD1') &&
                  !product.imageUrl!.contains('JBRD2') &&
                  !product.imageUrl!.contains('JBRH1') &&
                  !product.imageUrl!.contains('JBRH2') &&
                  !product.imageUrl!.contains('JBRH3')))
          .toList();

      print('جاري حذف ${productsToDelete.length} منتج...');
      for (var product in productsToDelete) {
        print('حذف: ${product.name}');
        await deleteProduct(product.id);
      }

      // الحصول على الفئات الموجودة
      final categories = await _storage.getCategories();
      print('الفئات الموجودة: ${categories.length}');
      categories.forEach((cat) => print('${cat.id}: ${cat.name}'));

      // البحث عن أو إنشاء الفئات الرئيسية
      String? sweetsCategoryId;
      String? coldDrinksCategoryId;
      String? hotDrinksCategoryId;

      // البحث عن الفئات حسب الاسم
      for (var category in categories) {
        final name = category.name.toLowerCase();
        if (name.contains('حلو') ||
            name.contains('كيك') ||
            name.contains('sweet')) {
          sweetsCategoryId = category.id;
          print(
              'تم العثور على فئة الحلويات: ${category.id} (${category.name})');
        } else if (name.contains('بارد') || name.contains('cold')) {
          coldDrinksCategoryId = category.id;
          print(
              'تم العثور على فئة المشروبات الباردة: ${category.id} (${category.name})');
        } else if (name.contains('ساخن') || name.contains('hot')) {
          hotDrinksCategoryId = category.id;
          print(
              'تم العثور على فئة المشروبات الساخنة: ${category.id} (${category.name})');
        }
      }

      // إنشاء الفئات إذا لم توجد
      if (sweetsCategoryId == null) {
        final newId = const Uuid().v4();
        final category = Category(
          id: newId,
          name: 'الحلويات',
          description: 'تشكيلة متنوعة من الحلويات',
          iconPath: 'assets/images/JBR2.png',
        );
        await _storage.saveCategory(category);
        sweetsCategoryId = newId;
        print('تم إنشاء فئة الحلويات بمعرف: $newId');
      }

      if (coldDrinksCategoryId == null) {
        final newId = const Uuid().v4();
        final category = Category(
          id: newId,
          name: 'المشروبات الباردة',
          description: 'مشروبات منعشة وباردة',
          iconPath: 'assets/images/JBRD1.png',
        );
        await _storage.saveCategory(category);
        coldDrinksCategoryId = newId;
        print('تم إنشاء فئة المشروبات الباردة بمعرف: $newId');
      }

      if (hotDrinksCategoryId == null) {
        final newId = const Uuid().v4();
        final category = Category(
          id: newId,
          name: 'المشروبات الساخنة',
          description: 'مشروبات ساخنة ولذيذة',
          iconPath: 'assets/images/JBRH1.png',
        );
        await _storage.saveCategory(category);
        hotDrinksCategoryId = newId;
        print('تم إنشاء فئة المشروبات الساخنة بمعرف: $newId');
      }

      print(
          'استخدام معرفات الفئات: الحلويات=$sweetsCategoryId, الباردة=$coldDrinksCategoryId, الساخنة=$hotDrinksCategoryId');

      // إضافة المنتجات الجديدة
      final newProducts = [
        // فئة الحلويات
        Product(
          id: const Uuid().v4(),
          name: 'كعكة كندر',
          description:
              'كعكة الكندر اللذيذة محضرة بطبقات من الكيك الإسفنجي الطري والكريمة الغنية بنكهة الشوكولاتة والحليب، مزينة بقطع من شوكولاتة كندر.',
          price: 2.500,
          cost: 1.000,
          categoryId: sweetsCategoryId!,
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

        // فئة المشروبات الباردة
        Product(
          id: const Uuid().v4(),
          name: 'سبانش لاتيه بارد',
          description:
              'سبانش لاتيه البارد، مزيج مثالي من الإسبريسو القوي والحليب المخفوق مع الحليب المكثف المحلى، منعش ومنبه في آن واحد.',
          price: 2.200,
          cost: 1.000,
          categoryId: coldDrinksCategoryId!,
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

        // فئة المشروبات الساخنة
        Product(
          id: const Uuid().v4(),
          name: 'وايت موكا حار',
          description:
              'وايت موكا حار، مشروب فاخر من الإسبريسو الغني ممزوج بالشوكولاتة البيضاء الكريمية والحليب المبخر، يقدم مع طبقة من الكريمة المخفوقة.',
          price: 2.100,
          cost: 1.000,
          categoryId: hotDrinksCategoryId!,
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

      // إضافة المنتجات الجديدة
      print('إضافة ${newProducts.length} منتج جديد...');
      for (var product in newProducts) {
        print('إضافة: ${product.name} (فئة: ${product.categoryId})');

        try {
          await saveProduct(product);
          print('تم إضافة ${product.name} بنجاح');
        } catch (e) {
          print('فشل في إضافة ${product.name}: $e');
        }
      }

      final updatedProducts = await getProducts();
      print('عدد المنتجات بعد التحديث: ${updatedProducts.length}');
      print('تم تحديث المنتجات بنجاح!');
    } catch (e) {
      print('حدث خطأ أثناء تحديث المنتجات: $e');
    }
  }
}
