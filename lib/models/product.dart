import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@HiveType(typeId: 7)
@JsonSerializable()
class Product extends HiveObject {
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
  final String? imageUrl; // إضافة حقل صورة المنتج

  @HiveField(7)
  final bool isAvailable;

  @HiveField(8)
  final List<ProductOption> options;

  @HiveField(9)
  final int order; // إضافة حقل الترتيب

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.cost,
    required this.categoryId,
    required this.isAvailable,
    required this.options,
    this.imageUrl,
    this.order = 0, // قيمة افتراضية للترتيب
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);

  // إضافة طريقة نسخ مع التعديل
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? cost,
    String? categoryId,
    String? imageUrl,
    bool? isAvailable,
    List<ProductOption>? options,
    int? order,
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
    );
  }
}

@HiveType(typeId: 8)
@JsonSerializable()
class ProductOption extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<ProductOptionItem> items;

  @HiveField(3)
  final bool isRequired;

  @HiveField(4)
  final bool isMultiSelect;

  @HiveField(5)
  final int maxSelections;

  ProductOption({
    required this.id,
    required this.name,
    required this.items,
    this.isRequired = false,
    this.isMultiSelect = false,
    this.maxSelections = 1,
  });

  factory ProductOption.fromJson(Map<String, dynamic> json) =>
      _$ProductOptionFromJson(json);
  Map<String, dynamic> toJson() => _$ProductOptionToJson(this);
}

@HiveType(typeId: 9)
@JsonSerializable()
class ProductOptionItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double price;

  ProductOptionItem({
    required this.id,
    required this.name,
    required this.price,
  });

  factory ProductOptionItem.fromJson(Map<String, dynamic> json) =>
      _$ProductOptionItemFromJson(json);
  Map<String, dynamic> toJson() => _$ProductOptionItemToJson(this);
}
