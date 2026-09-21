import 'package:flutter/material.dart';
import 'card_product.dart';
import 'detail_product.dart';
import 'form_product.dart';
import 'product.dart';
import 'product_storage.dart';

enum ViewState { loading, success, empty, error }

class ListProduct extends StatefulWidget {
  const ListProduct({super.key});

  @override
  State<ListProduct> createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  final ProductStorage _storage = ProductStorage();

  List<Product> _products = [];
  String _query = '';
  ViewState _state = ViewState.loading;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _state = ViewState.loading);
    try {
      final data = await _storage.load();
      if (!mounted) return;
      setState(() {
        _products = data;
        _state = data.isEmpty ? ViewState.empty : ViewState.success;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _state = ViewState.error;
      });
    }
  }

  Future<void> _persist() async {
    try {
      await _storage.save(_products);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save data: $e')));
    }
  }

  List<Product> get _filtered {
    if (_query.trim().isEmpty) return _products;
    final q = _query.toLowerCase();
    return _products.where((p) => p.name.toLowerCase().contains(q)).toList();
  }

  Future<void> _addProduct() async {
    final result = await Navigator.push<Product>(
      context,
      MaterialPageRoute(builder: (_) => const FormProduct()),
    );
    if (result == null) return;
    setState(() {
      _products.add(result);
      _state = ViewState.success;
    });
    await _persist();
  }

  Future<void> _editProduct(Product product) async {
    final result = await Navigator.push<Product>(
      context,
      MaterialPageRoute(builder: (_) => FormProduct(product: product)),
    );
    if (result == null) return;
    setState(() {
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) _products[index] = result;
    });
    await _persist();
  }

  Future<void> _deleteProduct(Product product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Delete "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    setState(() {
      _products.removeWhere((p) => p.id == product.id);
      if (_products.isEmpty) _state = ViewState.empty;
    });
    await _persist();
  }

  void _openDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailProduct(product: product)),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case ViewState.loading:
        return const Center(child: CircularProgressIndicator());

      case ViewState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 12),
                const Text('Something went wrong'),
                const SizedBox(height: 4),
                Text(
                  _errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadProducts,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );

      case ViewState.empty:
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 12),
              Text('No products yet. Tap + to add one.'),
            ],
          ),
        );

      case ViewState.success:
        final items = _filtered;
        if (items.isEmpty) {
          return const Center(child: Text('No products match your search.'));
        }
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final product = items[index];
            return CardProduct(
              product: product,
              onDetail: () => _openDetail(product),
              onEdit: () => _editProduct(product),
              onDelete: () => _deleteProduct(product),
            );
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List Product')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProduct,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search Product',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }
}
