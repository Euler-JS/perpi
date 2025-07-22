class CartItem {
  String id;
  String name;
  String price;
  String imagePath;
  String category;
  String unit;
  int quantity;
  bool isAvailable;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.category,
    required this.unit,
    this.quantity = 1,
    this.isAvailable = true,
  });

  double get totalPrice => double.parse(price) * quantity;

  CartItem copyWith({
    String? id,
    String? name,
    String? price,
    String? imagePath,
    String? category,
    String? unit,
    int? quantity,
    bool? isAvailable,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}