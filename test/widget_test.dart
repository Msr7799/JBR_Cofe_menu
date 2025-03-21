import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/main.dart';
import 'package:gpr_coffee_shop/controllers/settings_controller.dart';
import 'package:gpr_coffee_shop/services/local_storage_service.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // تهيئة المتحكمات
    final settingsController = Get.put(SettingsController(localStorageService));

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(settingsController: settingsController));

    // التأكد من أن التطبيق يعمل
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
