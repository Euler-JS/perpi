import 'package:flutter/material.dart';
import 'package:perpi_app/models/product_details.dart';
import 'package:perpi_app/providers/cart_provider.dart';
import 'package:perpi_app/providers/favorites_provider.dart';
import 'package:perpi_app/screens/Product/product_detail_screen.dart';
import 'package:perpi_app/screens/constants.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String selectedCategory = "Todos";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        surfaceTintColor: primaryColor,
        toolbarHeight: 100,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Favoritos",
          style: TextStyle(
            color: textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, child) {
              return favoritesProvider.isEmpty
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () => _showClearFavoritesDialog(context, favoritesProvider),
                      icon: Icon(
                        Icons.clear_all,
                        color: textPrimary,
                      ),
                    );
            },
          ),
        ],
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          if (favoritesProvider.isEmpty) {
            return _buildEmptyFavorites();
          }

          final categories = ["Todos", ...favoritesProvider.getFavoriteCategories()];
          final filteredFavorites = selectedCategory == "Todos"
              ? favoritesProvider.favorites
              : favoritesProvider.getFavoritesByCategory(selectedCategory);

          return Column(
            children: [
              // Category Filter
              if (categories.length > 1) _buildCategoryFilter(categories),
              
              // Favorites Count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${filteredFavorites.length} produtos favoritos",
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 16,
                      ),
                    ),
                    if (filteredFavorites.isNotEmpty)
                      GestureDetector(
                        onTap: () => _showAddAllToCartDialog(context, filteredFavorites),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: accentColor.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                color: accentColor,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Adicionar Tudo",
                                style: TextStyle(
                                  color: accentColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Favorites Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.64,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    itemCount: filteredFavorites.length,
                    itemBuilder: (context, index) {
                      final product = filteredFavorites[index];
                      return _buildFavoriteItem(context, product, favoritesProvider);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyFavorites() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 100,
            color: textSecondary,
          ),
          const SizedBox(height: 20),
          Text(
            "Nenhum favorito ainda",
            style: TextStyle(
              color: textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Adicione produtos aos favoritos\npara vê-los aqui",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              // Navigate back to home/products
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text("Explorar Produtos"),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(List<String> categories) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          
          return Container(
            margin: const EdgeInsets.only(right: 10),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedCategory = category;
                });
              },
              backgroundColor: cardBackground,
              selectedColor: buttonColor.withOpacity(0.2),
              checkmarkColor: buttonColor,
              labelStyle: TextStyle(
                color: isSelected ? buttonColor : textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? buttonColor : dividerColor,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFavoriteItem(BuildContext context, ProductDetails product, FavoritesProvider favoritesProvider) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Container
            Stack(
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: secondaryColor,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Image.network(
                      product.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: secondaryColor,
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: textSecondary,
                              size: 40,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                // Sale Badge
                if (product.isOnSale)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "OFERTA",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                
                // Remove from favorites button
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: buttonColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {
                        favoritesProvider.removeFavorite(product.imagePath);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${product.name} removido dos favoritos"),
                            backgroundColor: Colors.red.shade600,
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                            margin: const EdgeInsets.all(16),
                          ),
                        );
                      },
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.favorite,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                
                // Availability overlay
                if (!product.isAvailable)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        color: Colors.black.withOpacity(0.6),
                      ),
                      child: const Center(
                        child: Text(
                          "Esgotado",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
            // Product Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  //   decoration: BoxDecoration(
                  //     color: accentColor.withOpacity(0.1),
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  //   child: Text(
                  //     product.category,
                  //     style: TextStyle(
                  //       color: accentColor,
                  //       fontSize: 10,
                  //       fontWeight: FontWeight.w600,
                  //     ),
                  //   ),
                  // ),
                  
                  // const SizedBox(height: 6),
                  
                  // Product Name
                  Text(
                    product.name,
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 6),
                  
                  // Rating
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${product.rating}",
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "(${product.reviewCount})",
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Price section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Current Price with unit
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${product.price}MT",
                                style: TextStyle(
                                  color: textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "/${product.unit}",
                                style: TextStyle(
                                  color: textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          
                          // Original Price (if on sale)
                          if (product.isOnSale && product.originalPrice != null)
                            Text(
                              "${product.originalPrice}MT",
                              style: TextStyle(
                                color: textSecondary,
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                      
                      // Add to cart button
                      Consumer<CartProvider>(
                        builder: (context, cartProvider, child) {
                          return Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: product.isAvailable ? accentColor : textSecondary,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: product.isAvailable ? [
                                BoxShadow(
                                  color: accentColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ] : null,
                            ),
                            child: IconButton(
                              onPressed: product.isAvailable ? () {
                                cartProvider.addToCart(product);
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("${product.name} adicionado ao carrinho!"),
                                    backgroundColor: accentColor,
                                    behavior: SnackBarBehavior.floating,
                                    duration: const Duration(seconds: 2),
                                    margin: const EdgeInsets.all(16),
                                  ),
                                );
                              } : null,
                              icon: const Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearFavoritesDialog(BuildContext context, FavoritesProvider favoritesProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Limpar Favoritos",
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Deseja remover todos os produtos dos favoritos?",
            style: TextStyle(
              color: textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancelar",
                style: TextStyle(
                  color: textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                favoritesProvider.clearFavorites();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Favoritos removidos!"),
                    backgroundColor: Colors.red.shade600,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Remover Tudo"),
            ),
          ],
        );
      },
    );
  }

  void _showAddAllToCartDialog(BuildContext context, List<ProductDetails> products) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Adicionar ao Carrinho",
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Deseja adicionar todos os ${products.length} produtos favoritos ao carrinho?",
            style: TextStyle(
              color: textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancelar",
                style: TextStyle(
                  color: textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                final cartProvider = Provider.of<CartProvider>(context, listen: false);
                
                int addedCount = 0;
                for (var product in products) {
                  if (product.isAvailable) {
                    cartProvider.addToCart(product);
                    addedCount++;
                  }
                }
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("$addedCount produtos adicionados ao carrinho!"),
                    backgroundColor: accentColor,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Adicionar Tudo"),
            ),
          ],
        );
      },
    );
  }
}