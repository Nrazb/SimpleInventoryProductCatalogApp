import 'package:flutter/material.dart';
import 'product.dart';
import 'product_image.dart';

class CardProduct extends StatelessWidget {
  final Product product;
  final VoidCallback onDetail;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CardProduct({
    super.key,
    required this.product,
    required this.onDetail,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductImage(url: product.imageUrl, width: 80, height: 80),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Price: ${product.price.toStringAsFixed(0)}'),
                      const SizedBox(height: 4),
                      Text('Quantity: ${product.quantity}'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: onDetail,
                  child: const Text('Details'),
                ),
                ElevatedButton(onPressed: onEdit, child: const Text('Edit')),
                ElevatedButton(
                  onPressed: onDelete,
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
