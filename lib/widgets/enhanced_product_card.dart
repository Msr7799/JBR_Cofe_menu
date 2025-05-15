import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/category_controller.dart';
import 'package:gpr_coffee_shop/controllers/order_controller.dart';
import 'package:gpr_coffee_shop/models/product.dart';
import 'package:gpr_coffee_shop/models/order.dart';
import 'package:gpr_coffee_shop/models/category.dart';
import 'package:gpr_coffee_shop/utils/view_options_helper.dart';
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
  // تعيين الكمية الافتراضية إلى 1 بدلاً من 0
  int _quantity = 1;
  bool _isHovering = false;

  // معلومات التصنيف
  String _categoryName = '';

  // متغيرات التخصيص من خيارات العرض
  late bool _showImages;
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
        ),
      );

      setState(() {
        _categoryName = category.name;
      });
    } catch (e) {
      _categoryName = 'غير مصنف';
      LoggerUtil.logger.e('خطأ في تحميل معلومات الفئة: $e');
    }
  }

  void _loadViewOptions() {
    _showImages = ViewOptionsHelper.getShowImages();
    _showOrderButton = ViewOptionsHelper.getShowOrderButton();
    _titleFontSize = ViewOptionsHelper.getProductTitleFontSize();
    _priceFontSize = ViewOptionsHelper.getProductPriceFontSize();
    _buttonFontSize = ViewOptionsHelper.getProductButtonFontSize();
    _textColor = Color(ViewOptionsHelper.getTextColor());
    _priceColor = Color(ViewOptionsHelper.getPriceColor());
    _cardWidth = ViewOptionsHelper.getProductCardWidth();
    _cardHeight = ViewOptionsHelper.getProductCardHeight();

    // زيادة ارتفاع الصورة بنسبة معقولة
    _imageHeight = ViewOptionsHelper.getProductImageHeight() * 1.3;
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
        ? _cardHeight * 1.05
        : isMediumScreen
            ? _cardHeight * 1.1
            : _cardHeight * 1.2;

    final calculatedImageHeight = isSmallScreen
        ? _imageHeight * 1.0
        : isMediumScreen
            ? _imageHeight * 1.2
            : _imageHeight * 1.3;

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // قسم الصورة
                  if (_showImages) _buildProductImage(calculatedImageHeight),
                  
                  // إضافة مساحة بين الصورة والعنوان
                  const SizedBox(height: 12),
                  
                  // معلومات المنتج
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      textDirection: TextDirection.rtl,
                      children: [
                        // اسم المنتج
                        Text(
                          widget.product.name,
                          style: TextStyle(
                            fontSize: calculatedTitleSize,
                            fontWeight: FontWeight.bold,
                            color: _textColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                        ),
                        
                        // مساحة بين الاسم والسعر
                        const SizedBox(height: 6),
                        
                        // السعر
                        Text(
                          '${widget.product.price} د.ب',
                          style: TextStyle(
                            fontSize: calculatedPriceSize,
                            fontWeight: FontWeight.w700,
                            color: _priceColor,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        
                        // مساحة بين السعر والوصف
                        const SizedBox(height: 4),
                        
                        // وصف المنتج (إذا كان مطلوبًا عرض التفاصيل)
                        if (widget.showDetails && widget.product.description.isNotEmpty)
                          Text(
                            widget.product.description,
                            style: TextStyle(
                              fontSize: calculatedTitleSize * 0.8,
                              color: _textColor.withOpacity(0.7),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                          ),
                          
                        // مساحة قبل زر الطلب
                        const SizedBox(height: 12),
                        
                        // زر الطلب
                        if (_showOrderButton)
                          Row(
                            children: [
                              // زر إضافة للطلب
                              Expanded(
                                flex: 3,
                                child: ElevatedButton.icon(
                                  onPressed: widget.product.isAvailable
                                      ? _placeOrder
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    textStyle: TextStyle(
                                      fontSize: calculatedButtonSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  icon: const Icon(Icons.add_shopping_cart),
                                  label: const Text('طلب'),
                                ),
                              ),
                              
                              // مساحة بين الزر والتحكم بالكمية
                              const SizedBox(width: 8),
                              
                              // التحكم بالكمية
                              Expanded(
                                flex: 2,
                                child: _buildQuantityControls(calculatedButtonSize),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  
                  // مساحة أسفل البطاقة
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // تعديل طريقة بناء الصورة
  Widget _buildProductImage(double height) {
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
      child: GestureDetector(
        onTap: () {
          // عند الضغط على الصورة، عرض الصورة المكبرة
          _showEnlargedImage(context);
        },
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // صورة المنتج
                ImageHelper.buildImage(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: height,
                ),

                // شارة "غير متوفر" إذا لزم الأمر
                if (!widget.product.isAvailable)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black54,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: const Text(
                        'غير متوفر حاليًا',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // تحسين التحكم بالكمية
  Widget _buildQuantityControls(double fontSize) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // زر تقليل الكمية
          InkWell(
            onTap: () {
              if (_quantity > 1) {
                setState(() => _quantity--);
              }
            },
            child: Container(
              width: 32,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(7),
                  bottomRight: Radius.circular(7),
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.remove,
                size: fontSize * 0.8,
                color: Colors.black87,
              ),
            ),
          ),
          
          // عرض الكمية
          Expanded(
            child: Center(
              child: Text(
                '$_quantity',
                style: TextStyle(
                  fontSize: fontSize * 0.9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          // زر زيادة الكمية
          InkWell(
            onTap: () => setState(() => _quantity++),
            child: Container(
              width: 32,
              height: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(7),
                  bottomLeft: Radius.circular(7),
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.add,
                size: fontSize * 0.8,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // تبسيط دالة إضافة الطلب
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

      orderController.processOrder(widget.product, _quantity).then((success) {
        if (success && mounted) {
          setState(() => _quantity = 1);

          // عرض مربع حوار الاستمرار
          orderController.showContinueToIterateDialog(
            Get.context!,
            OrderItem(
              productId: widget.product.id,
              name: widget.product.name,
              price: widget.product.price,
              quantity: _quantity,
              cost: widget.product.cost,
              notes: '',
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

  // تبسيط عرض الصورة المكبرة
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
          insetPadding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // زر الإغلاق في الزاوية
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              
              // الصورة المكبرة
              Flexible(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 3.0,
                  child: _buildFullScreenImage(),
                ),
              ),
              
              // معلومات المنتج
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: TextDirection.rtl,
                  children: [
                    // عنوان المنتج والسعر
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.product.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Text(
                          '${widget.product.price} د.ب',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _priceColor,
                          ),
                        ),
                      ],
                    ),
                    
                    // وصف المنتج (إذا كان متوفراً)
                    if (widget.product.description.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.product.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ],
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
          Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 64,
          ),
          SizedBox(height: 16),
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
}