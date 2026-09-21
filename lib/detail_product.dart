import 'package:flutter/material.dart';
import 'product.dart';
import 'product_image.dart';

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
              url: product.imageUrl,
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
            Text('Quantity: ${product.quantity}'),
            const SizedBox(height: 8),
            Text(
              'Description: ${product.description.isEmpty ? '-' : product.description}',
            ),
          ],
        ),
      ),
    );
  }
}