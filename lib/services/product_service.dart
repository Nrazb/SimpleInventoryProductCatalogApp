import 'package:dio/dio.dart';
import '../models/product.dart';
import '../models/product_list_response.dart';
import 'api_client.dart';
import 'api_exception.dart';

class ProductService {
  final Dio _dio = ApiClient().dio;

  Future<ProductListResponse> getProducts({
    int limit = 10,
    int skip = 0,
    String? query,
  }) async {
    try {
      final hasQuery = query != null && query.trim().isNotEmpty;
      final response = await _dio.get(
        '/items/products',
        queryParameters: {
          'limit': limit,
          'offset': skip,
          'meta': 'filter_count',
          if (hasQuery) 'search': query.trim(),
        },
      );
      return ProductListResponse.fromJson(
        response.data as Map<String, dynamic>,
        skip: skip,
        limit: limit,
      );
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<Product> addProduct(Product product) async {
    try {
      final response = await _dio.post(
        '/items/products',
        data: product.toJson(),
      );
      final json = response.data as Map<String, dynamic>;
      return Product.fromJson(json['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<Product> updateProduct(String id, Product product) async {
    try {
      final response = await _dio.patch(
        '/items/products/$id',
        data: product.toJson(),
      );
      final json = response.data as Map<String, dynamic>;
      return Product.fromJson(json['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _dio.delete('/items/products/$id');
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}
