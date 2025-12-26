import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../services/data_service.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart';
import '../../models/event.dart';
import '../../widgets/animated_widgets.dart';
import '../events/event_details_screen.dart';
import 'package:flutter/cupertino.dart';
import '../../widgets/shimmer_image.dart';
import 'search_overlay.dart';

class EventsListPage extends StatefulWidget {
  const EventsListPage({super.key});

  @override
  State<EventsListPage> createState() => _EventsListPageState();
}

class _EventsListPageState extends State<EventsListPage> {
  String _selectedCategory = 'All';
  EventStatus _selectedStatus = EventStatus.published;
  final List<String> _categories = ['All', 'Sports', 'Technical', 'Hackathon', 'Workshop', 'Cultural'];

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DataService>();
    final auth = context.watch<AuthService>();
    final isAdmin = auth.currentUser?.role == UserRole.clubAdmin;

    List<EventModel> filteredEvents = data.events;
    if (_selectedCategory != 'All') {
      filteredEvents = data.events.where((e) => e.category.name.toLowerCase() == _selectedCategory.toLowerCase()).toList();
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

    return Container(
      color: AppTheme.scaffoldColor,
      child: Column(
        children: [
          const SizedBox(height: 56),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Stay ahead of the curve', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
                    Text('Campus Agenda', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24, letterSpacing: -1.0, color: AppTheme.textPrimary)),
                  ],
                ),
                _HeaderCircleAction(
                  icon: Icons.search_rounded,
                  onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const SearchOverlay(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          if (isAdmin)
             _buildAdminStatusFilter(),
          const SizedBox(height: 16),
          _buildCategoryPills(),
          const SizedBox(height: 24),
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                CupertinoSliverRefreshControl(
                    onRefresh: () async => await Future.delayed(const Duration(milliseconds: 1000))),
                if (filteredEvents.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 64, color: AppTheme.surfaceColor),
                        const SizedBox(height: 24),
                        Text(
                          'No events found',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.textPrimary, letterSpacing: -0.5),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Follow a club or explore societies to\nfill your campus agenda.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 32),
                        ScaleOnTap(
                          onTap: () => DefaultTabController.of(context).animateTo(2), // Move to Societies (assuming index 2)
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(100)),
                            child: const Text('Explore Societies', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          ),
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
                          return FadeSlideEntrance(
                            delay: Duration(milliseconds: 100 * index),
                            child: _EventTransactionTile(event: event, isAdmin: isAdmin),
                          );
                        },
                        childCount: filteredEvents.length,
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPills() {
    return SizedBox(
      height: 48,
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
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: isSelected ? Colors.transparent : AppTheme.primaryColor.withValues(alpha: 0.05)),
              ),
              child: Center(
                child: Text(
                  cat.toUpperCase(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                    fontWeight: FontWeight.w900,
                    fontSize: 10,
                    letterSpacing: 0.5,
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
