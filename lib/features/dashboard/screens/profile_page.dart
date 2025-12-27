import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:campus_one/services/auth_service.dart';
import 'package:campus_one/services/data_service.dart';
import 'package:campus_one/core/theme/app_theme.dart';
import 'package:campus_one/widgets/animations/animated_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:campus_one/features/dashboard/screens/events_view.dart';
import 'package:campus_one/features/dashboard/screens/societies_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final user = auth.currentUser;
    final data = context.watch<DataService>();

    if (user == null) return const Center(child: Text('Please login'));
    
    final savedCount = data.savedEventIds.length;
    final eventsCount = user.registeredEvents.length;
    final clubsCount = user.joinedSocieties.length;

    return Container(
      color: AppTheme.scaffoldColor,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverPadding(padding: EdgeInsets.only(top: 56)),
          CupertinoSliverRefreshControl(
            onRefresh: () async => await context.read<DataService>().refreshData(),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Profile'.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppTheme.textPrimary, letterSpacing: -0.5)),
                ],
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(top: 32)),
          
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 24),
                // Avatar with Edit Button
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.1), blurRadius: 20)
                          ],
                        ),
                        child: const ClipOval(child: Icon(Icons.person, size: 60, color: AppTheme.textSecondary)),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.surfaceColor),
                        ),
                        child: const Icon(Icons.edit_outlined, size: 16, color: AppTheme.primaryColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(user.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                const SizedBox(height: 8),
                Text('Level 12 • Senior Scholar', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 24),
                
                // Animated XP Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Journey Progress', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w800)),
                          Text('${user.points} / 5000 XP', style: TextStyle(color: AppTheme.primaryColor, fontSize: 11, fontWeight: FontWeight.w900)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0, end: 0.62),
                        duration: const Duration(seconds: 2),
                        curve: Curves.elasticOut,
                        builder: (context, value, child) {
                          return Stack(
                            children: [
                              Container(
                                height: 12,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceColor,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: value,
                                child: Container(
                                  height: 12,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [AppTheme.accentColor, Colors.greenAccent]),
                                    borderRadius: BorderRadius.circular(100),
                                    boxShadow: [
                                      BoxShadow(color: AppTheme.accentColor.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.bolt, size: 14, color: AppTheme.accentColor),
                          const SizedBox(width: 4),
                          Text('+120 XP earned today', style: TextStyle(color: AppTheme.accentColor.withBlue(100), fontSize: 10, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
          
          // My Activity Section
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                   _ActivityShortcut(
                     icon: Icons.confirmation_number_rounded, 
                     label: 'My Events', 
                     count: '$eventsCount',
                     color: AppTheme.primaryColor,
                     onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EventsViewPage())),
                   ),
                   const SizedBox(width: 12),
                   _ActivityShortcut(
                     icon: Icons.groups_rounded, 
                     label: 'My Clubs', 
                     count: '$clubsCount',
                     color: AppTheme.accentColor,
                     onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SocietiesPage())),
                   ),
                   const SizedBox(width: 12),
                   _ActivityShortcut(
                     icon: Icons.bookmark_rounded, 
                     label: 'Saved', 
                     count: '$savedCount',
                     color: Colors.orange,
                     onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EventsViewPage())),
                   ),
                ],
              ),
            ),
          ),

          // Personal Info Card matching Image 1
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Personal info', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                        Text('Edit', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w700, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _ProfileInfoRow(icon: Icons.person_outline_rounded, label: 'Name', value: user.name),
                    const Divider(height: 32),
                    _ProfileInfoRow(icon: Icons.alternate_email_rounded, label: 'E-mail', value: user.email),
                    const Divider(height: 32),
                    _ProfileInfoRow(icon: Icons.phone_android_rounded, label: 'Department', value: 'Computer Science & Eng.'),
                    const Divider(height: 32),
                    _ProfileInfoRow(icon: Icons.home_outlined, label: 'Campus Reg.', value: 'HIT Haldia, WB-721657'),
                  ],
                ),
              ),
            ),
          ),

          // Badges Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Achievements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _BadgeItem(icon: Icons.auto_awesome, label: 'Early Bird', description: 'Attended 5 events before 9 AM', isUnlocked: true),
                        _BadgeItem(icon: Icons.emoji_events, label: 'Campus Hero', description: 'Organized a successful technical event', isUnlocked: true),
                        _BadgeItem(icon: Icons.groups, label: 'Socialite', description: 'Member of 3+ different societies', isUnlocked: true),
                        _BadgeItem(icon: Icons.workspace_premium, label: 'Top Contributor', description: 'Earn 5000 XP in a single semester', isUnlocked: false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Account Info Card
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Account settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                    const SizedBox(height: 24),
                    _ProfileInfoRow(icon: Icons.verified_user_outlined, label: 'Status', value: 'Active Student'),
                    const Divider(height: 32),
                    _ProfileInfoRow(icon: Icons.stars_rounded, label: 'Clubs Joined', value: '03 active societies'),
                    const SizedBox(height: 32),
                    ScaleOnTap(
                      onTap: () => auth.logout(),
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Text('Log out', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w800, fontSize: 14)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final bool isUnlocked;
  const _BadgeItem({required this.icon, required this.label, required this.description, this.isUnlocked = true});

  void _showDetails(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppTheme.primaryColor)),
        message: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: isUnlocked ? AppTheme.accentColor.withValues(alpha: 0.1) : Colors.grey[100], shape: BoxShape.circle),
              child: Icon(icon, size: 40, color: isUnlocked ? AppTheme.primaryColor : Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(description, textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondary, fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 20),
            if (!isUnlocked)
              Text('Locked • Keep exploring to unlock', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
          ],
        ),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      onTap: () {
        HapticFeedback.lightImpact();
        _showDetails(context);
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUnlocked ? AppTheme.accentColor.withValues(alpha: 0.1) : Colors.grey[100],
                shape: BoxShape.circle,
                border: Border.all(color: isUnlocked ? AppTheme.accentColor.withValues(alpha: 0.5) : Colors.transparent),
              ),
              child: Icon(icon, color: isUnlocked ? AppTheme.primaryColor : Colors.grey[400], size: 24),
            ),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: isUnlocked ? AppTheme.textPrimary : Colors.grey, fontSize: 10, fontWeight: FontWeight.w800), textAlign: TextAlign.center, maxLines: 1),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _ProfileInfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppTheme.surfaceColor, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 20, color: AppTheme.primaryColor),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActivityShortcut extends StatelessWidget {
  final IconData icon;
  final String label;
  final String count;
  final Color color;
  final VoidCallback onTap;

  const _ActivityShortcut({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ScaleOnTap(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.05)),
            boxShadow: [
              BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))
            ],
          ),
          child: Column(
            children: [
              Text(count, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}
