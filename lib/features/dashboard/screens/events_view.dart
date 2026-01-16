import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:campus_one/services/data_service.dart';
import 'package:campus_one/core/theme/app_theme.dart';
import 'package:campus_one/services/auth_service.dart';
import 'package:campus_one/models/user.dart';
import 'package:campus_one/models/event.dart';
import 'package:campus_one/widgets/animations/animated_widgets.dart';
import 'package:campus_one/features/dashboard/screens/event_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:campus_one/widgets/common/shimmer_image.dart';
import 'package:campus_one/widgets/common/skeletons.dart';
import 'package:campus_one/features/notifications/screens/notifications_page.dart';

class EventsViewPage extends StatefulWidget {
  final bool showSaved;
  const EventsViewPage({super.key, this.showSaved = false});

  @override
  State<EventsViewPage> createState() => _EventsViewPageState();
}

class _EventsViewPageState extends State<EventsViewPage> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  EventStatus _selectedStatus = EventStatus.published;
  final List<String> _categories = ['All', 'Sports', 'Technical', 'Hackathon', 'Workshop', 'Cultural'];
  late bool _showOnlySaved;

  @override
  void initState() {
    super.initState();
    _showOnlySaved = widget.showSaved;
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DataService>();
    final auth = context.watch<AuthService>();
    final isAdmin = auth.currentUser?.role == UserRole.clubAdmin;

    List<EventModel> filteredEvents = data.events;
    if (_selectedCategory != 'All') {
      filteredEvents = data.events.where((e) => e.category.name.toLowerCase() == _selectedCategory.toLowerCase()).toList();
    }
    
    if (_showOnlySaved) {
       final savedIds = data.savedEventIds;
       filteredEvents = filteredEvents.where((e) => savedIds.contains(e.id)).toList();
    }
    
    if (isAdmin) {
       if (_selectedStatus == EventStatus.draft) {
          filteredEvents = filteredEvents.where((e) => e.status == EventStatus.draft).toList();
       } else if (_selectedStatus == EventStatus.published) {
         filteredEvents = filteredEvents.where((e) => e.status == EventStatus.published || e.status == EventStatus.live).toList();
       } else if (_selectedStatus == EventStatus.completed) {
         filteredEvents = filteredEvents.where((e) => e.status == EventStatus.completed).toList();
       }
    } else {
      filteredEvents = filteredEvents.where((e) => e.status == EventStatus.published || e.status == EventStatus.live).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filteredEvents = filteredEvents.where((e) => e.title.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    return Scaffold(
      backgroundColor: AppTheme.scaffoldColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(top: 20),
            sliver: CupertinoSliverRefreshControl(
              onRefresh: () async => await context.read<DataService>().refreshData(),
            ),
          ),
          
          // Header & Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded, size: 20, color: AppTheme.textPrimary),
                          const SizedBox(width: 8),
                          const Text(
                            'Haldia, West Bengal',
                            style: TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: AppTheme.textPrimary),
                        ],
                      ),
                      _HeaderCircleAction(
                        icon: Icons.notifications_none_rounded,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsPage())),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _showOnlySaved ? 'Your Saved\nEvents 🔖' : 'Discover Events\nNear You With Us! 📣',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900, 
                      fontSize: 28, 
                      letterSpacing: -1.0, 
                      height: 1.2,
                      color: AppTheme.textPrimary
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (isAdmin)
             SliverToBoxAdapter(child: _buildAdminStatusFilter()),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.05)),
                ),
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search events...',
                    hintStyle: TextStyle(color: AppTheme.textSecondary.withValues(alpha: 0.5), fontSize: 14),
                    border: InputBorder.none,
                    icon: const Icon(Icons.search_rounded, color: AppTheme.textSecondary, size: 20),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(child: _buildCategoryPills()),
          
          const SliverPadding(padding: EdgeInsets.only(top: 32)),

          // Latest Events Section Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Latest Events',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textPrimary, letterSpacing: -0.5),
                  ),
                  const Text(
                    'See more',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(top: 20)),
          
          // Horizontal Featured List
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 320,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: filteredEvents.length.clamp(0, 5),
                      itemBuilder: (context, index) {
                        return _ModernEventCard(event: filteredEvents[index]);
                      },
                    ),
                  ),
                ),

                const SliverPadding(padding: EdgeInsets.only(top: 24)),
                
                // Heading for the rest
                const SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Upcoming Agenda',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary, letterSpacing: -0.5),
                    ),
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.only(top: 16)),

                if (data.isLoading)
                  const SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverToBoxAdapter(child: SkeletonList()),
                  )
                else if (filteredEvents.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 64, color: AppTheme.surfaceColor),
                        const SizedBox(height: 24),
                        const Text(
                          'No events found',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.textPrimary, letterSpacing: -0.5),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Follow a club or explore societies to\nfill your campus agenda.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final event = filteredEvents[index];
                          // First 2 items are Large Cards, rest are Compact
                          if (index < 2) {
                            return FadeSlideEntrance(
                              delay: Duration(milliseconds: 100 * index),
                              child: _LargeEventTile(event: event),
                            );
                          }
                          return FadeSlideEntrance(
                            delay: Duration(milliseconds: 100 * index),
                            child: RepaintBoundary(
                              child: _EventTransactionTile(event: event, isAdmin: isAdmin),
                            ),
                          );
                        },
                        childCount: filteredEvents.length,
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
    );
  }

  Widget _buildCategoryPills() {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategory == cat;
          return ScaleOnTap(
            onTap: () => setState(() => _selectedCategory = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.accentColor : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isSelected ? Colors.transparent : Colors.black.withValues(alpha: 0.05)),
              ),
              child: Center(
                child: Text(
                  cat,
                  style: TextStyle(
                    color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdminStatusFilter() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          _buildStatusTab('Draft', EventStatus.draft),
          _buildStatusTab('Live', EventStatus.published),
          _buildStatusTab('Past', EventStatus.completed),
        ],
      ),
    );
  }

  Widget _buildStatusTab(String label, EventStatus status) {
    final isSelected = _selectedStatus == status;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedStatus = status),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
            boxShadow: isSelected ? [BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))] : [],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

class _ModernEventCard extends StatelessWidget {
  final EventModel event;
  const _ModernEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EventDetailsScreen(event: event))),
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 20, offset: const Offset(0, 10))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with rounded corners and heart icon
            Stack(
              children: [
                Hero(
                  tag: 'event_img_${event.id}',
                  child: ShimmerImage(
                    imageUrl: event.imageUrl,
                    width: double.infinity,
                    height: 180,
                    borderRadius: 32,
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: _UrgencyBadge(event: event),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Consumer<DataService>(
                    builder: (context, data, _) {
                      final isSaved = data.savedEventIds.contains(event.id);
                      return ScaleOnTap(
                        onTap: () => data.toggleSaveEvent(event.id),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: Icon(
                            isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded, 
                            color: AppTheme.primaryColor, 
                            size: 20
                          ),
                        ),
                      );
                    }
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    event.title,
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppTheme.textPrimary, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.organizerName,
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _CompactInfo(icon: Icons.location_on_rounded, label: event.location),
                      const SizedBox(width: 12),
                      _CompactInfo(icon: Icons.calendar_today_rounded, label: DateFormat('MMM dd').format(event.date)),
                      const SizedBox(width: 12),
                      _CompactInfo(icon: Icons.access_time_rounded, label: DateFormat('hh:mm').format(event.date)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompactInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  const _CompactInfo({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppTheme.accentColor),
        const SizedBox(width: 4),
        Text(
          label.length > 8 ? '${label.substring(0, 8)}...' : label,
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 10, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _EventTransactionTile extends StatelessWidget {
  final EventModel event;
  final bool isAdmin;
  const _EventTransactionTile({required this.event, this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final difference = event.date.difference(now);
    
    String urgencyLabel = '';
    Color urgencyColor = AppTheme.primaryColor;
    
    if (event.status == EventStatus.live) {
      urgencyLabel = 'LIVE';
      urgencyColor = Colors.red;
    } else if (difference.inDays == 0 && event.date.day == now.day) {
      urgencyLabel = 'TODAY';
      urgencyColor = Colors.orange;
    } else if (difference.inDays == 0 && event.date.day == now.add(const Duration(days: 1)).day) {
      urgencyLabel = 'TOMORROW';
      urgencyColor = Colors.blue;
    } else if (difference.inDays > 0 && difference.inDays <= 2) {
      urgencyLabel = 'IN ${difference.inDays + 1} DAYS';
      urgencyColor = AppTheme.textSecondary;
    }

    return ScaleOnTap(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EventDetailsScreen(event: event))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
              width: 52,
              height: 52,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(event.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppTheme.textPrimary))),
                      if (urgencyLabel.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: urgencyColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            urgencyLabel,
                            style: TextStyle(color: urgencyColor, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${DateFormat('hh:mm a').format(event.date)} • ${event.organizerName}', 
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)
                  ),
                ],
              ),
            ),
            if (isAdmin)
               const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.textSecondary)
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  DateFormat('MMM dd').format(event.date).toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 9, color: AppTheme.primaryColor),
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

class _LargeEventTile extends StatelessWidget {
  final EventModel event;
  const _LargeEventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EventDetailsScreen(event: event))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.02), blurRadius: 20, offset: const Offset(0, 10))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'event_lg_${event.id}',
                  child: ShimmerImage(
                    imageUrl: event.imageUrl,
                    width: double.infinity,
                    height: 200,
                    borderRadius: 32,
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: _UrgencyBadge(event: event),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Consumer<DataService>(
                    builder: (context, data, _) {
                      final isSaved = data.savedEventIds.contains(event.id);
                      return ScaleOnTap(
                        onTap: () => data.toggleSaveEvent(event.id),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: Icon(
                            isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded, 
                            color: AppTheme.primaryColor, 
                            size: 22
                          ),
                        ),
                      );
                    }
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      event.category.name.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 10, color: AppTheme.primaryColor, letterSpacing: 0.5),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('MMM dd • hh:mm a').format(event.date).toUpperCase(),
                        style: TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5),
                      ),
                      Text(
                        'FREE',
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: AppTheme.primaryColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.title,
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: AppTheme.textPrimary, height: 1.1),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        event.location,
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UrgencyBadge extends StatelessWidget {
  final EventModel event;
  const _UrgencyBadge({required this.event});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final difference = event.date.difference(now);
    
    String urgencyLabel = '';
    Color urgencyColor = AppTheme.primaryColor;
    
    if (event.status == EventStatus.live) {
      urgencyLabel = 'LIVE';
      urgencyColor = Colors.red;
    } else if (difference.inDays == 0 && event.date.day == now.day) {
      urgencyLabel = 'TODAY';
      urgencyColor = Colors.orange;
    } else if (difference.inDays == 0 && event.date.day == now.add(const Duration(days: 1)).day) {
      urgencyLabel = 'TOMORROW';
      urgencyColor = Colors.blue;
    } else if (difference.inDays > 0 && difference.inDays <= 2) {
      urgencyLabel = 'IN ${difference.inDays + 1} DAYS';
      urgencyColor = AppTheme.textSecondary;
    }

    if (urgencyLabel.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (event.status == EventStatus.live)
            const Padding(
              padding: EdgeInsets.only(right: 6),
              child: Icon(Icons.circle, color: Colors.red, size: 8),
            ),
          Text(
            urgencyLabel,
            style: TextStyle(color: urgencyColor, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }
}
