class Product {
  final String? id;
  final String name;
  final double price;
  final int stock;
  final String? image;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.stock,
    this.image,
  });

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id']?.toString(),
    name: json['name'] as String? ?? '',
    price: _toDouble(json['price']),
    stock: _toInt(json['stock']),
    image: json['image'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
    'stock': stock,
    if (image != null && image!.trim().isNotEmpty) 'image': image,
  };
}
