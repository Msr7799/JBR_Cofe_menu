<h1 style="color:#FF5252; font-size:36px; text-align:center;">⚠️ تحليل مشروع JBR Coffee Menu ⚠️</h1>
<p style="text-align:center; font-size:18px;">تقرير تحليل الأخطاء والتحذيرات في المشروع</p>
<hr style="border: 2px solid #FF5252;">

<!-- ملفات الثيم -->
<div style="background-color:#263238; color:white; padding:20px; margin-bottom:30px; border-radius:8px; border-left:8px solid #FF5252;">
<h2 style="color:#FF9800; font-size:28px;">📁 ملف الثيم (theme.dart)</h2>

<div style="background-color:#37474F; padding:15px; border-radius:5px;">
<pre style="color:#4FC3F7; margin:0;">
<span style="color:#B39DDB;">INFO:</span> استخدامات مهجورة (deprecated) - استبدل alpha بـ .a و red بـ .r و green بـ .g و blue بـ .b

<span style="color:#FFCC80;">- lib\constants\theme.dart:112:75 - استخدام alpha بدلاً من .a</span>
<span style="color:#FFCC80;">- lib\constants\theme.dart:112:107 - استخدام red بدلاً من .r</span>
<span style="color:#FFCC80;">- lib\constants\theme.dart:112:122 - استخدام green بدلاً من .g</span>
<span style="color:#FFCC80;">- lib\constants\theme.dart:112:139 - استخدام blue بدلاً من .b</span>

<span style="color:#F06292; font-weight:bold;">⚠️ تحذير:</span> المتغير المحلي 'textColor' غير مستخدم - lib\constants\theme.dart:121:11

</pre>
</div>
</div>

<!-- ملفات المتحكم -->
<div style="background-color:#1A237E; color:white; padding:20px; margin-bottom:30px; border-radius:8px; border-left:8px solid #7986CB;">
<h2 style="color:#29B6F6; font-size:28px;">📁 ملفات المتحكم (Controllers)</h2>

<div style="background-color:#283593; padding:15px; border-radius:5px;">
<pre style="color:#B3E5FC; margin:0;">
<span style="color:#B39DDB;">INFO:</span> استخدمات withOpacity مهجورة - استبدل بـ withValues() لتجنب فقدان الدقة

<span style="color:#81D4FA;">- lib\controllers\auth_controller.dart:419:39 - استخدام withOpacity</span>
<span style="color:#81D4FA;">- lib\controllers\auth_controller.dart:509:39 - استخدام withOpacity</span>
<span style="color:#81D4FA;">- lib\controllers\auth_controller.dart:578:39 - استخدام withOpacity</span>
<span style="color:#81D4FA;">- lib\controllers\auth_controller.dart:694:39 - استخدام withOpacity</span>

<span style="color:#9FA8DA;">INFO:</span> استخدام print في كود الإنتاج - lib\controllers\feedback_controller.dart:84:9

<span style="color:#F48FB1; font-weight:bold;">⚠️ تحذير:</span> قيمة الحقل '\_autoCompleteOrders' غير مستخدمة - lib\controllers\order_controller.dart:21:14
<span style="color:#F48FB1; font-weight:bold;">⚠️ تحذير:</span> هذا الشرط الافتراضي مغطى بالحالات السابقة - lib\controllers\order_controller.dart:850:7

</pre>
</div>
</div>

<!-- ملفات النماذج -->
<div style="background-color:#004D40; color:white; padding:20px; margin-bottom:30px; border-radius:8px; border-left:8px solid #009688;">
<h2 style="color:#26A69A; font-size:28px;">📁 ملفات النماذج (Models)</h2>

<div style="background-color:#00695C; padding:15px; border-radius:5px;">
<pre style="color:#B2DFDB; margin:0;">
<span style="color:#B39DDB;">INFO:</span> اسم الثابت 'default_bg' ليس معرّفًا بتنسيق lowerCamelCase - lib\models\app_settings.dart:10:3

<span style="color:#80CBC4;">INFO:</span> استدعاء 'print' في كود الإنتاج - lib\models\app_settings.dart:112:9

<span style="color:#80CBC4;">INFO:</span> 'value' مهجور ولا ينبغي استخدامه - استخدم وصول المكونات مثل .r أو .g - lib\models\menu_option.dart:32:22

</pre>
</div>
</div>

<!-- شاشات الإدارة -->
<div style="background-color:#3E2723; color:white; padding:20px; margin-bottom:30px; border-radius:8px; border-left:8px solid #8D6E63;">
<h2 style="color:#FFAB91; font-size:28px;">📁 شاشات الإدارة (Admin Screens)</h2>

<div style="background-color:#4E342E; padding:15px; border-radius:5px;">
<pre style="color:#FFCCBC; margin:0;">
<span style="color:#F48FB1; font-weight:bold;">⚠️ تحذير:</span> القيم غير المستخدمة في شاشة لوحة التحكم:
<span style="color:#FFAB91;">- lib\screens\admin\admin_dashboard.dart:67:23 - الحقل '_tinyPadding' غير مستخدم</span>
<span style="color:#FFAB91;">- lib\screens\admin\admin_dashboard.dart:68:23 - الحقل '_defaultIconSize' غير مستخدم</span>
<span style="color:#FFAB91;">- lib\screens\admin\admin_dashboard.dart:69:23 - الحقل '_smallIconSize' غير مستخدم</span>

<span style="color:#B39DDB;">INFO:</span> استخدمات withOpacity مهجورة - استبدل بـ withValues() في شاشات الإدارة المختلفة:
<span style="color:#BCAAA4;">- admin_dashboard.dart (خطوط متعددة)</span>
<span style="color:#BCAAA4;">- admin_notes.dart (خطوط متعددة)</span>
<span style="color:#BCAAA4;">- category_management.dart (خطوط متعددة)</span>
<span style="color:#BCAAA4;">- login_screen.dart (خطوط متعددة)</span>
<span style="color:#BCAAA4;">- order_management_screen.dart (خطوط متعددة)</span>
<span style="color:#BCAAA4;">- product_management.dart (خطوط متعددة)</span>
<span style="color:#BCAAA4;">- sync_screen.dart (خطوط متعددة)</span>

<span style="color:#F48FB1; font-weight:bold;">⚠️ تحذير:</span> تعريفات غير مستخدمة في شاشة إدارة المنتجات:
<span style="color:#FFAB91;">- lib\screens\admin\product_management.dart:275:8 - '\_showFilterDialog'</span>
<span style="color:#FFAB91;">- lib\screens\admin\product_management.dart:1369:10 - '\_buildSelectedFiltersBar'</span>

<span style="color:#F48FB1; font-weight:bold;">⚠️ تحذير:</span> التعريف '\_updateDateRange' غير مستخدم - lib\screens\admin\sales_report_screen.dart:100:8

</pre>
</div>
</div>

<!-- الشاشة الرئيسية والواجهة -->
<div style="background-color:#311B92; color:white; padding:20px; margin-bottom:30px; border-radius:8px; border-left:8px solid #9575CD;">
<h2 style="color:#B388FF; font-size:28px;">📁 الشاشة الرئيسية والواجهة (Home Screen & UI)</h2>

<div style="background-color:#4527A0; padding:15px; border-radius:5px;">
<pre style="color:#E1BEE7; margin:0;">
<span style="color:#B39DDB;">INFO:</span> استخدام نوع خاص في واجهة برمجة عامة - lib\screens\home_screen.dart:34:3

<span style="color:#B39DDB;">INFO:</span> العديد من استخدامات withOpacity المهجورة في ملفات واجهة المستخدم المختلفة:
<span style="color:#D1C4E9;">- lib\widgets\home\home_menu_options.dart (خطوط متعددة)</span>
<span style="color:#D1C4E9;">- lib\widgets\home\home_menu_options_fixed.dart (خطوط متعددة)</span>
<span style="color:#D1C4E9;">- lib\widgets\home\home_menu_options_new.dart (خطوط متعددة)</span>
<span style="color:#D1C4E9;">- lib\widgets\home\home_actions.dart (خطوط متعددة)</span>
<span style="color:#D1C4E9;">- lib\widgets\pending_orders_panel.dart (خطوط متعددة)</span>
<span style="color:#D1C4E9;">- lib\widgets\enhanced_product_card.dart (خطوط متعددة)</span>

</pre>
</div>
</div>

<!-- ملفات الاختبار والنصوص البرمجية -->
<div style="background-color:#BF360C; color:white; padding:20px; margin-bottom:30px; border-radius:8px; border-left:8px solid #FF8A65;">
<h2 style="color:#FFAB91; font-size:28px;">📁 ملفات الاختبار والنصوص البرمجية (Test & Scripts)</h2>

<div style="background-color:#E64A19; padding:15px; border-radius:5px;">
<pre style="color:#FFCCBC; margin:0;">
<span style="color:#B39DDB;">INFO:</span> بناء جملة تعبير منتظم غير صالح - test\scripts\translation_checker.dart:7:22

<span style="color:#B39DDB;">INFO:</span> استخدام 'print' في نصوص برمجية متعددة:
<span style="color:#FFCCBC;">- test\scripts\translation_checker.dart:26:3</span>
<span style="color:#FFCCBC;">- test\scripts\translation_checker.dart:33:7</span>
<span style="color:#FFCCBC;">- test\scripts\translation_checker.dart:38:5</span>
<span style="color:#FFCCBC;">- test\scripts\translation_checker.dart:40:5</span>
<span style="color:#FFCCBC;">- test\scripts\translation_checker.dart:43:7</span>
<span style="color:#FFCCBC;">- test\scripts\translation_checker.dart:44:7</span>

</pre>
</div>
</div>

<h2 style="color:#7CB342; font-size:28px; text-align:center;">ملخص التحسينات المطلوبة</h2>

<div style="background-color:#ECEFF1; padding:20px; border-radius:8px; margin-bottom:30px;">
<ol style="color:#263238; font-size:16px;">
  <li style="margin-bottom:10px;"><strong style="color:#D32F2F">استبدال الدوال المهجورة:</strong> استخدم .a بدلاً من alpha، .r بدلاً من red، .g بدلاً من green، .b بدلاً من blue</li>
  <li style="margin-bottom:10px;"><strong style="color:#D32F2F">استبدال withOpacity:</strong> استخدم withValues() بدلاً من withOpacity في جميع الملفات</li>
  <li style="margin-bottom:10px;"><strong style="color:#D32F2F">إزالة المتغيرات غير المستخدمة:</strong> textColor، _autoCompleteOrders، _tinyPadding، _defaultIconSize، _smallIconSize</li>
  <li style="margin-bottom:10px;"><strong style="color:#D32F2F">إزالة الدوال غير المستخدمة:</strong> _showFilterDialog، _buildSelectedFiltersBar، _updateDateRange</li>
  <li style="margin-bottom:10px;"><strong style="color:#D32F2F">إزالة استخدام print:</strong> استبدل print بـ logger في كود الإنتاج</li>
  <li style="margin-bottom:10px;"><strong style="color:#D32F2F">إصلاح أنماط التسمية:</strong> استخدم lowerCamelCase للثوابت مثل default_bg</li>
  <li style="margin-bottom:10px;"><strong style="color:#D32F2F">إصلاح التعبيرات المنتظمة:</strong> إصلاح بناء جملة التعبير المنتظم في translation_checker.dart</li>
</ol>
</div>

<div style="background-color:#E8F5E9; padding:20px; border-radius:8px;">
<h3 style="color:#2E7D32; text-align:center;">خطة العمل</h3>
<p style="color:#1B5E20; text-align:center; font-size:16px;">
1. بدء العمل بمعالجة استخدام الدوال المهجورة (alpha، red، green، blue) في ملف theme.dart<br>
2. استبدال استخدامات withOpacity بـ withValues() في جميع الملفات<br>
3. إزالة المتغيرات والدوال غير المستخدمة<br>
4. استبدال استخدامات print بـ logger<br>
5. إصلاح أنماط التسمية والتعبيرات المنتظمة
</p>
</div>
