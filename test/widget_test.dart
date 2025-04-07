import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/main.dart';
import 'package:gpr_coffee_shop/controllers/settings_controller.dart';
import 'package:gpr_coffee_shop/services/local_storage_service.dart';
import 'package:gpr_coffee_shop/services/shared_preferences_service.dart';
import 'package:gpr_coffee_shop/services/app_translation_service.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Initialize services
    await Get.putAsync(() => SharedPreferencesService().init());
    
    // Initialize and register services
    final localStorageService = LocalStorageService();
    await localStorageService.init();
    Get.put(localStorageService);
    
    // Register translation service
    Get.put(AppTranslationService());
    
    // Register settings controller
    Get.put(SettingsController());

    // Build our app and trigger a frame
    await tester.pumpWidget(MyApp());

    // Verify that the app starts
    expect(find.byType(GetMaterialApp), findsOneWidget);
  });
}
