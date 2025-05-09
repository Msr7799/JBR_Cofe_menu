import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'order.g.dart';

@HiveType(typeId: 3)
@JsonSerializable()
class Order extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final List<OrderItem> items;

  @HiveField(2)
  @JsonKey(defaultValue: OrderStatus.pending)
  OrderStatus status;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final String customerId;

  @HiveField(5)
  final String? customerName;

  @HiveField(6)
  final PaymentType paymentType;

  @HiveField(7)
  final String? notes;

  Order({
    required this.id,
    required this.items,
    required this.status,
    required this.createdAt,
    required this.customerId,
    this.customerName,
    required this.paymentType,
    this.notes,
  });

  double get total => items.fold(
        0.0,
        (sum, item) => sum + (item.price * item.quantity.toDouble()),
      );

  double get profit => items.fold(
        0.0,
        (sum, item) =>
            sum + ((item.price - item.cost) * item.quantity.toDouble()),
      );

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);

  Order copyWith({
    String? id,
    List<OrderItem>? items,
    OrderStatus? status,
    DateTime? createdAt,
    String? customerId,
    String? customerName,
    PaymentType? paymentType,
    String? notes,
  }) {
    return Order(
      id: id ?? this.id,
      items: items ?? this.items,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      paymentType: paymentType ?? this.paymentType,
      notes: notes ?? this.notes,
    );
  }

  /// إنشاء طلب جديد فارغ
  factory Order.empty() {
    return Order(
      id: const Uuid().v4(),
      items: [],
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
      customerId: 'walk-in',
      paymentType: PaymentType.cash,
    );
  }
}

@HiveType(typeId: 4)
@JsonSerializable()
class OrderItem extends HiveObject {
  @HiveField(0)
  final String productId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final double cost;

  @HiveField(4)
  final int quantity;

  @HiveField(5)
  final String? notes;

  OrderItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.cost,
    required this.quantity,
    this.notes,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);

  /// إنشاء نسخة جديدة من عنصر الطلب مع تغييرات
  OrderItem copyWith({
    String? productId,
    String? name,
    double? price,
    double? cost,
    int? quantity,
    String? notes,
  }) {
    return OrderItem(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      cost: cost ?? this.cost,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
    );
  }
}

@HiveType(typeId: 5)
enum OrderStatus {
  @HiveField(0)
  pending,

  @HiveField(1)
  processing,

  @HiveField(2)
  completed,

  @HiveField(3)
  cancelled
}

@HiveType(typeId: 6)
enum PaymentType {
  @HiveField(0)
  cash,

  @HiveField(1)
  card,

  @HiveField(2)
  benefit,

  @HiveField(3)
  other
}
