import 'package:get/get.dart';
import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 0)
class Product {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final double cost;

  @HiveField(5)
  final String categoryId;

  @HiveField(6)
  final String? imageUrl;

  @HiveField(7)
  final bool isAvailable;

  @HiveField(8)
  final List<dynamic> options;

  @HiveField(9)
  final int order;

  @HiveField(10) // Added field for English name
  final String nameEn;

  @HiveField(11) // Added field for English description
  final String descriptionEn;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    this.cost = 0.0,
    this.imageUrl,
    this.isAvailable = true,
    this.options = const [],
    this.order = 0,
    this.nameEn = '', // Default value
    this.descriptionEn = '', // Default value
  });

  String get localizedName => Get.locale?.languageCode == 'en' ? nameEn : name;
  String get localizedDescription =>
      Get.locale?.languageCode == 'en' ? descriptionEn : description;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      cost: (json['cost'] ?? 0.0).toDouble(),
      categoryId: json['categoryId'] ?? '',
      imageUrl: json['imageUrl'],
      isAvailable: json['isAvailable'] ?? true,
      options: json['options'] ?? [],
      order: json['order'] ?? 0,
      nameEn: json['nameEn'] ?? '', // Add English name
      descriptionEn: json['descriptionEn'] ?? '', // Add English description
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'cost': cost,
      'categoryId': categoryId,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
      'options': options,
      'order': order,
      'nameEn': nameEn, // Add English name
      'descriptionEn': descriptionEn, // Add English description
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? cost,
    String? categoryId,
    String? imageUrl,
    bool? isAvailable,
    List<dynamic>? options,
    int? order,
    String? nameEn,
    String? descriptionEn,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      cost: cost ?? this.cost,
      categoryId: categoryId ?? this.categoryId,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      options: options ?? this.options,
      order: order ?? this.order,
      nameEn: nameEn ?? this.nameEn,
      descriptionEn: descriptionEn ?? this.descriptionEn,
    );
  }
}

// فئات بسيطة للاستخدام في التطبيق - سيتم استخدامها فقط في واجهة المستخدم
class ProductOption {
  final String id;
  final String name;
  final List<ProductOptionItem> items;
  final bool isRequired;
  final bool isMultiSelect;
  final int maxSelections;

  ProductOption({
    required this.id,
    required this.name,
    required this.items,
    this.isRequired = false,
    this.isMultiSelect = false,
    this.maxSelections = 1,
  });

  factory ProductOption.fromJson(Map<String, dynamic> json) {
    return ProductOption(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => ProductOptionItem.fromJson(item))
              .toList() ??
          [],
      isRequired: json['isRequired'] ?? false,
      isMultiSelect: json['isMultiSelect'] ?? false,
      maxSelections: json['maxSelections'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'items': items.map((item) => item.toJson()).toList(),
      'isRequired': isRequired,
      'isMultiSelect': isMultiSelect,
      'maxSelections': maxSelections,
    };
  }
}

class ProductOptionItem {
  final String id;
  final String name;
  final double price;

  ProductOptionItem({
    required this.id,
    required this.name,
    required this.price,
  });

  factory ProductOptionItem.fromJson(Map<String, dynamic> json) {
    return ProductOptionItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
}
