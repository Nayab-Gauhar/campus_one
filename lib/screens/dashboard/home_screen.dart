import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart';
import '../../widgets/animated_widgets.dart';
import 'home_overview_page.dart';
import 'events_list_page.dart';
import '../societies/societies_page.dart';
import 'sports_page.dart';
import 'profile_page.dart';
import '../admin/create_event_screen.dart';
import '../admin/requests_page.dart';
import '../admin/admin_dashboard.dart';

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
      const EventsListPage(),
      const SocietiesPage(),
      const SportsPage(),
      const ProfilePage(),
    ];

    final List<Widget> adminPages = [
      const AdminDashboardPage(),
      const EventsListPage(),
      const CreateEventScreen(),
      const RequestsPage(),
      const ProfilePage(),
    ];

    final List<Widget> pages = isAdmin ? adminPages : studentPages;
    final List<IconData> icons = isAdmin 
      ? [Icons.grid_view_rounded, Icons.confirmation_number_outlined, Icons.add_rounded, Icons.notifications_active_outlined, Icons.person_outline_rounded]
      : [Icons.home_filled, Icons.receipt_long_rounded, Icons.groups_rounded, Icons.sports_basketball_rounded, Icons.person_rounded];
    
    final List<String> labels = isAdmin
      ? ['Home', 'Events', 'Create', 'Requests', 'Profile']
      : ['Home', 'Events', 'Clubs', 'Sports', 'Me'];

    return Scaffold(
      backgroundColor: AppTheme.scaffoldColor,
      extendBody: true, // Crucial for floating navbar to show content behind it
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: KeyedSubtree(
          key: ValueKey<int>(_currentIndex),
          child: pages[_currentIndex],
        ),
      ),
      bottomNavigationBar: _UniversalFloatingNav(
        selectedIndex: _currentIndex,
        icons: icons,
        labels: labels,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

class _UniversalFloatingNav extends StatelessWidget {
  final int selectedIndex;
  final List<IconData> icons;
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
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      height: 64,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor, // Solid Deep Forest Green
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(icons.length, (index) {
            final isSelected = selectedIndex == index;
            return Expanded(
              child: ScaleOnTap(
                onTap: () => onTap(index),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.accentColor : Colors.transparent, // Neon Lime
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icons[index],
                        color: isSelected ? AppTheme.primaryColor : Colors.white.withValues(alpha: 0.4),
                        size: 22,
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
