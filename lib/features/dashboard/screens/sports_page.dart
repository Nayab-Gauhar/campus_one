import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:campus_one/services/data_service.dart';
import 'package:campus_one/core/theme/app_theme.dart';
import 'package:campus_one/models/sports.dart';
import 'package:campus_one/widgets/common/shimmer_image.dart';
import 'package:campus_one/widgets/animations/animated_widgets.dart';
import 'package:flutter/cupertino.dart';

import 'package:campus_one/services/auth_service.dart';

class SportsPage extends StatefulWidget {
  const SportsPage({super.key});

  @override
  State<SportsPage> createState() => _SportsPageState();
}

class _SportsPageState extends State<SportsPage> {
  String _selectedSport = 'All';
  final List<String> _sports = ['All', 'Football', 'Cricket', 'Basketball', 'Tennis'];

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DataService>();

    List<SportsModel> filteredMatches = data.sportsData;
    if (_selectedSport != 'All') {
      filteredMatches = data.sportsData.where((s) => s.sportName == _selectedSport).toList();
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
                      Text('GAME DAY INTENSITY', style: TextStyle(color: AppTheme.accentColor, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                      const SizedBox(height: 4),
                      Text('Athletics', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 26, letterSpacing: -1.0, color: AppTheme.textPrimary)),
                    ],
                  ),
                  _HeaderCircleCount(
                     count: filteredMatches.where((s) => s.status == 'Ongoing').length,
                     icon: Icons.sports_basketball_rounded,
                  ),
                ],
              ),
            ),
          ),

          CupertinoSliverRefreshControl(
            onRefresh: () async => await context.read<DataService>().refreshData(),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: _buildSportsPills(),
            ),
          ),

          if (filteredMatches.any((s) => s.status == 'Ongoing')) ...[
            _buildSectionHeader('Live Scoredboard 🔥'),
            _buildSportsList(filteredMatches.where((s) => s.status == 'Ongoing').toList()),
          ],
          
          _buildSectionHeader('Upcoming Fixtures'),
          _buildSportsList(filteredMatches.where((s) => s.status == 'Upcoming').toList()),
          
          _buildSectionHeader('Club Teams'),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: data.sportsTeams.length,
                  itemBuilder: (context, index) => FadeSlideEntrance(
                    delay: Duration(milliseconds: 200 + (100 * index)),
                    child: _TeamCard(team: data.sportsTeams[index])),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(color: AppTheme.accentColor, borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(height: 8),
            Text(title.toUpperCase(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.textPrimary, letterSpacing: -0.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildSportsList(List<SportsModel> matches) {
    if (matches.isEmpty) {
      return SliverToBoxAdapter(
        child: FadeSlideEntrance(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.04)),
            ),
            child: Column(
              children: [
                const Icon(Icons.sports_basketball_outlined, size: 64, color: AppTheme.surfaceColor),
                const SizedBox(height: 24),
                const Text(
                  'No matches today',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textPrimary, letterSpacing: -0.5),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Follow a team or check training sessions to stay ahead.',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => FadeSlideEntrance(
            delay: Duration(milliseconds: 100 * index),
            child: _SportsMatchTile(match: matches[index])),
          childCount: matches.length,
        ),
      ),
    );
  }

  Widget _buildSportsPills() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _sports.length,
        itemBuilder: (context, index) {
          final sName = _sports[index];
          final isSelected = _selectedSport == sName;
          return ScaleOnTap(
            onTap: () => setState(() => _selectedSport = sName),
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
                  sName.toUpperCase(),
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

class _HeaderCircleCount extends StatelessWidget {
  final int count;
  final IconData icon;
  const _HeaderCircleCount({required this.count, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppTheme.accentColor),
          const SizedBox(width: 8),
          Text(
            '$count LIVE',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }
}

class _SportsMatchTile extends StatelessWidget {
  final SportsModel match;
  const _SportsMatchTile({required this.match});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DataService>();
    final isLive = match.status == 'Ongoing';

    return ScaleOnTap(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 20, offset: const Offset(0, 10))
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _TeamLogoSmall(teamId: match.teamIds.isNotEmpty ? match.teamIds.first : null),
                      const SizedBox(height: 8),
                      Text(match.teamIds.isNotEmpty ? data.sportsTeams.firstWhere((t) => t.id == match.teamIds.first).name : 'Home', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      if (isLive) ...[
                        Text(match.sportName.toUpperCase(), style: const TextStyle(color: AppTheme.accentTextColor, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                        const SizedBox(height: 8),
                        PulseAnimation(
                          child: Text(
                            '${match.homeScore ?? 0} - ${match.awayScore ?? 0}',
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppTheme.textPrimary, letterSpacing: -1),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                          child: const Text('LIVE', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w900, fontSize: 10)),
                        ),
                      ] else ...[
                         Text(DateFormat('MMM dd').format(match.dateTime).toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.textSecondary)),
                         const SizedBox(height: 4),
                         Text(DateFormat('hh:mm a').format(match.dateTime), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
                         const SizedBox(height: 8),
                         Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: AppTheme.surfaceColor, borderRadius: BorderRadius.circular(8)),
                          child: const Text('VS', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w900, fontSize: 10)),
                        ),
                      ],
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      _TeamLogoSmall(teamId: match.teamIds.length > 1 ? match.teamIds[1] : null),
                      const SizedBox(height: 8),
                      Text(match.teamIds.length > 1 ? data.sportsTeams.firstWhere((t) => t.id == match.teamIds[1]).name : 'Away', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                    ],
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

class _TeamLogoSmall extends StatelessWidget {
  final String? teamId;
  const _TeamLogoSmall({this.teamId});

  @override
  Widget build(BuildContext context) {
    final data = context.read<DataService>();
    final team = teamId != null ? data.sportsTeams.firstWhere((t) => t.id == teamId) : null;
    
    return Container(
      width: 60,
      height: 60,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        shape: BoxShape.circle,
        border: Border.all(color: team?.colorHex != null ? Color(int.parse('0xFF${team!.colorHex}')).withValues(alpha: 0.2) : Colors.transparent, width: 2),
      ),
      child: team?.logoUrl != null && team!.logoUrl.isNotEmpty
        ? ShimmerImage(imageUrl: team.logoUrl, borderRadius: 100)
        : const Icon(Icons.shield_rounded, size: 24, color: AppTheme.textSecondary),
    );
  }
}

class _TeamCard extends StatelessWidget {
  final SportsTeam team;
  const _TeamCard({required this.team});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final isFollowed = auth.currentUser?.followedTeamIds.contains(team.id) ?? false;

    return ScaleOnTap(
      onTap: () => auth.toggleFollowTeam(team.id),
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isFollowed ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isFollowed ? Colors.transparent : (team.colorHex != null 
              ? Color(int.parse('0xFF${team.colorHex}')).withValues(alpha: 0.2) 
              : AppTheme.primaryColor.withValues(alpha: 0.05)),
            width: 2,
          ),
          boxShadow: [
            if (isFollowed)
              BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.2), blurRadius: 15, offset: const Offset(0, 8))
            else
              BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isFollowed ? Colors.white.withValues(alpha: 0.1) : AppTheme.surfaceColor,
                shape: BoxShape.circle,
              ),
              child: team.logoUrl.isNotEmpty 
                ? ClipOval(child: ShimmerImage(imageUrl: team.logoUrl, width: 56, height: 56))
                : Icon(Icons.shield_rounded, size: 28, color: isFollowed ? Colors.white : AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            Text(
              team.name, 
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: isFollowed ? Colors.white : AppTheme.textPrimary), 
              textAlign: TextAlign.center, 
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              isFollowed ? 'FAVORITE' : team.sport.toUpperCase(), 
              style: TextStyle(color: isFollowed ? Colors.white.withValues(alpha: 0.7) : AppTheme.accentTextColor, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)
            ),
          ],
        ),
      ),
    );
  }
}
