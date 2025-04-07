import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ar': {
          // General
          'app_name': 'مقهى JBR',
          'loading': 'جاري التحميل...',
          'error': 'خطأ',
          'success': 'نجاح',
          'save': 'حفظ',
          'cancel': 'إلغاء',
          'delete': 'حذف',
          'edit': 'تعديل',
          'close': 'إغلاق',
          'confirm': 'تأكيد',
          'search': 'بحث',
          'back': 'رجوع',
          'next': 'التالي',
          'yes': 'نعم',
          'no': 'لا',

          // نصوص إضافية للشاشة الرئيسية
          'app_description_short': 'إستمتع بتجربة قهوة لا تُنسى',
          'rate': 'التقييمات والاقتراحات',

          // Menu
          'menu': 'القائمة',
          'menu_items': 'عناصر القائمة',
          'all_categories': 'جميع الفئات',
          'no_products': 'لا توجد منتجات في هذه الفئة',
          'add_to_cart': 'إضافة إلى السلة',
          'item_added': 'تمت إضافة العنصر',
          'search_menu': 'البحث في القائمة',

          // Home Screen
          'admin_panel': 'لوحة تحكم المدير',
          'settings': 'الإعدادات',
          'orders': 'الطلبات',
          'cart': 'سلة التسوق',

          // Settings Screen
          'appearance': 'المظهر',
          'language': 'اللغة',
          'language_changed': 'تم تغيير اللغة بنجاح',
          'language_change_failed': 'فشل تغيير اللغة',
          'theme': 'النمط',
          'theme_changed': 'تم تغيير النمط',
          'light': 'فاتح',
          'dark': 'داكن',
          'system': 'تلقائي (حسب إعدادات الجهاز)',
          'fontSize': 'حجم الخط',
          'small': 'صغير',
          'medium': 'متوسط',
          'large': 'كبير',
          'verySmall': 'صغير جداً',
          'veryLarge': 'كبير جداً',

          // Admin
          'admin': 'الإدارة',
          'adminPanel': 'لوحة تحكم المدير',
          'accessAdmin': 'الوصول إلى ميزات الإدارة',
          'products': 'المنتجات',
          'categories': 'الفئات',
          'add_product': 'إضافة منتج',
          'add_category': 'إضافة فئة',
          'manage_orders': 'إدارة الطلبات',
          'statistics': 'الإحصائيات',
          'users': 'المستخدمين',
          'login': 'تسجيل الدخول',
          'logout': 'تسجيل الخروج',
          'email': 'البريد الإلكتروني',
          'password': 'كلمة المرور',
          'username': 'اسم المستخدم',
          'login_success': 'تم تسجيل الدخول بنجاح',
          'login_failed': 'فشل تسجيل الدخول',

          // Menu Screen
          'searchFeatureSoon': 'سيتم إضافة ميزة البحث قريباً',
          'currency': 'د.ب',
          'searchFeatureSoon_en': 'Search feature will be added soon',
          'currency_en': 'BHD',

          // About
          'about': 'حول التطبيق',
          'aboutApp': 'عن التطبيق',
          'developer': 'المطور',
          'licenses': 'التراخيص',
          'version': 'الإصدار',
          'copyright': '© 2025 Mohamed S. Alromaihi. جميع الحقوق محفوظة',
          'app_description':
              'تطبيق لإدارة وعرض منتجات المقهى بالإضافة إلى قائمة الطعام الرقمية',

          // Payment
          'payment': 'خيارات الدفع',
          'phone': 'رقم الهاتف البحريني',
          'generateQR': 'إنشاء QR Code',
          'pleaseEnterPhone': 'الرجاء إدخال رقم الهاتف',
          'pleaseEnterIBAN': 'الرجاء إدخال رقم IBAN',
          'copyIBAN': 'نسخ IBAN',
          'copied': 'تم النسخ',
          'ibanCopied': 'تم نسخ IBAN إلى الحافظة',
          'cantOpen': 'لا يمكن فتح',
          'benefitpay': 'بنفت بي',
          'benefitpayQR': 'رمز بنفت بي QR',

          // Product details
          'price': 'السعر',
          'description': 'الوصف',
          'available': 'متوفر',
          'unavailable': 'غير متوفر',
          'options': 'الخيارات',
          'quantity': 'الكمية',
          'total': 'المجموع',

          // Orders
          'order_summary': 'ملخص الطلب',
          'order_number': 'رقم الطلب',
          'order_date': 'تاريخ الطلب',
          'order_status': 'حالة الطلب',
          'order_total': 'إجمالي الطلب',
          'order_items': 'عناصر الطلب',
          'checkout': 'إتمام الطلب',
          'place_order': 'إرسال الطلب',
          'order_placed': 'تم إرسال طلبك بنجاح',
          'order_failed': 'فشل إرسال الطلب',
          'order_processing': 'جاري المعالجة',
          'order_completed': 'مكتمل',
          'order_cancelled': 'ملغي',
        },

        // English translations
        'en': {
          // General
          'app_name': 'JBR Coffee Shop',
          'loading': 'Loading...',
          'error': 'Error',
          'success': 'Success',
          'save': 'Save',
          'cancel': 'Cancel',
          'delete': 'Delete',
          'edit': 'Edit',
          'close': 'Close',
          'confirm': 'Confirm',
          'search': 'Search',
          'back': 'Back',
          'next': 'Next',
          'yes': 'Yes',
          'no': 'No',

          // نصوص إضافية للشاشة الرئيسية
          'app_description_short': 'Enjoy an unforgettable coffee experience',
          'rate': 'Ratings & Suggestions',

          // Menu
          'menu': 'Menu',
          'menu_items': 'Menu Items',
          'all_categories': 'All Categories',
          'no_products': 'No products in this category',
          'add_to_cart': 'Add to Cart',
          'item_added': 'Item added',
          'search_menu': 'Search Menu',

          // Home Screen
          'admin_panel': 'Admin Panel',
          'settings': 'Settings',
          'orders': 'Orders',
          'cart': 'Cart',

          // Settings Screen
          'appearance': 'Appearance',
          'language': 'Language',
          'language_changed': 'Language changed successfully',
          'language_change_failed': 'Failed to change language',
          'theme': 'Theme',
          'theme_changed': 'Theme changed',
          'light': 'Light',
          'dark': 'Dark',
          'system': 'System (Auto)',
          'fontSize': 'Font Size',
          'small': 'Small',
          'medium': 'Medium',
          'large': 'Large',
          'verySmall': 'Very Small',
          'veryLarge': 'Very Large',

          // Admin
          'admin': 'Administration',
          'adminPanel': 'Admin Dashboard',
          'accessAdmin': 'Access admin features',
          'products': 'Products',
          'categories': 'Categories',
          'add_product': 'Add Product',
          'add_category': 'Add Category',
          'manage_orders': 'Manage Orders',
          'statistics': 'Statistics',
          'users': 'Users',
          'login': 'Login',
          'logout': 'Logout',
          'email': 'Email',
          'password': 'Password',
          'username': 'Username',
          'login_success': 'Login successful',
          'login_failed': 'Login failed',

          // About
          'about': 'About',
          'aboutApp': 'About App',
          'developer': 'Developer',
          'licenses': 'Licenses',
          'version': 'Version',
          'copyright': '© 2025 Mohamed S. Alromaihi. All Rights Reserved',
          'app_description':
              'App for managing and displaying cafe products and digital menu',

          // Payment
          'payment': 'Payment Options',
          'phone': 'Bahraini Phone Number',
          'generateQR': 'Generate QR Code',
          'pleaseEnterPhone': 'Please enter phone number',
          'pleaseEnterIBAN': 'Please enter IBAN number',
          'copyIBAN': 'Copy IBAN',
          'copied': 'Copied',
          'ibanCopied': 'IBAN copied to clipboard',
          'cantOpen': 'Cannot open',
          'benefitpay': 'BenefitPay',
          'benefitpayQR': 'BenefitPay QR Code',

          // Product details
          'price': 'Price',
          'description': 'Description',
          'available': 'Available',
          'unavailable': 'Unavailable',
          'options': 'Options',
          'quantity': 'Quantity',
          'total': 'Total',

          // Orders
          'order_summary': 'Order Summary',
          'order_number': 'Order Number',
          'order_date': 'Order Date',
          'order_status': 'Order Status',
          'order_total': 'Order Total',
          'order_items': 'Order Items',
          'checkout': 'Checkout',
          'place_order': 'Place Order',
          'order_placed': 'Your order has been placed successfully',
          'order_failed': 'Failed to place order',
          'order_processing': 'Processing',
          'order_completed': 'Completed',
          'order_cancelled': 'Cancelled',
        },
      };
}
