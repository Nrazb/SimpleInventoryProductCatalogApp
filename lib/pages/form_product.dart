import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_image.dart';

class FormProduct extends StatefulWidget {
  final Product? product;

  const FormProduct({super.key, this.product});

  @override
  State<FormProduct> createState() => _FormProductState();
}

class _FormProductState extends State<FormProduct> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _stockCtrl;
  late final TextEditingController _imageCtrl;

  bool get _isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _priceCtrl = TextEditingController(
      text: p != null ? p.price.toStringAsFixed(0) : '',
    );
    _stockCtrl = TextEditingController(text: p?.stock.toString() ?? '');
    _imageCtrl = TextEditingController(text: p?.image ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    _imageCtrl.dispose();
    super.dispose();
  }

  String? _validateUrl(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return null;
    final uri = Uri.tryParse(value);
    final valid =
        uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
    return valid ? null : 'Enter a valid http/https URL';
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final result = Product(
      id: widget.product?.id,
      name: _nameCtrl.text.trim(),
      price: double.parse(_priceCtrl.text.trim()),
      stock: int.parse(_stockCtrl.text.trim()),
      image: _imageCtrl.text.trim().isEmpty ? null : _imageCtrl.text.trim(),
    );

    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit Product' : 'Add Product')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _imageCtrl,
                builder: (context, value, _) {
                  final url = value.text.trim();
                  return ProductImage(
                    url: _validateUrl(url) == null ? url : null,
                    width: double.infinity,
                    height: 180,
                  );
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageCtrl,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'Image URL (optional)',
                  border: OutlineInputBorder(),
                ),
                validator: _validateUrl,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final value = double.tryParse((v ?? '').trim());
                  if (value == null) return 'Price must be a number';
                  if (value < 0) return 'Price cannot be negative';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stockCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Stock',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final value = int.tryParse((v ?? '').trim());
                  if (value == null) return 'Stock must be a whole number';
                  if (value < 0) return 'Stock cannot be negative';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text(_isEdit ? 'Save Changes' : 'Add Product'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
