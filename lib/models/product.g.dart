// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 7;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      price: fields[3] as double,
      cost: fields[4] as double,
      categoryId: fields[5] as String,
      isAvailable: fields[7] as bool,
      options: (fields[8] as List).cast<ProductOption>(),
      imageUrl: fields[6] as String?,
      order: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.cost)
      ..writeByte(5)
      ..write(obj.categoryId)
      ..writeByte(6)
      ..write(obj.imageUrl)
      ..writeByte(7)
      ..write(obj.isAvailable)
      ..writeByte(8)
      ..write(obj.options)
      ..writeByte(9)
      ..write(obj.order);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductOptionAdapter extends TypeAdapter<ProductOption> {
  @override
  final int typeId = 8;

  @override
  ProductOption read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductOption(
      id: fields[0] as String,
      name: fields[1] as String,
      items: (fields[2] as List).cast<ProductOptionItem>(),
      isRequired: fields[3] as bool,
      isMultiSelect: fields[4] as bool,
      maxSelections: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ProductOption obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.items)
      ..writeByte(3)
      ..write(obj.isRequired)
      ..writeByte(4)
      ..write(obj.isMultiSelect)
      ..writeByte(5)
      ..write(obj.maxSelections);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductOptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductOptionItemAdapter extends TypeAdapter<ProductOptionItem> {
  @override
  final int typeId = 9;

  @override
  ProductOptionItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductOptionItem(
      id: fields[0] as String,
      name: fields[1] as String,
      price: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ProductOptionItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductOptionItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      cost: (json['cost'] as num).toDouble(),
      categoryId: json['categoryId'] as String,
      isAvailable: json['isAvailable'] as bool,
      options: (json['options'] as List<dynamic>)
          .map((e) => ProductOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageUrl: json['imageUrl'] as String?,
      order: (json['order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'cost': instance.cost,
      'categoryId': instance.categoryId,
      'imageUrl': instance.imageUrl,
      'isAvailable': instance.isAvailable,
      'options': instance.options,
      'order': instance.order,
    };

ProductOption _$ProductOptionFromJson(Map<String, dynamic> json) =>
    ProductOption(
      id: json['id'] as String,
      name: json['name'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => ProductOptionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      isRequired: json['isRequired'] as bool? ?? false,
      isMultiSelect: json['isMultiSelect'] as bool? ?? false,
      maxSelections: (json['maxSelections'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$ProductOptionToJson(ProductOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'items': instance.items,
      'isRequired': instance.isRequired,
      'isMultiSelect': instance.isMultiSelect,
      'maxSelections': instance.maxSelections,
    };

ProductOptionItem _$ProductOptionItemFromJson(Map<String, dynamic> json) =>
    ProductOptionItem(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$ProductOptionItemToJson(ProductOptionItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
    };
