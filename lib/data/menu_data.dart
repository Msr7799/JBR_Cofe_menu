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
        name: 'مشروبات ساخنة',
        nameEn: 'Hot Drinks',
        description: 'مجموعة متنوعة من المشروبات الساخنة اللذيذة',
        descriptionEn: 'A variety of delicious hot beverages',
        iconPath: placeholderImage,
        order: 0,
      ),
      Category(
        id: 'cat2',
        name: 'مشروبات باردة',
        nameEn: 'Cold Drinks',
        description: 'مشروبات باردة منعشة ولذيذة',
        descriptionEn: 'Refreshing and tasty cold beverages',
        iconPath: placeholderImage,
        order: 1,
      ),
      Category(
        id: 'cat3',
        name: 'مشروبات مثلجة',
        nameEn: 'Iced Drinks',
        description: 'مشروبات مثلجة منعشة وباردة',
        descriptionEn: 'Refreshing ice-cold beverages',
        iconPath: placeholderImage,
        order: 2,
      ),
      Category(
        id: 'cat4',
        name: 'عصائر طازجة',
        nameEn: 'Fresh Juices',
        description: 'عصائر طازجة من الفواكه الطبيعية',
        descriptionEn: 'Fresh juices made from natural fruits',
        iconPath: placeholderImage,
        order: 3,
      ),
      Category(
        id: 'cat5',
        name: 'الوجبات الخفيفة',
        nameEn: 'Snacks',
        description: 'وجبات خفيفة لذيذة',
        descriptionEn: 'Delicious light snacks',
        iconPath: placeholderImage,
        order: 4,
      ),
      Category(
        id: 'cat6',
        name: 'الحلويات',
        nameEn: 'Desserts',
        description: 'حلويات شهية ومميزة',
        descriptionEn: 'Delicious and special desserts',
        iconPath: placeholderImage,
        order: 5,
      ),
    ];
  }

  // Get all products in both languages
  static List<Product> getProducts() {
    const uuid = Uuid();

    return [
      // Category 1: Hot Drinks
      Product(
        id: uuid.v4(),
        name: 'إسبريسو',
        nameEn: 'Espresso',
        description: 'قهوة إسبريسو قوية ونقية',
        descriptionEn: 'Strong and pure espresso coffee',
        price: 1.200,
        cost: 0.500,
        categoryId: 'cat1',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'أمريكانو',
        nameEn: 'Americano',
        description: 'قهوة إسبريسو مع ماء ساخن',
        descriptionEn: 'Espresso with hot water',
        price: 1.200,
        cost: 0.500,
        categoryId: 'cat1',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'كابتشينو',
        nameEn: 'Cappuccino',
        description: 'إسبريسو مع حليب مبخر ورغوة حليب',
        descriptionEn: 'Espresso with steamed milk and milk foam',
        price: 1.700,
        cost: 0.700,
        categoryId: 'cat1',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'لاتيه',
        nameEn: 'Latte',
        description: 'إسبريسو مع حليب مبخر وطبقة رقيقة من رغوة الحليب',
        descriptionEn:
            'Espresso with steamed milk and a thin layer of milk foam',
        price: 1.700,
        cost: 0.700,
        categoryId: 'cat1',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'قهوة تركية',
        nameEn: 'Turkish Coffee',
        description: 'قهوة تركية أصيلة',
        descriptionEn: 'Authentic Turkish coffee',
        price: 1.200,
        cost: 0.500,
        categoryId: 'cat1',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'قهوة عربية',
        nameEn: 'Arabic Coffee',
        description: 'قهوة عربية تقليدية مع الهيل',
        descriptionEn: 'Traditional Arabic coffee with cardamom',
        price: 1.500,
        cost: 0.600,
        categoryId: 'cat1',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'موكا',
        nameEn: 'Mocha',
        description: 'إسبريسو مع شوكولاتة وحليب مبخر',
        descriptionEn: 'Espresso with chocolate and steamed milk',
        price: 1.800,
        cost: 0.800,
        categoryId: 'cat1',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'شاي',
        nameEn: 'Tea',
        description: 'شاي أسود كلاسيكي',
        descriptionEn: 'Classic black tea',
        price: 1.000,
        cost: 0.300,
        categoryId: 'cat1',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'شاي بالنعناع',
        nameEn: 'Mint Tea',
        description: 'شاي منعش بالنعناع الطازج',
        descriptionEn: 'Refreshing tea with fresh mint',
        price: 1.200,
        cost: 0.400,
        categoryId: 'cat1',
        imageUrl: placeholderImage,
      ),

      // Category 2: Cold Drinks
      Product(
        id: uuid.v4(),
        name: 'قهوة مثلجة',
        nameEn: 'Iced Coffee',
        description: 'قهوة باردة منعشة',
        descriptionEn: 'Refreshing cold coffee',
        price: 1.700,
        cost: 0.700,
        categoryId: 'cat2',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'لاتيه مثلج',
        nameEn: 'Iced Latte',
        description: 'لاتيه بارد مع حليب وثلج',
        descriptionEn: 'Cold latte with milk and ice',
        price: 1.900,
        cost: 0.800,
        categoryId: 'cat2',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'موكا مثلجة',
        nameEn: 'Iced Mocha',
        description: 'موكا باردة مع شوكولاتة وحليب وثلج',
        descriptionEn: 'Cold mocha with chocolate, milk and ice',
        price: 2.000,
        cost: 0.900,
        categoryId: 'cat2',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'كراميل فرابتشينو',
        nameEn: 'Caramel Frappuccino',
        description: 'مشروب بارد مثلج مع صوص الكراميل والحليب والقهوة',
        descriptionEn: 'Cold iced drink with caramel sauce, milk and coffee',
        price: 2.200,
        cost: 1.000,
        categoryId: 'cat2',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'شوكولاتة فرابتشينو',
        nameEn: 'Chocolate Frappuccino',
        description: 'مشروب بارد مثلج مع شوكولاتة والحليب والقهوة',
        descriptionEn: 'Cold iced drink with chocolate, milk and coffee',
        price: 2.200,
        cost: 1.000,
        categoryId: 'cat2',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'ماتشا لاتيه مثلج',
        nameEn: 'Iced Matcha Latte',
        description: 'لاتيه بارد بالماتشا والحليب والثلج',
        descriptionEn: 'Cold latte with matcha, milk and ice',
        price: 2.100,
        cost: 1.000,
        categoryId: 'cat2',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'شاي مثلج',
        nameEn: 'Iced Tea',
        description: 'شاي بارد منعش',
        descriptionEn: 'Refreshing cold tea',
        price: 1.500,
        cost: 0.600,
        categoryId: 'cat2',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'كولد برو',
        nameEn: 'Cold Brew',
        description: 'قهوة مبردة بطريقة التخمير البارد',
        descriptionEn: 'Coffee brewed by cold brew method',
        price: 1.900,
        cost: 0.800,
        categoryId: 'cat2',
        imageUrl: placeholderImage,
      ),

      // Category 3: Iced Drinks
      Product(
        id: uuid.v4(),
        name: 'موهيتو',
        nameEn: 'Mojito',
        description: 'مشروب منعش بالنعناع والليمون',
        descriptionEn: 'Refreshing drink with mint and lemon',
        price: 2.100,
        cost: 0.900,
        categoryId: 'cat3',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'بلو ليمونادة',
        nameEn: 'Blue Lemonade',
        description: 'ليمونادة زرقاء منعشة',
        descriptionEn: 'Refreshing blue lemonade',
        price: 1.800,
        cost: 0.700,
        categoryId: 'cat3',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'سموذي فراولة',
        nameEn: 'Strawberry Smoothie',
        description: 'سموذي بالفراولة الطازجة',
        descriptionEn: 'Smoothie with fresh strawberries',
        price: 2.000,
        cost: 0.900,
        categoryId: 'cat3',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'سموذي مانجو',
        nameEn: 'Mango Smoothie',
        description: 'سموذي بالمانجو الطازجة',
        descriptionEn: 'Smoothie with fresh mango',
        price: 2.000,
        cost: 0.900,
        categoryId: 'cat3',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'ميلك شيك شوكولاتة',
        nameEn: 'Chocolate Milkshake',
        description: 'ميلك شيك بالشوكولاتة الغنية',
        descriptionEn: 'Milkshake with rich chocolate',
        price: 2.200,
        cost: 1.000,
        categoryId: 'cat3',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'ميلك شيك فانيلا',
        nameEn: 'Vanilla Milkshake',
        description: 'ميلك شيك بالفانيلا',
        descriptionEn: 'Milkshake with vanilla',
        price: 2.200,
        cost: 1.000,
        categoryId: 'cat3',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'ميلك شيك فراولة',
        nameEn: 'Strawberry Milkshake',
        description: 'ميلك شيك بالفراولة الطازجة',
        descriptionEn: 'Milkshake with fresh strawberries',
        price: 2.200,
        cost: 1.000,
        categoryId: 'cat3',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'آيس لاتيه بالكراميل',
        nameEn: 'Caramel Iced Latte',
        description: 'لاتيه مثلج مع صوص الكراميل',
        descriptionEn: 'Iced latte with caramel sauce',
        price: 2.100,
        cost: 0.900,
        categoryId: 'cat3',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'آيس كابتشينو',
        nameEn: 'Iced Cappuccino',
        description: 'كابتشينو مثلج منعش',
        descriptionEn: 'Refreshing iced cappuccino',
        price: 2.000,
        cost: 0.800,
        categoryId: 'cat3',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'آيس أمريكانو',
        nameEn: 'Iced Americano',
        description: 'أمريكانو مثلج منعش',
        descriptionEn: 'Refreshing iced americano',
        price: 1.600,
        cost: 0.600,
        categoryId: 'cat3',
        imageUrl: placeholderImage,
      ),

      // Category 4: Fresh Juices
      Product(
        id: uuid.v4(),
        name: 'عصير برتقال',
        nameEn: 'Orange Juice',
        description: 'عصير برتقال طازج',
        descriptionEn: 'Fresh orange juice',
        price: 1.800,
        cost: 0.800,
        categoryId: 'cat4',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'عصير تفاح',
        nameEn: 'Apple Juice',
        description: 'عصير تفاح طازج',
        descriptionEn: 'Fresh apple juice',
        price: 1.800,
        cost: 0.800,
        categoryId: 'cat4',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'عصير أناناس',
        nameEn: 'Pineapple Juice',
        description: 'عصير أناناس طازج',
        descriptionEn: 'Fresh pineapple juice',
        price: 2.000,
        cost: 0.900,
        categoryId: 'cat4',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'عصير مانجو',
        nameEn: 'Mango Juice',
        description: 'عصير مانجو طازج',
        descriptionEn: 'Fresh mango juice',
        price: 2.000,
        cost: 0.900,
        categoryId: 'cat4',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'عصير فراولة',
        nameEn: 'Strawberry Juice',
        description: 'عصير فراولة طازج',
        descriptionEn: 'Fresh strawberry juice',
        price: 2.000,
        cost: 0.900,
        categoryId: 'cat4',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'عصير جزر',
        nameEn: 'Carrot Juice',
        description: 'عصير جزر طازج',
        descriptionEn: 'Fresh carrot juice',
        price: 1.800,
        cost: 0.700,
        categoryId: 'cat4',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'عصير تفاح وجزر',
        nameEn: 'Apple & Carrot Juice',
        description: 'مزيج من عصير التفاح والجزر الطازج',
        descriptionEn: 'Mix of fresh apple and carrot juice',
        price: 2.000,
        cost: 0.900,
        categoryId: 'cat4',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'عصير أفوكادو',
        nameEn: 'Avocado Juice',
        description: 'عصير أفوكادو طازج',
        descriptionEn: 'Fresh avocado juice',
        price: 2.200,
        cost: 1.100,
        categoryId: 'cat4',
        imageUrl: placeholderImage,
      ),

      // Category 5: Snacks
      Product(
        id: uuid.v4(),
        name: 'كروسان سادة',
        nameEn: 'Plain Croissant',
        description: 'كروسان طازج',
        descriptionEn: 'Fresh plain croissant',
        price: 1.500,
        cost: 0.600,
        categoryId: 'cat5',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'كروسان جبنة',
        nameEn: 'Cheese Croissant',
        description: 'كروسان طازج محشو بالجبنة',
        descriptionEn: 'Fresh croissant filled with cheese',
        price: 1.800,
        cost: 0.800,
        categoryId: 'cat5',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'سلطة فواكه',
        nameEn: 'Fruit Salad',
        description: 'سلطة من الفواكه الطازجة الموسمية',
        descriptionEn: 'Salad of fresh seasonal fruits',
        price: 2.500,
        cost: 1.200,
        categoryId: 'cat5',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'ساندويتش جبنة',
        nameEn: 'Cheese Sandwich',
        description: 'ساندويتش بالجبنة الطازجة',
        descriptionEn: 'Sandwich with fresh cheese',
        price: 2.000,
        cost: 0.900,
        categoryId: 'cat5',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'ساندويتش تونا',
        nameEn: 'Tuna Sandwich',
        description: 'ساندويتش بالتونا الطازجة',
        descriptionEn: 'Sandwich with fresh tuna',
        price: 2.200,
        cost: 1.000,
        categoryId: 'cat5',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'ساندويتش دجاج',
        nameEn: 'Chicken Sandwich',
        description: 'ساندويتش بالدجاج المشوي',
        descriptionEn: 'Sandwich with grilled chicken',
        price: 2.300,
        cost: 1.100,
        categoryId: 'cat5',
        imageUrl: placeholderImage,
      ),

      // Category 6: Desserts
      Product(
        id: uuid.v4(),
        name: 'تشيز كيك',
        nameEn: 'Cheesecake',
        description: 'كعكة الجبن التقليدية',
        descriptionEn: 'Traditional cheesecake',
        price: 2.500,
        cost: 1.200,
        categoryId: 'cat6',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'تيراميسو',
        nameEn: 'Tiramisu',
        description: 'حلوى التيراميسو الإيطالية الشهيرة',
        descriptionEn: 'Famous Italian tiramisu dessert',
        price: 2.500,
        cost: 1.200,
        categoryId: 'cat6',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'براونيز',
        nameEn: 'Brownies',
        description: 'قطع براونيز بالشوكولاتة الغنية',
        descriptionEn: 'Brownie pieces with rich chocolate',
        price: 2.200,
        cost: 1.000,
        categoryId: 'cat6',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'كوكيز بالشوكولاتة',
        nameEn: 'Chocolate Cookies',
        description: 'كوكيز بقطع الشوكولاتة',
        descriptionEn: 'Cookies with chocolate chips',
        price: 1.800,
        cost: 0.800,
        categoryId: 'cat6',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'كعكة الشوكولاتة',
        nameEn: 'Chocolate Cake',
        description: 'كعكة شوكولاتة غنية ولذيذة',
        descriptionEn: 'Rich and delicious chocolate cake',
        price: 2.800,
        cost: 1.300,
        categoryId: 'cat6',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'كعكة الفانيلا',
        nameEn: 'Vanilla Cake',
        description: 'كعكة فانيلا ناعمة ولذيذة',
        descriptionEn: 'Soft and delicious vanilla cake',
        price: 2.800,
        cost: 1.300,
        categoryId: 'cat6',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'موس الشوكولاتة',
        nameEn: 'Chocolate Mousse',
        description: 'موس شوكولاتة خفيف وغني',
        descriptionEn: 'Light and rich chocolate mousse',
        price: 2.200,
        cost: 1.000,
        categoryId: 'cat6',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'كريم بروليه',
        nameEn: 'Crème Brûlée',
        description: 'حلوى فرنسية كلاسيكية بطبقة كراميل مقرمشة',
        descriptionEn: 'Classic French dessert with crispy caramel layer',
        price: 2.500,
        cost: 1.200,
        categoryId: 'cat6',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'آيس كريم فانيلا',
        nameEn: 'Vanilla Ice Cream',
        description: 'آيس كريم فانيلا منعش',
        descriptionEn: 'Refreshing vanilla ice cream',
        price: 1.800,
        cost: 0.800,
        categoryId: 'cat6',
        imageUrl: placeholderImage,
      ),
      Product(
        id: uuid.v4(),
        name: 'آيس كريم شوكولاتة',
        nameEn: 'Chocolate Ice Cream',
        description: 'آيس كريم شوكولاتة غني',
        descriptionEn: 'Rich chocolate ice cream',
        price: 1.800,
        cost: 0.800,
        categoryId: 'cat6',
        imageUrl: placeholderImage,
      ),
    ];
  }
}
