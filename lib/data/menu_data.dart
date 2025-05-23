import 'package:gpr_coffee_shop/models/category.dart';
import 'package:gpr_coffee_shop/models/product.dart';
import 'package:uuid/uuid.dart';

class MenuData {
  // Make sure this path is correct and the image exists in your assets
  static const placeholderImage = 'assets/images/placeholder.png';

  // Get all categories in both languages
  static List<Category> getCategories() {
    return [
       
      Category(
        id: 'cat1',
        name: 'اختيارات على ذوقك 🔥',
        nameEn: 'Your Choices 🔥',
        description: 'مجموعة متنوعه تناسب ذوقك',
        descriptionEn: 'A variety to suit your taste',
        iconPath: placeholderImage,
        order: 1,
      ),
      Category(
        id: 'cat2',
        name: 'القهوة الباردة',
        nameEn: 'Cold coffee',
        description: 'قهوة باردة منعشة ولذيذة',
        descriptionEn: 'Refreshing and delicious cold coffee',
        iconPath: placeholderImage,
        order: 2,
      ),
      Category(
        id: 'cat3',
        name: 'المشروبات الساخنة',
        nameEn: 'Hot Drinks',
        description: 'مجموعة متنوعة من المشروبات الساخنة اللذيذة',
        descriptionEn: 'A variety of delicious hot beverages',
        iconPath: placeholderImage,
        order: 3,
      ),
      Category(
        id: 'cat4',
        name: 'لاتيه الماتشا',
        nameEn: 'Matcha Latte',
        description: 'مشروبات الماتشا اللذيذة',
        descriptionEn: 'Delicious matcha drinks',
        iconPath: placeholderImage,
        order: 4,
      ),
      Category(
        id: 'cat5',
        name: 'V60',
        nameEn: 'V60',
        description: 'قهوة V60',
        descriptionEn: 'V60 coffee',
        iconPath: placeholderImage,
        order: 5,
      ),
      Category(
        id: 'cat6',
        name: 'الموهيتو',
        nameEn: 'Mojito',
        description: 'مهيتو JBR المنعشة',
        descriptionEn: 'Refreshing JBR mojito',
        iconPath: placeholderImage,
        order: 6,
      ),
      Category(
        id: 'cat7',
        name: 'الحلويات',
        nameEn: 'Desserts',
        description: 'حلويات شهية ومميزة',
        descriptionEn: 'Delicious and special desserts',
        iconPath: placeholderImage,
        order: 7,
      ),
    ];
  }

  // Get all products in both languages
  static List<Product> getProducts() {
    const uuid = Uuid();

    return [
      // Category 1: Your Choices (اختيارات على ذوقك)
      Product(
        id: uuid.v4(),
        name: 'إسبريسو',
        nameEn: 'Espresso',
        description: 'شوت اسبريسو قوي وجريء',
        descriptionEn: 'Strong and bold espresso shot',
        price: 0.900,
        cost: 0.000,
        categoryId: 'cat1',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'لاتيه بندق مثلجة',
        nameEn: 'Iced Hazelnut Latte',
        description: 'لاتيه مثلج كريمي مع نوتس البندق',
        descriptionEn: 'Creamy iced latte with hazelnut notes',
        price: 2.000,
        cost: 0.000,
        categoryId: 'cat1',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'أمريكانو ساخن',
        nameEn: 'Hot Americano',
        description: 'قهوة سوداء كلاسيكية',
        descriptionEn: 'Classic black coffee',
        price: 1.300,
        cost: 0.000,
        categoryId: 'cat1',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'هوت سبانش',
        nameEn: 'Hot Spanish',
        description: 'لاتيه دافئ مع لمسة من القرفة',
        descriptionEn: 'Warm latte with a touch of cinnamon',
        price: 1.800,
        cost: 0.000,
        categoryId: 'cat1',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'ماتشا أسبانية مثلجة',
        nameEn: 'Iced Spanish Matcha',
        description: 'ماتشا مبردة مع لمسة من القرفة',
        descriptionEn: 'Chilled matcha with a touch of cinnamon',
        price: 2.300,
        cost: 0.000,
        categoryId: 'cat1',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'لاتيه بندق ساخن',
        nameEn: 'Hot Hazelnut Latte',
        description: 'لاتيه ساخن بنكهة البندق الجوزية',
        descriptionEn: 'Hot latte with nutty hazelnut flavor',
        price: 1.900,
        cost: 0.000,
        categoryId: 'cat1',
        imageUrl: placeholderImage,
      ),

      // Category 2: Cold Coffee (القهوة الباردة)
      Product(
        id: uuid.v4(),
        name: 'لاتيه أسباني مثلجة',
        nameEn: 'Iced Spanish Latte',
        description: 'لاتيه مبرد مع لمسة من القرفة',
        descriptionEn: 'Chilled latte with a touch of cinnamon',
        price: 1.900,
        cost: 0.000,
        categoryId: 'cat2',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'لاتيه زعفران مثلجة',
        nameEn: 'Iced Saffron Latte',
        description: 'لاتيه مثلج ناعم مملوء بالزعفران',
        descriptionEn: 'Smooth iced latte filled with saffron',
        price: 2.000,
        cost: 0.000,
        categoryId: 'cat2',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'سيجنتشر',
        nameEn: 'Signature',
        description: 'خليط قهوة سبيشيال هاوس',
        descriptionEn: 'Special house coffee blend',
        price: 2.200,
        cost: 0.000,
        categoryId: 'cat2',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'شيكن مثلج',
        nameEn: 'Iced Shaken',
        description: 'قهوة مثلجة شيكن منعشة',
        descriptionEn: 'Refreshing shaken iced coffee',
        price: 1.900,
        cost: 0.000,
        categoryId: 'cat2',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'لاتيه كراميل مثلج',
        nameEn: 'Iced Caramel Latte',
        description: 'لاتيه مثلج بنكهة كراميل غنية',
        descriptionEn: 'Iced latte with rich caramel flavor',
        price: 2.000,
        cost: 0.000,
        categoryId: 'cat2',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'كراميل مملح مثلج',
        nameEn: 'Iced Salted Caramel',
        description: 'لاتيه كراميل مملح و حلو مثلج',
        descriptionEn: 'Sweet and salty iced caramel latte',
        price: 2.000,
        cost: 0.000,
        categoryId: 'cat2',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'لاتيه بندق مثلجة',
        nameEn: 'Iced Hazelnut Latte',
        description: 'لاتيه مثلج كريمي مع نوتس البندق',
        descriptionEn: 'Creamy iced latte with hazelnut notes',
        price: 2.000,
        cost: 0.000,
        categoryId: 'cat2',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'لاتيه كراميل فانيليا مثلجة',
        nameEn: 'Iced Vanilla Caramel Latte',
        description: 'لاتيه مثلج مخلوط بالفانيليا والكراميل',
        descriptionEn: 'Iced latte blended with vanilla and caramel',
        price: 2.000,
        cost: 0.000,
        categoryId: 'cat2',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'لاتيه مثلج',
        nameEn: 'Iced Latte',
        description: 'لاتيه كلاسيك مبرد',
        descriptionEn: 'Classic chilled latte',
        price: 1.700,
        cost: 0.000,
        categoryId: 'cat2',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'أمريكانو مثلج',
        nameEn: 'Iced Americano',
        description: 'قهوة سوداء مثلجة ناعمة',
        descriptionEn: 'Smooth iced black coffee',
        price: 1.500,
        cost: 0.000,
        categoryId: 'cat2',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'روز ألتر',
        nameEn: 'Rose Alter',
        description: 'قهوة مبردة مملوءة روز',
        descriptionEn: 'Chilled coffee infused with rose',
        price: 2.000,
        cost: 0.000,
        categoryId: 'cat2',
        imageUrl: placeholderImage,
      ),

      // Category 3: Hot Drinks (المشروبات الساخنة)
      Product(
        id: uuid.v4(),
        name: 'إسبريسو',
        nameEn: 'Espresso',
        description: 'شوت اسبريسو قوي وجريء',
        descriptionEn: 'Strong and bold espresso shot',
        price: 0.900,
        cost: 0.000,
        categoryId: 'cat3',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: '315',
        nameEn: '315',
        description: 'مزيج قهوة خفيف',
        descriptionEn: 'Light coffee blend',
        price: 1.000,
        cost: 0.000,
        categoryId: 'cat3',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'لاتيه ساخن',
        nameEn: 'Hot Latte',
        description: 'حليب مبخر كريمي مع إسبريسو',
        descriptionEn: 'Creamy steamed milk with espresso',
        price: 1.700,
        cost: 0.000,
        categoryId: 'cat3',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'هوت سبانش',
        nameEn: 'Hot Spanish',
        description: 'لاتيه دافئ مع لمسة من القرفة',
        descriptionEn: 'Warm latte with a touch of cinnamon',
        price: 1.800,
        cost: 0.000,
        categoryId: 'cat3',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'فلات وايت',
        nameEn: 'Flat White',
        description: 'إسبريسو مخملي مع حليب مبخر',
        descriptionEn: 'Velvety espresso with steamed milk',
        price: 1.700,
        cost: 0.000,
        categoryId: 'cat3',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'كورتادو ساخن',
        nameEn: 'Hot Cortado',
        description: 'أجزاء متساوية إسبريسو مع حليب',
        descriptionEn: 'Equal parts espresso and milk',
        price: 1.400,
        cost: 0.000,
        categoryId: 'cat3',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'كورتادو أسباني',
        nameEn: 'Spanish Cortado',
        description: 'إسبريسو قوي مع لمسة من الحليب المبخر',
        descriptionEn: 'Strong espresso with a touch of steamed milk',
        price: 1.700,
        cost: 0.000,
        categoryId: 'cat3',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'لاتيه كراميل ساخن',
        nameEn: 'Hot Caramel Latte',
        description: 'لاتيه دافئ مع حلاوة الكراميل',
        descriptionEn: 'Warm latte with caramel sweetness',
        price: 1.900,
        cost: 0.000,
        categoryId: 'cat3',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'لاتيه بندق ساخن',
        nameEn: 'Hot Hazelnut Latte',
        description: 'لاتيه ساخن بنكهة البندق الجوزية',
        descriptionEn: 'Hot latte with nutty hazelnut flavor',
        price: 1.900,
        cost: 0.000,
        categoryId: 'cat3',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'كراميل فانيليا ساخن',
        nameEn: 'Hot Vanilla Caramel',
        description: 'لاتيه ساخن مملوءة بالفانيليا والكراميل',
        descriptionEn: 'Hot latte filled with vanilla and caramel',
        price: 1.900,
        cost: 0.000,
        categoryId: 'cat3',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'كابتشينو ساخن',
        nameEn: 'Hot Cappuccino',
        description: 'حليب رغوي مع إسبريسو قوي',
        descriptionEn: 'Foamy milk with strong espresso',
        price: 1.700,
        cost: 0.000,
        categoryId: 'cat3',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'شوكولاتة ساخنة',
        nameEn: 'Hot Chocolate',
        description: 'شوكولاتة ساخنة غنية وكريمية',
        descriptionEn: 'Rich and creamy hot chocolate',
        price: 2.300,
        cost: 0.000,
        categoryId: 'cat3',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'أمريكانو ساخن',
        nameEn: 'Hot Americano',
        description: 'قهوة سوداء كلاسيكية',
        descriptionEn: 'Classic black coffee',
        price: 1.300,
        cost: 0.000,
        categoryId: 'cat3',
        imageUrl: placeholderImage,
      ),

      // Category 4: Matcha Latte (لاتيه الماتشا)
      Product(
        id: uuid.v4(),
        name: 'ماتشا أسبانية مثلجة',
        nameEn: 'Iced Spanish Matcha',
        description: 'ماتشا مبردة مع لمسة من القرفة',
        descriptionEn: 'Chilled matcha with a touch of cinnamon',
        price: 2.300,
        cost: 0.000,
        categoryId: 'cat4',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'روز ماتشا',
        nameEn: 'Rose Matcha',
        description: 'ماتشا مثلجة بنكهة الروز',
        descriptionEn: 'Iced matcha with rose flavor',
        price: 2.400,
        cost: 0.000,
        categoryId: 'cat4',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'سبانش ماتشا ساخنة',
        nameEn: 'Hot Spanish Matcha',
        description: 'ماتشا دافئ مع اندرتونز قرفة',
        descriptionEn: 'Warm matcha with cinnamon undertones',
        price: 2.100,
        cost: 0.000,
        categoryId: 'cat4',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'لاتيه ماتشا',
        nameEn: 'Matcha Latte',
        description: 'لاتيه ماتشا كريمي وناعم',
        descriptionEn: 'Creamy and smooth matcha latte',
        price: 2.100,
        cost: 0.000,
        categoryId: 'cat4',
        imageUrl: placeholderImage,
      ),

      // Category 5: V60
      Product(
        id: uuid.v4(),
        name: 'في 60 إثيوبيا',
        nameEn: 'V60 Ethiopia',
        description: 'قهوة إثيوبية مخمرة يدوياً',
        descriptionEn: 'Hand-brewed Ethiopian coffee',
        price: 2.100,
        cost: 0.000,
        categoryId: 'cat5',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'في 60 كولومبيا',
        nameEn: 'V60 Colombia',
        description: 'قهوة كولومبية ناعمة وعطرية',
        descriptionEn: 'Smooth and aromatic Colombian coffee',
        price: 2.300,
        cost: 0.000,
        categoryId: 'cat5',
        imageUrl: placeholderImage,
      ),

      // Category 6: Mojito (الموهيتو)
      Product(
        id: uuid.v4(),
        name: 'بلاك جى بى آر موهيتو',
        nameEn: 'Black JBR Mojito',
        description: 'موهيتو أسود منعش مع نعناع',
        descriptionEn: 'Refreshing black mojito with mint',
        price: 2.100,
        cost: 0.000,
        categoryId: 'cat6',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'موهيتو باشون',
        nameEn: 'Passion Mojito',
        description: 'موهيتو باشون فروت تروبيكال',
        descriptionEn: 'Tropical passion fruit mojito',
        price: 2.100,
        cost: 0.000,
        categoryId: 'cat6',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'موهيتو بلو',
        nameEn: 'Blue Mojito',
        description: 'موهيتو نعناع بلو كول',
        descriptionEn: 'Cool blue mint mojito',
        price: 2.100,
        cost: 0.000,
        categoryId: 'cat6',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'موهيتو فراولة',
        nameEn: 'Strawberry Mojito',
        description: 'موهيتو مملوء فراولة طازجة',
        descriptionEn: 'Mojito filled with fresh strawberries',
        price: 2.100,
        cost: 0.000,
        categoryId: 'cat6',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'موهيتو سموك',
        nameEn: 'Smoke Mojito',
        description: 'موهيتو بنكهة سموكى',
        descriptionEn: 'Mojito with smoky flavor',
        price: 2.100,
        cost: 0.000,
        categoryId: 'cat6',
        imageUrl: placeholderImage,
      ),

      // Category 7: Desserts (الحلويات)
      Product(
        id: uuid.v4(),
        name: 'كوكيز بالشوكولاتة',
        nameEn: 'Chocolate Cookies',
        description: 'كوكيز طرية مع الشوكولاتة',
        descriptionEn: 'Soft cookies with chocolate',
        price: 1.500,
        cost: 0.000,
        categoryId: 'cat7',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'كوكو بيري',
        nameEn: 'Coco Berry',
        description: 'كوكو بيري',
        descriptionEn: 'Coco Berry',
        price: 2.500,
        cost: 0.000,
        categoryId: 'cat7',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'تشيز كيك',
        nameEn: 'Cheesecake',
        description: 'تشيز كيك كريمي كلاسيك',
        descriptionEn: 'Classic creamy cheesecake',
        price: 2.500,
        cost: 0.000,
        categoryId: 'cat7',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'كوكيز',
        nameEn: 'Cookies',
        description: 'كوكيز تشوى وطري',
        descriptionEn: 'Chewy and soft cookies',
        price: 1.000,
        cost: 0.000,
        categoryId: 'cat7',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'تشيز كيك شوكولاتة',
        nameEn: 'Chocolate Cheesecake',
        description: 'تشيز كيك مع توبينج شوكولاتة',
        descriptionEn: 'Cheesecake with chocolate topping',
        price: 2.500,
        cost: 0.000,
        categoryId: 'cat7',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'خبز فرنسي محمص',
        nameEn: 'French Toast',
        description: 'خبز فرنسي محمص ذهبى بنى مع شراب',
        descriptionEn: 'Golden brown French toast with syrup',
        price: 2.600,
        cost: 0.000,
        categoryId: 'cat7',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'بودنج شوكولاتة',
        nameEn: 'Chocolate Pudding',
        description: 'بودنج شوكولاتة غني وكريمي',
        descriptionEn: 'Rich and creamy chocolate pudding',
        price: 1.800,
        cost: 0.000,
        categoryId: 'cat7',
        imageUrl: placeholderImage,
      ),
    ];
  }
}
