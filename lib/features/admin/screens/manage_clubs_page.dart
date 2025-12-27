import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_one/services/data_service.dart';
import 'package:campus_one/widgets/animations/animated_widgets.dart';
import 'package:campus_one/core/theme/app_theme.dart';

class ManageClubsPage extends StatelessWidget {
  const ManageClubsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DataService>();
    final societies = data.societies;

    return Scaffold(
      backgroundColor: AppTheme.scaffoldColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Club Management', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
            Text('Organizations', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24, letterSpacing: -1.0, color: AppTheme.textPrimary)),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 70,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        physics: const BouncingScrollPhysics(),
        itemCount: societies.length,
        itemBuilder: (context, index) {
          final society = societies[index];
          final activityScore = 85 + (index * 2);
          final isHighPerforming = activityScore > 90;

          return FadeSlideEntrance(
            delay: Duration(milliseconds: 100 * index),
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.04)),
                boxShadow: [
                  BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.02), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Column(
                children: [
                   Row(
                     children: [
                       Container(
                         width: 56,
                         height: 56,
                         decoration: BoxDecoration(
                           color: AppTheme.surfaceColor,
                           borderRadius: BorderRadius.circular(20),
                         ),
                         child: const Icon(Icons.groups_rounded, color: AppTheme.primaryColor),
                       ),
                       const SizedBox(width: 16),
                       Expanded(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(society.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: AppTheme.textPrimary)),
                             const SizedBox(height: 4),
                             Text('${society.memberIds.length} ACTIVE MEMBERS', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                           ],
                         ),
                       ),
                       _StatusPill(status: 'ACTIVE', color: AppTheme.accentColor),
                     ],
                   ),
                   const SizedBox(height: 24),
                   Container(
                     padding: const EdgeInsets.all(16),
                     decoration: BoxDecoration(
                       color: AppTheme.surfaceColor.withValues(alpha: 0.5),
                       borderRadius: BorderRadius.circular(24),
                     ),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         _DetailStat(label: 'PERFORMANCE', value: '$activityScore%', color: isHighPerforming ? AppTheme.primaryColor : AppTheme.textSecondary),
                         _DetailStat(label: 'EVENTS', value: '12', color: AppTheme.primaryColor),
                         _DetailStat(label: 'REPORTS', value: '0', color: AppTheme.textSecondary),
                       ],
                     ),
                   ),
                   const SizedBox(height: 24),
                   Row(
                     children: [
                       Expanded(
                         child: ScaleOnTap(
                           onTap: () {},
                           child: Container(
                             height: 52,
                             alignment: Alignment.center,
                             decoration: BoxDecoration(
                               color: AppTheme.primaryColor,
                               borderRadius: BorderRadius.circular(100),
                             ),
                             child: const Text('View Analytics', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                           ),
                         ),
                       ),
                       const SizedBox(width: 12),
                       ScaleOnTap(
                         onTap: () {},
                         child: Container(
                           width: 52,
                           height: 52,
                           decoration: BoxDecoration(
                             color: Colors.white,
                             borderRadius: BorderRadius.circular(100),
                             border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.1)),
                           ),
                           child: const Icon(Icons.more_horiz, color: AppTheme.primaryColor),
                         ),
                       ),
                     ],
                   ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String status;
  final Color color;
  const _StatusPill({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        status, 
        style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w900, fontSize: 10)
      ),
    );
  }
}

class _DetailStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _DetailStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.3)),
      ],
    );
  }
}
