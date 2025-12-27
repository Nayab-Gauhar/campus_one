import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_one/models/society.dart';
import 'package:campus_one/services/data_service.dart';
import 'package:campus_one/services/auth_service.dart';
import 'package:campus_one/core/theme/app_theme.dart';
import 'package:campus_one/widgets/animations/animated_widgets.dart';

class SocietyDetailsScreen extends StatelessWidget {
  final SocietyModel society;

  const SocietyDetailsScreen({super.key, required this.society});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final isMember = society.memberIds.contains(auth.currentUser?.id);
    final isPending = society.pendingRequests.contains(auth.currentUser?.id);

    return Scaffold(
      backgroundColor: AppTheme.scaffoldColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppTheme.primaryColor,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ScaleOnTap(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3), shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    society.logoUrl,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.4),
                          Colors.transparent,
                          AppTheme.primaryColor.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0, -30, 0),
              decoration: const BoxDecoration(
                color: AppTheme.scaffoldColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      society.category.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 10, color: AppTheme.primaryColor, letterSpacing: 0.5),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    society.name,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: AppTheme.textPrimary, letterSpacing: -1),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    society.description,
                    style: const TextStyle(color: AppTheme.textSecondary, height: 1.6, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  
                  const SizedBox(height: 48),
                  const Text('GOALS & OPERATIONS', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1)),
                  const SizedBox(height: 16),
                  _BlueprintCard(
                    what: society.whatWeDo,
                    profile: society.idealtudentProfile,
                    time: society.timeCommitment,
                  ),

                  const SizedBox(height: 32),
                  const Text('LEADERSHIP TEAM', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.04)),
                    ),
                    child: Column(
                      children: society.coreTeam.entries.map((entry) => _CoreTeamRow(role: entry.key, name: entry.value, isLast: entry.key == society.coreTeam.keys.last)).toList(),
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, -5)),
          ],
        ),
        child: ScaleOnTap(
          onTap: isMember || isPending
              ? null
              : () {
                  if (auth.currentUser != null) {
                    context.read<DataService>().joinSociety(society.id, auth.currentUser!.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Join request captured! 🚀')),
                    );
                  }
                },
          child: Container(
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: (isMember || isPending) ? AppTheme.surfaceColor : AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              isMember ? 'YOU ARE A MEMBER' : (isPending ? 'REQUEST PENDING' : 'REQUEST ENTRANCE'),
              style: TextStyle(
                fontSize: 14, 
                fontWeight: FontWeight.w900,
                color: (isMember || isPending) ? AppTheme.textSecondary : Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BlueprintCard extends StatelessWidget {
  final String what;
  final String profile;
  final String time;

  const _BlueprintCard({required this.what, required this.profile, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.04)),
      ),
      child: Column(
        children: [
          _BlueprintItem(icon: Icons.auto_awesome_rounded, title: 'Strategic Purpose', value: what),
          const SizedBox(height: 24),
          _BlueprintItem(icon: Icons.psychology_rounded, title: 'Ideal Candidate', value: profile),
          const SizedBox(height: 24),
          _BlueprintItem(icon: Icons.timer_rounded, title: 'Commitment Level', value: time),
        ],
      ),
    );
  }
}

class _BlueprintItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const _BlueprintItem({required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(color: AppTheme.surfaceColor, shape: BoxShape.circle),
          child: Icon(icon, color: AppTheme.primaryColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: AppTheme.textPrimary)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}

class _CoreTeamRow extends StatelessWidget {
  final String role;
  final String name;
  final bool isLast;
  const _CoreTeamRow({required this.role, required this.name, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(role.toUpperCase(), style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
            Text(name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppTheme.textPrimary)),
          ],
        ),
        if (!isLast) Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Divider(height: 1, color: AppTheme.primaryColor.withValues(alpha: 0.05)),
        ),
      ],
    );
  }
}
