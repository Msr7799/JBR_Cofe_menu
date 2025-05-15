import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/controllers/feedback_controller.dart';
import 'package:gpr_coffee_shop/screens/customer/rate_screen.dart';

class FeedbackSection extends StatelessWidget {
  final bool isPortrait;
  
  const FeedbackSection({
    Key? key, 
    required this.isPortrait
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return GetBuilder<FeedbackController>(
      builder: (controller) {
        final featuredFeedbacks = controller.featuredFeedbacks;
        
        if (featuredFeedbacks.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isPortrait ? screenWidth * 0.08 : screenHeight * 0.05,
            vertical: isPortrait ? screenHeight * 0.015 : screenHeight * 0.02,
          ),
          child: AnimationConfiguration.synchronized(
            duration: const Duration(milliseconds: 800),
            child: SlideAnimation(
              verticalOffset: 30.0,
              child: FadeInAnimation(
                child: Neumorphic(
                  style: NeumorphicStyle(
                    depth: 8,
                    intensity: 0.7,
                    shape: NeumorphicShape.flat,
                    boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.circular(16),
                    ),
                    color: Colors.white.withAlpha(230),
                    lightSource: LightSource.topLeft,
                    shadowDarkColor: Colors.black45,
                    shadowLightColor: Colors.transparent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.format_quote,
                              color: AppTheme.primaryColor,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'customer_feedback'.tr,
                              style: TextStyle(
                                fontSize: isPortrait ? 18 : 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...featuredFeedbacks.map((feedback) =>
                            _buildFeedbackItem(feedback, isPortrait)),
                        const SizedBox(height: 12),
                        Center(
                          child: TextButton.icon(
                            icon: const Icon(Icons.rate_review, size: 18),
                            label: Text('share_your_feedback'.tr),
                            onPressed: () => Get.to(() => const RateScreen()),
                            style: TextButton.styleFrom(
                              foregroundColor: AppTheme.primaryColor,
                            ),
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
      },
    );
  }
  Widget _buildFeedbackItem(FeedbackItem feedback, bool isPortrait) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.brown.shade50.withAlpha(153),
        borderRadius: BorderRadius.circular(12),
        // Eliminada la propiedad border que añadía un sutil efecto de sombra
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < feedback.rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  );
                }),
              ),
              const Spacer(),
              Text(
                _formatFeedbackDate(feedback.timestamp),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            feedback.message,
            style: TextStyle(
              fontSize: isPortrait ? 14 : 12,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  String _formatFeedbackDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;

    return '$year/$month/$day';
  }
}
