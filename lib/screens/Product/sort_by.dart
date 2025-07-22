import 'package:flutter/material.dart';
import 'package:perpi_app/screens/constants.dart';

class SortBy extends StatelessWidget {
  const SortBy({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: buttonColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.tune, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  "Filtros",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: cardBackground,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: dividerColor),
            ),
            child: Center(
              child: Text(
                "Ofertas",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: cardBackground,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: dividerColor),
            ),
            child: Center(
              child: Text(
                "Populares",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: cardBackground,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: dividerColor),
            ),
            child: Center(
              child: Text(
                "Novos",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}