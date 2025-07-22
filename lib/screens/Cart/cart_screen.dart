import 'package:flutter/material.dart';
import 'package:perpi_app/models/cart_item.dart';
import 'package:perpi_app/providers/cart_provider.dart';
import 'package:perpi_app/screens/constants.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

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
          "My Cart",
          style: TextStyle(
            color: textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: textPrimary,
          ),
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.isEmpty) {
            return _buildEmptyCart();
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      
                      // Cart Items
                      ...cartProvider.items.map((item) => _buildCartItem(context, item, cartProvider)),
                      
                      const SizedBox(height: 30),
                      
                      // Discount Code Section
                      _buildDiscountSection(cartProvider),
                      
                      const SizedBox(height: 30),
                      
                      // Order Summary
                      _buildOrderSummary(cartProvider),
                      
                      const SizedBox(height: 100), // Space for checkout button
                    ],
                  ),
                ),
              ),
              
              // Checkout Button
              _buildCheckoutButton(context, cartProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: textSecondary,
          ),
          const SizedBox(height: 20),
          Text(
            "Seu carrinho está vazio",
            style: TextStyle(
              color: textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Adicione alguns produtos para começar",
            style: TextStyle(
              color: textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem item, CartProvider cartProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: secondaryColor,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: secondaryColor,
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: textSecondary,
                        size: 30,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(width: 15),
          
          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  item.category,
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "${item.price}MT",
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 15),
          
          // Quantity Controls and Delete Button
          Column(
            children: [
              // Delete Button
              GestureDetector(
                onTap: () => cartProvider.removeFromCart(item.id),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: buttonColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    color: buttonColor,
                    size: 20,
                  ),
                ),
              ),
              
              const SizedBox(height: 15),
              
              // Quantity Controls
              Container(
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: dividerColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Decrease Button
                    GestureDetector(
                      onTap: () => cartProvider.updateQuantity(item.id, item.quantity - 1),
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.remove,
                          color: textPrimary,
                          size: 18,
                        ),
                      ),
                    ),
                    
                    // Quantity
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: Text(
                        "${item.quantity}",
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    
                    // Increase Button
                    GestureDetector(
                      onTap: () => cartProvider.updateQuantity(item.id, item.quantity + 1),
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add,
                          color: textPrimary,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountSection(CartProvider cartProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Enter Discount Code",
                hintStyle: TextStyle(
                  color: textSecondary,
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyle(
                color: textPrimary,
                fontSize: 16,
              ),
              onSubmitted: (code) {
                if (code.isNotEmpty) {
                  cartProvider.applyDiscountCode(code);
                }
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              // Get text field value and apply discount
              // For demo purposes, we'll apply a sample discount
              cartProvider.applyDiscountCode("welcome10");
            },
            child: Text(
              "Apply",
              style: TextStyle(
                color: buttonColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(CartProvider cartProvider) {
    return Column(
      children: [
        // Subtotal
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Subtotal",
              style: TextStyle(
                color: textSecondary,
                fontSize: 18,
              ),
            ),
            Text(
              "${cartProvider.subtotal.toStringAsFixed(2)}MT",
              style: TextStyle(
                color: textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        
        // Discount (if applied)
        if (cartProvider.discountPercentage > 0) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Desconto (${cartProvider.discountPercentage.toStringAsFixed(0)}%)",
                style: TextStyle(
                  color: accentColor,
                  fontSize: 16,
                ),
              ),
              Text(
                "-${cartProvider.discountAmount.toStringAsFixed(2)}MT",
                style: TextStyle(
                  color: accentColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
        
        const SizedBox(height: 20),
        
        // Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total",
              style: TextStyle(
                color: textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${cartProvider.total.toStringAsFixed(2)}MT",
              style: TextStyle(
                color: textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckoutButton(BuildContext context, CartProvider cartProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: cartProvider.isEmpty ? null : () {
              // Handle checkout
              _showCheckoutDialog(context, cartProvider);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 8,
              shadowColor: buttonColor.withOpacity(0.3),
            ),
            child: const Text(
              "Checkout",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCheckoutDialog(BuildContext context, CartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Confirmar Pedido",
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Deseja finalizar seu pedido no valor de ${cartProvider.total.toStringAsFixed(2)}MT?",
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
                cartProvider.clearCart();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Pedido realizado com sucesso!"),
                    backgroundColor: accentColor,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }
}