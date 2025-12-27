import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:campus_one/services/auth_service.dart';
import 'package:campus_one/core/theme/app_theme.dart';
import 'package:campus_one/widgets/animations/animated_widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthService>().currentUser;
    _nameController = TextEditingController(text: user?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    setState(() => _isLoading = true);
    await context.read<AuthService>().updateProfile(name: _nameController.text);
    setState(() => _isLoading = false);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldColor,
      appBar: AppBar(
        title: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.w900)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                         BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.1), blurRadius: 20)
                      ],
                    ),
                    child: const ClipOval(child: Icon(Icons.person, size: 60, color: AppTheme.textSecondary)),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: AppTheme.primaryColor, shape: BoxShape.circle),
                    child: const Icon(Icons.camera_alt_outlined, size: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            _buildField('Full Name', _nameController, Icons.person_outline_rounded),
            const SizedBox(height: 24),
            _buildField('Department', TextEditingController(text: 'Computer Science & Eng.'), Icons.school_outlined, enabled: false),
            const SizedBox(height: 48),
            ScaleOnTap(
              onTap: _isLoading ? null : _handleSave,
              child: Container(
                height: 56,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: _isLoading 
                  ? const CupertinoActivityIndicator(color: Colors.white) 
                  : const Text('Save Changes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon, {bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: enabled ? Colors.white : AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.05)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppTheme.primaryColor.withValues(alpha: 0.4)),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: enabled,
                  decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
