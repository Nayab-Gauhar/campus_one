import 'package:flutter/material.dart';
import 'package:campus_one/models/event.dart';
import 'package:campus_one/core/theme/app_theme.dart';
import 'package:campus_one/widgets/animations/animated_widgets.dart';

class EventRegistrationScreen extends StatefulWidget {
  final EventModel event;
  const EventRegistrationScreen({super.key, required this.event});

  @override
  State<EventRegistrationScreen> createState() => _EventRegistrationScreenState();
}

class _EventRegistrationScreenState extends State<EventRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form Controllers
  final _nameController = TextEditingController();
  final _rollController = TextEditingController();
  final _deptController = TextEditingController();
  final _yearController = TextEditingController();
  final _phoneController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _emailController = TextEditingController();
  final _teamInfoController = TextEditingController();
  final _transactionIdController = TextEditingController();
  
  final List<String> _selectedSubEvents = [];
  bool _isPaymentConfirmed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldColor,
      appBar: AppBar(
        title: const Text('Event Registration', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _buildStepHeader('1', 'ACADEMIC IDENTITY'),
            const SizedBox(height: 16),
            _buildInputField('Full Name', _nameController, Icons.person_outline_rounded),
            const SizedBox(height: 12),
            _buildInputField('Roll No. (e.g. 24/EE/82)', _rollController, Icons.badge_outlined),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildInputField('Department', _deptController, Icons.account_balance_outlined)),
                const SizedBox(width: 12),
                Expanded(child: _buildInputField('Year', _yearController, Icons.school_outlined)),
              ],
            ),
            
            const SizedBox(height: 32),
            _buildStepHeader('2', 'CONTACT CHANNELS'),
            const SizedBox(height: 16),
            _buildInputField('Email ID', _emailController, Icons.alternate_email_rounded, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 12),
            _buildInputField('Phone Number', _phoneController, Icons.phone_android_rounded, keyboardType: TextInputType.phone),
            const SizedBox(height: 12),
            _buildInputField('WhatsApp Number', _whatsappController, Icons.chat_bubble_outline_rounded, keyboardType: TextInputType.phone),
            
            const SizedBox(height: 32),
            _buildStepHeader('3', 'EVENT SELECTION'),
            const SizedBox(height: 16),
            const Text('Choose up to 3 events you\'d like to participate in:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
            const SizedBox(height: 12),
            ..._buildSubEventChips(),
            
            if (widget.event.maxTeamSize > 1) ...[
              const SizedBox(height: 32),
              _buildStepHeader('4', 'TEAM CONFIGURATION'),
              const SizedBox(height: 16),
              _buildInputField('Team Details (Name & Members)', _teamInfoController, Icons.groups_outlined, maxLines: 3),
            ],
            
            if (widget.event.requiresPayment) ...[
               const SizedBox(height: 32),
               _buildStepHeader('\$', 'PAYMENT & VERIFICATION'),
               const SizedBox(height: 16),
               _buildPaymentCard(),
            ],

            const SizedBox(height: 48),
            ScaleOnTap(
              onTap: _submitRegistration,
              child: Container(
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: const Text('SUBMIT APPLICATION', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1.0)),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildStepHeader(String step, String title) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: const BoxDecoration(color: AppTheme.primaryColor, shape: BoxShape.circle),
          child: Text(step, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
        ),
        const SizedBox(width: 12),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.5, color: AppTheme.textSecondary)),
      ],
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, IconData icon, {TextInputType? keyboardType, int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.05)),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        decoration: InputDecoration(
          hintText: label,
          prefixIcon: Icon(icon, size: 18, color: AppTheme.primaryColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        validator: (v) => (v?.isEmpty ?? true) ? 'Required' : null,
      ),
    );
  }

  List<Widget> _buildSubEventChips() {
    // If we have actual pricing buckets, use them. Else use event rules or categories.
    final subEvents = ['Inkfinity', 'DesignX', 'ArtByte', 'SparkX', 'Hackarena'];
    
    return [
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: subEvents.map((e) {
          final isSelected = _selectedSubEvents.contains(e);
          return FilterChip(
            label: Text(e, style: TextStyle(color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary, fontWeight: FontWeight.w800, fontSize: 12)),
            selected: isSelected,
            onSelected: (val) {
              setState(() {
                if (val) {
                  if (_selectedSubEvents.length < 3) _selectedSubEvents.add(e);
                } else {
                  _selectedSubEvents.remove(e);
                }
              });
            },
            backgroundColor: Colors.white,
            selectedColor: AppTheme.accentColor,
            checkmarkColor: AppTheme.primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100), side: BorderSide(color: isSelected ? AppTheme.primaryColor : AppTheme.primaryColor.withValues(alpha: 0.1))),
          );
        }).toList(),
      )
    ];
  }

  Widget _buildPaymentCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('PAYMENT DETAILS', style: TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.0)),
          const SizedBox(height: 16),
          const Text('BUCKET 1: ₹65 (Early Bird)', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
          const Text('Scan the QR or use ID: hit@upi', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800)),
          const SizedBox(height: 24),
          _buildInputField('Transaction ID', _transactionIdController, Icons.receipt_long_rounded),
          const SizedBox(height: 16),
          ScaleOnTap(
            onTap: () => setState(() => _isPaymentConfirmed = true),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: _isPaymentConfirmed ? Colors.green : Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(_isPaymentConfirmed ? Icons.check_circle_rounded : Icons.cloud_upload_outlined, color: Colors.white, size: 20),
                   const SizedBox(width: 8),
                   Text(_isPaymentConfirmed ? 'PROOF UPLOADED' : 'UPLOAD SCREENSHOT', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitRegistration() {
    if (_formKey.currentState!.validate()) {
       if (widget.event.requiresPayment && !_isPaymentConfirmed) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please upload payment proof first.')));
         return;
       }
       
       // Success!
       showDialog(
         context: context,
         builder: (context) => SuccessDialog(
           title: 'Application Sent!',
           message: 'Your registration for ${widget.event.title} is being reviewed by the team.',
           onClose: () {
             Navigator.pop(context); // Close dialog
             Navigator.pop(context); // Go back from registration
           },
         ),
       );
    }
  }
}

class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onClose;

  const SuccessDialog({super.key, required this.title, required this.message, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.green, size: 64),
            const SizedBox(height: 24),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: AppTheme.textPrimary)),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
            const SizedBox(height: 32),
            ScaleOnTap(
              onTap: onClose,
              child: Container(
                height: 56,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(100)),
                child: const Text('Back to Event', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
