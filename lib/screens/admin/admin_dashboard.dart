import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../services/data_service.dart';
import '../../widgets/animated_widgets.dart';
import '../../theme/app_theme.dart';
import 'create_event_screen.dart';
import 'requests_page.dart';
import 'users_page.dart';
import 'broadcast_page.dart';
import 'manage_clubs_page.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DataService>();
    
    return Scaffold(
      backgroundColor: AppTheme.scaffoldColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Command Center', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22, color: AppTheme.textPrimary, letterSpacing: -0.5)),
            Text(
              'OVERVIEW • ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: AppTheme.primaryColor),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async => await Future.delayed(const Duration(milliseconds: 1000)),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildCriticalIssues(context, data),
                const SizedBox(height: 32),
                _buildMetricsRow(context, data),
                const SizedBox(height: 32),
                _buildSectionHeader('Quick Actions', 'Configuration'),
                const SizedBox(height: 16),
                _buildActionGrid(context),
                const SizedBox(height: 32),
                _buildSectionHeader('Recent Activity', 'View all'),
                const SizedBox(height: 16),
                _buildActivityFeed(),
                const SizedBox(height: 100), // Bottom padding for floating navbar
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsRow(BuildContext context, DataService data) {
    return FadeSlideEntrance(
      delay: const Duration(milliseconds: 100),
      child: Row(
        children: [
          _MetricCard(
            label: 'ACTIVE EVENTS',
            value: data.activeEventCount.toString(),
            icon: Icons.confirmation_number_outlined,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: 12),
          _MetricCard(
            label: 'PENDING',
            value: data.totalPendingRequests.toString(),
            icon: Icons.hourglass_empty_rounded,
            color: data.totalPendingRequests > 0 ? AppTheme.accentColor : AppTheme.primaryColor,
            isAlert: data.totalPendingRequests > 0,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RequestsPage())),
          ),
          const SizedBox(width: 12),
          const _MetricCard(
            label: 'ENGAGEMENT',
            value: 'HIGH',
            icon: Icons.trending_up_rounded,
            color: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    return FadeSlideEntrance(
      delay: const Duration(milliseconds: 200),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.4,
        children: [
          _ActionCard(
            icon: Icons.add_rounded, 
            label: 'Create Event', 
            color: AppTheme.accentColor,
            textColor: AppTheme.primaryColor,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateEventScreen())),
          ),
          _ActionCard(
            icon: Icons.campaign_rounded, 
            label: 'Broadcast', 
            color: AppTheme.primaryColor, 
            textColor: Colors.white,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BroadcastPage())),
          ),
          _ActionCard(
            icon: Icons.shield_rounded, 
            label: 'Manage Clubs', 
            color: AppTheme.surfaceColor, 
            textColor: AppTheme.primaryColor,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageClubsPage())),
          ),
          _ActionCard(
            icon: Icons.security_rounded, 
            label: 'Safety Center', 
            color: AppTheme.surfaceColor, 
            textColor: AppTheme.primaryColor,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UsersPage())),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityFeed() {
    return FadeSlideEntrance(
      delay: const Duration(milliseconds: 300),
      child: Column(
        children: [
          _ActivityItem(
            text: 'Photography Club posted "Photo Walk"',
            time: '2h ago',
            icon: Icons.event_available,
            color: AppTheme.surfaceColor,
          ),
          _ActivityItem(
            text: 'New join request: John Doe',
            time: '5h ago',
            icon: Icons.person_add_alt_1,
            color: AppTheme.accentColor.withValues(alpha: 0.2),
          ),
          _ActivityItem(
            text: 'System: Weekly report generated',
            time: '1d ago',
            icon: Icons.analytics_outlined,
            color: AppTheme.surfaceColor,
          ),
        ],
      ),
    );
  }

  Widget _buildCriticalIssues(BuildContext context, DataService data) {
    final pending = data.totalPendingRequests;
    if (pending == 0) return const SizedBox.shrink();

    return FadeSlideEntrance(
      delay: const Duration(milliseconds: 100),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.red.withValues(alpha: 0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Text('CRITICAL OVERSIGHT', style: TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
              ],
            ),
            const SizedBox(height: 16),
            _CriticalIssueTile(
              label: 'Join requests pending approval',
              value: '$pending REQUIRES ACTION',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RequestsPage())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String sub) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppTheme.textPrimary)),
        Text(sub, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
      ],
    );
  }
}

class _CriticalIssueTile extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  const _CriticalIssueTile({required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(value, style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.red),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isAlert;
  final VoidCallback? onTap;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.isAlert = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ScaleOnTap(
        onTap: onTap ?? () {},
        child: Container(
          height: 110,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isAlert ? AppTheme.accentColor : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppTheme.primaryColor, size: 20),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 24, color: AppTheme.textPrimary),
              ),
              Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.3)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const _ActionCard({required this.icon, required this.label, required this.color, required this.textColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.05)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 28),
            const SizedBox(height: 12),
            Text(label, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: textColor)),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String text;
  final String time;
  final IconData icon;
  final Color color;

  const _ActivityItem({required this.text, required this.time, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.04)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, size: 18, color: AppTheme.primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textPrimary))),
          Text(time, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
