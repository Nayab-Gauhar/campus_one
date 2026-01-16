import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:campus_one/models/event.dart';
import 'package:campus_one/services/auth_service.dart';
import 'package:campus_one/core/theme/app_theme.dart';
import 'package:campus_one/widgets/common/shimmer_image.dart';
import 'package:campus_one/features/dashboard/screens/event_registration_screen.dart';
import 'package:campus_one/widgets/animations/animated_widgets.dart';

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
      body: SafeArea( // Added SafeArea
        child: CustomScrollView(
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
                  ShimmerImage(
                imageUrl: event.imageUrl,
                height: 350,
                width: double.infinity,
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
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
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
                  const SizedBox(height: 16),
                  Text(
                    event.title,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: AppTheme.textPrimary, letterSpacing: -1),
                  ),
                  if (event.tagline.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      event.tagline.toUpperCase(),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppTheme.accentTextColor, letterSpacing: 1.0),
                    ),
                  ],
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
                        const SizedBox(width: 8),
                        _QuickInfoPill(icon: Icons.layers_rounded, label: event.isMultiEvent ? 'Multi-Event' : 'Single Event'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  const Text('ABOUT EVENT', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1)),
                  const SizedBox(height: 12),
                  Text(
                    event.description,
                    style: const TextStyle(color: AppTheme.textSecondary, height: 1.6, fontSize: 15, fontWeight: FontWeight.w600),
                  ),

                  if (event.isMultiEvent && event.subEvents.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    const Text('EVENT SUITE AT A GLANCE', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1)),
                    const SizedBox(height: 16),
                    ...event.subEvents.map((se) => _SubEventCard(subEvent: se)),
                  ],

                  const SizedBox(height: 32),
                  const Text('OPPORTUNITIES', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1)),
                  const SizedBox(height: 16),
                  _ExperienceCard(
                    skills: event.skillsToLearn,
                    audience: event.targetAudience,
                    prereq: event.prerequisites,
                  ),

                  if (event.structuredGuidelines.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    const Text('IMPORTANT GUIDELINES', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1)),
                    const SizedBox(height: 16),
                    _StructuredGuidelines(guidelines: event.structuredGuidelines),
                  ],

                  if (event.requiresPayment && event.pricingBuckets.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    const Text('PRICING BUCKETS', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1)),
                    const SizedBox(height: 16),
                    ...event.pricingBuckets.map((b) => _PricingCard(bucket: b, earlyBirdDeadline: event.earlyBirdDeadline)),
                  ],
                  
                  if (event.agenda.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    const Text('AGENDA', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1)),
                    const SizedBox(height: 16),
                    _AgendaSection(agenda: event.agenda),
                  ],

                  if (event.contactNumber.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    _ContactCard(name: event.contactName, number: event.contactNumber),
                  ],
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EventRegistrationScreen(event: event)),
                  );
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

class _AgendaSection extends StatelessWidget {
  final List<EventAgendaItem> agenda;
  const _AgendaSection({required this.agenda});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: agenda.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isLast = index == agenda.length - 1;
        
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.time, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: AppTheme.textPrimary)),
                  ],
                ),
              ),
              Column(
                children: [
                   Container(
                     width: 10, 
                     height: 10, 
                     decoration: BoxDecoration(
                       color: AppTheme.primaryColor, 
                       borderRadius: BorderRadius.circular(100),
                       border: Border.all(color: Colors.white, width: 2),
                       boxShadow: [BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.3), blurRadius: 4, offset: const Offset(0, 2))],
                     ),
                   ),
                   if (!isLast)
                     Expanded(child: Container(width: 2, color: AppTheme.surfaceColor)),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppTheme.textPrimary)),
                      const SizedBox(height: 4),
                      Text(item.description, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _RulesSection extends StatelessWidget {
  final List<String> rules;
  const _RulesSection({required this.rules});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rules.map((rule) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Icon(Icons.circle, size: 6, color: AppTheme.accentTextColor),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(rule, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w600, height: 1.5))),
            ],
          ),
        )).toList(),
      ),
    );
  }
}

class _SubEventCard extends StatelessWidget {
  final SubEvent subEvent;
  const _SubEventCard({required this.subEvent});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: AppTheme.surfaceColor, shape: BoxShape.circle),
            child: Icon(subEvent.isTeam ? Icons.groups_rounded : Icons.person_rounded, color: AppTheme.primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subEvent.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppTheme.textPrimary)),
                const SizedBox(height: 2),
                Text(subEvent.description, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StructuredGuidelines extends StatelessWidget {
  final Map<String, String> guidelines;
  const _StructuredGuidelines({required this.guidelines});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppTheme.surfaceColor.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(28)),
      child: Column(
        children: guidelines.entries.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Expanded(child: Text(e.key, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppTheme.textSecondary))),
              Text(e.value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: AppTheme.textPrimary)),
            ],
          ),
        )).toList(),
      ),
    );
  }
}

class _PricingCard extends StatelessWidget {
  final PricingBucket bucket;
  final DateTime earlyBirdDeadline;
  const _PricingCard({required this.bucket, required this.earlyBirdDeadline});

  @override
  Widget build(BuildContext context) {
    final bool isEarlyBird = DateTime.now().isBefore(earlyBirdDeadline);
    final double price = isEarlyBird ? bucket.earlyBirdPrice : bucket.normalPrice;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.primaryColor.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bucket.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
                const SizedBox(height: 4),
                Text(bucket.subEvents.join(' • '), style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₹${price.toInt()}', style: const TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.w900, fontSize: 28)),
              if (isEarlyBird)
               Text('EARLY BIRD', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final String name;
  final String number;
  const _ContactCard({required this.name, required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.04)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(color: AppTheme.surfaceColor, shape: BoxShape.circle),
            child: const Icon(Icons.support_agent_rounded, color: AppTheme.primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('HAVE QUESTIONS?', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.accentTextColor, letterSpacing: 0.5)),
                const SizedBox(height: 2),
                Text('Contact $name', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppTheme.textPrimary)),
                Text(number, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Container(
             padding: const EdgeInsets.all(10),
             decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), shape: BoxShape.circle),
             child: const Icon(Icons.phone_rounded, color: Colors.green, size: 20),
          ),
        ],
      ),
    );
  }
}
