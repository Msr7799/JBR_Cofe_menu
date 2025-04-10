import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:get/get.dart';

part 'category.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class Category extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String? iconPath;

  @HiveField(4)
  final int order;

  @HiveField(5)
  final bool isActive;

  @HiveField(6) // Added field for English name
  final String nameEn;

  @HiveField(7) // Added field for English description
  final String descriptionEn;

  Category({
    required this.id,
    required this.name,
    this.description = '',
    this.iconPath,
    this.order = 0,
    this.isActive = true,
    this.nameEn = '', // Default value
    this.descriptionEn = '', // Default value,
  });

  // Localized getters for name and description
  String get localizedName => Get.locale?.languageCode == 'en' ? nameEn : name;
  String get localizedDescription =>
      Get.locale?.languageCode == 'en' ? descriptionEn : description;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  Category copyWith({
    String? id,
    String? name,
    String? description,
    String? iconPath,
    int? order,
    bool? isActive,
    String? nameEn,
    String? descriptionEn,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      order: order ?? this.order,
      isActive: isActive ?? this.isActive,
      nameEn: nameEn ?? this.nameEn,
      descriptionEn: descriptionEn ?? this.descriptionEn,
    );
  }
}

@HiveType(typeId: 2)
enum CategoryType {
  @HiveField(0)
  food,

  @HiveField(1)
  drinks,

  @HiveField(2)
  desserts,

  @HiveField(3)
  other,
}
