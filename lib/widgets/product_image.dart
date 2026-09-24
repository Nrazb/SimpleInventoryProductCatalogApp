import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;

  const ProductImage({super.key, this.url, this.width, this.height});

  Widget _placeholder({IconData icon = Icons.image_outlined}) => Container(
    width: width,
    height: height,
    color: Colors.grey.shade200,
    child: Icon(icon, size: 40, color: Colors.grey),
  );

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.trim().isEmpty) return _placeholder();
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        url!,
        width: width,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            width: width,
            height: height,
            color: Colors.grey.shade200,
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stack) =>
            _placeholder(icon: Icons.broken_image_outlined),
      ),
    );
  }
}
