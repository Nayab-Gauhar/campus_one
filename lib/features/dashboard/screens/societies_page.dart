import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_one/services/data_service.dart';
import 'package:campus_one/models/society.dart';
import 'package:campus_one/features/dashboard/screens/society_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:campus_one/widgets/common/shimmer_image.dart';
import 'package:campus_one/widgets/animations/animated_widgets.dart';
import 'package:campus_one/core/theme/app_theme.dart';
import 'package:campus_one/widgets/common/skeletons.dart';

class SocietiesPage extends StatefulWidget {
  const SocietiesPage({super.key});

  @override
  State<SocietiesPage> createState() => _SocietiesPageState();
}

class _SocietiesPageState extends State<SocietiesPage> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final List<String> _categories = ['All', 'Tech', 'Cultural', 'Sports', 'Social'];

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DataService>();

    List<SocietyModel> filteredSocieties = data.societies;
    if (_selectedCategory != 'All') {
      filteredSocieties = data.societies.where((s) => s.category == _selectedCategory).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      filteredSocieties = filteredSocieties.where((s) => s.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    return Scaffold(
      backgroundColor: AppTheme.scaffoldColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Modern App Bar Replacement
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('COMMUNITIES', style: TextStyle(color: AppTheme.accentColor, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                      const SizedBox(height: 4),
                      Text('Discover Societies', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 26, letterSpacing: -1.0, color: AppTheme.textPrimary)),
                    ],
                  ),
                  _HeaderCircleAction(
                    icon: Icons.search_rounded,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),

          // Search & Filter Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.05)),
                    ),
                    child: TextField(
                      onChanged: (v) => setState(() => _searchQuery = v),
                      decoration: InputDecoration(
                        hintText: 'Search communities...',
                        hintStyle: TextStyle(color: AppTheme.textSecondary.withValues(alpha: 0.4), fontSize: 14, fontWeight: FontWeight.w600),
                        border: InputBorder.none,
                        icon: const Icon(Icons.hub_rounded, color: AppTheme.primaryColor, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildCategoryPills(),
                ],
              ),
            ),
          ),

          // Trending Societies Section
          if (_selectedCategory == 'All' && _searchQuery.isEmpty) ...[
            const SliverPadding(padding: EdgeInsets.only(top: 32)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Trending Now 🔥', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.textPrimary, letterSpacing: -0.5)),
                    Text('See all', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(top: 16)),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: data.societies.length.clamp(0, 4),
                  itemBuilder: (context, index) {
                    return _TrendingSocietyCard(society: data.societies[index]);
                  },
                ),
              ),
            ),
          ],

          const SliverPadding(padding: EdgeInsets.only(top: 40)),
          
          // List Section Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                _selectedCategory == 'All' ? 'All Communities' : '$_selectedCategory Societies',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.textPrimary, letterSpacing: -0.5),
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(top: 16)),

          CupertinoSliverRefreshControl(
              onRefresh: () async => await context.read<DataService>().refreshData()),
              
          if (data.isLoading)
             const SliverPadding(
               padding: EdgeInsets.symmetric(horizontal: 24),
               sliver: SliverToBoxAdapter(child: SkeletonList(itemCount: 4)),
             )
          else if (filteredSocieties.isEmpty)
             const SliverFillRemaining(
               hasScrollBody: false,
               child: _EmptyClubState(),
             )
          else
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
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Icon(icon, size: 20, color: AppTheme.primaryColor),
      ),
    );
  }
}

class _TrendingSocietyCard extends StatelessWidget {
  final SocietyModel society;
  const _TrendingSocietyCard({required this.society});

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SocietyDetailsScreen(society: society))),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 15, offset: const Offset(0, 8))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShimmerImage(
              imageUrl: society.logoUrl,
              borderRadius: 20,
              width: 70,
              height: 70,
            ),
            const SizedBox(height: 16),
            Text(
              society.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              '${society.memberIds.length} Members',
              style: TextStyle(color: AppTheme.accentColor, fontSize: 10, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocietyListTile extends StatelessWidget {
  final SocietyModel society;
  const _SocietyListTile({required this.society});

  @override
  Widget build(BuildContext context) {
    // Use model properties
    final isRecruiting = society.isRecruiting; 


    return ScaleOnTap(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SocietyDetailsScreen(society: society))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            ShimmerImage(
              imageUrl: society.logoUrl,
              borderRadius: 16,
              width: 60,
              height: 60,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    children: [
                      Expanded(
                        child: Text(
                          society.name, 
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppTheme.textPrimary)
                        )
                      ),
                      if (isRecruiting)
                        const Icon(Icons.bolt_rounded, size: 16, color: AppTheme.accentColor),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    society.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _CompactTag(label: society.category, color: AppTheme.primaryColor.withValues(alpha: 0.1), textColor: AppTheme.primaryColor),
                      const SizedBox(width: 8),
                      Text('${society.memberIds.length} Members', style: TextStyle(color: AppTheme.textSecondary.withValues(alpha: 0.6), fontSize: 10, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompactTag extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  const _CompactTag({required this.label, required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(color: textColor, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 0.5),
      ),
    );
  }
}

class _EmptyClubState extends StatelessWidget {
  const _EmptyClubState();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(color: AppTheme.surfaceColor, shape: BoxShape.circle),
          child: const Icon(Icons.groups_3_rounded, size: 48, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 24),
        const Text(
          'More clubs launching soon',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary, letterSpacing: -0.5),
        ),
        const SizedBox(height: 8),
        const Text(
          'Be the first to start a new community.\nReach out to the admin office.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 24),
        ScaleOnTap(
          onTap: (){},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Text('Start a Club', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
          ),
        ),
      ],
    );
  }
}
