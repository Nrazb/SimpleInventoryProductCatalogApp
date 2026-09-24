import 'package:flutter/material.dart';
import 'package:product_catalog/models/product.dart';
import 'package:product_catalog/widgets/product_image.dart';

class DetailProduct extends StatelessWidget {
  final Product product;

  const DetailProduct({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Detail')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImage(
              url: product.image,
              width: double.infinity,
              height: 240,
            ),
            const SizedBox(height: 16),
            Text(
              product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Price: ${product.price.toStringAsFixed(0)}'),
            const SizedBox(height: 8),
            Text('Stock: ${product.stock}'),
          ],
        ),
      ),
    );
  }
}
