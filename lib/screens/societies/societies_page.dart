import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/data_service.dart';
import '../../models/society.dart';
import 'society_details_screen.dart';
import 'package:flutter/cupertino.dart';
import '../../widgets/shimmer_image.dart';
import '../../widgets/animated_widgets.dart';
import '../../theme/app_theme.dart';

class SocietiesPage extends StatefulWidget {
  const SocietiesPage({super.key});

  @override
  State<SocietiesPage> createState() => _SocietiesPageState();
}

class _SocietiesPageState extends State<SocietiesPage> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Tech', 'Cultural', 'Sports', 'Social'];

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DataService>();

    List<SocietyModel> filteredSocieties = data.societies;
    if (_selectedCategory != 'All') {
      filteredSocieties = data.societies.where((s) => s.category == _selectedCategory).toList();
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
                    Text('Find your tribe', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
                    Text('Societies', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24, letterSpacing: -1.0, color: AppTheme.textPrimary)),
                  ],
                ),
                _HeaderCircleAction(
                  icon: Icons.search_rounded,
                  onTap: () {}, // Simplified for now
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const SizedBox(height: 8),
          _buildCategoryPills(),
          const SizedBox(height: 24),
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                CupertinoSliverRefreshControl(
                    onRefresh: () async => await Future.delayed(const Duration(milliseconds: 1000))),
                SliverPadding(
                   padding: const EdgeInsets.symmetric(horizontal: 24),
                   sliver: SliverList(
                     delegate: SliverChildBuilderDelegate(
                       (context, index) {
                         final society = filteredSocieties[index];
                         return FadeSlideEntrance(
                           delay: Duration(milliseconds: 100 * index),
                           child: _SocietyListTile(society: society),
                         );
                       },
                       childCount: filteredSocieties.length,
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

class _SocietyListTile extends StatelessWidget {
  final SocietyModel society;
  const _SocietyListTile({required this.society});

  @override
  Widget build(BuildContext context) {
    final isTrending = society.memberIds.length > 5; // Placeholder logic for trending

    return ScaleOnTap(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SocietyDetailsScreen(society: society))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.04)),
          boxShadow: [
            BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.01), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ShimmerImage(
                  imageUrl: society.logoUrl,
                  borderRadius: 16,
                  width: 48,
                  height: 48,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(society.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppTheme.textPrimary))),
                          if (isTrending)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.accentColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Row(
                                children: [
                                  Text('🔥 ', style: TextStyle(fontSize: 10)),
                                  Text('TRENDING', style: TextStyle(color: AppTheme.primaryColor, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                                ],
                              ),
                            ),
                        ],
                      ),
                      Text(
                        society.category.toUpperCase(),
                        style: const TextStyle(color: AppTheme.accentColor, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              society.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w500, height: 1.4),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.people_outline_rounded, size: 14, color: AppTheme.textSecondary),
                    const SizedBox(width: 6),
                    Text(
                      '${society.memberIds.length}+ members',
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Text(
                    'VIEW CLUB',
                    style: TextStyle(color: AppTheme.primaryColor, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

