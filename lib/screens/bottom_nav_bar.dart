import 'package:flutter/material.dart';
import 'package:perpi_app/screens/Product/product_display_screen.dart';
import 'package:perpi_app/screens/constants.dart';

import 'Home/home_screen.dart';

List<Widget> screen = [const HomeScreen(), const ProductDisplayScreen()];

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;
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
        child: const Icon(
          Icons.home_filled,
          color: Colors.white,
          size: 28,
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
                  _buildNavItem(Icons.apps_outlined, 0),
                  const SizedBox(width: 40),
                  _buildNavItem(Icons.favorite_border, 1),
                ],
              ),
              
              // Right side icons  
              Row(
                children: [
                  _buildNavItem(Icons.shopping_bag_outlined, 2),
                  const SizedBox(width: 40),
                  _buildNavItem(Icons.person_outline, 3),
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
        if (index <= 1) {
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
}