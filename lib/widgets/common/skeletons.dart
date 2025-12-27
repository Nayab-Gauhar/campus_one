import 'package:flutter/material.dart';
import 'package:campus_one/core/theme/app_theme.dart';

class SkeletonContainer extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonContainer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 16,
  });

  @override
  State<SkeletonContainer> createState() => _SkeletonContainerState();
}

class _SkeletonContainerState extends State<SkeletonContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this)
      ..repeat(reverse: true);
      
    _animation = ColorTween(
      begin: AppTheme.surfaceColor,
      end: AppTheme.surfaceColor.withValues(alpha: 0.5),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: _animation.value,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      },
    );
  }
}

class SkeletonEventTile extends StatelessWidget {
  const SkeletonEventTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.04)),
      ),
      child: Row(
        children: [
          const SkeletonContainer(width: 48, height: 48, borderRadius: 16),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SkeletonContainer(width: 140, height: 16, borderRadius: 4),
                SizedBox(height: 8),
                SkeletonContainer(width: 80, height: 12, borderRadius: 4),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const SkeletonContainer(width: 60, height: 24, borderRadius: 8),
        ],
      ),
    );
  }
}

class SkeletonList extends StatelessWidget {
  final int itemCount;
  final Widget item;
  
  const SkeletonList({
    super.key, 
    this.itemCount = 5,
    this.item = const SkeletonEventTile(),
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: itemCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => item,
    );
  }
}
