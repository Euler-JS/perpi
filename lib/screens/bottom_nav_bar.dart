import 'package:flutter/material.dart';
import 'package:perpi_app/screens/Favorites/favorite_screen.dart';
import 'package:provider/provider.dart';
import 'package:perpi_app/screens/Product/product_display_screen.dart';
import 'package:perpi_app/screens/Cart/cart_screen.dart';
import 'package:perpi_app/screens/Profile/profile_screen.dart';
import 'package:perpi_app/providers/cart_provider.dart';
import 'package:perpi_app/providers/favorites_provider.dart';
import 'package:perpi_app/screens/constants.dart';

import 'Home/home_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;
  
  List<Widget> get screen => [
    const HomeScreen(), 
    const ProductDisplayScreen(),
    const CartScreen(),
    const ProfileScreen(),
    const FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[currentIndex],
      backgroundColor: primaryColor,
      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: buttonColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: buttonColor.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: IconButton(
          onPressed: () {
            setState(() {
              currentIndex = 0;
            });
          },
          icon: const Icon(
            Icons.home_filled,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: cardBackground,
        elevation: 20,
        notchMargin: 8,
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side icons
              Row(
                children: [
                  _buildNavItem(Icons.apps_outlined, 1),
                  const SizedBox(width: 40),
                  _buildFavoritesNavItem(),
                ],
              ),
              
              // Right side icons  
              Row(
                children: [
                  _buildCartNavItem(),
                  const SizedBox(width: 40),
                  _buildNavItem(Icons.local_shipping_outlined, 3),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        if (index <= 4) {
          setState(() {
            currentIndex = index;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          color: isSelected ? buttonColor : textSecondary,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildCartNavItem() {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        bool isSelected = currentIndex == 2;
        
        return GestureDetector(
          onTap: () {
            setState(() {
              currentIndex = 2;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  color: isSelected ? buttonColor : textSecondary,
                  size: 28,
                ),
                
                // Cart item count badge
                if (cartProvider.itemCount > 0)
                  Positioned(
                    top: -8,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: buttonColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: buttonColor.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Text(
                        cartProvider.itemCount > 99 ? '99+' : '${cartProvider.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFavoritesNavItem() {
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        bool isSelected = currentIndex == 4;
        
        return GestureDetector(
          onTap: () {
            setState(() {
              currentIndex = 4;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? Icons.favorite : Icons.favorite_border,
                  color: isSelected ? buttonColor : textSecondary,
                  size: 28,
                ),
                
                // Favorites count badge
                if (favoritesProvider.favoritesCount > 0)
                  Positioned(
                    top: -8,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red.shade500,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Text(
                        favoritesProvider.favoritesCount > 99 ? '99+' : '${favoritesProvider.favoritesCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}