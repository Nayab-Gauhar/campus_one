import 'package:flutter/material.dart';
import 'package:campus_one/core/theme/app_theme.dart';
import 'package:campus_one/widgets/animations/animated_widgets.dart';

class BroadcastPage extends StatefulWidget {
  const BroadcastPage({super.key});

  @override
  State<BroadcastPage> createState() => _BroadcastPageState();
}

class _BroadcastPageState extends State<BroadcastPage> {
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedAudience = 'All Students';
  bool _scheduleLater = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldColor,
      appBar: AppBar(
        title: const Text('Broadcast', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w800)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('SEND ANNOUNCEMENT', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.0, color: AppTheme.textSecondary)),
            const SizedBox(height: 16),
            _buildWrapper(
              child: DropdownButtonFormField<String>(
                initialValue: _selectedAudience,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.people_alt_rounded, color: AppTheme.primaryColor),
                  border: InputBorder.none,
                  labelText: 'Audience',
                ),
                items: ['All Students', 'Club Leads', 'Faculty', 'Hostel Residents']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontWeight: FontWeight.w700))))
                    .toList(),
                onChanged: (v) => setState(() => _selectedAudience = v!),
              ),
            ),
            const SizedBox(height: 16),
            _buildWrapper(
              child: TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.title_rounded, color: AppTheme.primaryColor),
                  border: InputBorder.none,
                  hintText: 'Subject Line',
                ),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 16),
            _buildWrapper(
              child: TextFormField(
                controller: _messageController,
                maxLines: 6,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.message_rounded, color: AppTheme.primaryColor),
                  border: InputBorder.none,
                  hintText: 'Message Body...',
                  contentPadding: EdgeInsets.only(top: 16, right: 16, bottom: 16),
                ),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              title: const Text('Schedule for later', style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
              value: _scheduleLater,
              activeTrackColor: AppTheme.primaryColor,
              activeThumbColor: Colors.white,
              onChanged: (v) => setState(() => _scheduleLater = v),
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            if (_scheduleLater) ...[
              const SizedBox(height: 12),
               _buildWrapper(
                child: ListTile(
                  leading: const Icon(Icons.calendar_today_rounded, color: AppTheme.primaryColor),
                  title: const Text('Select Date & Time', style: TextStyle(fontWeight: FontWeight.w700)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  onTap: () {}, // Date picker stub
                ),
              ),
            ],
            const SizedBox(height: 48),
            ScaleOnTap(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Broadcast queued successfully!')));
                Navigator.pop(context);
              },
              child: Container(
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(100)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_scheduleLater ? Icons.schedule_send_rounded : Icons.send_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(_scheduleLater ? 'Schedule Broadcast' : 'Send Now', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWrapper({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.05)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: child,
    );
  }
}
