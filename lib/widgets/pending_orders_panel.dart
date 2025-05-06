import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/controllers/order_controller.dart';
import 'package:gpr_coffee_shop/models/order.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:intl/intl.dart';

class PendingOrdersPanel extends StatelessWidget {
  final bool compact;
  final int maxItems;
  final Function(Order)? onOrderTap;

  const PendingOrdersPanel({
    Key? key,
    this.compact = false,
    this.maxItems = 5,
    this.onOrderTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderController = Get.find<OrderController>();

    return Obx(() {
      // دمج الطلبات المعلّقة والتي قيد التحضير
      final pendingOrders = orderController.getPendingOrders();
      final processingOrders = orderController.getProcessingOrders();
      final allActiveOrders = [...pendingOrders, ...processingOrders];

      if (allActiveOrders.isEmpty) {
        return SizedBox(height: 0);
      }

      return Card(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: compact ? 8 : 16),
        color: Colors.grey.shade50,
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'الطلبات النشطة',
                    style: TextStyle(
                      fontSize: compact ? 14 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      _buildStatusIndicator(
                        'معلق',
                        Colors.orange,
                        pendingOrders.length.toString(),
                      ),
                      SizedBox(width: 8),
                      _buildStatusIndicator(
                        'قيد التحضير',
                        Colors.blue,
                        processingOrders.length.toString(),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(),
              ...allActiveOrders
                  .take(maxItems)
                  .map((order) => _buildOrderItem(order, context))
                  .toList(),
              if (allActiveOrders.length > maxItems)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Center(
                    child: TextButton(
                      child: Text(
                        'عرض جميع الطلبات (${allActiveOrders.length})',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () {
                        Get.toNamed('/admin/orders');
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildOrderItem(Order order, BuildContext context) {
    final createdTime = DateFormat('HH:mm').format(order.createdAt);
    final elapsedMinutes = DateTime.now().difference(order.createdAt).inMinutes;

    Color statusColor;
    String statusText;

    if (order.status == OrderStatus.pending) {
      statusText = 'معلّق';
      statusColor = Colors.orange;
    } else {
      statusText = 'قيد التحضير';
      statusColor = Colors.blue;
    }

    return InkWell(
      onTap: onOrderTap != null ? () => onOrderTap!(order) : null,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#${order.id.substring(0, 6)} - ${order.items.map((item) => '${item.name} (${item.quantity}x)').join(', ')}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: compact ? 12 : 14,
                    ),
                  ),
                  if (!compact)
                    Text(
                      'قيمة الطلب: ${order.total.toStringAsFixed(3)} د.ب',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(createdTime,
                    style: TextStyle(fontSize: compact ? 11 : 12)),
                Text(
                  '$elapsedMinutes دقيقة',
                  style: TextStyle(
                    fontSize: compact ? 11 : 12,
                    color: _getTimeColor(elapsedMinutes),
                    fontWeight: elapsedMinutes > 15
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
            if (onOrderTap != null) ...[
              SizedBox(width: 4),
              Icon(
                Icons.chevron_right,
                size: 16,
                color: Colors.grey.shade500,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String label, Color color, String count) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '$label: $count',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTimeColor(int minutes) {
    if (minutes <= 5) return Colors.green;
    if (minutes <= 10) return Colors.orange;
    if (minutes <= 15) return Colors.deepOrange;
    return Colors.red;
  }
}

// لا نزال نحتفظ بالفئة القديمة للحفاظ على التوافق مع الكود الحالي
class PendingOrdersWidget extends PendingOrdersPanel {
  const PendingOrdersWidget({Key? key}) : super(key: key);
}
