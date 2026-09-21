import 'dart:convert';

class Product {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String description;
  final String? imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.description = '',
    this.imageUrl,
  });

  Product copyWith({
    String? name,
    double? price,
    int? quantity,
    String? description,
    String? imageUrl,
    bool clearImage = false,
  }) {
    return Product(
      id: id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
      imageUrl: clearImage ? null : (imageUrl ?? this.imageUrl),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'price': price,
    'quantity': quantity,
    'description': description,
    'imageUrl': imageUrl,
  };

  factory Product.fromMap(Map<String, dynamic> map) => Product(
    id: map['id'] as String,
    name: map['name'] as String,
    price: (map['price'] as num).toDouble(),
    quantity: map['quantity'] as int,
    description: (map['description'] ?? '') as String,
    imageUrl: map['imageUrl'] as String?,
  );

  static String encodeList(List<Product> products) =>
      jsonEncode(products.map((p) => p.toMap()).toList());

  static List<Product> decodeList(String source) {
    final List<dynamic> data = jsonDecode(source) as List<dynamic>;
    return data.map((e) => Product.fromMap(e as Map<String, dynamic>)).toList();
  }
}
