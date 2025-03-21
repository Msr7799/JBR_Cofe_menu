import 'package:get/get.dart';
import 'package:gpr_coffee_shop/models/category.dart';
import 'package:gpr_coffee_shop/services/local_storage_service.dart';
import 'package:uuid/uuid.dart';

class CategoryController extends GetxController {
  final LocalStorageService _storage;
  final categories = <Category>[].obs;
  final isLoading = RxBool(false);
  final selectedCategoryId = RxString('');

  CategoryController(this._storage);

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    isLoading.value = true;
    try {
      final loadedCategories = await _storage.getCategories();
      categories.assignAll(loadedCategories);

      // إذا لم توجد فئات، أضف بيانات تجريبية
      if (categories.isEmpty) {
        await _addSampleCategories();
      }
    } catch (e) {
      print('Error loading categories: $e');
      // أضف بيانات تجريبية في حالة الخطأ
      await _addSampleCategories();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _addSampleCategories() async {
    final sampleCategories = [
      Category(
        id: '1',
        name: 'قهوة ساخنة',
        description: 'مجموعة متنوعة من القهوة الساخنة',
        iconPath:
            'assets/images/placeholder.png', // استخدم iconPath بدلاً من image
      ),
      Category(
        id: '2',
        name: 'قهوة باردة',
        description: 'مشروبات القهوة الباردة المنعشة',
        iconPath: 'assets/images/placeholder.png',
      ),
      Category(
        id: '3',
        name: 'حلويات',
        description: 'تشكيلة من الحلويات الشهية',
        iconPath: 'assets/images/placeholder.png',
      ),
    ];

    for (var category in sampleCategories) {
      await _storage.saveCategory(category);
    }

    categories.assignAll(sampleCategories);
  }

  Future<void> addCategory(Category category) async {
    try {
      isLoading.value = true;
      await _storage.saveCategory(category);
      categories.add(category);
      Get.snackbar(
        'نجاح',
        'تم إضافة الفئة بنجاح',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error adding category: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء إضافة الفئة',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateCategory(Category category) async {
    try {
      isLoading.value = true;
      await _storage.saveCategory(category);
      final index = categories.indexWhere((c) => c.id == category.id);
      if (index != -1) {
        categories[index] = category;
      }
      Get.snackbar(
        'نجاح',
        'تم تحديث الفئة بنجاح',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error updating category: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تحديث الفئة',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      isLoading.value = true;
      await _storage.deleteCategory(id);
      categories.removeWhere((category) => category.id == id);
      Get.snackbar(
        'نجاح',
        'تم حذف الفئة بنجاح',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error deleting category: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء حذف الفئة',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void reorderCategories(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = categories.removeAt(oldIndex);
    categories.insert(newIndex, item);

    // Update order for all categories
    for (var i = 0; i < categories.length; i++) {
      final category = categories[i];
      if (category.order != i) {
        updateCategory(category.copyWith(order: i));
      }
    }
  }

  Category? findById(String id) {
    try {
      return categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  String createNewCategory(String name, {String description = ''}) {
    final category = Category(
      id: Uuid().v4(),
      name: name,
      description: description,
      order: categories.length,
    );
    addCategory(category);
    return category.id;
  }

  void selectCategory(String? id) {
    selectedCategoryId.value = id ?? '';
  }
}
