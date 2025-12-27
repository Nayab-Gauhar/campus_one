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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Game day intensity', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
                      Text('Athletics', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24, letterSpacing: -1.0, color: AppTheme.textPrimary)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(top: 24)),
          SliverToBoxAdapter(child: _buildSportsPills()),
          const SliverPadding(padding: EdgeInsets.only(top: 32)),
          
          _buildSectionHeader('Live Action'),
          _buildSportsList(filteredMatches.where((s) => s.status == 'Ongoing').toList()),
          
          _buildSectionHeader('Upcoming Matches'),
          _buildSportsList(filteredMatches.where((s) => s.status == 'Upcoming').toList()),
          
          _buildSectionHeader('Our Teams'),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: 140,
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

class _SportsMatchTile extends StatelessWidget {
  final SportsModel match;
  const _SportsMatchTile({required this.match});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DataService>();
    final now = DateTime.now();
    final isLive = match.status == 'Ongoing';
    final isUpcoming = match.status == 'Upcoming';
    final difference = match.dateTime.difference(now);

    return ScaleOnTap(
      onTap: () {},
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
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: match.teamIds.isNotEmpty 
                      ? Color(int.parse('0xFF${data.sportsTeams.firstWhere((t) => t.id == match.teamIds.first, orElse: () => SportsTeam(id: '', name: '', sport: '', captain: '', logoUrl: '', colorHex: 'F1F4F1')).colorHex ?? "F1F4F1"}')).withValues(alpha: 0.1)
                      : AppTheme.surfaceColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.sports_soccer_rounded, 
                    color: isLive ? Colors.red : (match.teamIds.isNotEmpty 
                      ? Color(int.parse('0xFF${data.sportsTeams.firstWhere((t) => t.id == match.teamIds.first, orElse: () => SportsTeam(id: '', name: '', sport: '', captain: '', logoUrl: '', colorHex: '0D291E')).colorHex ?? "0D291E"}'))
                      : AppTheme.primaryColor), 
                    size: 20
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(match.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppTheme.textPrimary)),
                      Text('${match.sportName} • ${match.venue}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                if (isLive)
                  PulseAnimation(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        '${match.homeScore ?? 0} - ${match.awayScore ?? 0}', 
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w900, fontSize: 16)
                      ),
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('MMM dd').format(match.dateTime).toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: AppTheme.textPrimary),
                      ),
                      Text(DateFormat('hh:mm a').format(match.dateTime), style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10, fontWeight: FontWeight.w700)),
                    ],
                  ),
              ],
            ),
            if (isLive || (isUpcoming && difference.inHours < 24 && difference.inHours > 0))
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: isLive ? Colors.red.withValues(alpha: 0.05) : AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(isLive ? Icons.sensors_rounded : Icons.timer_outlined, size: 14, color: isLive ? Colors.red : AppTheme.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        isLive ? 'LIVE COVERAGE ACTIVE' : 'STARTS IN ${difference.inHours}H ${difference.inMinutes % 60}M',
                        style: TextStyle(
                          color: isLive ? Colors.red : AppTheme.primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
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
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isFollowed ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isFollowed ? Colors.transparent : (team.colorHex != null 
              ? Color(int.parse('0xFF${team.colorHex}')).withValues(alpha: 0.2) 
              : AppTheme.primaryColor.withValues(alpha: 0.04)),
            width: team.colorHex != null ? 2 : 1,
          ),
          boxShadow: isFollowed ? [
            BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))
          ] : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 44,
              height: 44,
              child: team.logoUrl.isNotEmpty 
                ? ClipOval(
                    child: ShimmerImage(
                      imageUrl: team.logoUrl,
                      width: 44,
                      height: 44,
                    ),
                  )
                : const Icon(Icons.shield_rounded, size: 24, color: AppTheme.surfaceColor),
            ),
            const SizedBox(height: 12),
            Text(
              team.name, 
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: isFollowed ? Colors.white : AppTheme.textPrimary), 
              textAlign: TextAlign.center, 
              maxLines: 1
            ),
            Text(
              isFollowed ? 'FOLLOWING' : team.sport.toUpperCase(), 
              style: TextStyle(color: isFollowed ? Colors.white.withValues(alpha: 0.6) : AppTheme.textSecondary, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5)
            ),
          ],
        ),
      ),
    );
  }
}
