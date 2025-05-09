import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpr_coffee_shop/controllers/order_controller.dart';
import 'package:gpr_coffee_shop/controllers/product_controller.dart';
import 'package:gpr_coffee_shop/controllers/category_controller.dart';
import 'package:gpr_coffee_shop/widgets/admin/category_sales_chart.dart';
// إزالة استيراد chart_utils.dart و date_formatter.dart غير المستخدمين
import 'package:gpr_coffee_shop/utils/logger_util.dart';
// إزالة استيراد fl_chart.dart غير المستخدم

class SalesReportScreen extends StatefulWidget {
  const SalesReportScreen({Key? key}) : super(key: key);

  @override
  State<SalesReportScreen> createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  late final OrderController orderController;
  late final ProductController productController;
  late final CategoryController categoryController;

  // تعريف متغيرات التاريخ
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _endDate = DateTime.now();

  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();

    // تهيئة المتحكمات
    orderController = Get.find<OrderController>();
    productController = Get.find<ProductController>();
    categoryController = Get.find<CategoryController>();

    // تأخير تحميل البيانات لضمان اكتمال بناء الواجهة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // تحميل البيانات بطريقة هادئة
      await orderController.loadOrdersQuietly();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });

      LoggerUtil.logger.e('خطأ في تحميل البيانات: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تقارير المبيعات'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('حدث خطأ: $_error'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // عناصر التقرير

                        // مخطط المبيعات حسب الفئة - تمرير التواريخ بشكل صحيح
                        CategorySalesChart(
                          startDate: _startDate,
                          endDate: _endDate,
                        ),

                        // باقي عناصر التقرير
                      ],
                    ),
                  ),
                ),
    );
  }

  // استخدم هذه الدوال للتعامل مع تغيير نطاق التقرير
  void _updateDateRange(DateTime start, DateTime end) {
    setState(() {
      _startDate = start;
      _endDate = end;
    });
  }
}
