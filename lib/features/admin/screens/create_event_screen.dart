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
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locController = TextEditingController();
  final _dateController = TextEditingController();
  
  EventCategory _selectedCategory = EventCategory.technical;

  @override
  void initState() {
    super.initState();
    _applyTemplate();
  }

  void _applyTemplate() {
    if (widget.template == 'Hackathon') {
      _titleController.text = 'Campus CodeFest 2024';
      _descController.text = 'A 24-hour coding marathon to build solutions for campus problems. Food and swag provided!';
      _selectedCategory = EventCategory.hackathon;
      _locController.text = 'Main Auditorium';
      _dateController.text = 'Saturday, 10:00 AM';
    } else if (widget.template == 'Guest Speaker') {
      _titleController.text = 'Industry Talk: AI Future';
      _descController.text = 'Join us for an interactive session with leading experts in Artificial Intelligence.';
      _selectedCategory = EventCategory.workshop;
      _locController.text = 'Seminar Hall B';
      _dateController.text = 'Friday, 2:00 PM';
    } else if (widget.template == 'Sports') {
      _titleController.text = 'Inter-Department Cricket';
      _descController.text = 'T20 Match: CSE vs ECE. Come support your department!';
      _selectedCategory = EventCategory.sports;
      _locController.text = 'College Ground';
      _dateController.text = 'Sunday, 9:00 AM';
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final user = context.read<AuthService>().currentUser!;
      final eventDate = DateTime.now().add(const Duration(days: 7)); // Mock date parsing
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
        imageUrl: _getMockImageForCategory(_selectedCategory),
        skillsToLearn: ['Leadership', 'Communication'],
        targetAudience: 'All interested students',
      );
      
      _showPreview(newEvent);
    }
  }

  String _getMockImageForCategory(EventCategory cat) {
    // Quick mock images
    switch (cat) {
      case EventCategory.hackathon: return 'https://images.unsplash.com/photo-1504384308090-c54be3855833?auto=format&fit=crop&q=80&w=800';
      case EventCategory.sports: return 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?auto=format&fit=crop&q=80&w=800';
      case EventCategory.cultural: return 'https://images.unsplash.com/photo-1514525253440-b393452e3383?auto=format&fit=crop&q=80&w=800';
      default: return 'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?auto=format&fit=crop&q=80&w=800';
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
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor, 
                        borderRadius: BorderRadius.circular(24),
                        image: DecorationImage(image: NetworkImage(event.imageUrl), fit: BoxFit.cover),
                      ),
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
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Event published successfully!')));
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
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded, color: AppTheme.textSecondary),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _buildCategoryDropdown(),
            const SizedBox(height: 24),
            
            _buildSectionLabel('CORE DETAILS'),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _titleController,
              hint: 'Event Title',
              icon: Icons.title_rounded,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _descController,
              hint: 'Description',
              icon: Icons.description_rounded,
              maxLines: 4,
            ),
            
            const SizedBox(height: 32),
            _buildSectionLabel('LOGISTICS'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _dateController,
                    hint: 'Date & Time',
                    icon: Icons.calendar_today_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _locController,
                    hint: 'Venue',
                    icon: Icons.location_on_rounded,
                  ),
                ),
              ],
            ),
            
            if (_locController.text.isEmpty)
               Padding(
                 padding: const EdgeInsets.only(top: 8, left: 4),
                 child: Wrap(
                   spacing: 8,
                   children: [
                     _SuggestedChip(label: 'Main Hall', onTap: () => setState(() => _locController.text = 'Main Hall')),
                     _SuggestedChip(label: 'Sports Ground', onTap: () => setState(() => _locController.text = 'Sports Ground')),
                     _SuggestedChip(label: 'Auditorium', onTap: () => setState(() => _locController.text = 'Auditorium')),
                   ],
                 ),
               ),

            const SizedBox(height: 32),
            
            // Collapsible Advanced Section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.05)),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: const Text('Advanced Settings', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppTheme.textPrimary)),
                  iconColor: AppTheme.primaryColor,
                  collapsedIconColor: AppTheme.textSecondary,
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    _buildTextField(
                      controller: TextEditingController(),
                      hint: 'Registration Link (Optional)',
                      icon: Icons.link_rounded,
                      isOptional: true,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: TextEditingController(),
                      hint: 'Max Participants',
                      icon: Icons.people_outline_rounded,
                      isOptional: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 48),
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
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label, 
      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.0, color: AppTheme.textSecondary.withValues(alpha: 0.5))
    );
  }

  Widget _buildTextField({
    required TextEditingController controller, 
    required String hint, 
    required IconData icon, 
    int maxLines = 1,
    bool isOptional = false,
  }) {
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
          prefixIcon: Icon(icon, color: isOptional ? AppTheme.textSecondary : AppTheme.primaryColor, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(18),
        ),
        validator: (v) => (!isOptional && (v?.isEmpty ?? true)) ? 'Required' : null,
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
        onChanged: (v) => setState(() {
          _selectedCategory = v!;
          // Auto-fill logic based on category change
          if (_dateController.text.isEmpty) {
             if (v == EventCategory.sports) _dateController.text = 'Sunday, 9:00 AM';
             if (v == EventCategory.hackathon) _dateController.text = 'Saturday, 10:00 AM';
             if (v == EventCategory.workshop) _dateController.text = 'Friday, 3:00 PM';
          }
        }),
      ),
    );
  }
}

class _SuggestedChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _SuggestedChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.accentColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.2)),
        ),
        child: Text(label, style: const TextStyle(color: AppTheme.primaryColor, fontSize: 10, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
