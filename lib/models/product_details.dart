class ProductDetails {
  String name;
  String price;
  String imagePath;
  bool isFav;
  String category;
  String unit;
  String? originalPrice;
  bool isOnSale;
  String? description;
  double rating;
  int reviewCount;
  bool isAvailable;

  ProductDetails({
    required this.name,
    required this.price,
    required this.imagePath,
    required this.isFav,
    required this.category,
    required this.unit,
    this.originalPrice,
    this.isOnSale = false,
    this.description,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.isAvailable = true,
  });
}

// Produtos de mercearia para o app Perpi Delivery
List<ProductDetails> productItems = [
  // Frutas & Vegetais
  ProductDetails(
    name: "Maçãs Vermelhas",
    price: "150.00",
    originalPrice: "180.00",
    imagePath: "https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=500&h=500&fit=crop&crop=center",
    isFav: false,
    category: "Frutas & Vegetais",
    unit: "kg",
    isOnSale: true,
    description: "Maçãs vermelhas frescas e doces, ricas em vitaminas",
    rating: 4.7,
    reviewCount: 156,
  ),
  
  ProductDetails(
    name: "Bananas",
    price: "80.00",
    imagePath: "https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=500&h=500&fit=crop&crop=center",
    isFav: true,
    category: "Frutas & Vegetais",
    unit: "kg",
    description: "Bananas maduras e saborosas, fonte natural de energia",
    rating: 4.5,
    reviewCount: 89,
  ),

  ProductDetails(
    name: "Tomates Frescos",
    price: "120.00",
    imagePath: "https://images.unsplash.com/photo-1546094096-0df4bcaaa337?w=500&h=500&fit=crop&crop=center",
    isFav: false,
    category: "Frutas & Vegetais",
    unit: "kg",
    description: "Tomates vermelhos frescos, ideais para saladas e cozinhados",
    rating: 4.6,
    reviewCount: 234,
  ),

  ProductDetails(
    name: "Cebolas",
    price: "90.00",
    imagePath: "https://images.unsplash.com/photo-1508747703725-719777637510?w=500&h=500&fit=crop&crop=center",
    isFav: false,
    category: "Frutas & Vegetais",
    unit: "kg",
    description: "Cebolas frescas, tempero essencial para sua cozinha",
    rating: 4.3,
    reviewCount: 67,
  ),

  // Carne & Peixe
  ProductDetails(
    name: "Frango Inteiro",
    price: "350.00",
    imagePath: "https://images.unsplash.com/photo-1518492104633-130d0cc84637?w=500&h=500&fit=crop&crop=center",
    isFav: true,
    category: "Carne & Peixe",
    unit: "kg",
    description: "Frango fresco e de qualidade, criado em quintal",
    rating: 4.8,
    reviewCount: 145,
  ),

  ProductDetails(
    name: "Peixe Tilápia",
    price: "280.00",
    imagePath: "https://images.unsplash.com/photo-1544943910-4c1dc44aab44?w=500&h=500&fit=crop&crop=center",
    isFav: false,
    category: "Carne & Peixe",
    unit: "kg",
    description: "Peixe tilápia fresco, rica em proteínas e ômega-3",
    rating: 4.4,
    reviewCount: 78,
  ),

  // Laticínios
  ProductDetails(
    name: "Leite Integral",
    price: "85.00",
    imagePath: "https://images.unsplash.com/photo-1563636619-e9143da7973b?w=500&h=500&fit=crop&crop=center",
    isFav: false,
    category: "Laticínios",
    unit: "1L",
    description: "Leite integral pasteurizado, rico em cálcio",
    rating: 4.6,
    reviewCount: 201,
  ),

  ProductDetails(
    name: "Queijo Mussarela",
    price: "450.00",
    imagePath: "https://images.unsplash.com/photo-1486297678162-eb2a19b0a32d?w=500&h=500&fit=crop&crop=center",
    isFav: true,
    category: "Laticínios",
    unit: "500g",
    description: "Queijo mussarela cremoso, perfeito para pizzas e sanduíches",
    rating: 4.7,
    reviewCount: 167,
  ),

  // Padaria
  ProductDetails(
    name: "Pão de Forma",
    price: "65.00",
    imagePath: "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=500&h=500&fit=crop&crop=center",
    isFav: false,
    category: "Padaria",
    unit: "500g",
    description: "Pão de forma macio e fresco, ideal para sanduíches",
    rating: 4.5,
    reviewCount: 123,
  ),

  ProductDetails(
    name: "Pão Francês",
    price: "2.50",
    imagePath: "https://images.unsplash.com/photo-1585478259715-876acc5be8eb?w=500&h=500&fit=crop&crop=center",
    isFav: false,
    category: "Padaria",
    unit: "unidade",
    description: "Pão francês crocante e quentinho, direto do forno",
    rating: 4.8,
    reviewCount: 289,
  ),

  // Bebidas
  ProductDetails(
    name: "Água Mineral",
    price: "25.00",
    imagePath: "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500&h=500&fit=crop&crop=center",
    isFav: false,
    category: "Bebidas",
    unit: "1.5L",
    description: "Água mineral pura e cristalina",
    rating: 4.6,
    reviewCount: 345,
  ),

  ProductDetails(
    name: "Refrigerante Cola",
    price: "75.00",
    originalPrice: "85.00",
    imagePath: "https://images.unsplash.com/photo-1581636625402-29b2a704ef13?w=500&h=500&fit=crop&crop=center",
    isFav: true,
    category: "Bebidas",
    unit: "2L",
    isOnSale: true,
    description: "Refrigerante cola gelado, sabor tradicional",
    rating: 4.3,
    reviewCount: 198,
  ),

  // Limpeza
  ProductDetails(
    name: "Detergente Líquido",
    price: "45.00",
    imagePath: "https://images.unsplash.com/photo-1585421514738-01798e348b17?w=500&h=500&fit=crop&crop=center",
    isFav: false,
    category: "Limpeza",
    unit: "500ml",
    description: "Detergente concentrado, remove gordura facilmente",
    rating: 4.4,
    reviewCount: 156,
  ),

  ProductDetails(
    name: "Sabão em Pó",
    price: "180.00",
    imagePath: "https://images.unsplash.com/photo-1558618047-3c8c76ca7d13?w=500&h=500&fit=crop&crop=center",
    isFav: false,
    category: "Limpeza",
    unit: "2kg",
    description: "Sabão em pó concentrado, poder de limpeza superior",
    rating: 4.7,
    reviewCount: 234,
  ),

  // Grãos e Cereais
  ProductDetails(
    name: "Arroz Branco",
    price: "120.00",
    imagePath: "https://images.unsplash.com/photo-1586201375761-83865001e31c?w=500&h=500&fit=crop&crop=center",
    isFav: true,
    category: "Grãos & Cereais",
    unit: "5kg",
    description: "Arroz branco tipo 1, grãos selecionados",
    rating: 4.8,
    reviewCount: 412,
  ),

  ProductDetails(
    name: "Feijão Preto",
    price: "95.00",
    imagePath: "https://images.unsplash.com/photo-1596797882870-8c33deeaee20?w=500&h=500&fit=crop&crop=center",
    isFav: false,
    category: "Grãos & Cereais",
    unit: "1kg",
    description: "Feijão preto premium, rico em proteínas",
    rating: 4.6,
    reviewCount: 167,
  ),
];