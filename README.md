# ☕ JBR Coffee Shop App

## 📋 Overview
JBR Coffee Shop App is an e-commerce platform designed specifically for coffee shops, allowing users to browse products, filter by categories, and add items to their shopping cart. The application is available for Android and web platforms only.

## 📱 Supported Platforms
- 🤖 Android
- 🌐 Web

## ✨ Key Features
- 🍽️ **Interactive Menu**: Attractive product listing with detailed information and filtering options
- 📊 **Admin Dashboard**: Comprehensive dashboard with sales charts and analytics
- 📈 **Sales Analytics**: Real-time analysis of top-selling products and sales trends
- 🔐 **Authentication System**: Secure login for customers and staff
- 📲 **QR Code Payment**: Generate QR codes for contactless payment
- 🎨 **Multiple Themes**: Support for various UI themes to match your coffee shop's brand
- 📦 **Order Management**: Easy tracking and processing of customer orders

## 🏗️ Project Structure
```
lib/
|-- main.dart
|-- screens/
|   |-- menu_screen.dart
|-- widgets/
|   |-- product_card.dart
|-- models/
|   |-- product.dart
|-- controllers/
|   |-- product_controller.dart
|-- services/
|   |-- api_service.dart
```

## 🛠️ How to Use

### 👥 Customer Experience
When opening the app, users will see the main menu screen featuring:

1. **Navigation Bar**: Displays "Product Menu" at the top
2. **Categories Section**: Horizontal scrollable bar for filtering products by category
3. **Products Grid**: Displays available products as cards showing product image, name, price, and an add-to-cart button

Customers can:
- Click on any category to filter related products
- Tap on any product to view its complete details
- Add products directly to the shopping cart
- Complete the checkout process

### 🛡️ Admin Experience
Administrators can access the dashboard by logging in with admin credentials:

1. **Sales Dashboard**: View real-time sales data with interactive charts
2. **Inventory Management**: Add, edit, or remove products from the menu
3. **Analytics Panel**: Analyze selling trends and customer preferences
4. **Settings**: Configure app settings including:
   - QR Code Generation: Enter phone number to generate payment QR codes
   - Theme Selection: Choose from multiple UI themes
   - User Management: Manage staff accounts and permissions

## 💳 QR Code Payment Setup
In the admin settings, owners can:
1. Navigate to the Settings page
2. Select "Payment Methods"
3. Choose "Generate QR Code"
4. Enter the business phone number
5. The system will generate a unique QR code that can be printed or displayed for customer payments

## 🛠️ Technologies Used
- Flutter - Cross-platform development framework
- GetX - State management and routing
- Material Design - UI design system
- Firebase - Backend services and authentication
- Chart.js - For sales analytics visualization

## 💻 System Requirements
- For web: Any modern browser
- For Android: Android 5.0 or higher

## 🚀 Future Development
We are currently working on developing the following features:
- Integration with popular POS systems
- Customer loyalty program
- Scheduled orders and reservations
- Expanded payment options
- Menu customization for dietary preferences

## 📥 Installation
1. Download the app from Google Play Store (for Android) or visit our website (for web)
2. Install the app on your device if using Android
3. Start browsing products and enjoy a seamless shopping experience!

## 🛠️ Technical Support
For inquiries or assistance, please contact us via email: support@jbrcoffee.com
