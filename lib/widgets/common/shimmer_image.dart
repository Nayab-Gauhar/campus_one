import 'package:flutter/material.dart';

class ShimmerImage extends StatefulWidget {
  final String imageUrl;
  final double height;
  final double width;
  final double borderRadius;
  final BoxFit fit;

  const ShimmerImage({
    super.key,
    required this.imageUrl,
    this.height = 200,
    this.width = double.infinity,
    this.borderRadius = 0,
    this.fit = BoxFit.cover,
  });

  @override
  State<ShimmerImage> createState() => _ShimmerImageState();
}

class _ShimmerImageState extends State<ShimmerImage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Image.network(
        widget.imageUrl,
        height: widget.height,
        width: widget.width,
        fit: widget.fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                height: widget.height,
                width: widget.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey[200]!,
                      Colors.grey[100]!,
                      Colors.grey[200]!,
                    ],
                    stops: const [0.1, 0.5, 0.9],
                    begin: Alignment(-1.0 + (_controller.value * 2), 0.0),
                    end: Alignment(1.0 + (_controller.value * 2), 0.0),
                  ),
                ),
              );
            },
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: widget.height,
            width: widget.width,
            color: Colors.grey[200],
            child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
          );
        },
      ),
    );
  }
}
