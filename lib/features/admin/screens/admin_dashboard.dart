import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:campus_one/services/data_service.dart';
import 'package:campus_one/widgets/animations/animated_widgets.dart';
import 'package:campus_one/core/theme/app_theme.dart';
import 'package:campus_one/features/admin/screens/create_event_screen.dart';
import 'package:campus_one/features/admin/screens/requests_page.dart';
import 'package:campus_one/features/admin/screens/users_page.dart';
import 'package:campus_one/features/admin/screens/broadcast_page.dart';
import 'package:campus_one/features/admin/screens/manage_clubs_page.dart';

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
            Text('Command Center', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: AppTheme.textPrimary, letterSpacing: -0.5)),
            Text(
              '${DateTime.now().day} ${const ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][DateTime.now().month-1]} • Overview',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: AppTheme.textPrimary, size: 22),
            onPressed: () {}, // Future: Quick Search
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
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildCriticalIssues(context, data),
                const SizedBox(height: 16), // Reduced spacing
                _buildMetricsRow(context, data),
                const SizedBox(height: 32),
                
                _buildSectionHeader('Configuration', 'EDIT'),
                const SizedBox(height: 12),
                _buildActionGrid(context),
                
                const SizedBox(height: 32),
                _buildSectionHeader('Recent Activity', 'VIEW LOGS'),
                const SizedBox(height: 8),
                _buildActivityFeed(),
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
          _MetricTile(
            label: 'ACTIVE',
            value: data.activeEventCount.toString(),
            icon: Icons.wifi_tethering_rounded,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: 12),
          _MetricTile(
            label: 'PENDING',
            value: data.totalPendingRequests.toString(),
            icon: Icons.hourglass_top_rounded,
            color: data.totalPendingRequests > 0 ? AppTheme.accentColor : AppTheme.textSecondary,
            textColor: data.totalPendingRequests > 0 ? AppTheme.primaryColor : Colors.white,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RequestsPage())),
          ),
          const SizedBox(width: 12),
          const _MetricTile(
            label: 'ENGAGEMENT',
            value: '94%',
            icon: Icons.trending_up,
            color: AppTheme.surfaceColor,
            textColor: AppTheme.primaryColor,
            isMuted: true,
            showGraph: true,
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
        childAspectRatio: 1.6, // Shorter cards
        children: [
          _ActionCard(
            label: 'Create Event', 
            icon: Icons.add_circle_outline_rounded,
            color: AppTheme.primaryColor,
            textColor: Colors.white,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateEventScreen())),
            onLongPress: () => _showQuickTemplates(context),
          ),
          _CircularActionCard( // Broadcast is secondary
            label: 'Broadcast', 
            icon: Icons.campaign_outlined,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BroadcastPage())),
          ),
          _CircularActionCard(
            label: 'Club Mgmt', 
            icon: Icons.shield_outlined,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageClubsPage())),
          ),
          _CircularActionCard(
            label: 'Students', 
            icon: Icons.people_outline_rounded,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UsersPage())),
          ),
        ],
      ),
    );
  }

  void _showQuickTemplates(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('QUICK TEMPLATES', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: AppTheme.textSecondary, letterSpacing: 1.0)),
            const SizedBox(height: 16),
            _TemplateTile(
              icon: Icons.code_rounded, 
              title: 'Hackathon', 
              subtitle: '24h • Tech Club • Main Hall',
              color: Colors.orange,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateEventScreen(template: 'Hackathon'))),
            ),
            const SizedBox(height: 12),
            _TemplateTile(
              icon: Icons.mic_external_on_rounded, 
              title: 'Guest Speaker', 
              subtitle: '2h • Auditorium • All Depts',
              color: Colors.blue,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateEventScreen(template: 'Guest Speaker'))),
            ),
             const SizedBox(height: 12),
            _TemplateTile(
              icon: Icons.sports_cricket_rounded, 
              title: 'Sports Match', 
              subtitle: '3h • Ground • Inter-college',
              color: Colors.green,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateEventScreen(template: 'Sports'))),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityFeed() {
    return FadeSlideEntrance(
      delay: const Duration(milliseconds: 300),
      child: Column(
        children: [
          _ActivityRow(
            title: 'Photography Club posted "Photo Walk"',
            time: '2h ago',
            icon: Icons.camera_alt_outlined,
            isAlert: false,
          ),
          const Divider(height: 1, indent: 56),
          _ActivityRow(
            title: 'New join request: John Doe',
            time: '5h ago',
            icon: Icons.person_add_outlined,
            isAlert: true,
            actionLabel: 'REVIEW',
          ),
          const Divider(height: 1, indent: 56),
          _ActivityRow(
            title: 'Weekly analytics report generated',
            time: '1d ago',
            icon: Icons.analytics_outlined,
            isAlert: false,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '$pending pending requests require attention',
                style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title.toUpperCase(), style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: AppTheme.textSecondary.withValues(alpha: 0.7), letterSpacing: 1.0)),
        Text(action, style: const TextStyle(color: AppTheme.primaryColor, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color textColor;
  final bool isMuted;
  final bool showGraph;
  final VoidCallback? onTap;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.textColor = Colors.white,
    this.isMuted = false,
    this.showGraph = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 90,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isMuted ? color : color,
            borderRadius: BorderRadius.circular(20),
            border: isMuted ? Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.05)) : null,
          ),
          child: Stack(
            children: [
              if (showGraph)
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: CustomPaint(
                      painter: _SparklinePainter(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
                    ),
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, color: isMuted ? AppTheme.primaryColor : textColor.withValues(alpha: 0.8), size: 18),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(value, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: textColor, height: 1.0)),
                      const SizedBox(height: 4),
                      Text(label, style: TextStyle(color: textColor.withValues(alpha: 0.7), fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final Color color;
  _SparklinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    // Simple 7-point mock graph
    final points = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.16, size.height * 0.6),
      Offset(size.width * 0.33, size.height * 0.75),
      Offset(size.width * 0.5, size.height * 0.4),
      Offset(size.width * 0.66, size.height * 0.5),
      Offset(size.width * 0.83, size.height * 0.2), // Peak
      Offset(size.width, size.height * 0.3),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    for (var i = 1; i < points.length; i++) {
      path.quadraticBezierTo(
        (points[i-1].dx + points[i].dx) / 2, 
        (points[i-1].dy + points[i].dy) / 2, 
        points[i].dx, 
        points[i].dy
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _ActionCard({
    required this.label, 
    required this.icon, 
    required this.color, 
    required this.textColor, 
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
              child: Icon(icon, color: textColor, size: 20),
            ),
            Text(label, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: textColor)),
          ],
        ),
      ),
    );
  }
}

class _CircularActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _CircularActionCard({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.05)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppTheme.primaryColor, size: 24),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppTheme.textPrimary)),
          ],
        ),
      ),
    );
  }
}

class _TemplateTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _TemplateTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.05)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppTheme.textPrimary)),
                   const SizedBox(height: 2),
                   Text(subtitle, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: AppTheme.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppTheme.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final String title;
  final String time;
  final IconData icon;
  final bool isAlert;
  final String? actionLabel;

  const _ActivityRow({required this.title, required this.time, required this.icon, this.isAlert = false, this.actionLabel});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(title),
      direction: DismissDirection.horizontal, // Bidirectional
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        color: Colors.green, // Approve
        child: const Icon(Icons.check_rounded, color: Colors.white),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red, // Dismiss
        child: const Icon(Icons.close_rounded, color: Colors.white),
      ),
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isAlert ? AppTheme.accentColor.withValues(alpha: 0.2) : AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 18, color: isAlert ? AppTheme.primaryColor : AppTheme.textSecondary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.textPrimary)),
                    const SizedBox(height: 2),
                    Text(time, style: TextStyle(color: AppTheme.textSecondary.withValues(alpha: 0.6), fontSize: 11, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              if (actionLabel != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(actionLabel!, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
