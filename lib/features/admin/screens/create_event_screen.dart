import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_one/services/data_service.dart';
import 'package:campus_one/services/auth_service.dart';
import 'package:campus_one/models/event.dart';
import 'package:campus_one/core/theme/app_theme.dart';
import 'package:campus_one/widgets/animations/animated_widgets.dart';

class CreateEventScreen extends StatefulWidget {
  final String? template;
  const CreateEventScreen({super.key, this.template});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 1;
  static const int _totalSteps = 7;

  // Step 1: Type Selection
  bool _isMultiEvent = false;

  // Step 2: Overview
  final _titleController = TextEditingController();
  final _taglineController = TextEditingController();
  final _descController = TextEditingController();
  EventCategory _selectedCategory = EventCategory.technical;
  String _mode = 'Offline';

  // Step 3: Sub-Events (For Multi)
  final List<SubEvent> _subEvents = [];

  // Step 4: Rules & Guidelines
  final Map<String, String> _guidelines = {
    'Max Events per Student': '3',
    'Team Auto-Allocation': 'No',
    'WhatsApp Mandatory': 'Yes',
    'Certificates': 'E-Certificate',
  };

  // Step 5: Pricing & Buckets
  bool _requiresPayment = false;
  final List<PricingBucket> _buckets = [];
  final _earlyBirdPriceController = TextEditingController();
  final _normalPriceController = TextEditingController();
  
  // Logistics
  final _locController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _applyTemplate();
  }

  void _applyTemplate() {
    if (widget.template == 'Hackathon') {
      _isMultiEvent = false;
      _titleController.text = 'Campus CodeFest 2024';
      _descController.text = '24-hour coding marathon.';
      _selectedCategory = EventCategory.hackathon;
    }
  }

  void _nextStep() {
    if (_currentStep < _totalSteps) {
      setState(() => _currentStep++);
    } else {
      _deploy();
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    }
  }

  void _deploy() {
    final event = EventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      tagline: _taglineController.text,
      description: _descController.text,
      date: DateTime.now().add(const Duration(days: 7)),
      registrationDeadline: DateTime.now().add(const Duration(days: 5)),
      location: _locController.text,
      mode: _mode,
      organizerId: 'new_org',
      organizerName: 'Admin',
      category: _selectedCategory,
      imageUrl: 'https://images.unsplash.com/photo-1504384308090-c54be3855833?auto=format&fit=crop&q=80&w=800',
      isMultiEvent: _isMultiEvent,
      subEvents: _subEvents,
      requiresPayment: _requiresPayment,
      pricingBuckets: _buckets,
    );
    _showPreview(event);
  }

  void _showPreview(EventModel event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(color: AppTheme.scaffoldColor, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 24),
            const Text('LIVE PREVIEW', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 2.0, color: AppTheme.textSecondary)),
            Expanded(child: Center(child: Text('Student View of ${event.title}\n(Preview Logic Implementation)')),),
            _buildActionButtons(onNext: () {
               context.read<DataService>().addEvent(event);
               Navigator.pop(context); // Close preview
               Navigator.pop(context); // Close screen
            }, nextLabel: 'CONFIRM & DEPLOY'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Step $_currentStep of $_totalSteps', style: const TextStyle(color: AppTheme.primaryColor, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
            Text(_getStepTitle(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppTheme.textPrimary)),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: _prevStep,
        ),
      ),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _buildCurrentStep(),
            ),
          ),
          _buildActionButtons(
            onNext: _nextStep,
            nextLabel: _currentStep == _totalSteps ? 'REVIEW & DEPLOY' : 'CONTINUE',
          ),
        ],
      ),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 1: return 'Event Type';
      case 2: return 'Basic Overview';
      case 3: return 'Sub-Event Architect';
      case 4: return 'Guidelines';
      case 5: return 'Logistics';
      case 6: return 'Pricing Buckets';
      case 7: return 'Registration Settings';
      default: return 'Create Event';
    }
  }

  Widget _buildProgressIndicator() {
    return Container(
      height: 4,
      width: double.infinity,
      color: AppTheme.primaryColor.withValues(alpha: 0.05),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: _currentStep / _totalSteps,
        child: Container(color: AppTheme.accentColor),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 1: return _buildStep1();
      case 2: return _buildStep2();
      case 3: return _buildStep3();
      case 4: return _buildStep4();
      case 5: return _buildStep5();
      case 6: return _buildStep6();
      case 7: return _buildStep7();
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildStep1() {
    return Column(
      children: [
        _TypeCard(
          title: 'Single Event',
          subtitle: 'Workshops, Seminars, Single-track contests',
          icon: Icons.event_rounded,
          isSelected: !_isMultiEvent,
          onTap: () => setState(() => _isMultiEvent = false),
        ),
        const SizedBox(height: 16),
        _TypeCard(
          title: 'Multi-Event / Fest',
          subtitle: 'Mega events like ESCALATE X with sub-events',
          icon: Icons.auto_awesome_motion_rounded,
          isSelected: _isMultiEvent,
          onTap: () => setState(() => _isMultiEvent = true),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(controller: _titleController, hint: 'Event Name (e.g. Escalate X)', icon: Icons.title_rounded),
        const SizedBox(height: 16),
        _buildTextField(controller: _taglineController, hint: 'Catchy Tagline (1 line)', icon: Icons.auto_awesome_rounded),
        const SizedBox(height: 16),
        _buildCategoryDropdown(),
        const SizedBox(height: 16),
        _buildModeSelector(),
        const SizedBox(height: 16),
        _buildTextField(controller: _descController, hint: 'Full Description', icon: Icons.description_rounded, maxLines: 4),
      ],
    );
  }

  Widget _buildStep3() {
    if (!_isMultiEvent) {
       return _buildEmptyPlaceholder('Not applicable for Single Events. Skipping to guidelines.');
    }
    return Column(
      children: [
        ..._subEvents.map((se) => _buildSubEventListTile(se)),
        ScaleOnTap(
          onTap: () => setState(() => _subEvents.add(SubEvent(id: '1', title: 'New Sub-Event', description: 'Enter details'))),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.1)), borderRadius: BorderRadius.circular(16)),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline_rounded, color: AppTheme.primaryColor),
                SizedBox(width: 12),
                Text('Add Sub-Event', style: TextStyle(fontWeight: FontWeight.w800, color: AppTheme.primaryColor)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep4() {
    return Column(
      children: _guidelines.keys.map((key) => _buildGuidelineField(key)).toList(),
    );
  }

  Widget _buildStep5() {
    return Column(
      children: [
        _buildTextField(controller: _locController, hint: 'Venue / Meeting Link', icon: Icons.location_on_rounded),
        const SizedBox(height: 16),
        _buildTextField(controller: _dateController, hint: 'Date & Start Time', icon: Icons.timer_rounded),
      ],
    );
  }

  Widget _buildStep6() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Require Payment', style: TextStyle(fontWeight: FontWeight.w800)),
          value: _requiresPayment,
          onChanged: (v) => setState(() => _requiresPayment = v),
          activeColor: AppTheme.accentColor,
        ),
        if (_requiresPayment) ...[
          const SizedBox(height: 16),
          ..._buckets.map((b) => _buildBucketListTile(b)),
          ScaleOnTap(
            onTap: () => setState(() => _buckets.add(const PricingBucket(name: 'BUCKET 1', subEvents: [], earlyBirdPrice: 0, normalPrice: 0))),
            child: Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: const Text('+ Add Pricing Bucket', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStep7() {
    return Column(
      children: [
        _buildConfigItem('Full Name', true),
        _buildConfigItem('Roll Number', true),
        _buildConfigItem('Department', true),
        _buildConfigItem('WhatsApp Number', true),
        _buildConfigItem('Payment Screenshot', _requiresPayment),
      ],
    );
  }

  Widget _buildActionButtons({required VoidCallback onNext, String nextLabel = 'CONTINUE'}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))]),
      child: Row(
        children: [
          if (_currentStep > 1)
            IconButton(
              onPressed: _prevStep,
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
          Expanded(
            child: ScaleOnTap(
              onTap: onNext,
              child: Container(
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(100)),
                child: Text(nextLabel, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helpers
  Widget _buildTextField({required TextEditingController controller, required String hint, required IconData icon, int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.black12)),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon, color: AppTheme.primaryColor, size: 18), border: InputBorder.none, contentPadding: const EdgeInsets.all(18)),
      ),
    );
  }

  Widget _buildModeSelector() {
    return Row(
      children: ['Offline', 'Online', 'Hybrid'].map((m) => Expanded(
        child: GestureDetector(
          onTap: () => setState(() => _mode = m),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _mode == m ? AppTheme.primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12),
            ),
            child: Text(m, style: TextStyle(color: _mode == m ? Colors.white : AppTheme.textPrimary, fontWeight: FontWeight.w800, fontSize: 12)),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildConfigItem(String label, bool isEnabled) {
    return ListTile(
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      trailing: Switch(value: isEnabled, onChanged: (_) {}, activeColor: AppTheme.primaryColor),
    );
  }

  Widget _buildEmptyPlaceholder(String text) {
    return Center(child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textSecondary)));
  }

  Widget _buildCategoryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.black12)),
      child: DropdownButtonFormField<EventCategory>(
        initialValue: _selectedCategory,
        decoration: const InputDecoration(prefixIcon: Icon(Icons.category_rounded), border: InputBorder.none, contentPadding: EdgeInsets.all(18)),
        items: EventCategory.values.map((c) => DropdownMenuItem(value: c, child: Text(c.name.toUpperCase()))).toList(),
        onChanged: (v) => setState(() => _selectedCategory = v!),
      ),
    );
  }

  Widget _buildGuidelineField(String key) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _buildTextField(controller: TextEditingController(text: _guidelines[key]), hint: key, icon: Icons.rule_rounded),
    );
  }

  Widget _buildSubEventListTile(SubEvent se) {
    return Card(child: ListTile(title: Text(se.title), subtitle: Text(se.description), trailing: const Icon(Icons.edit_note_rounded)));
  }

  Widget _buildBucketListTile(PricingBucket b) {
    return Card(child: ListTile(title: Text(b.name), subtitle: Text('₹${b.normalPrice}')));
  }
}

class _TypeCard extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeCard({required this.title, required this.subtitle, required this.icon, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.black12, width: 2),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.white : AppTheme.primaryColor, size: 32),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: isSelected ? Colors.white : AppTheme.textPrimary)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: isSelected ? Colors.white70 : AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
