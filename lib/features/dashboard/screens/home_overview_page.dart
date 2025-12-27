import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:campus_one/services/data_service.dart';
import 'package:campus_one/services/auth_service.dart';
import 'package:campus_one/core/theme/app_theme.dart';
import 'package:campus_one/models/event.dart';
import 'package:campus_one/widgets/animations/animated_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:campus_one/widgets/common/shimmer_image.dart';
import 'package:campus_one/features/notifications/screens/notifications_page.dart';
import 'package:campus_one/models/user.dart';
import 'package:campus_one/features/dashboard/screens/event_details_screen.dart';
import 'package:campus_one/features/admin/screens/create_event_screen.dart';
import 'package:campus_one/features/dashboard/screens/events_view.dart';
import 'package:campus_one/features/dashboard/screens/societies_page.dart';
import 'package:campus_one/features/dashboard/screens/calendar_page.dart';
class HomeOverviewPage extends StatelessWidget {
  const HomeOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final data = context.watch<DataService>();
    final user = auth.currentUser;
    final isAdmin = user?.role == UserRole.clubAdmin;
    
    final upcomingEvents = data.events.where((e) => e.date.isAfter(DateTime.now())).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    
    final nextEvent = upcomingEvents.isNotEmpty ? upcomingEvents.first : null;

    return Container(
      color: AppTheme.scaffoldColor,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(top: 20), // Reload animation pushed down
            sliver: CupertinoSliverRefreshControl(
              onRefresh: () async => await context.read<DataService>().refreshData(),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(top: 30)), // Top layout fix - increased to 30
            
            // Header with Profile Circle
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.1)),
                          ),
                          child: const ClipOval(child: Icon(Icons.person, color: AppTheme.primaryColor, size: 24)),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back, ${user?.name.split(' ')[0] ?? "User"}',
                              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              nextEvent != null ? 'Ready for ${nextEvent.title}?' : 'No events today',
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textPrimary, letterSpacing: -0.5),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _HeaderCircleAction(
                          icon: Icons.notifications_none_rounded,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsPage())),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Today's Stats Row - De-emphasized
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor.withValues(alpha: 0.5), // Lighter background
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _CompactStat(icon: Icons.event_available, label: '${upcomingEvents.length} events'),
                      _CompactStat(icon: Icons.notifications_active_outlined, label: '${data.societies.expand((s) => s.pendingRequests).length} requests'),
                      _CompactStat(icon: Icons.bolt, label: '${user?.points ?? 0} points'),
                    ],
                  ),
                ),
              ),
            ),

            // Main "Next Event" Credit Card Style Card - HERO STYLE
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24), // Tighter horizontal padding to make card look bigger
              sliver: SliverToBoxAdapter(
                child: FadeSlideEntrance(
                  child: Builder(
                    builder: (context) {
                      final isJoined = nextEvent != null && nextEvent.participantIds.contains(user?.id ?? '1');
                      
                      return ScaleOnTap(
                        onTap: () {
                          if (nextEvent != null) {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => EventDetailsScreen(event: nextEvent)));
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.05)),
                            boxShadow: [
                              BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.08), blurRadius: 40, offset: const Offset(0, 16)), // Stronger shadow
                              BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Your next event', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
                                  if (nextEvent != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppTheme.accentColor,
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      child: Text(
                                        nextEvent.category.name.toUpperCase(),
                                        style: const TextStyle(color: AppTheme.primaryColor, fontSize: 9, fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                nextEvent?.title ?? "Free Campus",
                                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -1.2, height: 1.1, color: AppTheme.textPrimary),
                              ),
                              Row(
                                children: [
                                  _InfoChip(icon: Icons.calendar_today_rounded, label: nextEvent != null ? DateFormat('MMM dd').format(nextEvent.date).toUpperCase() : 'TODAY'),
                                  const SizedBox(width: 8),
                                  _InfoChip(icon: Icons.access_time_rounded, label: nextEvent != null ? DateFormat('hh:mm A').format(nextEvent.date) : 'ANYTIME'),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_rounded, size: 14, color: AppTheme.accentTextColor),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${nextEvent?.location ?? "Auditorium"} • ${nextEvent?.organizerName ?? "Campus"}',
                                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              if (isJoined)
                                Row(
                                  children: [
                                    Expanded(
                                      child: ScaleOnTap(
                                        onTap: () => _showTicket(context, nextEvent),
                                        child: Container(
                                          height: 56,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryColor,
                                            borderRadius: BorderRadius.circular(100),
                                          ),
                                          child: const Text('View Ticket', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    ScaleOnTap(
                                      onTap: () => _showTicket(context, nextEvent),
                                      child: Container(
                                        width: 56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: AppTheme.accentColor,
                                          borderRadius: BorderRadius.circular(100),
                                        ),
                                        child: const Icon(Icons.qr_code_2, color: AppTheme.primaryColor),
                                      ),
                                    ),
                                  ],
                                )
                              else
                                ScaleOnTap(
                                  onTap: () {
                                    if (nextEvent != null) {
                                      context.read<DataService>().registerForEvent(nextEvent.id, user?.id ?? '1');
                                      context.read<AuthService>().addPoints(100);
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Joined Event! +100 XP')));
                                    }
                                  },
                                  child: Container(
                                    height: 56,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: const Text('Join Event', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }
                  ),
                ),
              ),
            ),
            
            // Actions Grid
             SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _ActionPill(
                      icon: Icons.grid_view_rounded, 
                      label: 'EXPLORE', 
                      color: AppTheme.surfaceColor, 
                      textColor: AppTheme.primaryColor,
                      isPrimary: false,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EventsViewPage())),
                    ),
                     if (isAdmin)
                      _ActionPill(
                        icon: Icons.add_rounded, 
                        label: 'CREATE', 
                        color: Colors.white, 
                        textColor: AppTheme.primaryColor,
                        isPrimary: false,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateEventScreen())),
                      ),
                    _ActionPill(
                      icon: Icons.calendar_month_rounded, 
                      label: 'CALENDAR', 
                      color: Colors.white, 
                      textColor: AppTheme.primaryColor,
                      isPrimary: false,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CalendarPage())),
                    ),
                  ],
                ),
              ),
            ),

            _buildSectionHeader(context, 'Overview', 'View stats'),

            // Horizontal Scrollable OverviewStats
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    _FeatureTile(
                      label: 'Pending',
                      value: '${data.societies.expand((s) => s.pendingRequests).where((r) => r == user?.id).length}',
                      icon: Icons.hourglass_top_rounded, 
                      color: AppTheme.surfaceColor,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SocietiesPage())),
                    ),
                    const SizedBox(width: 12),
                    _FeatureTile(
                      label: 'Attended', 
                      value: '${user?.registeredEvents.length ?? 0}', 
                      icon: Icons.check_circle_rounded, 
                      color: AppTheme.accentColor.withValues(alpha: 0.3),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EventsViewPage())),
                    ),
                    const SizedBox(width: 12),
                     _FeatureTile(
                      label: 'Points', 
                      value: '${user?.points ?? 0}', 
                      icon: Icons.bolt_rounded, 
                      color: const Color(0xFFFFF4D1),
                      onTap: () {}, // Could navigate to a points history
                    ),
                  ],
                ),
              ),
            ),

            _buildSectionHeader(context, 'Discover Events', 'See all'),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _EventListTile(event: upcomingEvents[index]),
                  childCount: upcomingEvents.length.clamp(0, 3),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, String action) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(color: AppTheme.accentTextColor, borderRadius: BorderRadius.circular(10)),
                ),
                const SizedBox(height: 8),
                Text(title.toUpperCase(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.textPrimary, letterSpacing: -0.5)),
              ],
            ),
            Text(action, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 0.2)),
          ],
        ),
      ),
    );
  }

  void _showTicket(BuildContext context, EventModel event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.qr_code_2_rounded, size: 180, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 24),
            Text(event.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: AppTheme.textPrimary, letterSpacing: -0.5)),
            const SizedBox(height: 4),
            Text(DateFormat('MMM dd, yyyy • hh:mm A').format(event.date), style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 32),
            ScaleOnTap(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 56,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text('Back to Home', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderCircleAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HeaderCircleAction({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.05)),
        ),
        child: Icon(icon, size: 20, color: AppTheme.primaryColor),
      ),
    );
  }
}

class _CompactStat extends StatelessWidget {
  final IconData icon;
  final String label;
  const _CompactStat({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppTheme.primaryColor.withValues(alpha: 0.4)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.primaryColor)),
      ],
    );
  }
}

class _ActionPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color textColor;
  final bool isPrimary;
  final VoidCallback onTap;
  const _ActionPill({required this.icon, required this.label, required this.color, required this.textColor, required this.onTap, this.isPrimary = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ScaleOnTap(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 52,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(100),
            border: isPrimary ? null : Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.1)),
            boxShadow: isPrimary ? [
              BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))
            ] : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor, size: 18),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 0.5)),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppTheme.accentTextColor),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.accentTextColor)),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _FeatureTile({
    required this.label, 
    required this.value, 
    required this.icon, 
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      onTap: onTap,
      child: Container(
        width: 140, // Fixed width for horizontal scrolling
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Container(
               padding: const EdgeInsets.all(8),
               decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
               child: Icon(icon, size: 16, color: AppTheme.primaryColor),
             ),
             const SizedBox(height: 16),
             Text(label, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w700)),
             const SizedBox(height: 4),
             Text(value, style: TextStyle(color: AppTheme.textPrimary, fontSize: 24, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

class _EventListTile extends StatelessWidget {
  final EventModel event;
  const _EventListTile({required this.event});

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EventDetailsScreen(event: event))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.04)),
        ),
        child: Row(
          children: [
            ShimmerImage(
              imageUrl: event.imageUrl,
              borderRadius: 16,
              height: 48,
              width: 48,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppTheme.textPrimary)),
                  Text(event.organizerName, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                 Text(
                   DateFormat('MMM dd').format(event.date),
                   style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppTheme.textPrimary.withValues(alpha: 0.6)),
                 ),
                 Text(
                   'FREE',
                   style: TextStyle(color: AppTheme.accentColor.withBlue(100), fontSize: 10, fontWeight: FontWeight.w900),
                 ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
