import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/event.dart';
import '../../services/data_service.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/animated_widgets.dart';

class EventDetailsScreen extends StatelessWidget {
  final EventModel event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final isRegistered = event.participantIds.contains(auth.currentUser?.id);
    final daysToEvent = event.date.difference(DateTime.now()).inDays;

    return Scaffold(
      backgroundColor: AppTheme.scaffoldColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            backgroundColor: AppTheme.primaryColor,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ScaleOnTap(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3), shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    event.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.4),
                          Colors.transparent,
                          AppTheme.primaryColor.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0, -30, 0),
              decoration: const BoxDecoration(
                color: AppTheme.scaffoldColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          event.category.name.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 10, color: AppTheme.primaryColor, letterSpacing: 0.5),
                        ),
                      ),
                      if (daysToEvent > 0)
                        Text(
                          'IN $daysToEvent DAYS',
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    event.title,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: AppTheme.textPrimary, letterSpacing: -1),
                  ),
                  const SizedBox(height: 24),
                  
                  // Quick Info Horizontal List
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _QuickInfoPill(icon: Icons.calendar_today_rounded, label: DateFormat('MMM dd').format(event.date)),
                        const SizedBox(width: 8),
                        _QuickInfoPill(icon: Icons.access_time_rounded, label: DateFormat('hh:mm a').format(event.date)),
                        const SizedBox(width: 8),
                        _QuickInfoPill(icon: Icons.location_on_rounded, label: event.location),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  const Text('OPPORTUNITIES', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1)),
                  const SizedBox(height: 16),
                  _ExperienceCard(
                    skills: event.skillsToLearn,
                    audience: event.targetAudience,
                    prereq: event.prerequisites,
                  ),

                  const SizedBox(height: 32),
                  const Text('CONCEPT', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1)),
                  const SizedBox(height: 12),
                  Text(
                    event.description,
                    style: const TextStyle(color: AppTheme.textSecondary, height: 1.6, fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, -5)),
          ],
        ),
        child: ScaleOnTap(
          onTap: isRegistered || event.isRegistrationClosed || event.isFull
              ? null
              : () {
                  if (auth.currentUser != null) {
                    context.read<DataService>().registerForEvent(event.id, auth.currentUser!.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Registration Confirmed! 🎉', style: TextStyle(fontWeight: FontWeight.w800)),
                        backgroundColor: AppTheme.primaryColor,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    );
                  }
                },
          child: Container(
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isRegistered ? AppTheme.surfaceColor : AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              isRegistered 
                  ? 'ALREADY REGISTERED' 
                  : (event.isRegistrationClosed ? 'REGISTRATION CLOSED' : (event.isFull ? 'CAPACITY REACHED' : 'SECURE YOUR SPOT')),
              style: TextStyle(
                fontSize: 14, 
                fontWeight: FontWeight.w900,
                color: isRegistered ? AppTheme.textSecondary : Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickInfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _QuickInfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppTheme.primaryColor),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
        ],
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  final List<String> skills;
  final String audience;
  final String prereq;

  const _ExperienceCard({required this.skills, required this.audience, required this.prereq});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ExperienceItem(icon: Icons.auto_awesome_rounded, title: 'Skillset Growth', value: skills.isEmpty ? 'Leadership & Networking' : skills.join(', ')),
          const SizedBox(height: 24),
          _ExperienceItem(icon: Icons.groups_2_rounded, title: 'Target Group', value: audience),
          const SizedBox(height: 24),
          _ExperienceItem(icon: Icons.checklist_rounded, title: 'Requirements', value: prereq.isEmpty ? 'None' : prereq),
        ],
      ),
    );
  }
}

class _ExperienceItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const _ExperienceItem({required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(color: AppTheme.surfaceColor, shape: BoxShape.circle),
          child: Icon(icon, color: AppTheme.primaryColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: AppTheme.textPrimary)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}
