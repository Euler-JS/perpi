import 'package:flutter/material.dart';
import 'package:perpi_app/models/product_details.dart';
import 'package:perpi_app/screens/Common/product_view.dart';
import 'package:perpi_app/screens/Product/sort_by.dart';
import 'package:perpi_app/screens/constants.dart';

class ProductDisplayScreen extends StatelessWidget {
  const ProductDisplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        surfaceTintColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Produtos",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: textPrimary,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: textPrimary,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: dividerColor),
                  ),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    size: 24,
                    color: textPrimary,
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: buttonColor,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const SortBy(),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(bottom: 30),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, 
                  childAspectRatio: 0.64,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: productItems.length,
                itemBuilder: (context, index) {
                  final product = productItems[index];
                  return ProductView(
                    imageUrl: product.imagePath,
                    price: product.price,
                    product: product,
                    title: product.name,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
