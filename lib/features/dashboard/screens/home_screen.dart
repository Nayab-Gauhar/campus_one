import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:campus_one/core/theme/app_theme.dart';
import 'package:campus_one/services/auth_service.dart';
import 'package:campus_one/models/user.dart';
import 'package:campus_one/widgets/animations/animated_widgets.dart';
import 'home_overview_page.dart';
import 'package:campus_one/features/dashboard/screens/events_view.dart';
import 'package:campus_one/features/dashboard/screens/societies_page.dart';
import 'package:campus_one/features/dashboard/screens/sports_page.dart';
import 'package:campus_one/features/dashboard/screens/profile_page.dart';
import 'package:campus_one/features/admin/screens/create_event_screen.dart';
import 'package:campus_one/features/admin/screens/requests_page.dart';
import 'package:campus_one/features/admin/screens/admin_dashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final isAdmin = auth.currentUser?.role == UserRole.clubAdmin;

    final List<Widget> studentPages = [
      const HomeOverviewPage(),
      const EventsViewPage(),
      const SocietiesPage(),
      const SportsPage(),
      const ProfilePage(),
    ];

    final List<Widget> adminPages = [
      const AdminDashboardPage(),
      const EventsViewPage(),
      const CreateEventScreen(),
      const RequestsPage(),
      const ProfilePage(),
    ];

    final List<Widget> pages = isAdmin ? adminPages : studentPages;
    
    // Icons: [Active, Inactive]
    final List<List<IconData>> studentIcons = [
      [Icons.home_rounded, Icons.home_outlined],
      [Icons.confirmation_number_rounded, Icons.confirmation_number_outlined],
      [Icons.groups_rounded, Icons.groups_outlined],
      [Icons.sports_basketball_rounded, Icons.sports_basketball_outlined],
      [Icons.person_rounded, Icons.person_outline_rounded],
    ];

    final List<List<IconData>> adminIcons = [
      [Icons.grid_view_rounded, Icons.grid_view_outlined],
      [Icons.confirmation_number_rounded, Icons.confirmation_number_outlined],
      [Icons.add_circle_rounded, Icons.add_circle_outline_rounded],
      [Icons.notifications_rounded, Icons.notifications_none_rounded],
      [Icons.person_rounded, Icons.person_outline_rounded],
    ];

    final currentIcons = isAdmin ? adminIcons : studentIcons;
    final List<String> labels = isAdmin
      ? ['Command Center', 'Events', 'Create', 'Requests', 'Profile']
      : ['Home', 'Events', 'Societies', 'Athletics', 'Profile'];

    return Scaffold(
      backgroundColor: AppTheme.scaffoldColor,
      extendBody: true, 
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: KeyedSubtree(
          key: ValueKey<int>(_currentIndex),
          child: pages[_currentIndex],
        ),
      ),
      bottomNavigationBar: _UniversalFloatingNav(
        selectedIndex: _currentIndex,
        icons: currentIcons,
        labels: labels,
        onTap: (index) {
          HapticFeedback.lightImpact();
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}

class _UniversalFloatingNav extends StatelessWidget {
  final int selectedIndex;
  final List<List<IconData>> icons;
  final List<String> labels;
  final Function(int) onTap;

  const _UniversalFloatingNav({
    required this.selectedIndex,
    required this.icons,
    required this.labels,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      height: 72, // Increased from 50
      decoration: BoxDecoration(
        color: AppTheme.primaryColor, 
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15), // Lighter shadow
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(icons.length, (index) {
            final isSelected = selectedIndex == index;
            return ScaleOnTap(
              onTap: () => onTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.fastOutSlowIn,
                width: isSelected ? 130 : 56,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.accentColor : Colors.transparent, 
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isSelected ? icons[index][0] : icons[index][1],
                        color: isSelected ? AppTheme.primaryColor : Colors.white.withValues(alpha: 0.6),
                        size: 22,
                      ),
                    ),
                    if (isSelected)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4, right: 8),
                          child: Text(
                            labels[index],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppTheme.primaryColor, 
                              fontWeight: FontWeight.w800, 
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
