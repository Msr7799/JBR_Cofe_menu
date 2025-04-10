import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/models/category.dart';
import 'package:gpr_coffee_shop/services/local_storage_service.dart';
import 'package:uuid/uuid.dart';
import 'package:gpr_coffee_shop/utils/logger_util.dart';
import 'package:gpr_coffee_shop/data/menu_data.dart';

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
      LoggerUtil.logger.e('Error loading categories: $e');
      // أضف بيانات تجريبية في حالة الخطأ
      await _addSampleCategories();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _addSampleCategories() async {
    final sampleCategories = MenuData.getCategories();

    for (var category in sampleCategories) {
      await _storage.saveCategory(category);
    }

    categories.assignAll(sampleCategories);
  }

  Future<bool> addCategory(Category category) async {
    try {
      isLoading.value = true;
      await _storage.saveCategory(category);
      categories.add(category);
      categories.refresh(); // Use refresh instead of update
      Get.snackbar(
        'نجاح',
        'تم إضافة الفئة بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return true;
    } catch (e) {
      LoggerUtil.logger.e('Error adding category: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء إضافة الفئة',
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

  Future<void> updateCategory(Category category) async {
    try {
      isLoading.value = true;
      await _storage.saveCategory(category);
      final index = categories.indexWhere((c) => c.id == category.id);
      if (index != -1) {
        categories[index] = category; // ✅ Update specific category
        update();
      }
      Get.snackbar(
        'نجاح',
        'تم تحديث الفئة بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      LoggerUtil.logger.e('Error updating category: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تحديث الفئة',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      isLoading.value = true;
      await _storage.deleteCategory(id);
      categories.removeWhere(
          (category) => category.id == id); // ✅ Update list immediately
      update();
      Get.snackbar(
        'نجاح',
        'تم حذف الفئة بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      LoggerUtil.logger.e('Error deleting category: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء حذف الفئة',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
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
      id: const Uuid().v4(),
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

  Future<void> resetCategories() async {
    try {
      isLoading.value = true;

      // احصل على الفئات الافتراضية من ملف menu_data.dart
      final defaultCategories = MenuData.getCategories();

      // احذف جميع الفئات الحالية
      await _storage.clearCategories();

      // أضف الفئات الافتراضية
      for (var category in defaultCategories) {
        await _storage.saveCategory(category);
      }

      // أعد تحميل القائمة
      categories.assignAll(defaultCategories);
      categories.refresh();

      Get.snackbar(
        'نجاح',
        'تم إعادة ضبط الفئات إلى الحالة الافتراضية',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      LoggerUtil.logger.e('Error resetting categories: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء إعادة ضبط الفئات',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
