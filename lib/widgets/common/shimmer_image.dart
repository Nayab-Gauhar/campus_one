import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:campus_one/core/theme/app_theme.dart';

class ShimmerImage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        width: width,
        fit: fit,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: height,
            width: width,
            color: Colors.white,
          ),
        ),
        errorWidget: (context, url, error) => Container(
          height: height,
          width: width,
          color: AppTheme.surfaceColor,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image_rounded, color: AppTheme.textSecondary, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
