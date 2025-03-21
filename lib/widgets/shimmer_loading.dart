import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:gpr_coffee_shop/constants/colors.dart';

/// أداة تأثير التحميل بنمط الوميض (Shimmer)
/// تستخدم لإظهار مؤشر تحميل بدلاً من البيانات أثناء تحميلها
class ShimmerLoading extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  /// إنشاء تأثير الشيمر للتحميل
  /// [child] العنصر الذي سيتم عرضه بعد انتهاء التحميل
  /// [isLoading] حالة التحميل، إذا كانت true سيظهر تأثير الشيمر
  const ShimmerLoading({Key? key, required this.child, this.isLoading = true})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return child;
    }

    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: child,
    );
  }
}

/// قوالب جاهزة لاستخدامها مع Shimmer
class ShimmerWidgets {
  // منع إنشاء نسخة من الكلاس
  ShimmerWidgets._();

  /// قالب تحميل للمنتج
  static Widget productCard({double? width, double? height}) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 120.0,
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }

  /// قالب تحميل للنص
  static Widget text({double? width, double height = 14.0}) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }

  /// قالب تحميل للصورة
  static Widget image({
    double? width,
    double? height,
    double borderRadius = 8.0,
  }) {
    return Container(
      width: width ?? 80.0,
      height: height ?? 80.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  /// قالب تحميل لقائمة العناصر
  static Widget listView({
    int itemCount = 5,
    double itemHeight = 80.0,
    double spacing = 12.0,
  }) {
    return Column(
      children: List.generate(
        itemCount,
        (index) => Column(
          children: [
            Container(
              height: itemHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            SizedBox(height: spacing),
          ],
        ),
      ),
    );
  }

  /// قالب تحميل لشبكة المنتجات
  static Widget gridView({
    int crossAxisCount = 2,
    int itemCount = 6,
    double aspectRatio = 0.8,
    double spacing = 12.0,
  }) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      childAspectRatio: aspectRatio,
      children: List.generate(
        itemCount,
        (index) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }
}
