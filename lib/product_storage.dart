import 'product.dart';
import 'dummy_product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductStorage {
  static const String _key = 'products';

  Future<List<Product>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    // Pertama kali dijalankan: isi dengan data dummy.
    if (raw == null) {
      final seed = List<Product>.from(dummyProducts);
      await save(seed);
      return seed;
    }
    return Product.decodeList(raw);
  }

  Future<void> save(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, Product.encodeList(products));
  }
}
