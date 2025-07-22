import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product_details.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  String _discountCode = '';
  double _discountPercentage = 0.0;

  List<CartItem> get items => List.unmodifiable(_items);
  String get discountCode => _discountCode;
  double get discountPercentage => _discountPercentage;

  int get itemCount => _items.fold(0, (total, item) => total + item.quantity);

  double get subtotal => _items.fold(0.0, (total, item) => total + item.totalPrice);

  double get discountAmount => subtotal * (_discountPercentage / 100);

  double get total => subtotal - discountAmount;

  bool get isEmpty => _items.isEmpty;

  void addToCart(ProductDetails product, {int quantity = 1}) {
    final existingIndex = _items.indexWhere((item) => item.id == product.imagePath);
    
    if (existingIndex >= 0) {
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + quantity,
      );
    } else {
      _items.add(CartItem(
        id: product.imagePath, // Using imagePath as unique ID
        name: product.name,
        price: product.price,
        imagePath: product.imagePath,
        category: product.category,
        unit: product.unit,
        quantity: quantity,
        isAvailable: product.isAvailable,
      ));
    }
    notifyListeners();
  }

  void removeFromCart(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  void updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(itemId);
      return;
    }

    final index = _items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: quantity);
      notifyListeners();
    }
  }

  void applyDiscountCode(String code) {
    _discountCode = code;
    
    // Simple discount logic - in real app, this would be validated with backend
    switch (code.toLowerCase()) {
      case 'welcome10':
        _discountPercentage = 10.0;
        break;
      case 'save20':
        _discountPercentage = 20.0;
        break;
      case 'perpi15':
        _discountPercentage = 15.0;
        break;
      default:
        _discountPercentage = 0.0;
    }
    notifyListeners();
  }

  void clearDiscountCode() {
    _discountCode = '';
    _discountPercentage = 0.0;
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _discountCode = '';
    _discountPercentage = 0.0;
    notifyListeners();
  }
}