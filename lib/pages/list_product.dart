import 'package:flutter/material.dart';
import '../models/product.dart';
import '../pages/detail_product.dart';
import '../pages/form_product.dart';
import '../services/product_service.dart';
import '../widgets/card_product.dart';

enum ViewState { loading, success, empty, error }

class ListProduct extends StatefulWidget {
  const ListProduct({super.key});

  @override
  State<ListProduct> createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  final ProductService _service = ProductService();
  final TextEditingController _searchCtrl = TextEditingController();

  static const int _limit = 10;

  List<Product> _products = [];
  ViewState _state = ViewState.loading;
  String _errorMessage = '';

  int _skip = 0;
  int _total = 0;
  String _query = '';

  int get _currentPage => (_skip ~/ _limit) + 1;
  int get _totalPages => _total == 0 ? 1 : ((_total - 1) ~/ _limit) + 1;
  bool get _hasNext => _skip + _limit < _total;
  bool get _hasPrev => _skip > 0;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadProducts({bool showLoading = true}) async {
    if (showLoading) setState(() => _state = ViewState.loading);
    try {
      final result = await _service.getProducts(
        limit: _limit,
        skip: _skip,
        query: _query,
      );
      if (!mounted) return;
      setState(() {
        _products = result.products;
        _total = result.total;
        _state = result.products.isEmpty ? ViewState.empty : ViewState.success;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _state = ViewState.error;
      });
    }
  }

  Future<void> _refresh() async => _loadProducts(showLoading: false);

  void _search(String value) {
    setState(() {
      _query = value.trim();
      _skip = 0;
    });
    _loadProducts();
  }

  void _clearSearch() {
    _searchCtrl.clear();
    _search('');
  }

  void _nextPage() {
    if (!_hasNext) return;
    setState(() => _skip += _limit);
    _loadProducts();
  }

  void _prevPage() {
    if (!_hasPrev) return;
    setState(() => _skip -= _limit);
    _loadProducts();
  }

  Future<void> _addProduct() async {
    final input = await Navigator.push<Product>(
      context,
      MaterialPageRoute(builder: (_) => const FormProduct()),
    );
    if (input == null) return;
    try {
      await _service.addProduct(input);
      _showMessage('Product added');
      await _loadProducts();
    } catch (e) {
      _showMessage('Failed to add product: $e');
    }
  }

  Future<void> _editProduct(Product product) async {
    final input = await Navigator.push<Product>(
      context,
      MaterialPageRoute(builder: (_) => FormProduct(product: product)),
    );
    if (input == null) return;
    try {
      final updated = await _service.updateProduct(product.id!, input);
      if (!mounted) return;
      setState(() {
        final index = _products.indexWhere((p) => p.id == product.id);
        if (index != -1) _products[index] = updated;
      });
      _showMessage('Product updated');
    } catch (e) {
      _showMessage('Failed to update product: $e');
    }
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
    try {
      await _service.deleteProduct(product.id!);
      _showMessage('Product deleted');
      await _loadProducts();
    } catch (e) {
      _showMessage('Failed to delete product: $e');
    }
  }

  void _openDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailProduct(product: product)),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            children: const [
              SizedBox(height: 120),
              Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 12),
              Center(child: Text('No products found.')),
            ],
          ),
        );

      case ViewState.success:
        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.builder(
            itemCount: _products.length,
            itemBuilder: (context, index) {
              final product = _products[index];
              return CardProduct(
                product: product,
                onDetail: () => _openDetail(product),
                onEdit: () => _editProduct(product),
                onDelete: () => _deleteProduct(product),
              );
            },
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory Products')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProduct,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                labelText: 'Search Product',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: _searchCtrl.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearSearch,
                      ),
              ),
              onSubmitted: _search,
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(child: _buildBody()),
          if (_state == ViewState.success || _state == ViewState.empty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: _hasPrev ? _prevPage : null,
                    icon: const Icon(Icons.chevron_left),
                    label: const Text('Prev'),
                  ),
                  Text('Page $_currentPage of $_totalPages'),
                  TextButton.icon(
                    onPressed: _hasNext ? _nextPage : null,
                    icon: const Icon(Icons.chevron_right),
                    label: const Text('Next'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
