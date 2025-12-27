import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:campus_one/services/data_service.dart';
import 'package:campus_one/core/theme/app_theme.dart';
import 'package:campus_one/models/event.dart';
import 'package:campus_one/widgets/animations/animated_widgets.dart';
import 'package:intl/intl.dart';
import 'package:campus_one/features/dashboard/screens/event_details_screen.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  List<EventModel> _getEventsForDay(DateTime day, List<EventModel> allEvents) {
    return allEvents.where((event) => isSameDay(event.date, day)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DataService>();
    final selectedEvents = _getEventsForDay(_selectedDay!, data.events);

    return Scaffold(
      backgroundColor: AppTheme.scaffoldColor,
      appBar: AppBar(
        title: Text('Campus Calendar'.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: -0.5)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppTheme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.05)),
              boxShadow: [
                BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.02), blurRadius: 20, offset: const Offset(0, 8))
              ],
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(2025, 1, 1),
              lastDay: DateTime.utc(2025, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              eventLoader: (day) => _getEventsForDay(day, data.events),
              calendarStyle: CalendarStyle(
                markerDecoration: const BoxDecoration(color: AppTheme.accentColor, shape: BoxShape.circle),
                todayDecoration: BoxDecoration(color: AppTheme.primaryColor.withValues(alpha: 0.1), shape: BoxShape.circle),
                todayTextStyle: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                selectedDecoration: const BoxDecoration(color: AppTheme.primaryColor, shape: BoxShape.circle),
                markerSize: 6,
                markersMaxCount: 1,
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                leftChevronIcon: const Icon(Icons.chevron_left_rounded, color: AppTheme.primaryColor),
                rightChevronIcon: const Icon(Icons.chevron_right_rounded, color: AppTheme.primaryColor),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(color: AppTheme.accentColor, borderRadius: BorderRadius.circular(10)),
                ),
                const SizedBox(width: 12),
                Text(
                  _selectedDay != null ? DateFormat('MMMM dd, yyyy').format(_selectedDay!).toUpperCase() : 'SELECT A DATE',
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: AppTheme.textPrimary, letterSpacing: 0.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: selectedEvents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy_rounded, size: 48, color: AppTheme.textSecondary.withValues(alpha: 0.2)),
                        const SizedBox(height: 16),
                        Text('No events scheduled for this day', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: selectedEvents.length,
                    itemBuilder: (context, index) {
                      final event = selectedEvents[index];
                      return FadeSlideEntrance(
                        delay: Duration(milliseconds: 100 * index),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.05)),
                          ),
                          child: InkWell(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EventDetailsScreen(event: event))),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(color: AppTheme.surfaceColor, borderRadius: BorderRadius.circular(12)),
                                  child: const Icon(Icons.bolt_rounded, color: AppTheme.primaryColor, size: 20),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(event.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppTheme.textPrimary)),
                                      Text('${DateFormat('hh:mm A').format(event.date)} • ${event.location}', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppTheme.textSecondary),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
