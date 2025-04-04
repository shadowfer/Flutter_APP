class CartItemModel {
  final String id;
  final String name;
  final String image;
  final double price;
  final String category;
  int quantity;

  CartItemModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.category,
    this.quantity = 1,
  });

  // Getter para calcular el subtotal
  double get subtotal => price * quantity;

  // Método para convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'category': category,
      'quantity': quantity,
    };
  }

  // Método para crear desde Map de Firestore
  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      price: (map['price'] is String)
          ? double.parse(map['price'])
          : (map['price'] ?? 0.0).toDouble(),
      category: map['category'] ?? '',
      quantity: map['quantity'] ?? 1,
    );
  }

  // Método para crear una copia con cambios
  CartItemModel copyWith({
    String? id,
    String? name,
    String? image,
    double? price,
    String? category,
    int? quantity,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
    );
  }
}
