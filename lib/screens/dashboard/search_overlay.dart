import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/data_service.dart';
import '../../theme/app_theme.dart';
import '../events/event_details_screen.dart';
import '../societies/society_details_screen.dart';

class SearchOverlay extends StatefulWidget {
  const SearchOverlay({super.key});

  @override
  State<SearchOverlay> createState() => _SearchOverlayState();
}

class _SearchOverlayState extends State<SearchOverlay> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DataService>();
    
    final filteredEvents = data.events.where((e) => e.title.toLowerCase().contains(_query.toLowerCase())).toList();
    final filteredSocieties = data.societies.where((s) => s.name.toLowerCase().contains(_query.toLowerCase())).toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: const BoxDecoration(
        color: AppTheme.scaffoldColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: AppTheme.primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 24),
          
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.05)),
            ),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              onChanged: (val) => setState(() => _query = val),
              style: const TextStyle(fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search campus agenda...',
                hintStyle: const TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w600),
                prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primaryColor),
                suffixIcon: _query.isNotEmpty 
                    ? IconButton(icon: const Icon(Icons.close_rounded, size: 18, color: AppTheme.primaryColor), onPressed: () => setState(() {
                      _searchController.clear();
                      _query = '';
                    })) 
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(18),
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          Expanded(
            child: _query.isEmpty
                ? _buildRecentSearches()
                : ListView(
                    children: [
                      if (filteredEvents.isNotEmpty) ...[
                        const Text('AGENDA MATCHES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.textSecondary, letterSpacing: 1)),
                        const SizedBox(height: 16),
                        ...filteredEvents.map((e) => _SearchResultTile(title: e.title, subtitle: e.organizerName, type: 'Event', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EventDetailsScreen(event: e))))),
                        const SizedBox(height: 32),
                      ],
                      if (filteredSocieties.isNotEmpty) ...[
                        const Text('SOCIETY MATCHES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.textSecondary, letterSpacing: 1)),
                        const SizedBox(height: 16),
                        ...filteredSocieties.map((s) => _SearchResultTile(title: s.name, subtitle: s.category, type: 'Club', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SocietyDetailsScreen(society: s))))),
                      ],
                      if (filteredEvents.isEmpty && filteredSocieties.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 60),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.search_off_rounded, size: 48, color: AppTheme.surfaceColor),
                                SizedBox(height: 16),
                                Text('No matches found.', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('QUICK EXPLORE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.textSecondary, letterSpacing: 1)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['Hackathon', 'Music', 'Sports', 'AI', 'Coding'].map((tag) => GestureDetector(
            onTap: () => setState(() {
              _searchController.text = tag;
              _query = tag;
            }),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.05)),
              ),
              child: Text(tag, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.primaryColor)),
            ),
          )).toList(),
        ),
      ],
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String type;
  final VoidCallback onTap;

  const _SearchResultTile({required this.title, required this.subtitle, required this.type, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(color: AppTheme.surfaceColor, shape: BoxShape.circle),
              child: Icon(type == 'Event' ? Icons.calendar_today_rounded : Icons.groups_rounded, size: 20, color: AppTheme.primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppTheme.textPrimary)),
                   const SizedBox(height: 2),
                   Text(subtitle.toUpperCase(), style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
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
