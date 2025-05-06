import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/category_controller.dart';
import 'package:gpr_coffee_shop/controllers/order_controller.dart';
import 'package:gpr_coffee_shop/models/product.dart';
import 'package:gpr_coffee_shop/models/order.dart';
import 'package:gpr_coffee_shop/models/category.dart'; // Añadido para solucionar el error
import 'package:gpr_coffee_shop/services/notification_service.dart';
import 'package:gpr_coffee_shop/utils/view_options_helper.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gpr_coffee_shop/utils/image_helper.dart';
import 'package:gpr_coffee_shop/utils/logger_util.dart';

class EnhancedProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap;
  final bool showDetails;
  final Function(Product, int)? onOrderPlaced;
  final String heroTag;

  const EnhancedProductCard({
    Key? key,
    required this.product,
    this.onTap,
    this.showDetails = true,
    this.onOrderPlaced,
    this.heroTag = '',
  }) : super(key: key);

  @override
  State<EnhancedProductCard> createState() => _EnhancedProductCardState();
}

class _EnhancedProductCardState extends State<EnhancedProductCard>
    with SingleTickerProviderStateMixin {
  // متغيرات الحالة
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  int _quantity = 1;
  bool _isHovering = false;

  // معلومات التصنيف
  String _categoryName = '';

  // متغيرات التخصيص من خيارات العرض
  late double _cardSize;
  late bool _showImages;
  late bool _useAnimations;
  late bool _showOrderButton;
  late double _titleFontSize;
  late double _priceFontSize;
  late double _buttonFontSize;
  late Color _textColor;
  late Color _priceColor;
  late double _cardWidth;
  late double _cardHeight;
  late double _imageHeight;

  @override
  void initState() {
    super.initState();
    // إعداد التحريك
    _animController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    // تحميل معلومات الفئة
    _loadCategoryInfo();

    // تحميل خيارات العرض
    _loadViewOptions();
  }

  @override
  void didUpdateWidget(EnhancedProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product.id != widget.product.id) {
      _loadCategoryInfo();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // تحميل معلومات الفئة
  void _loadCategoryInfo() {
    try {
      final CategoryController categoryController =
          Get.find<CategoryController>();
      final category = categoryController.categories.firstWhere(
        (c) => c.id == widget.product.categoryId,
        orElse: () => Category(
          id: '',
          name: 'غير مصنف',
          nameEn: 'Uncategorized',
          description: '',
          descriptionEn: '',
          iconPath: '',
          order: 0,
        ), // تصحيح الخطأ: إرجاع كائن Category بدلاً من null
      );

      setState(() {
        _categoryName = category.name;
      });
    } catch (e) {
      _categoryName = 'غير مصنف';
      LoggerUtil.logger.e('خطأ في تحميل معلومات الفئة: $e');
    }
  }

  // تحميل خيارات العرض
  void _loadViewOptions() {
    _cardSize = ViewOptionsHelper.getCardSize();
    _showImages = ViewOptionsHelper.getShowImages();
    _useAnimations = ViewOptionsHelper.getUseAnimations();
    _showOrderButton = ViewOptionsHelper.getShowOrderButton();
    _titleFontSize = ViewOptionsHelper.getProductTitleFontSize();
    _priceFontSize = ViewOptionsHelper.getProductPriceFontSize();
    _buttonFontSize = ViewOptionsHelper.getProductButtonFontSize();
    _textColor = Color(ViewOptionsHelper.getTextColor());
    _priceColor = Color(ViewOptionsHelper.getPriceColor());
    _cardWidth = ViewOptionsHelper.getProductCardWidth();
    _cardHeight = ViewOptionsHelper.getProductCardHeight();
    _imageHeight = ViewOptionsHelper.getProductImageHeight();
  }

  // بناء البطاقة
  @override
  Widget build(BuildContext context) {
    // تحسين الاستجابة للشاشات المختلفة
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth < 480 && screenWidth >= 360;

    // حساب قيم التحجيم بناءً على حجم الشاشة
    final calculatedCardWidth = isSmallScreen
        ? _cardWidth * 0.85
        : isMediumScreen
            ? _cardWidth * 0.9
            : _cardWidth;

    final calculatedCardHeight = isSmallScreen
        ? _cardHeight * 0.85
        : isMediumScreen
            ? _cardHeight * 0.9
            : _cardHeight;

    final calculatedImageHeight = isSmallScreen
        ? _imageHeight * 0.8
        : isMediumScreen
            ? _imageHeight * 0.9
            : _imageHeight;

    final calculatedTitleSize = isSmallScreen
        ? _titleFontSize * 0.85
        : isMediumScreen
            ? _titleFontSize * 0.9
            : _titleFontSize;

    final calculatedPriceSize = isSmallScreen
        ? _priceFontSize * 0.85
        : isMediumScreen
            ? _priceFontSize * 0.9
            : _priceFontSize;

    final calculatedButtonSize = isSmallScreen
        ? _buttonFontSize * 0.85
        : isMediumScreen
            ? _buttonFontSize * 0.9
            : _buttonFontSize;

    // بناء البطاقة مع إصلاح مشكلة الأوفرفلو
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: calculatedCardWidth,
        // منع تحديد ارتفاع ثابت لتجنب مشكلة الفائض
        constraints: BoxConstraints(
          minHeight: calculatedCardHeight,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: _isHovering ? 3 : 1,
              blurRadius: _isHovering ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize:
                      MainAxisSize.min, // استخدام هذا لمنع مشكلة الفائض
                  textDirection: TextDirection.rtl,
                  children: [
                    if (_showImages) _buildProductImage(calculatedImageHeight),
                    const SizedBox(height: 8),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize:
                            MainAxisSize.min, // استخدام هذا لمنع مشكلة الفائض
                        children: [
                          Text(
                            widget.product.name,
                            style: TextStyle(
                              fontSize: calculatedTitleSize,
                              fontWeight: FontWeight.bold,
                              color: _textColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          if (_categoryName.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              _categoryName,
                              style: TextStyle(
                                fontSize: calculatedTitleSize * 0.7,
                                color: Colors.grey.shade700,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                          const SizedBox(height: 4),
                          Text(
                            '${widget.product.price.toStringAsFixed(3)} د.ب',
                            style: TextStyle(
                              fontSize: calculatedPriceSize,
                              fontWeight: FontWeight.bold,
                              color: _priceColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (widget.showDetails && _showOrderButton) ...[
                            Row(
                              children: [
                                _buildQuantityControls(calculatedButtonSize),
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: _placeOrder,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'طلب',
                                    style: TextStyle(
                                      fontSize: calculatedButtonSize,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // بناء صورة المنتج
  Widget _buildProductImage(double height) {
    // استخدام القيمة المخزنة من ViewOptionsHelper
    double imageHeight = ViewOptionsHelper.getProductImageHeight() * _cardSize;

    String? imageUrl = widget.product.imageUrl;
    Widget errorWidget = Container(
      height: height,
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported,
              size: height * 0.3,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 8),
            Text(
              widget.product.name,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    if (imageUrl == null || imageUrl.isEmpty) {
      return errorWidget;
    }

    // Hero for smooth transitions when opening product details
    String heroTagToUse = widget.heroTag.isEmpty
        ? 'product-${widget.product.id}'
        : widget.heroTag;

    return Hero(
      tag: heroTagToUse,
      child: SizedBox(
        height: height, // استخدم القيمة المحسوبة المرسلة من الخارج
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // صورة المنتج مع استخدام ImageHelper
              ImageHelper.buildImage(
                imageUrl,
                fit: BoxFit.cover,
                errorWidget: errorWidget,
              ),

              // تأثير الضغط على الصورة
              if (_isHovering)
                Container(
                  color: Colors.black.withOpacity(0.1),
                  child: Center(
                    child: Icon(
                      Icons.zoom_in,
                      color: Colors.white,
                      size: height * 0.2,
                    ),
                  ),
                ),

              // شارة "غير متوفر" إذا لزم الأمر
              if (!widget.product.isAvailable)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'غير متاح',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _titleFontSize * 0.6,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // بناء التحكم بالكمية
  Widget _buildQuantityControls(double fontSize) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildQuantityButton(
          Icons.remove,
          () {
            if (_quantity > 1) {
              setState(() => _quantity--);
            }
          },
          fontSize,
        ),
        Container(
          width: fontSize * 2,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '$_quantity',
            style: TextStyle(
              fontSize: fontSize * 0.9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildQuantityButton(
          Icons.add,
          () => setState(() => _quantity++),
          fontSize,
          isAdd: true,
        ),
      ],
    );
  }

  // زر التحكم بالكمية
  Widget _buildQuantityButton(
    IconData icon,
    VoidCallback onPressed,
    double size, {
    bool isAdd = false,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: size * 1.6,
        height: size * 1.6,
        decoration: BoxDecoration(
          color: isAdd ? AppTheme.primaryColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: size * 0.8,
          color: isAdd ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  // تعديل دالة _placeOrder لاستخدام الطريقة الموحدة
  void _placeOrder() {
    if (!widget.product.isAvailable) return;

    try {
      // إذا كان هناك دالة خارجية للتعامل مع الطلب، استخدمها
      if (widget.onOrderPlaced != null) {
        widget.onOrderPlaced!(widget.product, _quantity);
        setState(() => _quantity = 1); // إعادة تعيين الكمية
        return;
      }

      // استخدام الطريقة الموحدة في OrderController
      final OrderController orderController = Get.find<OrderController>();

      // Use the processOrder method which handles notifications and statistics
      orderController.processOrder(widget.product, _quantity).then((success) {
        if (success && mounted) {
          // Only update state if widget is still mounted
          setState(() => _quantity = 1);

          // Show continuation dialog only if successful
          orderController.showContinueToIterateDialog(
            Get.context!,
            OrderItem(
              productId: widget.product.id,
              name: widget.product.name,
              price: widget.product.price,
              quantity: _quantity,
              cost: widget.product.cost,
            ),
          );
        }
      });
    } catch (e) {
      LoggerUtil.logger.e('خطأ في إضافة المنتج للطلب: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء إضافة المنتج للطلب',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // عرض صورة المنتج بحجم كبير
  void _showEnlargedImage(BuildContext context) {
    if (widget.product.imageUrl == null || widget.product.imageUrl!.isEmpty) {
      return;
    }

    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => GestureDetector(
        onTap: () => Navigator.pop(context),
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
                  tag: 'enlarged-${widget.product.id}',
                  child: _buildFullScreenImage(),
                ),
              ),
              Positioned(
                top: 20,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.product.description.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          widget.product.description,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _categoryName,
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${widget.product.price.toStringAsFixed(3)} د.ب',
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          Get.back(); // إغلاق صفحة الصورة المكبرة

                          // استخدام الطريقة الموحدة
                          final OrderController orderController =
                              Get.find<OrderController>();
                          orderController
                              .processOrder(widget.product, _quantity)
                              .then((success) {
                            if (success) {
                              setState(() => _quantity = 1);
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                        ),
                        child: const Text('إضافة للطلب'),
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

  // صورة شاشة كاملة
  Widget _buildFullScreenImage() {
    final imageUrl = widget.product.imageUrl;
    const errorWidget = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'تعذّر تحميل الصورة',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );

    if (imageUrl == null || imageUrl.isEmpty) {
      return errorWidget;
    }

    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        fit: BoxFit.contain,
        errorBuilder: (ctx, error, _) => errorWidget,
      );
    } else if (imageUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.contain,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
        errorWidget: (ctx, url, error) => errorWidget,
      );
    } else {
      try {
        return Image.file(
          File(imageUrl),
          fit: BoxFit.contain,
          errorBuilder: (ctx, error, _) => errorWidget,
        );
      } catch (e) {
        return errorWidget;
      }
    }
  }

  // تعديل الجزء الذي يسبب مشكلة الفائض (overflow)
  Widget _buildProductInfo() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize:
              MainAxisSize.min, // هام: لمنع المحتوى من التوسع بشكل مفرط
          children: [
            // استخدام Flexible بدلاً من Expanded للنصوص لتجنب مشكلة الفائض
            Flexible(
              child: Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2, // تحديد عدد أقصى من السطور
                overflow: TextOverflow.ellipsis, // إظهار ... عند تجاوز المساحة
              ),
            ),
            const SizedBox(height: 4),
            // وصف المنتج مع تقييد المساحة
            if (widget.product.description != null &&
                widget.product.description!.isNotEmpty)
              Flexible(
                child: Text(
                  widget.product.description!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                  maxLines: 2, // تحديد عدد أقصى من السطور
                  overflow:
                      TextOverflow.ellipsis, // إظهار ... عند تجاوز المساحة
                ),
              ),
            const SizedBox(height: 8),
            // معلومات السعر
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.product.cost.toStringAsFixed(3)} د.ب',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                // إضافة أيقونة صغيرة بدلاً من نص كبير لتوفير المساحة
                if (widget.product.isPopular)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
