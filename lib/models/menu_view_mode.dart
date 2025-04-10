/// تعريف أوضاع عرض القائمة
enum MenuViewMode {
  grid, // Grid layout with images
  list, // List layout
  compact, // Compact list layout
  textOnly, // Text-only layout
  singleProduct, // Shows one product at a time
  categories // Shows categories only
}

// Function to convert string to MenuViewMode
MenuViewMode stringToMenuViewMode(String viewModeString) {
  switch (viewModeString) {
    case 'grid':
      return MenuViewMode.grid;
    case 'list':
      return MenuViewMode.list;
    case 'compact':
      return MenuViewMode.compact;
    case 'textOnly':
      return MenuViewMode.textOnly;
    case 'singleProduct':
      return MenuViewMode.singleProduct;
    case 'categories':
      return MenuViewMode.categories;
    default:
      return MenuViewMode.grid; // Default to grid
  }
}

// Function to convert MenuViewMode to string
String menuViewModeToString(MenuViewMode viewMode) {
  switch (viewMode) {
    case MenuViewMode.grid:
      return 'grid';
    case MenuViewMode.list:
      return 'list';
    case MenuViewMode.compact:
      return 'compact';
    case MenuViewMode.textOnly:
      return 'textOnly';
    case MenuViewMode.singleProduct:
      return 'singleProduct';
    case MenuViewMode.categories:
      return 'categories';
  }
}
