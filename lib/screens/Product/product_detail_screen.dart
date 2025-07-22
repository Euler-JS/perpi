import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:perpi_app/models/product_details.dart';
import 'package:perpi_app/providers/cart_provider.dart';
import 'package:perpi_app/screens/constants.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductDetails product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.product.isFav;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header com imagem do produto
            _buildImageHeader(size),
            
            // Conteúdo scrollável
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProductInfo(),
                        const SizedBox(height: 20),
                        _buildRatingSection(),
                        const SizedBox(height: 20),
                        _buildDescriptionSection(),
                        const SizedBox(height: 20),
                        _buildQuantitySelector(),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // Bottom bar com preço e botão de adicionar
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageHeader(Size size) {
    return Container(
      height: size.height * 0.4,
      width: double.infinity,
      color: secondaryColor,
      child: Stack(
        children: [
          // Imagem do produto
          Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(40),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                widget.product.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: Icon(
                      Icons.image_not_supported,
                      color: textSecondary,
                      size: 80,
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Botões de navegação
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: textPrimary,
                  size: 20,
                ),
              ),
            ),
          ),
          
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: isFavorite ? buttonColor : Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.white : textPrimary,
                  size: 20,
                ),
              ),
            ),
          ),
          
          // Badge de oferta
          if (widget.product.isOnSale)
            Positioned(
              top: 80,
              left: 30,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  "OFERTA",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Categoria
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: accentColor.withOpacity(0.3)),
          ),
          child: Text(
            widget.product.category,
            style: TextStyle(
              color: accentColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Nome do produto
        Text(
          widget.product.name,
          style: TextStyle(
            color: textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Preços
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "${widget.product.price}MT",
              style: TextStyle(
                color: buttonColor,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "/${widget.product.unit}",
              style: TextStyle(
                color: textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 16),
            if (widget.product.isOnSale && widget.product.originalPrice != null)
              Text(
                "${widget.product.originalPrice}MT",
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 18,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Container(
      padding: const EdgeInsets.all(16),
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
          // Rating
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  "${widget.product.rating}",
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Avaliações
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.product.reviewCount} avaliações",
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Ver todas as avaliações",
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // Disponibilidade
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: widget.product.isAvailable 
                ? accentColor.withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.product.isAvailable ? "Disponível" : "Esgotado",
              style: TextStyle(
                color: widget.product.isAvailable ? accentColor : Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Descrição",
          style: TextStyle(
            color: textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.product.description ?? "Produto de alta qualidade, ideal para o seu dia a dia. Produzido com os melhores ingredientes e seguindo rigorosos padrões de qualidade.",
          style: TextStyle(
            color: textSecondary,
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quantidade",
          style: TextStyle(
            color: textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            // Botão diminuir
            Container(
              decoration: BoxDecoration(
                color: cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: dividerColor),
              ),
              child: IconButton(
                onPressed: quantity > 1 ? () {
                  setState(() {
                    quantity--;
                  });
                } : null,
                icon: Icon(
                  Icons.remove,
                  color: quantity > 1 ? textPrimary : textSecondary,
                ),
              ),
            ),
            
            const SizedBox(width: 20),
            
            // Quantidade
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: accentColor.withOpacity(0.3)),
              ),
              child: Text(
                "$quantity",
                style: TextStyle(
                  color: accentColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            const SizedBox(width: 20),
            
            // Botão aumentar
            Container(
              decoration: BoxDecoration(
                color: cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: dividerColor),
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    quantity++;
                  });
                },
                icon: Icon(
                  Icons.add,
                  color: textPrimary,
                ),
              ),
            ),
            
            const Spacer(),
            
            // Preço total
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Total",
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "${(double.parse(widget.product.price) * quantity).toStringAsFixed(2)}MT",
                  style: TextStyle(
                    color: buttonColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Container(
          padding: const EdgeInsets.all(24),
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
          child: Row(
            children: [
              // Botão favorito
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: dividerColor),
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? buttonColor : textSecondary,
                    size: 24,
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Botão adicionar ao carrinho
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.product.isAvailable ? () {
                    // Adicionar ao carrinho com a quantidade selecionada
                    cartProvider.addToCart(widget.product, quantity: quantity);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${widget.product.name} (${quantity}x) adicionado ao carrinho!"),
                        backgroundColor: accentColor,
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                        margin: const EdgeInsets.all(16),
                      ),
                    );
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.product.isAvailable ? buttonColor : textSecondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: widget.product.isAvailable ? 8 : 0,
                    shadowColor: buttonColor.withOpacity(0.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shopping_bag_outlined, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        widget.product.isAvailable 
                          ? "Adicionar ao Carrinho" 
                          : "Produto Esgotado",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}