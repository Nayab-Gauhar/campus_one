import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/data_service.dart';
import '../../services/auth_service.dart';
import '../../models/event.dart';
import '../../theme/app_theme.dart';
import '../../widgets/animated_widgets.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locController = TextEditingController();
  EventCategory _selectedCategory = EventCategory.technical;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final user = context.read<AuthService>().currentUser!;
      final eventDate = DateTime.now().add(const Duration(days: 7));
      final newEvent = EventModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descController.text,
        date: eventDate,
        registrationDeadline: eventDate.subtract(const Duration(days: 2)),
        location: _locController.text,
        organizerId: 'new_org',
        organizerName: user.name,
        category: _selectedCategory,
        imageUrl: 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?auto=format&fit=crop&q=80&w=800',
        skillsToLearn: ['Leadership', 'Communication'],
        targetAudience: 'All interested students',
      );
      
      _showPreview(newEvent);
    }
  }

  void _showPreview(EventModel event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: AppTheme.scaffoldColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppTheme.primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(height: 24),
            const Text('PREVIEW AS STUDENT', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.0, color: AppTheme.textSecondary)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(color: AppTheme.surfaceColor, borderRadius: BorderRadius.circular(24)),
                      child: const Icon(Icons.image_outlined, size: 48, color: AppTheme.primaryColor),
                    ),
                    const SizedBox(height: 24),
                    Text(event.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                    const SizedBox(height: 16),
                    Text(event.description, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 16, height: 1.5)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: ScaleOnTap(
                onTap: () {
                  context.read<DataService>().addEvent(event);
                   _titleController.clear();
                  _descController.clear();
                  _locController.clear();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Event published!')));
                },
                child: Container(
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(100)),
                  child: const Text('Confirm & Publish', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                ),
              ),
            ),
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
            Text('Initiate new project', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
            Text('Create Event', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24, letterSpacing: -1.0, color: AppTheme.textPrimary)),
          ],
        ),
        toolbarHeight: 70,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 8),
            // Step Indicator
            Row(
              children: [
                _StepBubble(number: '1', label: 'DETAILS', isActive: true),
                _StepLine(isActive: false),
                _StepBubble(number: '2', label: 'ASSETS', isActive: false),
                _StepLine(isActive: false),
                _StepBubble(number: '3', label: 'REVIEW', isActive: false),
              ],
            ),
            const SizedBox(height: 48),
            _buildTextField(
              controller: _titleController,
              hint: 'Event Title',
              icon: Icons.title_rounded,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _descController,
              hint: 'Description',
              icon: Icons.description_rounded,
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _locController,
              hint: 'Location / Venue',
              icon: Icons.location_on_rounded,
            ),
            const SizedBox(height: 20),
            _buildCategoryDropdown(),
            const SizedBox(height: 32),
            _buildSmartTip('Events posted between 6-9 PM see 24% higher engagement.'),
            const SizedBox(height: 12),
            _buildSmartTip('Short, punchy titles usually get more clicks.'),
            const SizedBox(height: 56),
            ScaleOnTap(
              onTap: _submit,
              child: Container(
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: const Text('Publish to Agenda', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hint, required IconData icon, int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.05)),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppTheme.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: AppTheme.primaryColor, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(18),
        ),
        validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.05)),
      ),
      child: DropdownButtonFormField<EventCategory>(
        initialValue: _selectedCategory,
        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.primaryColor),
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.category_rounded, color: AppTheme.primaryColor, size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(18),
        ),
        items: EventCategory.values.map((cat) {
          return DropdownMenuItem(value: cat, child: Text(cat.name.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppTheme.textPrimary)));
        }).toList(),
        onChanged: (v) => setState(() => _selectedCategory = v!),
      ),
    );
  }

  Widget _buildSmartTip(String tip) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline_rounded, size: 18, color: AppTheme.primaryColor),
          const SizedBox(width: 12),
          Expanded(child: Text(tip, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.primaryColor))),
        ],
      ),
    );
  }
}

class _StepBubble extends StatelessWidget {
  final String number;
  final String label;
  final bool isActive;
  const _StepBubble({required this.number, required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? AppTheme.accentColor : AppTheme.surfaceColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(color: AppTheme.primaryColor, fontSize: 12, fontWeight: FontWeight.w900),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: isActive ? AppTheme.textPrimary : AppTheme.textSecondary, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
      ],
    );
  }
}

class _StepLine extends StatelessWidget {
  final bool isActive;
  const _StepLine({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 3,
        margin: const EdgeInsets.only(bottom: 22, left: 8, right: 8),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primaryColor : AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
