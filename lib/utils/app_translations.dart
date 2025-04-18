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
          'welcome': 'مرحباً بك',
          'warning': 'تحذير',
          'info': 'معلومات',
          'home': 'الرئيسية',
          'pleaseWait': 'يرجى الانتظار',
          'done': 'تم',
          'change': 'تغيير',
          'retry': 'إعادة المحاولة',
          'noData': 'لا توجد بيانات',
          'refresh': 'تحديث',

          // نصوص إضافية للشاشة الرئيسية
          'rate': 'التقييمات والاقتراحات',
          'our_location': 'موقعنا',
          'todays_special': 'عرض اليوم',
          'popular_items': 'الأصناف الشائعة',
          'order_now': 'اطلب الآن',
          'welcome_message': 'أهلاً بك في مقهى JBR',
          'discover_menu': 'استكشف قائمتنا',

          // Menu
          'menu': 'القائمة',
          'menu_items': 'عناصر القائمة',
          'all_categories': 'جميع الفئات',
          'no_products': 'لا توجد منتجات في هذه الفئة',
          'add_to_cart': 'إضافة إلى السلة',
          'item_added': 'تمت إضافة العنصر',
          'search_menu': 'البحث في القائمة',
          'coffee': 'قهوة',
          'drinks': 'مشروبات',
          'desserts': 'حلويات',
          'food': 'طعام',
          'snacks': 'وجبات خفيفة',
          'favorites': 'المفضلة',
          'new_items': 'أصناف جديدة',
          'seasonal': 'عروض موسمية',
          'sort_by': 'ترتيب حسب',
          'filter': 'تصفية',
          'view_details': 'عرض التفاصيل',

          // View Options
          'view_options': 'خيارات العرض',
          'view_mode': 'وضع العرض',
          'grid_view': 'عرض شبكي',
          'list_view': 'عرض قائمة',
          'show_images': 'عرض الصور',
          'show_order_button': 'عرض زر الطلب',
          'use_animations': 'استخدام التأثيرات الحركية',
          'save_view_settings': 'حفظ إعدادات العرض',
          'view_settings_saved': 'تم حفظ إعدادات العرض',
          'default_view': 'العرض الافتراضي',
          'compact_view': 'عرض مضغوط',

          // Home Screen
          'admin_panel': 'لوحة تحكم المدير',
          'settings': 'الإعدادات',
          'orders': 'الطلبات',
          'cart': 'سلة التسوق',
          'my_account': 'حسابي',
          'browse_menu': 'تصفح القائمة',
          'featured_products': 'منتجات مميزة',
          'special_offers': 'عروض خاصة',
          'notifications': 'الإشعارات',

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
          'coffee_theme': 'ثيم القهوة',
          'sweet_theme': 'ثيم الحلويات',
          'background_settings': 'إعدادات الخلفية',
          'text_color': 'لون النص',
          'auto_text_color': 'لون النص التلقائي',
          'reset_to_default': 'إعادة للإعدادات الافتراضية',
          'pick_background_image': 'اختيار صورة خلفية',
          'choose_color': 'اختيار لون',
          'Default': 'الخلفية الافتراضية',
          'Custom Color': 'لون مخصص',
          'Custom Image': 'صورة مخصصة',
          'Image Not Available': 'الصورة غير متوفرة',
          'view_options': 'خيارات العرض',
          'contact_developer': 'تواصل مع المطور',
          'general_settings': 'الإعدادات العامة',
          'display_settings': 'إعدادات العرض',
          'accessibility': 'إمكانية الوصول',
          'notifications_settings': 'إعدادات الإشعارات',

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
          'admin_options': 'خيارات الإدارة',
          'reports': 'التقارير',
          'analytics': 'التحليلات',
          'sales_report': 'تقرير المبيعات',
          'daily_report': 'التقرير اليومي',
          'weekly_report': 'التقرير الأسبوعي',
          'monthly_report': 'التقرير الشهري',
          'product_management': 'إدارة المنتجات',
          'category_management': 'إدارة الفئات',
          'edit_product': 'تعديل منتج',
          'delete_product': 'حذف منتج',
          'edit_category': 'تعديل فئة',
          'delete_category': 'حذف فئة',
          'confirm_delete': 'هل أنت متأكد من الحذف؟',
          'this_cannot_be_undone': 'لا يمكن التراجع عن هذه العملية.',
          'product_added': 'تمت إضافة المنتج بنجاح',
          'product_updated': 'تم تحديث المنتج بنجاح',
          'product_deleted': 'تم حذف المنتج بنجاح',
          'category_added': 'تمت إضافة الفئة بنجاح',
          'category_updated': 'تم تحديث الفئة بنجاح',
          'category_deleted': 'تم حذف الفئة بنجاح',

          // Admin Screen - Additional Terms
          'restore_default_categories': 'استعادة الفئات الافتراضية',
          'add_new_category': 'إضافة فئة جديدة',
          'edit_category': 'تعديل فئة',
          'click_to_add_image': 'اضغط لإضافة صورة',
          'category_name_ar': 'اسم الفئة (عربي)',
          'category_name_en': 'اسم الفئة (إنجليزي)',
          'category_description_ar': 'وصف الفئة (عربي)',
          'category_description_en': 'وصف الفئة (إنجليزي)',
          'enter_category_name_ar': 'يرجى إدخال اسم الفئة بالعربية',
          'enter_category_name_en': 'يرجى إدخال اسم الفئة بالإنجليزية',
          'save_changes': 'حفظ التعديلات',
          'delete_category': 'حذف الفئة',
          'are_you_sure_delete': 'هل أنت متأكد من حذف',
          'restore': 'استعادة',
          'error_loading_image': 'خطأ تحميل الصورة',
          'error_loading_assets': 'خطأ تحميل الأصول',
          'success_completed': 'تم بنجاح',
          'category_updated': 'تم تحديث الفئة',
          'category_added': 'تم إضافة الفئة',
          'no_categories_available': 'لا توجد فئات حاليًا',

          // Feedback Management
          'feedback_management': 'إدارة التعليقات والمقترحات',
          'delete_all_feedback': 'حذف جميع التعليقات',
          'no_feedback': 'لا توجد تعليقات أو مقترحات',
          'delete_comment': 'حذف التعليق',
          'feature_comment': 'تمييز التعليق للعرض في الشاشة الرئيسية',
          'unfeature_comment': 'إلغاء تمييز التعليق',
          'displayed_on_home': 'معروض في الشاشة الرئيسية',
          'deleted': 'تم الحذف',
          'comment_deleted': 'تم حذف التعليق بنجاح',
          'all_comments_deleted': 'تم حذف جميع التعليقات بنجاح',
          'confirm_delete_comment': 'هل أنت متأكد من حذف هذا التعليق؟',
          'confirm_delete_all_feedback':
              'هل أنت متأكد من حذف جميع التعليقات والمقترحات؟',
          'action_cannot_be_undone': 'لا يمكن التراجع عن هذا الإجراء',
          'delete_all': 'حذف الكل',
          'featured': 'تم التمييز',
          'unfeatured': 'إلغاء التمييز',
          'comment_featured': 'تم تمييز التعليق وسيظهر في الشاشة الرئيسية',
          'comment_unfeatured': 'تم إلغاء تمييز التعليق من الشاشة الرئيسية',

          // Order Management
          'order_management': 'إدارة الطلبات',
          'pending_orders': 'الطلبات المعلقة',
          'completed_orders': 'الطلبات المكتملة',
          'filter_orders': 'تصفية الطلبات',
          'order_id': 'رقم الطلب',
          'customer_name': 'اسم العميل',
          'customer_phone': 'هاتف العميل',
          'order_time': 'وقت الطلب',
          'preparation_time': 'وقت التحضير',
          'order_type': 'نوع الطلب',
          'dine_in': 'في المطعم',
          'takeaway': 'استلام',
          'delivery': 'توصيل',
          'mark_ready': 'تحديد كجاهز',
          'mark_delivered': 'تحديد كتم التسليم',
          'mark_completed': 'تحديد كمكتمل',
          'order_ready': 'الطلب جاهز',
          'order_delivered': 'تم تسليم الطلب',
          'order_receipt': 'إيصال الطلب',
          'print_receipt': 'طباعة الإيصال',
          'customer_details': 'تفاصيل العميل',
          'delivery_address': 'عنوان التوصيل',
          'payment_method': 'طريقة الدفع',
          'payment_status': 'حالة الدفع',
          'paid': 'مدفوع',
          'unpaid': 'غير مدفوع',
          'export_orders': 'تصدير الطلبات',

          // Product Management
          'product_management': 'إدارة المنتجات',
          'add_new_product': 'إضافة منتج جديد',
          'edit_product': 'تعديل المنتج',
          'product_name_ar': 'اسم المنتج (عربي)',
          'product_name_en': 'اسم المنتج (إنجليزي)',
          'product_description_ar': 'وصف المنتج (عربي)',
          'product_description_en': 'وصف المنتج (إنجليزي)',
          'product_price': 'سعر المنتج',
          'product_category': 'فئة المنتج',
          'product_image': 'صورة المنتج',
          'product_availability': 'توفر المنتج',
          'product_options': 'خيارات المنتج',
          'product_extras': 'إضافات المنتج',
          'product_popular': 'منتج شائع',
          'product_featured': 'منتج مميز',
          'product_new': 'منتج جديد',
          'mark_popular': 'تحديد كشائع',
          'unmark_popular': 'إلغاء تحديد كشائع',
          'mark_featured': 'تحديد كمميز',
          'unmark_featured': 'إلغاء تحديد كمميز',
          'no_products_available': 'لا توجد منتجات متاحة',

          // Dashboard & Reports
          'dashboard': 'لوحة المعلومات',
          'total_sales': 'إجمالي المبيعات',
          'total_orders': 'إجمالي الطلبات',
          'popular_products': 'المنتجات الشائعة',
          'revenue': 'الإيرادات',
          'sales_overview': 'نظرة عامة على المبيعات',
          'today': 'اليوم',
          'this_week': 'هذا الأسبوع',
          'this_month': 'هذا الشهر',
          'last_month': 'الشهر الماضي',
          'custom_range': 'نطاق مخصص',
          'export_report': 'تصدير التقرير',
          'print_report': 'طباعة التقرير',
          'sales_by_category': 'المبيعات حسب الفئة',
          'sales_by_product': 'المبيعات حسب المنتج',
          'sales_trends': 'اتجاهات المبيعات',
          'customer_feedback': 'تقييمات العملاء',
          'average_rating': 'متوسط التقييم',
          'system_settings': 'إعدادات النظام',
          'tax_settings': 'إعدادات الضرائب',
          'vat_percentage': 'نسبة ضريبة القيمة المضافة',
          'currency_settings': 'إعدادات العملة',
          'app_settings': 'إعدادات التطبيق',
          'backup': 'النسخ الاحتياطي',
          'restore_data': 'استعادة البيانات',
          'export_data': 'تصدير البيانات',
          'import_data': 'استيراد البيانات',
          'reset_application': 'إعادة ضبط التطبيق',
          'confirm_reset':
              'هل أنت متأكد أنك تريد إعادة ضبط التطبيق؟ سيتم حذف جميع البيانات.',

          // User Management
          'user_management': 'إدارة المستخدمين',
          'add_user': 'إضافة مستخدم',
          'edit_user': 'تعديل مستخدم',
          'user_roles': 'أدوار المستخدمين',
          'admin_user': 'مدير',
          'staff_user': 'موظف',
          'cashier': 'أمين الصندوق',
          'waiter': 'نادل',
          'active': 'نشط',
          'inactive': 'غير نشط',
          'last_login': 'آخر تسجيل دخول',
          'reset_password': 'إعادة تعيين كلمة المرور',
          'permissions': 'الصلاحيات',
          'full_access': 'وصول كامل',
          'limited_access': 'وصول محدود',
          'manage_users': 'إدارة المستخدمين',
          'manage_products': 'إدارة المنتجات',
          'manage_orders': 'إدارة الطلبات',
          'view_reports': 'عرض التقارير',
          'system_log': 'سجل النظام',

          // Menu Screen
          'searchFeatureSoon': 'سيتم إضافة ميزة البحث قريباً',
          'currency': 'د.ب',
          'sortByPrice': 'ترتيب حسب السعر',
          'sortByName': 'ترتيب حسب الاسم',
          'sortByPopularity': 'ترتيب حسب الشعبية',
          'ascending': 'تصاعدي',
          'descending': 'تنازلي',
          'filterByCategory': 'تصفية حسب الفئة',
          'filterByPrice': 'تصفية حسب السعر',
          'priceRange': 'نطاق السعر',
          'clearFilters': 'مسح التصفية',
          'applyFilters': 'تطبيق التصفية',

          // About
          'about': 'حول التطبيق',
          'aboutApp': 'عن التطبيق',
          'developer': 'المطور',
          'licenses': 'التراخيص',
          'version': 'الإصدار',
          'copyright': '© 2025 Mohamed S. Alromaihi. جميع الحقوق محفوظة',
          'app_description':
              'تطبيق لإدارة وعرض منتجات المقهى بالإضافة إلى قائمة الطعام الرقمية',
          'terms_of_service': 'شروط الخدمة',
          'privacy_policy': 'سياسة الخصوصية',
          'contact_us': 'اتصل بنا',
          'follow_us': 'تابعنا',
          'website': 'الموقع الإلكتروني',
          'social_media': 'وسائل التواصل الاجتماعي',
          'app_version': 'إصدار التطبيق',

          // Location Screen
          'address': 'العنوان',
          'directions': 'الاتجاهات',
          'open_in_maps': 'افتح في الخرائط',
          'opening_hours': 'ساعات العمل',
          'contact_info': 'معلومات الاتصال',
          'call_us': 'اتصل بنا',
          'email_us': 'راسلنا',
          'whatsapp_us': 'واتساب',
          'delivery_info': 'معلومات التوصيل',
          'delivery_areas': 'مناطق التوصيل',
          'delivery_time': 'وقت التوصيل',
          'delivery_fee': 'رسوم التوصيل',
          'minimum_order': 'الحد الأدنى للطلب',
          'saturday_thursday': 'السبت - الخميس',
          'friday': 'الجمعة',

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
          'cash_on_delivery': 'الدفع عند الاستلام',
          'credit_card': 'بطاقة ائتمان',
          'debit_card': 'بطاقة خصم',
          'online_payment': 'الدفع الإلكتروني',
          'payment_successful': 'تمت عملية الدفع بنجاح',
          'payment_failed': 'فشلت عملية الدفع',
          'try_again': 'حاول مرة أخرى',
          'proceed_to_payment': 'المتابعة إلى الدفع',
          'payment_options': 'خيارات الدفع',
          'scan_to_pay': 'امسح للدفع',

          // Product details
          'price': 'السعر',
          'description': 'الوصف',
          'available': 'متوفر',
          'unavailable': 'غير متوفر',
          'options': 'الخيارات',
          'quantity': 'الكمية',
          'total': 'المجموع',
          'ingredients': 'المكونات',
          'allergies': 'تحذيرات الحساسية',
          'nutritional_info': 'المعلومات الغذائية',
          'calories': 'السعرات الحرارية',
          'add_extras': 'إضافات',
          'choose_size': 'اختر الحجم',
          'small_size': 'صغير',
          'medium_size': 'وسط',
          'large_size': 'كبير',
          'choose_milk': 'اختر الحليب',
          'choose_sugar': 'اختر كمية السكر',
          'special_instructions': 'تعليمات خاصة',
          'item_details': 'تفاصيل المنتج',
          'similar_products': 'منتجات مشابهة',
          'related': 'ذات صلة',

          // Rate Screen
          'rate_us': 'قيّمنا',
          'your_feedback': 'رأيك يهمنا',
          'feedback_received': 'تم استلام تقييمك بنجاح',
          'thanks_for_feedback': 'شكراً لك على تقييمك',
          'rate_experience': 'قيم تجربتك',
          'write_review': 'اكتب تقييماً',
          'enter_name': 'أدخل اسمك',
          'enter_comments': 'أدخل تعليقاتك هنا',
          'submit_rating': 'إرسال التقييم',
          'rating_required': 'التقييم مطلوب',
          'how_was_experience': 'كيف كانت تجربتك معنا؟',
          'leave_suggestion': 'اترك لنا اقتراحاً',
          'anonymous_feedback': 'تقييم مجهول',

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
          'subtotal': 'المجموع الفرعي',
          'tax': 'الضريبة',
          'discount': 'الخصم',
          'track_order': 'تتبع الطلب',
          'recent_orders': 'الطلبات الأخيرة',
          'reorder': 'إعادة الطلب',
          'order_history': 'سجل الطلبات',
          'cancel_order': 'إلغاء الطلب',
          'modify_order': 'تعديل الطلب',
          'order_details': 'تفاصيل الطلب',
          'confirm_cancel_order': 'هل أنت متأكد من إلغاء الطلب؟',
          'cancel_order_success': 'تم إلغاء الطلب بنجاح',

          // Notifications
          'notification': 'إشعار',
          'no_notifications': 'لا توجد إشعارات',
          'clear_all': 'مسح الكل',
          'notifications_cleared': 'تم مسح جميع الإشعارات',
          'new_notification': 'إشعار جديد',
          'order_update': 'تحديث الطلب',
          'promotion': 'عرض ترويجي',
          'mark_as_read': 'تحديد كمقروء',
          'delete_notification': 'حذف الإشعار',
          'enable_notifications': 'تفعيل الإشعارات',
          'disable_notifications': 'إيقاف الإشعارات',

          // Confirmation Dialogs
          'confirmation': 'تأكيد',
          'are_you_sure': 'هل أنت متأكد؟',
          'this_action_cannot_be_undone': 'لا يمكن التراجع عن هذا الإجراء',
          'confirm_delete_item': 'هل أنت متأكد من حذف هذا العنصر؟',
          'confirm_exit': 'هل تريد الخروج من التطبيق؟',
          'confirm_discard': 'هل تريد تجاهل التغييرات؟',
          'unsaved_changes': 'تغييرات غير محفوظة',
          'save_changes': 'حفظ التغييرات',
          'discard_changes': 'تجاهل التغييرات',
          'continue_editing': 'متابعة التحرير',

          // Error Messages
          'no_internet': 'لا يوجد اتصال بالإنترنت',
          'connection_error': 'خطأ في الاتصال',
          'failed_to_load': 'فشل في تحميل البيانات',
          'try_again_later': 'يرجى المحاولة لاحقاً',
          'invalid_input': 'إدخال غير صالح',
          'required_field': 'هذا الحقل مطلوب',
          'invalid_email': 'بريد إلكتروني غير صالح',
          'invalid_phone': 'رقم هاتف غير صالح',
          'minimum_characters': 'الحد الأدنى للأحرف:',
          'password_mismatch': 'كلمات المرور غير متطابقة',
          'server_error': 'خطأ في الخادم',
          'session_expired': 'انتهت صلاحية الجلسة',
          'please_login_again': 'يرجى تسجيل الدخول مرة أخرى',

          // Additional Admin & UI Keys
          'not_logged_in': 'غير مسجل دخول',
          'system_admin': 'مدير النظام',
          'dashboard': 'لوحة التحكم',
          'order_history': 'سجل الطلبات',
          'confirm_logout': 'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
          'about_app_title': 'حول البرنامج',
          'display_options': 'خيارات العرض',
          'pay_with_benefitpay': 'ادفع مع بنفت بي',
          'scan_qr_to_pay': 'امسح الباركود للدفع عبر تطبيق بنفت بي',
          'customer_feedback': 'آراء الزبائن',
          'share_your_feedback': 'شاركنا رأيك',
          'error_loading_qr': 'خطأ في تحميل صورة الباركود',

          // Admin Dashboard Additions
          'reset_stats': 'إعادة تعيين الإحصائيات',
          'factory_reset': 'إعادة ضبط المصنع',
          'factory_reset_description': 'مسح جميع البيانات والإعدادات',
          'daily_sales': 'مبيعات اليوم',
          'daily_profits': 'الأرباح اليومية',
          'order_count': 'عدد الطلبات',
          'reset_stats_confirmation':
              'هل أنت متأكد من أنك تريد إعادة تعيين الإحصائيات؟ سيتم مسح جميع بيانات المبيعات.',
          'export_and_save': 'تصدير وحفظ',
          'reset_without_save': 'إعادة تعيين بدون حفظ',
          'stats_reset_success': 'تم إعادة تعيين الإحصائيات بنجاح',
          'no_sales_data': 'لا توجد بيانات مبيعات متاحة',
          'coming_soon': 'قريباً',
          'feature_coming_soon': 'هذه الميزة قيد التطوير وستكون متاحة قريباً',
          'reports': 'التقارير',
          'sales_overview': 'نظرة عامة على المبيعات',
          'manage_feedback': 'إدارة التعليقات',
          'manage_qr': 'إدارة رمز QR',
          'benefitpayQR': 'رمز بنفت بي',
          'app_settings': 'إعدادات التطبيق',
          'pending': 'قيد الانتظار',
          'processing': 'قيد المعالجة',
          'completed': 'مكتمل',
          'cancelled': 'ملغي',

          // Language Switch
          'switch_language': 'تغيير اللغة',
          'ar': 'عربي',
          'en': 'English',
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
          'welcome': 'Welcome',
          'warning': 'Warning',
          'info': 'Information',
          'home': 'Home',
          'pleaseWait': 'Please wait',
          'done': 'Done',
          'change': 'Change',
          'retry': 'Retry',
          'noData': 'No data available',
          'refresh': 'Refresh',

          // Home Screen additional texts
          'app_description_short': 'Enjoy an unforgettable coffee experience',
          'rate': 'Ratings & Suggestions',
          'our_location': 'Our Location',
          'todays_special': 'Today\'s Special',
          'popular_items': 'Popular Items',
          'order_now': 'Order Now',
          'welcome_message': 'Welcome to JBR Coffee Shop',
          'discover_menu': 'Discover Our Menu',

          // Menu
          'menu': 'Menu',
          'menu_items': 'Menu Items',
          'all_categories': 'All Categories',
          'no_products': 'No products in this category',
          'add_to_cart': 'Add to Cart',
          'item_added': 'Item added',
          'search_menu': 'Search Menu',
          'coffee': 'Coffee',
          'drinks': 'Drinks',
          'desserts': 'Desserts',
          'food': 'Food',
          'snacks': 'Snacks',
          'favorites': 'Favorites',
          'new_items': 'New Items',
          'seasonal': 'Seasonal',
          'sort_by': 'Sort By',
          'filter': 'Filter',
          'view_details': 'View Details',

          // View Options
          'view_options': 'View Options',
          'view_mode': 'View Mode',
          'grid_view': 'Grid View',
          'list_view': 'List View',
          'show_images': 'Show Images',
          'show_order_button': 'Show Order Button',
          'use_animations': 'Use Animations',
          'save_view_settings': 'Save View Settings',
          'view_settings_saved': 'View settings saved',
          'default_view': 'Default View',
          'compact_view': 'Compact View',

          // Home Screen
          'admin_panel': 'Admin Panel',
          'settings': 'Settings',
          'orders': 'Orders',
          'cart': 'Cart',
          'my_account': 'My Account',
          'browse_menu': 'Browse Menu',
          'featured_products': 'Featured Products',
          'special_offers': 'Special Offers',
          'notifications': 'Notifications',

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
          'coffee_theme': 'Coffee Theme',
          'sweet_theme': 'Sweet Theme',
          'background_settings': 'Background Settings',
          'text_color': 'Text Color',
          'auto_text_color': 'Auto Text Color (changes with background)',
          'reset_to_default': 'Reset to Default',
          'pick_background_image': 'Pick Background Image',
          'choose_color': 'Choose Color',
          'Default': 'Default Background',
          'Custom Color': 'Custom Color',
          'Custom Image': 'Custom Image',
          'Image Not Available': 'Image Not Available',
          'view_options': 'View Options',
          'contact_developer': 'Contact Developer',
          'general_settings': 'General Settings',
          'display_settings': 'Display Settings',
          'accessibility': 'Accessibility',
          'notifications_settings': 'Notification Settings',

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
          'admin_options': 'Admin Options',
          'reports': 'Reports',
          'analytics': 'Analytics',
          'sales_report': 'Sales Report',
          'daily_report': 'Daily Report',
          'weekly_report': 'Weekly Report',
          'monthly_report': 'Monthly Report',
          'product_management': 'Product Management',
          'category_management': 'Category Management',
          'edit_product': 'Edit Product',
          'delete_product': 'Delete Product',
          'edit_category': 'Edit Category',
          'delete_category': 'Delete Category',
          'confirm_delete': 'Are you sure you want to delete?',
          'this_cannot_be_undone': 'This action cannot be undone.',
          'product_added': 'Product added successfully',
          'product_updated': 'Product updated successfully',
          'product_deleted': 'Product deleted successfully',
          'category_added': 'Category added successfully',
          'category_updated': 'Category updated successfully',
          'category_deleted': 'Category deleted successfully',

          // Admin Screen - Additional Terms
          'restore_default_categories': 'Restore Default Categories',
          'add_new_category': 'Add New Category',
          'edit_category': 'Edit Category',
          'click_to_add_image': 'Click to Add Image',
          'category_name_ar': 'Category Name (Arabic)',
          'category_name_en': 'Category Name (English)',
          'category_description_ar': 'Category Description (Arabic)',
          'category_description_en': 'Category Description (English)',
          'enter_category_name_ar': 'Please enter category name in Arabic',
          'enter_category_name_en': 'Please enter category name in English',
          'save_changes': 'Save Changes',
          'delete_category': 'Delete Category',
          'are_you_sure_delete': 'Are you sure you want to delete',
          'restore': 'Restore',
          'error_loading_image': 'Error loading image',
          'error_loading_assets': 'Error loading assets',
          'success_completed': 'Successfully Completed',
          'category_updated': 'Category Updated',
          'category_added': 'Category Added',
          'no_categories_available': 'No Categories Available',

          // Feedback Management
          'feedback_management': 'Feedback Management',
          'delete_all_feedback': 'Delete All Feedback',
          'no_feedback': 'No Feedback or Suggestions',
          'delete_comment': 'Delete Comment',
          'feature_comment': 'Feature Comment on Home Screen',
          'unfeature_comment': 'Unfeature Comment',
          'displayed_on_home': 'Displayed on Home Screen',
          'deleted': 'Deleted',
          'comment_deleted': 'Comment deleted successfully',
          'all_comments_deleted': 'All comments deleted successfully',
          'confirm_delete_comment':
              'Are you sure you want to delete this comment?',
          'confirm_delete_all_feedback':
              'Are you sure you want to delete all feedback and suggestions?',
          'action_cannot_be_undone': 'This action cannot be undone',
          'delete_all': 'Delete All',
          'featured': 'Featured',
          'unfeatured': 'Unfeatured',
          'comment_featured': 'Comment featured and will appear on home screen',
          'comment_unfeatured': 'Comment unfeatured from home screen',

          // Order Management
          'order_management': 'Order Management',
          'pending_orders': 'Pending Orders',
          'completed_orders': 'Completed Orders',
          'filter_orders': 'Filter Orders',
          'order_id': 'Order ID',
          'customer_name': 'Customer Name',
          'customer_phone': 'Customer Phone',
          'order_time': 'Order Time',
          'preparation_time': 'Preparation Time',
          'order_type': 'Order Type',
          'dine_in': 'Dine In',
          'takeaway': 'Takeaway',
          'delivery': 'Delivery',
          'mark_ready': 'Mark as Ready',
          'mark_delivered': 'Mark as Delivered',
          'mark_completed': 'Mark as Completed',
          'order_ready': 'Order Ready',
          'order_delivered': 'Order Delivered',
          'order_receipt': 'Order Receipt',
          'print_receipt': 'Print Receipt',
          'customer_details': 'Customer Details',
          'delivery_address': 'Delivery Address',
          'payment_method': 'Payment Method',
          'payment_status': 'Payment Status',
          'paid': 'Paid',
          'unpaid': 'Unpaid',
          'export_orders': 'Export Orders',

          // Product Management
          'product_management': 'Product Management',
          'add_new_product': 'Add New Product',
          'edit_product': 'Edit Product',
          'product_name_ar': 'Product Name (Arabic)',
          'product_name_en': 'Product Name (English)',
          'product_description_ar': 'Product Description (Arabic)',
          'product_description_en': 'Product Description (English)',
          'product_price': 'Product Price',
          'product_category': 'Product Category',
          'product_image': 'Product Image',
          'product_availability': 'Product Availability',
          'product_options': 'Product Options',
          'product_extras': 'Product Extras',
          'product_popular': 'Popular Product',
          'product_featured': 'Featured Product',
          'product_new': 'New Product',
          'mark_popular': 'Mark as Popular',
          'unmark_popular': 'Unmark as Popular',
          'mark_featured': 'Mark as Featured',
          'unmark_featured': 'Unmark as Featured',
          'no_products_available': 'No Products Available',

          // Dashboard & Reports
          'dashboard': 'Dashboard',
          'total_sales': 'Total Sales',
          'total_orders': 'Total Orders',
          'popular_products': 'Popular Products',
          'revenue': 'Revenue',
          'sales_overview': 'Sales Overview',
          'today': 'Today',
          'this_week': 'This Week',
          'this_month': 'This Month',
          'last_month': 'Last Month',
          'custom_range': 'Custom Range',
          'export_report': 'Export Report',
          'print_report': 'Print Report',
          'sales_by_category': 'Sales by Category',
          'sales_by_product': 'Sales by Product',
          'sales_trends': 'Sales Trends',
          'customer_feedback': 'Customer Feedback',
          'average_rating': 'Average Rating',
          'system_settings': 'System Settings',
          'tax_settings': 'Tax Settings',
          'vat_percentage': 'VAT Percentage',
          'currency_settings': 'Currency Settings',
          'app_settings': 'App Settings',
          'backup': 'Backup',
          'restore_data': 'Restore Data',
          'export_data': 'Export Data',
          'import_data': 'Import Data',
          'reset_application': 'Reset Application',
          'confirm_reset':
              'Are you sure you want to reset the application? All data will be deleted.',

          // User Management
          'user_management': 'User Management',
          'add_user': 'Add User',
          'edit_user': 'Edit User',
          'user_roles': 'User Roles',
          'admin_user': 'Administrator',
          'staff_user': 'Staff',
          'cashier': 'Cashier',
          'waiter': 'Waiter',
          'active': 'Active',
          'inactive': 'Inactive',
          'last_login': 'Last Login',
          'reset_password': 'Reset Password',
          'permissions': 'Permissions',
          'full_access': 'Full Access',
          'limited_access': 'Limited Access',
          'manage_users': 'Manage Users',
          'manage_products': 'Manage Products',
          'manage_orders': 'Manage Orders',
          'view_reports': 'View Reports',
          'system_log': 'System Log',

          // Additional Admin & UI Keys
          'not_logged_in': 'Not Logged In',
          'system_admin': 'System Administrator',
          'dashboard': 'Dashboard',
          'order_history': 'Order History',
          'confirm_logout': 'Are you sure you want to logout?',
          'about_app_title': 'About App',
          'display_options': 'Display Options',
          'pay_with_benefitpay': 'Pay with BenefitPay',
          'scan_qr_to_pay': 'Scan the QR code to pay via BenefitPay app',
          'customer_feedback': 'Customer Feedback',
          'share_your_feedback': 'Share your feedback',
          'error_loading_qr': 'Error loading QR code image',

          // Admin Dashboard Additions
          'reset_stats': 'Reset Statistics',
          'factory_reset': 'Factory Reset',
          'factory_reset_description': 'Erase all data and settings',
          'daily_sales': 'Daily Sales',
          'daily_profits': 'Daily Profits',
          'order_count': 'Order Count',
          'reset_stats_confirmation':
              'Are you sure you want to reset statistics? All sales data will be erased.',
          'export_and_save': 'Export & Save',
          'reset_without_save': 'Reset Without Saving',
          'stats_reset_success': 'Statistics reset successfully',
          'no_sales_data': 'No sales data available',
          'coming_soon': 'Coming Soon',
          'feature_coming_soon':
              'This feature is under development and will be available soon',
          'reports': 'Reports',
          'sales_overview': 'Sales Overview',
          'manage_feedback': 'Manage Feedback',
          'manage_qr': 'Manage QR Code',
          'benefitpayQR': 'BenefitPay QR',
          'app_settings': 'App Settings',
          'pending': 'Pending',
          'processing': 'Processing',
          'completed': 'Completed',
          'cancelled': 'Cancelled',

          // Language Switch
          'switch_language': 'Switch Language',
          'ar': 'عربي',
          'en': 'English',
        },
      };
}
