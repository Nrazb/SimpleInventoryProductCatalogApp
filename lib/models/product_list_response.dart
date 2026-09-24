import 'product.dart';

class ProductListResponse {
  final List<Product> products;
  final int total;

  ProductListResponse({required this.products, required this.total});

  factory ProductListResponse.fromJson(
    Map<String, dynamic> json, {
    required int skip,
    required int limit,
  }) {
    final list = (json['data'] as List<dynamic>? ?? [])
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();

    final metaCount = (json['meta'] as Map<String, dynamic>?)?['filter_count'];
    final total = metaCount != null
        ? (metaCount as num).toInt()
        : skip + list.length + (list.length == limit ? limit : 0);

    return ProductListResponse(products: list, total: total);
  }
}
