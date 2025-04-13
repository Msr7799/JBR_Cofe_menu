import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/models/product.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/controllers/order_controller.dart';
import 'package:gpr_coffee_shop/models/order.dart';
import 'package:gpr_coffee_shop/services/notification_service.dart';
import 'package:gpr_coffee_shop/utils/view_options_helper.dart';
import 'package:gpr_coffee_shop/utils/image_helper.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap;
  final bool showImage;
  final double cardSize;
  final Color textColor;
  final Color priceColor;

  const ProductCard({
    Key? key,
    required this.product,
    this.onTap,
    this.showImage = true,
    this.cardSize = 1.0,
    this.textColor = Colors.black,
    this.priceColor = AppTheme.primaryColor,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovering = false;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // استخدام قيمة cardSize للتحكم في الحجم
    final scaleFactor = widget.cardSize;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovering = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovering = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: GestureDetector(
          onTap: widget.onTap,
          child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: _isHovering ? 8 : 4,
            shadowColor: _isHovering
                ? AppTheme.primaryColor.withAlpha(AppTheme.primaryColor.alpha)
                : Colors.black.withAlpha(51),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: LayoutBuilder(builder: (context, constraints) {
              final availableHeight = constraints.maxHeight;
              final imageHeight = constraints.maxWidth * 0.65;
              final contentHeight = availableHeight - imageHeight;

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.showImage)
                    SizedBox(
                      height: imageHeight,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          GestureDetector(
                            onTap: () => _showEnlargedImage(context),
                            child: _buildProductImage(),
                          ),
                          if (!widget.product.isAvailable)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'غير متوفر',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          Positioned(
                            bottom: 8,
                            left: 8,
                            child: AnimatedOpacity(
                              opacity: _isHovering ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 200),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withAlpha(153),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.zoom_in,
                                  color: Colors.white,
                                  size: 20 * scaleFactor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Container(
                    height: widget.showImage ? contentHeight : availableHeight,
                    padding: EdgeInsets.all(8.0 * scaleFactor),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.localizedName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16 * scaleFactor,
                            color: widget.textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 1 * scaleFactor),
                        Text(
                          widget.product.localizedDescription,
                          style: TextStyle(
                            fontSize: 12 * scaleFactor,
                            color: Colors.grey[700],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(flex: 1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${widget.product.price.toStringAsFixed(3)} د.ب",
                              style: TextStyle(
                                color: widget.priceColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15 * scaleFactor,
                              ),
                            ),
                            _buildQuantitySelector(),
                          ],
                        ),
                        SizedBox(height: 4 * scaleFactor),
                        if (widget.product.isAvailable &&
                            ViewOptionsHelper.getShowOrderButton())
                          _buildOrderButton(scaleFactor),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    if (widget.product.imageUrl != null &&
        widget.product.imageUrl!.isNotEmpty) {
      // Check if the path is a local file path
      if (widget.product.imageUrl!.startsWith('C:') ||
          widget.product.imageUrl!.startsWith('/') ||
          widget.product.imageUrl!.contains('Documents')) {
        return Image.file(
          File(widget.product.imageUrl!),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (ctx, error, _) {
            print('خطأ تحميل الصورة: ${widget.product.imageUrl}, $error');
            return _buildErrorPlaceholder();
          },
        );
      } else {
        // It's an asset path
        return Image.asset(
          widget.product.imageUrl!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (ctx, error, _) {
            print('خطأ تحميل الصورة: ${widget.product.imageUrl}, $error');
            return _buildErrorPlaceholder();
          },
        );
      }
    } else {
      return _buildErrorPlaceholder();
    }
  }

  Widget _buildQuantitySelector() {
    final scaleFactor = widget.cardSize;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              if (quantity > 1) quantity--;
            });
          },
          child: Container(
            width: 24 * scaleFactor,
            height: 24 * scaleFactor,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4 * scaleFactor),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.remove,
              size: 16 * scaleFactor,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
        Container(
          width: 28 * scaleFactor,
          height: 24 * scaleFactor,
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 3 * scaleFactor),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4 * scaleFactor),
          ),
          child: Text(
            quantity.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13 * scaleFactor,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              quantity++;
            });
          },
          child: Container(
            width: 24 * scaleFactor,
            height: 24 * scaleFactor,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(4 * scaleFactor),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.add,
              size: 16 * scaleFactor,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderButton(double scale) {
    return SizedBox(
      height: 30 * scale,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _placeOrder,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF800000),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 4 * scale, vertical: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6 * scale),
          ),
          elevation: 2,
          minimumSize: Size(10, 20 * scale),
        ),
        child: Text(
          'طلب',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14 * scale,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    final scaleFactor = widget.cardSize;
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported,
              size: 40 * scaleFactor,
              color: Colors.grey[400],
            ),
            SizedBox(height: 4 * scaleFactor),
            Text(
              widget.product.name,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
                fontSize: 14 * scaleFactor,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullScreenImage() {
    if (widget.product.imageUrl!.startsWith('assets/')) {
      return Image.asset(
        widget.product.imageUrl!,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
      );
    } else if (widget.product.imageUrl!.startsWith('http')) {
      return Image.network(
        widget.product.imageUrl!,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
      );
    } else {
      try {
        return Image.file(
          File(widget.product.imageUrl!),
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
              _buildErrorPlaceholder(),
        );
      } catch (e) {
        return _buildErrorPlaceholder();
      }
    }
  }

  void _placeOrder() {
    try {
      final OrderController orderController = Get.find<OrderController>();

      final orderItem = OrderItem(
        productId: widget.product.id,
        name: widget.product.name,
        price: widget.product.price,
        cost: widget.product.cost,
        quantity: quantity,
      );

      orderController.addPendingOrder(orderItem);
      orderController.completePendingItem(orderItem);

      final notificationService = Get.find<NotificationService>();
      notificationService.showOrderNotification(orderItem);

      Get.snackbar(
        'تم الطلب',
        'تم طلب ${widget.product.name} (${quantity}x)',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withAlpha(179),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      setState(() {
        quantity = 1;
      });
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تقديم الطلب',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withAlpha(230),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(10),
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    }
  }

  void _showEnlargedImage(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            alignment: Alignment.center,
            children: [
              InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(20),
                minScale: 0.5,
                maxScale: 3.0,
                child: Hero(
                  tag: 'product-image-zoom-${widget.product.id}',
                  child: widget.product.imageUrl != null &&
                          widget.product.imageUrl!.isNotEmpty
                      ? _buildFullScreenImage()
                      : _buildErrorPlaceholder(),
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 36),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(179),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.localizedName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.product.localizedDescription,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.product.price.toStringAsFixed(3)} د.ب',
                        style: TextStyle(
                          color: Colors.amber[300],
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProductDetails(Product product) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                Container(
                  width: double.infinity,
                  height: 200,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _buildProductImage(),
                  ),
                ),
              Text(
                product.localizedName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: widget.textColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                product.localizedDescription,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${product.price.toStringAsFixed(3)} د.ب',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: widget.priceColor,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('الكمية:', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 10),
                  _buildQuantitySelector(),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('إلغاء'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _placeOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                    ),
                    child: const Text('إضافة للطلب'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
