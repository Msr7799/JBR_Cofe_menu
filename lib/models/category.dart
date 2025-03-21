import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

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

  Category({
    required this.id,
    required this.name,
    this.description = '',
    this.iconPath,
    this.order = 0,
    this.isActive = true,
  });

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
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      order: order ?? this.order,
      isActive: isActive ?? this.isActive,
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