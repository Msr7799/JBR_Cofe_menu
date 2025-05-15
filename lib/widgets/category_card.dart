import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/models/category.dart';

class CategoryCard extends StatefulWidget {
  final Category category;
  final VoidCallback? onTap;
  final double cardSize;

  const CategoryCard({
    Key? key,
    required this.category,
    this.onTap,
    this.cardSize = 1.0,
  }) : super(key: key);

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovering = false;

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
                ? AppTheme.primaryColor.withOpacity(0.5)
                : Colors.black.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              // إضافة بوردر خفيف للبطاقات
              side: BorderSide(
                color: _isHovering
                    ? AppTheme.primaryColor.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.2),
                width: _isHovering ? 1.5 : 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // قسم الصورة
                Expanded(
                  flex: 3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildCategoryImage(),
                      // طبقة تدرج لتحسين وضوح النص
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                            stops: const [0.6, 1.0],
                          ),
                        ),
                      ),
                      // عنوان الفئة - بتعديل عرض الفئة
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Text(
                            'فئة',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // اسم الفئة
                      Positioned(
                        bottom: 8,
                        left: 8,
                        right: 8,
                        child: Text(
                          widget.category.localizedName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18 * widget.cardSize,
                            fontWeight: FontWeight.bold,
                            shadows: const [
                              Shadow(
                                blurRadius: 3,
                                color: Colors.black,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                // قسم المعلومات - تحسين الوصف
                Expanded(
                  flex: 1,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _isHovering
                          ? AppTheme.primaryColor.withOpacity(0.05)
                          : Colors.transparent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.category.description,
                          style: TextStyle(
                            fontSize: 13 * widget.cardSize,
                            color: Colors.grey[700],
                            height: 1.2, // تحسين المسافة بين السطور
                            fontWeight: FontWeight.w400, // تحسين وزن الخط
                          ),
                          maxLines: 2, // السماح بسطرين للوصف
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
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

  Widget _buildCategoryImage() {
    if (widget.category.iconPath == null || widget.category.iconPath!.isEmpty) {
      return Container(
        color: Colors.grey[300],
        child: Icon(
          Icons.category,
          size: 60 * widget.cardSize,
          color: Colors.grey[500],
        ),
      );
    }

    // التحقق من نوع مسار الصورة
    if (widget.category.iconPath!.startsWith('C:') ||
        widget.category.iconPath!.startsWith('/') ||
        widget.category.iconPath!.contains('Documents')) {
      // إذا كانت الصورة ملفًا محليًا
      return Image.file(
        File(widget.category.iconPath!),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('خطأ تحميل صورة الفئة: ${widget.category.iconPath}, $error');
          return _buildFallbackImage();
        },
      );
    } else {
      // إذا كانت الصورة من الأصول (assets)
      return Image.asset(
        widget.category.iconPath!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('خطأ تحميل صورة الفئة: ${widget.category.iconPath}, $error');
          return _buildFallbackImage();
        },
      );
    }
  }

  Widget _buildFallbackImage() {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category,
              size: 40 * widget.cardSize,
              color: Colors.grey[500],
            ),
            const SizedBox(height: 8),
            Text(
              widget.category.name,
              style: TextStyle(
                fontSize: 14 * widget.cardSize,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
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
}
