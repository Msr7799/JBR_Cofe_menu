<h1 style="color:#FF5252; font-size:36px; text-ali er;">⚠️ تحليل مشروع JBR Coffee Menu ⚠️</h1>
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
<span style="color:#FFCC80;">- lib\constants\theme.dart:115:76 - استخدام alpha بدلاً من .a</span>
<span style="color:#FFCC80;">- lib\constants\theme.dart:115:108 - استخدام red بدلاً من .r</span>
<span style="color:#FFCC80;">- lib\constants\theme.dart:115:123 - استخدام green بدلاً من .g</span>
<span style="color:#FFCC80;">- lib\constants\theme.dart:115:140 - استخدام blue بدلاً من .b</span>

<span style="color:#F06292; font-weight:bold;">⚠️ تحذير:</span> المتغير المحلي 'textColor' غير مستخدم - lib\constants\theme.dart:121:11

<span style="color:#FFCC80;">- lib\constants\theme.dart:143:58 - استخدام alpha بدلاً من .a</span>
<span style="color:#FFCC80;">- lib\constants\theme.dart:143:101 - استخدام red بدلاً من .r</span>
<span style="color:#FFCC80;">- lib\constants\theme.dart:143:126 - استخدام green بدلاً من .g</span>
<span style="color:#FFCC80;">- lib\constants\theme.dart:143:153 - استخدام blue بدلاً من .b</span>
<span style="color:#FFCC80;">- lib\constants\theme.dart:146:71 - استخدام alpha بدلاً من .a</span>
<span style="color:#FFCC80;">- lib\constants\theme.dart:146:114 - استخدام red بدلاً من .r</span>
<span style="color:#FFCC80;">- lib\constants\theme.dart:146:139 - استخدام green بدلاً من .g</span>
<span style="color:#FFCC80;">- lib\constants\theme.dart:146:166 - استخدام blue بدلاً من .b</span>
<span style="color:#FFCC80;">- lib\constants\theme.dart:153:72 - استخدام alpha بدلاً من .a</span>
<span style="color:#FFCC80;">- lib\constants\theme.dart:153:113 - استخدام red بدلاً من .r</span>
<span style="color:#FFCC80;">- lib\constants\theme.dart:153:137 - استخدام green بدلاً من .g</span>
<span style="color:#FFCC80;">- lib\constants\theme.dart:153:163 - استخدام blue بدلاً من .b</span>
<span style="color:#FFCC80;">- lib\constants\theme.dart:157:77 - استخدام alpha بدلاً من .a</span>
<span style="color:#FFCC80;">- lib\constants\theme.dart:157:119 - استخدام red بدلاً من .r</span>
<span style="color:#FFCC80;">- lib\constants\theme.dart:157:144 - استخدام green بدلاً من .g</span>
<span style="color:#FFCC80;">- lib\constants\theme.dart:157:171 - استخدام blue بدلاً من .b</span>
</pre>
</div>

<div style="background-color:#37474F; padding:15px; border-radius:5px; margin-top:15px;">
<pre style="color:#4FC3F7; margin:0;">
<span style="color:#B39DDB;">INFO:</span> دوال ألوان مهجورة متعددة المواقع

<span style="color:#FFCC80;">- lib\constants\theme.dart:161</span>
<span style="color:#FFCC80;">- lib\constants\theme.dart:238</span>
<span style="color:#FFCC80;">- lib\constants\theme.dart:240</span>
<span style="color:#FFCC80;">- lib\constants\theme.dart:243</span>
<span style="color:#FFCC80;">- lib\constants\theme.dart:294</span>
<span style="color:#FFCC80;">- lib\constants\theme.dart:296</span>
<span style="color:#FFCC80;">- lib\constants\theme.dart:299</span>
<span style="color:#FFCC80;">- lib\constants\theme.dart:350</span>
<span style="color:#FFCC80;">- lib\constants\theme.dart:352</span>
</pre>
</div>
</div>
</code>
</pre>

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
<span style="color:#81D4FA;">- lib\controllers\settings_controller.dart:648:31 - استخدام withOpacity</span>

<span style="color:#9FA8DA;">INFO:</span> استخدام print في كود الإنتاج - lib\controllers\feedback_controller.dart:84:9

<span style="color:#F48FB1; font-weight:bold;">⚠️ تحذير:</span> قيمة الحقل '\_autoCompleteOrders' غير مستخدمة - lib\controllers\order_controller.dart:21:14
<span style="color:#F48FB1; font-weight:bold;">⚠️ تحذير:</span> هذا الشرط الافتراضي مغطى بالحالات السابقة - lib\controllers\order_controller.dart:850:7
</code>
</pre>

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
</code>
</pre>

</pre>
</div>
</div>

<!-- شاشات الإدارة -->
<div style="background-color:#3E2723; color:white; padding:20px; margin-bottom:30px; border-radius:8px; border-left:8px solid #8D6E63;">
<h2 style="color:#FFAB91; font-size:28px;">📁 شاشات الإدارة (Admin Screens)</h2>

<div style="background-color:#4E342E; padding:15px; border-radius:5px;">
<pre style="color:#FFCCBC; margin:0;">
<span style="color:#F48FB1; font-weight:bold;">⚠️ تحذير:</span> حقول غير مستخدمة في شاشة لوحة التحكم:
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

<span style="color:#F48FB1; font-weight:bold;">⚠️ تحذير:</span> تصريحات غير مستخدمة:
<span style="color:#FFAB91;">- lib\screens\admin\product_management.dart:275:8 - الدالة '_showFilterDialog'</span>
<span style="color:#FFAB91;">- lib\screens\admin\product_management.dart:1369:10 - الدالة '_buildSelectedFiltersBar'</span>
<span style="color:#FFAB91;">- lib\screens\admin\sales_report_screen.dart:100:8 - الدالة '_updateDateRange'</span>

<span style="color:#F48FB1; font-weight:bold;">⚠️ تحذير:</span> قيمة المتغير المحلي 'totalItems' غير مستخدمة - lib\screens\admin\order_management_screen.dart:167:11

<span style="color:#B39DDB;">INFO:</span> اسم النوع '_ordersBox' ليس معرّفًا بتنسيق UpperCamelCase - lib\screens\admin\order_management_screen.dart:700:7

<span style="color:#B39DDB;">INFO:</span> استخدام نوع خاص في واجهة برمجة عامة - lib\screens\admin\admin_notes.dart:10:3
</code>
</pre>

</pre>
</div>
</div>

<!-- شاشات الرئيسية والعملاء -->
<div style="background-color:#1B5E20; color:white; padding:20px; margin-bottom:30px; border-radius:8px; border-left:8px solid #388E3C;">
<h2 style="color:#81C784; font-size:28px;">📁 شاشات الرئيسية والعملاء (Home & Customer)</h2>

<div style="background-color:#2E7D32; padding:15px; border-radius:5px;">
<pre style="color:#C8E6C9; margin:0;">
<span style="color:#F48FB1; font-weight:bold;">⚠️ تحذير:</span> متغيرات وتصريحات متعددة غير مستخدمة في home_screen.dart:
<span style="color:#A5D6A7;">- '_showViewOptionsDialog' - دالة غير مستخدمة</span>
<span style="color:#A5D6A7;">- 'screenMetrics', 'textColor', 'isVerySmallScreen', 'isTablet', 'isDesktop', 'isLargeScreen' - متغيرات غير مستخدمة</span>
<span style="color:#A5D6A7;">- '_buildNavigationButton', '_buildOptionCard', '_getAdaptiveBackgroundColor', '_getAdaptiveTextColor' - دوال غير مستخدمة</span>

<span style="color:#B39DDB;">INFO:</span> فحوصات النل الزائدة والكود الميت موجودة - lib\screens\home_screen.dart:2058:11, 2534:35

<span style="color:#B39DDB;">INFO:</span> استخدام BuildContext عبر فجوات async - lib\screens\home_screen.dart:2293:22, 2369:22

<span style="color:#B39DDB;">INFO:</span> استخدمات withOpacity مهجورة في عدة مواقع في home_screen.dart - استبدل بـ withValues()

<span style="color:#F48FB1; font-weight:bold;">⚠️ تحذير:</span> متغيرات غير مستخدمة في view_options_screen.dart:
<span style="color:#A5D6A7;">- '_buildCardSizeSlider', '_buildHomeScreenOptions', '_buildMenuOptionsBackground', '_buildMenuOptionsPreview'</span>

<span style="color:#B39DDB;">INFO:</span> 'value' و 'showLabel' مهجوران في view_options_screen.dart - استخدم وصول المكونات بدلاً من ذلك
</code>
</pre>

<h1 style="color:#5D4037; font-size:32px;">🔧 Utils & Widget Issues</h1>

<pre style="font-size: 28px; color: #D7CCC8; background-color:#3E2723;">
<code>
  warning - Equal keys in map literals - lib\utils\app_translations.dart (multiple instances: 211:11, 642:11, 643:11, 644:11, 816:11)
  
  warning - Unused declarations in image_helper.dart:
    - '_buildLoadingWidget', '_defaultErrorWidget'
    
  info - Use of deprecated 'renderView' and 'window' - consider using RendererBinding.renderViews and View.of(context)
  
  warning - Unused fields in view_options_helper.dart:
    - '_defaultProductCardWidth', '_defaultProductCardHeight', '_defaultProductImageHeight'
    
  warning - Unused fields and declarations in enhanced_product_card.dart:
    - '_scaleAnimation', '_cardSize', '_useAnimations', '_showEnlargedImage', '_buildProductInfo'
    
  info - 'withOpacity' usage throughout widgets should be replaced with 'withValues()'
   info - Don't invoke 'print' in production code - lib\screens\admin\category_management.dart:219:11 - avoid_print
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\admin\category_management.dart:321:61 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\admin\login_screen.dart:179:39 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\admin\login_screen.dart:180:41 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\admin\login_screen.dart:207:49 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\admin\login_screen.dart:444:42 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\admin\order_history.dart:100:46 - deprecated_member_use
warning - The value of the local variable 'totalItems' isn't used - lib\screens\admin\order_management_screen.dart:167:11 - unused_local_variable
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\admin\order_management_screen.dart:385:43 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\admin\order_management_screen.dart:406:41 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\admin\order_management_screen.dart:423:42 - deprecated_member_use
   info - The type name '_ordersBox' isn't an UpperCamelCase identifier - lib\screens\admin\order_management_screen.dart:700:7 - camel_case_types
   info - An uninitialized field should have an explicit type annotation - lib\screens\admin\order_management_screen.dart:701:14 - prefer_typing_uninitialized_variables
warning - The declaration '_showFilterDialog' isn't referenced - lib\screens\admin\product_management.dart:275:8 - unused_element
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\admin\product_management.dart:509:63 - deprecated_member_use
warning - The declaration '_buildSelectedFiltersBar' isn't referenced - lib\screens\admin\product_management.dart:1369:10 - unused_element
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\admin\product_management.dart:1397:56 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\admin\product_management.dart:1757:60 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\admin\product_management.dart:1778:50 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\admin\product_management.dart:1779:48 - deprecated_member_use
warning - The declaration '_updateDateRange' isn't referenced - lib\screens\admin\sales_report_screen.dart:100:8 - unused_element
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\admin\sync_screen.dart:78:37 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\admin\sync_screen.dart:79:39 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\admin\sync_screen.dart:97:41 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\admin\sync_screen.dart:164:43 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\admin\sync_screen.dart:311:29 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\customer\menu_screen.dart:371:49 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\customer\menu_screen.dart:422:49 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\customer\menu_screen.dart:904:48 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\customer\menu_screen.dart:982:51 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\customer\menu_screen.dart:1039:56 - deprecated_member_use
   info - Don't invoke 'print' in production code - lib\screens\customer\menu_screen.dart:1266:13 - avoid_print
   info - Don't invoke 'print' in production code - lib\screens\customer\menu_screen.dart:1276:13 - avoid_print
   info - Don't invoke 'print' in production code - lib\screens\customer\menu_screen.dart:1282:7 - avoid_print
   info - Invalid use of a private type in a public API - lib\screens\home_screen.dart:34:3 - library_private_types_in_public_api
warning - The declaration '_showViewOptionsDialog' isn't referenced - lib\screens\home_screen.dart:140:8 - unused_element
warning - The value of the local variable 'screenMetrics' isn't used - lib\screens\home_screen.dart:223:11 - unused_local_variable
warning - The value of the local variable 'textColor' isn't used - lib\screens\home_screen.dart:231:15 - unused_local_variable
warning - The value of the local variable 'isVerySmallScreen' isn't used - lib\screens\home_screen.dart:236:20 - unused_local_variable
warning - The value of the local variable 'isTablet' isn't used - lib\screens\home_screen.dart:237:20 - unused_local_variable
warning - The value of the local variable 'isDesktop' isn't used - lib\screens\home_screen.dart:238:20 - unused_local_variable
warning - The value of the local variable 'isLargeScreen' isn't used - lib\screens\home_screen.dart:559:16 - unused_local_variable
warning - The value of the local variable 'isTablet' isn't used - lib\screens\home_screen.dart:742:16 - unused_local_variable
warning - The value of the local variable 'isDesktop' isn't used - lib\screens\home_screen.dart:743:16 - unused_local_variable
warning - The value of the local variable 'index' isn't used - lib\screens\home_screen.dart:859:39 - unused_local_variable
warning - The declaration '_buildNavigationButton' isn't referenced - lib\screens\home_screen.dart:1273:10 - unused_element
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\home_screen.dart:1417:40 - deprecated_member_use
warning - The declaration '_buildOptionCard' isn't referenced - lib\screens\home_screen.dart:1509:10 - unused_element
warning - The declaration '_getAdaptiveBackgroundColor' isn't referenced - lib\screens\home_screen.dart:1559:9 - unused_element
warning - The declaration '_getAdaptiveTextColor' isn't referenced - lib\screens\home_screen.dart:1585:9 - unused_element
warning - The value of the local variable 'currentLogo' isn't used - lib\screens\home_screen.dart:1621:11 - unused_local_variable
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\home_screen.dart:1795:39 - deprecated_member_use
warning - The value of the local variable 'textColor' isn't used - lib\screens\home_screen.dart:1818:11 - unused_local_variable
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\home_screen.dart:1842:33 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\home_screen.dart:1955:33 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\home_screen.dart:1958:44 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\home_screen.dart:1963:37 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\home_screen.dart:1991:34 - deprecated_member_use
warning - The operand must be 'null', so the condition is always 'false' - lib\screens\home_screen.dart:2058:11 - unnecessary_null_comparison
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\home_screen.dart:2106:37 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\home_screen.dart:2217:58 - deprecated_member_use
   info - Don't use 'BuildContext's across async gaps - lib\screens\home_screen.dart:2293:22 - use_build_context_synchronously
   info - Don't use 'BuildContext's across async gaps - lib\screens\home_screen.dart:2369:22 - use_build_context_synchronously
warning - Dead code - lib\screens\home_screen.dart:2534:35 - dead_code
warning - The value of the local variable 'iconSize' isn't used - lib\screens\home_screen.dart:2572:11 - unused_local_variable
warning - The value of the local variable 'isArabic' isn't used - lib\screens\home_screen.dart:2585:11 - unused_local_variable
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\home_screen.dart:2624:45 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\home_screen.dart:2651:55 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\home_screen.dart:2666:63 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\home_screen.dart:2700:53 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\home_screen.dart:2715:63 - deprecated_member_use
   info - Use 'const' with the constructor to improve performance - lib\screens\home_screen.dart:2782:23 - prefer_const_constructors
   info - Use 'const' with the constructor to improve performance - lib\screens\home_screen.dart:2794:13 - prefer_const_constructors
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\home_screen.dart:2808:39 - deprecated_member_use
   info - Use a 'SizedBox' to add whitespace to a layout - lib\screens\home_screen.dart:2871:23 - sized_box_for_whitespace
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\home_screen.dart:2885:59 - deprecated_member_use
   info - Use 'const' with the constructor to improve performance - lib\screens\home_screen.dart:2889:49 - prefer_const_constructors
   info - Use 'const' with the constructor to improve performance - lib\screens\home_screen.dart:2893:46 - prefer_const_constructors
   info - Use 'const' with the constructor to improve performance - lib\screens\home_screen.dart:2897:35 - prefer_const_constructors
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\home_screen.dart:2943:63 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\home_screen.dart:2948:50 - deprecated_member_use
   info - Use 'const' with the constructor to improve performance - lib\screens\home_screen.dart:2950:29 - prefer_const_constructors
   info - Use a 'SizedBox' to add whitespace to a layout - lib\screens\home_screen.dart:2956:15 - sized_box_for_whitespace
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\home_screen.dart:3077:30 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\home_screen.dart:3085:39 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\home_screen.dart:3105:42 - deprecated_member_use
warning - The value of the local variable 'screenHeight' isn't used - lib\screens\home_screen.dart:3204:11 - unused_local_variable
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\home_screen.dart:3227:28 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\home_screen.dart:3238:33 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\home_screen.dart:3259:96 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\location_screen.dart:296:42 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\location_screen.dart:297:42 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\location_screen.dart:413:22 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\location_screen.dart:703:22 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\location_screen.dart:712:37 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\location_screen.dart:715:39 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\location_screen.dart:756:38 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\location_screen.dart:766:38 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\location_screen.dart:808:30 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\location_screen.dart:821:38 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\settings_screen.dart:607:43 - deprecated_member_use
warning - The declaration '_buildColorPickerItem' isn't referenced - lib\screens\settings_screen.dart:1181:10 - unused_element
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\settings_screen.dart:1205:39 - deprecated_member_use
warning - The method doesn't override an inherited method - lib\screens\view_options_screen.dart:64:8 - override_on_non_overriding_member
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\view_options_screen.dart:220:53 - deprecated_member_use
warning - The declaration '_buildCardSizeSlider' isn't referenced - lib\screens\view_options_screen.dart:365:10 - unused_element
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\view_options_screen.dart:409:46 - deprecated_member_use
   info - 'value' is deprecated and shouldn't be used. Use component accessors like .r or .g, or toARGB32 for an explicit conversion - lib\screens\view_options_screen.dart:635:51 - deprecated_member_use
   info - 'value' is deprecated and shouldn't be used. Use component accessors like .r or .g, or toARGB32 for an explicit conversion - lib\screens\view_options_screen.dart:650:52 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\view_options_screen.dart:717:39 - deprecated_member_use
warning - The declaration '_buildHomeScreenOptions' isn't referenced - lib\screens\view_options_screen.dart:885:10 - unused_element
   info - 'value' is deprecated and shouldn't be used. Use component accessors like .r or .g, or toARGB32 for an explicit conversion - lib\screens\view_options_screen.dart:927:33 - deprecated_member_use
   info - 'value' is deprecated and shouldn't be used. Use component accessors like .r or .g, or toARGB32 for an explicit conversion - lib\screens\view_options_screen.dart:949:39 - deprecated_member_use
   info - 'value' is deprecated and shouldn't be used. Use component accessors like .r or .g, or toARGB32 for an explicit conversion - lib\screens\view_options_screen.dart:969:33 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\view_options_screen.dart:1065:38 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\view_options_screen.dart:1076:53 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\view_options_screen.dart:1098:56 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\view_options_screen.dart:1139:38 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\view_options_screen.dart:1150:53 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\view_options_screen.dart:1172:56 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\view_options_screen.dart:1250:42 - deprecated_member_use
   info - 'showLabel' is deprecated and shouldn't be used. Use empty list in [labelTypes] to disable label - lib\screens\view_options_screen.dart:1382:15 - deprecated_member_use
warning - The declaration '_buildMenuOptionsBackground' isn't referenced - lib\screens\view_options_screen.dart:1477:10 - unused_element
   info - 'value' is deprecated and shouldn't be used. Use component accessors like .r or .g, or toARGB32 for an explicit conversion - lib\screens\view_options_screen.dart:1493:33 - deprecated_member_use
warning - The declaration '_buildMenuOptionsPreview' isn't referenced - lib\screens\view_options_screen.dart:1694:10 - unused_element
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\view_options_screen.dart:1737:38 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\view_options_screen.dart:1747:53 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\view_options_screen.dart:1801:38 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\screens\view_options_screen.dart:1811:53 - deprecated_member_use
   info - 'value' is deprecated and shouldn't be used. Use component accessors like .r or .g, or toARGB32 for an explicit conversion - lib\screens\view_options_screen.dart:1881:33 - deprecated_member_use
   info - 'value' is deprecated and shouldn't be used. Use component accessors like .r or .g, or toARGB32 for an explicit conversion - lib\screens\view_options_screen.dart:1915:39 - deprecated_member_use
   info - 'value' is deprecated and shouldn't be used. Use component accessors like .r or .g, or toARGB32 for an explicit conversion - lib\screens\view_options_screen.dart:1936:33 - deprecated_member_use
   info - 'value' is deprecated and shouldn't be used. Use component accessors like .r or .g, or toARGB32 for an explicit conversion - lib\screens\view_options_screen.dart:2010:33 - deprecated_member_use
   info - The constant name 'PRODUCTS_BOX' isn't a lowerCamelCase identifier - lib\services\local_storage_service.dart:10:23 - constant_identifier_names
   info - The constant name 'CATEGORIES_BOX' isn't a lowerCamelCase identifier - lib\services\local_storage_service.dart:11:23 - constant_identifier_names
   info - The constant name 'ORDERS_BOX' isn't a lowerCamelCase identifier - lib\services\local_storage_service.dart:12:23 - constant_identifier_names
   info - The constant name 'SETTINGS_BOX' isn't a lowerCamelCase identifier - lib\services\local_storage_service.dart:13:23 - constant_identifier_names
   info - The constant name 'CART_BOX' isn't a lowerCamelCase identifier - lib\services\local_storage_service.dart:14:23 - constant_identifier_names
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\services\notification_service.dart:31:38 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\services\notification_service.dart:57:35 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\services\notification_service.dart:72:35 - deprecated_member_use
warning - Two keys in a map literal shouldn't be equal - lib\utils\app_translations.dart:211:11 - equal_keys_in_map
warning - Two keys in a map literal shouldn't be equal - lib\utils\app_translations.dart:642:11 - equal_keys_in_map
warning - Two keys in a map literal shouldn't be equal - lib\utils\app_translations.dart:643:11 - equal_keys_in_map
warning - Two keys in a map literal shouldn't be equal - lib\utils\app_translations.dart:644:11 - equal_keys_in_map
warning - Two keys in a map literal shouldn't be equal - lib\utils\app_translations.dart:816:11 - equal_keys_in_map
warning - The declaration '_buildLoadingWidget' isn't referenced - lib\utils\image_helper.dart:375:17 - unused_element
warning - The declaration '_defaultErrorWidget' isn't referenced - lib\utils\image_helper.dart:388:17 - unused_element
   info - Don't invoke 'print' in production code - lib\utils\platform_fix_util.dart:14:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\utils\platform_fix_util.dart:44:7 - avoid_print
   info - 'renderView' is deprecated and shouldn't be used. Consider using RendererBinding.renderViews instead as the binding may manage multiple RenderViews. This feature was deprecated after v3.10.0-12.0.pre - lib\utils\rendering_helper.dart:100:29 - deprecated_member_use
   info - 'window' is deprecated and shouldn't be used. Look up the current FlutterView from the context via View.of(context) or consult the PlatformDispatcher directly instead. Deprecated to prepare for the upcoming multi-window support. This feature was deprecated after v3.7.0-32.0.pre - lib\utils\rendering_helper.dart:126:12 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\utils\rendering_helper.dart:192:39 - deprecated_member_use
warning - The value of the field '_defaultProductCardWidth' isn't used - lib\utils\view_options_helper.dart:21:23 - unused_field
warning - The value of the field '_defaultProductCardHeight' isn't used - lib\utils\view_options_helper.dart:22:23 - unused_field
warning - The value of the field '_defaultProductImageHeight' isn't used - lib\utils\view_options_helper.dart:23:23 - unused_field
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\widgets\admin\data_card.dart:113:51 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\widgets\admin\data_card.dart:238:34 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\widgets\admin\data_card.dart:269:50 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\widgets\admin\data_card.dart:270:48 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\widgets\admin\data_card.dart:425:53 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\widgets\admin\sales_chart.dart:148:33 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\widgets\category_card.dart:71:41 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\widgets\category_card.dart:72:32 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\widgets\category_card.dart:78:45 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\widgets\category_card.dart:79:35 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\widgets\category_card.dart:101:44 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\widgets\category_card.dart:119:53 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\widgets\category_card.dart:170:51 - deprecated_member_use
   info - Don't invoke 'print' in production code - lib\widgets\category_card.dart:222:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\widgets\category_card.dart:232:11 - avoid_print
warning - The value of the field '_scaleAnimation' isn't used - lib\widgets\enhanced_product_card.dart:39:26 - unused_field
warning - The value of the field '_cardSize' isn't used - lib\widgets\enhanced_product_card.dart:47:15 - unused_field
warning - The value of the field '_useAnimations' isn't used - lib\widgets\enhanced_product_card.dart:49:13 - unused_field
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\widgets\enhanced_product_card.dart:200:34 - deprecated_member_use
warning - The value of the local variable 'imageHeight' isn't used - lib\widgets\enhanced_product_card.dart:323:12 - unused_local_variable
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\widgets\enhanced_product_card.dart:382:39 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\widgets\enhanced_product_card.dart:530:37 - deprecated_member_use
warning - The declaration '_showEnlargedImage' isn't referenced - lib\widgets\enhanced_product_card.dart:538:8 - unused_element
warning - The declaration '_buildProductInfo' isn't referenced - lib\widgets\enhanced_product_card.dart:716:10 - unused_element
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\widgets\home_drawer.dart:142:38 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\widgets\home_drawer.dart:145:42 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\widgets\home_drawer.dart:249:43 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\widgets\home_drawer.dart:253:45 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\widgets\home_drawer.dart:271:49 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\widgets\home_drawer.dart:272:39 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\widgets\home_drawer.dart:415:37 - deprecated_member_use
warning - The value of the local variable 'statusText' isn't used - lib\widgets\pending_orders_panel.dart:105:12 - unused_local_variable
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\widgets\pending_orders_panel.dart:191:22 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\widgets\pending_orders_panel.dart:204:32 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\widgets\pending_orders_panel.dart:217:28 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\widgets\platform_map_widget.dart:116:41 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\widgets\platform_map_widget.dart:136:41 - deprecated_member_use
</code>
</pre>

<h1 style="color:#BF360C; font-size:32px;">🧪 Test Files Issues</h1>

<pre style="font-size: 28px; color: #FFCCBC; background-color:#E64A19;">
<code>
  info - Invalid regular expression syntax - test\scripts\translation_checker.dart:7:22
  
  info - Multiple 'print' statements in test code:
    - test\scripts\translation_checker.dart:26:3
    - test\scripts\translation_checker.dart:33:7
    - test\scripts\translation_checker.dart:38:5
    - test\scripts\translation_checker.dart:40:5
    - test\scripts\translation_checker.dart:43:7
    - test\scripts\translation_checker.dart:44:7
</code>
</pre>

<h2 style="color:#7CB342; font-size:28px; text-align:center;">ملخص التحسينات المطلوبة</h2>

<div style="background-color:#ECEFF1; padding:20px; border-radius:8px; margin-bottom:30px;">
<ol style="color:#263238; font-size:16px;">
  <li style="margin-bottom:10px;"><strong style="color:#D32F2F">معالجة الوظائف المهجورة:</strong> استبدال alpha بـ .a، red بـ .r، green بـ .g، blue بـ .b في جميع الملفات</li>
  <li style="margin-bottom:10px;"><strong style="color:#D32F2F">استبدال withOpacity:</strong> استخدام withValues() بدلاً من withOpacity في جميع الملفات لتجنب فقدان الدقة</li>
  <li style="margin-bottom:10px;"><strong style="color:#D32F2F">إزالة المتغيرات غير المستخدمة:</strong> إزالة جميع الحقول والمتغيرات المحلية والتعريفات غير المستخدمة</li>
  <li style="margin-bottom:10px;"><strong style="color:#D32F2F">معالجة استخدام print:</strong> استخدام نظام تسجيل مناسب بدلاً من print في الكود الإنتاجي</li>
  <li style="margin-bottom:10px;"><strong style="color:#D32F2F">إصلاح المفاتيح المتكررة:</strong> معالجة المفاتيح المتساوية في كائنات Map في app_translations.dart</li>
  <li style="margin-bottom:10px;"><strong style="color:#D32F2F">تحديث استخدام BuildContext:</strong> تجنب استخدام BuildContext عبر فجوات async</li>
  <li style="margin-bottom:10px;"><strong style="color:#D32F2F">تصحيح التعبيرات المنتظمة:</strong> إصلاح بناء RegExp في translation_checker.dart</li>
</ol>
</div>

<div style="background-color:#E8F5E9; padding:20px; border-radius:8px;">
<h3 style="color:#2E7D32; text-align:center;">خطة العمل</h3>
<p style="color:#1B5E20; text-align:center; font-size:16px;">
1. البدء بمعالجة استخدام الدوال المهجورة (alpha، red، green، blue) في ملف theme.dart<br>
2. استبدال استخدامات withOpacity بـ withValues() في جميع الملفات<br>
3. إزالة المتغيرات والدوال غير المستخدمة<br>
4. استبدال print بنظام تسجيل مناسب<br>
5. إصلاح المفاتيح المتكررة في app_translations.dart<br>
6. معالجة مشكلات BuildContext عبر فجوات async<br>
7. تحديث الكود لاستخدام واجهات البرمجة الجديدة (مثل RendererBinding.renderViews)
</p>
</div>
