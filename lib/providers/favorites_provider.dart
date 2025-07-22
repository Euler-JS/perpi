import 'package:flutter/material.dart';
import '../models/product_details.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<ProductDetails> _favorites = [];

  List<ProductDetails> get favorites => List.unmodifiable(_favorites);

  int get favoritesCount => _favorites.length;

  bool get isEmpty => _favorites.isEmpty;

  bool isFavorite(ProductDetails product) {
    return _favorites.any((fav) => fav.imagePath == product.imagePath);
  }

  void toggleFavorite(ProductDetails product) {
    final existingIndex = _favorites.indexWhere((fav) => fav.imagePath == product.imagePath);
    
    if (existingIndex >= 0) {
      // Remove from favorites
      _favorites.removeAt(existingIndex);
    } else {
      // Add to favorites
      final favoriteProduct = ProductDetails(
        name: product.name,
        price: product.price,
        imagePath: product.imagePath,
        isFav: true,
        category: product.category,
        unit: product.unit,
        originalPrice: product.originalPrice,
        isOnSale: product.isOnSale,
        description: product.description,
        rating: product.rating,
        reviewCount: product.reviewCount,
        isAvailable: product.isAvailable,
      );
      _favorites.add(favoriteProduct);
    }
    notifyListeners();
  }

  void removeFavorite(String productId) {
    _favorites.removeWhere((product) => product.imagePath == productId);
    notifyListeners();
  }

  void clearFavorites() {
    _favorites.clear();
    notifyListeners();
  }

  List<ProductDetails> getFavoritesByCategory(String category) {
    return _favorites.where((product) => product.category == category).toList();
  }

  List<String> getFavoriteCategories() {
    return _favorites.map((product) => product.category).toSet().toList();
  }
}